Flow of application
1. developement on Local created nextjs app on local (npx create-next-app@latest my-next-app). install dependencies and build
2. create of githubhub repo and pushed the code to git 
3. created node js github action workflow tried to build application locally and copy only dependencied and .next folder to docker image with node:18 as base image
4. Dockerization of image created with proper tagging
5. login on GHCR using PAT and pushed the image.
