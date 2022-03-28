# Docker-Kubernetes-deployment Project

In this project:
we use Docker to create a Nignix web server image and host abs-guide content in it. 
We use kubernetes to create a deployemnt of image created in docker

Technologies used for this project are Docker and minikube(kubernetes)

1)Download the abs-guide from link : https://tldp.org/LDP/abs/abs-guide.html.tar.gz


2)
To Create of Docker Image to host nignix web-server and store nbs-guide content it

FROM nginx
ADD  /abs-guide /usr/share/nginx/html

The above commands will pull nignx image and copy the contents of /abs-guide to /usr/share/nginx/html
 

Building a Docker image
docker build -t <image_name> .
<name> is the name of your image

Use the Command "Docker images" to check if the image is created.

To Run a docker Image
docker run -d -p 8000:80 <image_name>
-d is used to run the container in the detached mode(background)
-p is the flag for mapping the port 8000 (local machine) to the port 80 in the container as 80 is the port on which nginx serves by default.

Using the above command you are runnig Nginx web server in your local machine. To check that open any browser and type "localhost:8000". This will display the content in nginx index.html file.index.html and all other *.html files are copied to nginx-web-server from abs-guide.


To make the image pubilcly available through dockerhub 
docker build -t Mohanrao122/assessment .
docker push Mohanrao122/assessment




3)
Creation of assesment-deployment.yaml and service.yml files, you can go and execute these files for deployment in kubernetes cluster

These configuration files are used by the kubectl tool and based on the configuration of these files, The Kubernetes cluster will take all the contents of the file and do the deployment accordingly.


assesment-deployment.yaml:
In this file I have given all the configurations related to deployment, basically, in this deployment, Kubernetes is going to pick the Docker image i have created initally(Mohanrao122/assessment) from Docker Hub,

Let’s go through some of the important sections of this deployment file.

apiVersion: apps/v1 = This section specifies the version of the deployment.
kind: Deployment = It specifies the function that is carried out on by Kubernetes cluster, In this case it is Deployment. 
Specification conatins:
  -Replica = specifies how many replicas are required to be created for this application/container, in this case i have created only 1. 
  -Selector = specifies which application is going to be associated with this replica.
  -template = is a compenent used to metion the configuration of container.

I have also exposed the containerPort as 80 which is required to communicate for http requests. I have given the name of the application as “nginx” which will run on this container.


service.yml file:
It is used to expose services and make application reachable. In this case we have used NodePort. This will allow reaching the index page of the application of the Nginx container which is running on the Kubernetes cluster.
NodePort : A NodePort is an open port on every node of your cluster. Kubernetes transparently routes incoming traffic on the NodePort to your service, even if your application is running on a different node

In the service.yaml file, we use type of service as Nodeport which will route the traffic from service to targetPort which is nignix container

Some important sections of this file are as follows:

kind: Service = This says this is a service type of deployment. Which will be a front service for the backend container.

Specifications contains : type of service, port and targertPort being exposed.


Then will execute the commands one by one.

Kubectl apply -f assesment-deployment.yml

Kubectl apply -f service.yml 

By implementing the above commnads both  assesment-deployment.yml and service.yml are now deployed in kubernetes cluster

Excute the following commands to check if pod and service are successfully created 

Kubectl get pod
Kubectl get service

To Check the pod ip address 
kubectl get pod -o wide

To check if the service is mapped to correct pod
kubectl describe service nginx-service

To access the deployemnt
minikube service nginx-service

Above command will automatically launch the browser and display the content in Nginx we-server

Here what we have done that we have deployed our application to a POD that is running on a container on the Kubernetes cluster then we have exposed the service during the deployment so that all http requests can be redirected to the backend application “nginx”.


Conclusion
We have successfully created a docker image to host the content of abs-guide in nginx web-server, then hosted that image in dockerhub and made it publicy accessable.so that we can use that image/container to host nginx web-server in kubernetes by assesment-deployment.yaml and service.yaml deployment.

