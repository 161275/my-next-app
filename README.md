**Flow github action pipeline**
1. developement on Local created nextjs app on local (npx create-next-app@latest my-next-app). install dependencies and build
2. create of githubhub repo and pushed the code to git 
3. created node js github action workflow tried to build application locally and copy only dependencied and .next folder to docker image with node:18 as base image
4. Dockerization of image created with proper tagging
5. login on GHCR using PAT and pushed the image.
6. created another job for the deployment on kubernetes cluster 

**Dockerfile optimization**
1. using node alpine(light weight) as base image 
2. copy package.json and install dependencies (rarely changes and docker will use chached layer and saves time during build)
3. then copied rest of the files that are frequently changes with new features or otherwise 
4. exposes port 3000 for the container and used cmd run on container initialization

**Kubernetes Menifests**
1. deployment.yaml
   => proper labeling that are used in service.yaml
   => replicas: 2 for fault tolerance and reliability
   => pulling image from GHCR (we pushed earlier) and created Docker registry secret and used **ImagePullSecret **to ensure clusterwide accessibility of image.
2. service.yaml
   => nodeport service to expose container to outside world
   => nodePort (range: 30000-32767) and targetPort to port assigned to container in deployment.yaml
   => selector to direct targeted pods

**Configurations and kubernetes cluster setup**
1. created EC2 instances. and configured it self-hosted runner
2. installed all the dependencies like docker minikube kubectl installation on it




