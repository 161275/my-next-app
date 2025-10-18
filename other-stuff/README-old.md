**Instructions to run**
1. docker run -p 3000:3000 --name next-app ghcr.io/161275/my-next-app:latest (I made the image public on GHCR so that anyone can check without credentials)check http://localhost:3000
2. setup k8s cluster by minikube or kubeadm or ECR or any other managed environment (but the application is simple so minikube single node cluster would be suffice) [minikube documentation](https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download)
3. clone the repo (git clone https://github.com/161275/my-next-app.git) where kubectl is installed
4. run kubectl apply -f ./k8s (create both deployment and service)
5. check http://<ip-of-worker-node>:31005

![alt text](<Screenshot 2025-10-08 at 11.47.15 PM.png>)    ![alt text](<Screenshot 2025-10-09 at 2.04.59 AM.png>)

**Flow github action pipeline**
1. developement on Local created nextjs app on local (npx create-next-app@latest my-next-app). install dependencies and build
2. create of github repo and pushed the code to git 
3. created node js github action workflow tried to build application locally and copy only dependencied and .next folder to docker image with node:18 as base image
4. Dockerization of image created with proper tagging
5. login on GHCR using PAT and pushed the image.
6. created another job for the deployment on kubernetes cluster .
 
![alt text](<Screenshot 2025-10-09 at 2.49.15 AM.png>)

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
   => nodeport service to expose container to outside world
   => nodePort (range: 30000-32767) and targetPort to port assigned to container in deployment.yaml
   => selector to direct targeted pods

**Configurations and kubernetes cluster setup**
1. created EC2 instances. and configured it self-hosted runner
2. installed all the dependencies like docker minikube kubectl installation on it


**Troubleshooting steps:**
1. when copying .next directory after creating on local to save build time not downloading and uploading artifacts (though now commented because building everything in the image itself, can check commented code in workflow file)
2. Imagepullbackoff > because not created buildx (for all arch platforms amd64 and arm64) in the first instance and k8s cluster using amd64 .
3. authentication Issue during deployment or pod creation image was in private registry then I created a registry secret and used imagePullSecrets in deployment.yaml (but now I made it pulic so can be removesd and no need to create secret ).

Summary:
This project demonstrates a complete CI/CD pipeline for a Next.js application, automating build, containerization, and deployment to a Kubernetes cluster using GitHub Actions and GHCR.





