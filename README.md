**Infra creation**
1. created EC2 instances. and configured it self-hosted runner
2. installed all the dependencies like docker, kubectl, installation, trivy, aws cli, helm on it.
3. creation of EKS or any other kubernetes (kubeadm/minikube or any other managed like GKE) cluster.

**Instructions to run**
1. docker run -p 3000:3000 --name next-app ghcr.io/161275/my-next-app:latest (I made the image public on GHCR so that anyone can check without credentials)check http://localhost:3000
2. setup EKS cluster and update kubeconfig on the self-hosted runner (follow README.me of https://github.com/161275/terraform-eks-cluster)
3. github action will install helm chart on the above EKS cluster
4. if you want to run witout github action clone the repo on the server with all the required dependencies installed 
   -> helm install <release-name> ./helm-next-app
   -> kubectl apply -f ./k8s 
5. check the next-svc (load balancer) external IP (eg. http://a4523fde6ec9e40e7b3f0554933cce2c-9224b886b7cbba06.elb.us-east-1.amazonaws.com/)

**Flow github action pipeline**
-> **one click whole automated pipeline. (just give one git push whole application will build -> security scan -> push on GHCR -> helm cahrt upgrade on EKS -> live application)**
1. Build docker image
2. trivy scan
3. login on GHCR using PAT and pushed the image.
4. created another job for the deployment on kubernetes cluster . (commented after helm packaging)
5. install helm package.

**Dockerfile optimization**
1. using node alpine(light weight) as base image 
2. copy package.json and install dependencies (rarely changes and docker will use chached layer and saves time during build)
3. then copied rest of the files that are frequently changes with new features or otherwise 
4. exposes port 3000 for the container and used cmd run on container initialization.

**Kubernetes Menifests**
1. deployment.yaml
   => proper labeling that are used in service.yaml
   => replicas: 2 for fault tolerance and reliability
   => pulling image from GHCR (we pushed earlier) and created Docker registry secret and used **ImagePullSecret** to ensure clusterwide accessibility of image.
2. service.yaml
   => LoadBalancer service to expose app to outside world
   => targetPort to port assigned to container in deployment.yaml
   => selector to direct targeted pods


**Troubleshooting steps:**
1. when copying .next directory after creating on local to save build time not downloading and uploading artifacts (though now commented because building everything in the image itself, can check commented code in workflow file)
2. Imagepullbackoff > because not created buildx (for all arch platforms amd64 and arm64) in the first instance and k8s cluster using amd64 .
3. authentication Issue during deployment or pod creation image was in private registry then I created a registry secret and used imagePullSecrets in deployment.yaml (but now I made it pulic so can be removesd and no need to create secret ).

Summary:
This project demonstrates a complete CI/CD pipeline for a Next.js application, automating build, containerization, and deployment to a Kubernetes cluster using GitHub Actions and GHCR.