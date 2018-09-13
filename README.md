# GCP-KubernetesEngineCluster-Webapp

The appropriate GCP properties should be updated at deploy_url_shortner/deploymentmanager.properties

A GCP service account keyfile should be copied to deploy_url_shortner/keyfiles directory for authentication.



Assuming working directory is GCP-KubernetesEngineCluster-Webapp

build the docker image to create the cluster in Kubernetes Engine and deploy the web app
docker build -t ubuntu-googlecloudsdk .

build the docker image to delete the cluster in Kubernetes Engine
docker build -t ubuntu-googlecloudsdk -f Dockerfile_delete .

run the image to create container
docker run -ti --rm ubuntu-googlecloudsdk:latest		
