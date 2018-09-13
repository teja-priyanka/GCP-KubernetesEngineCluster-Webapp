#########################################################################################
#Scriptname	: deploy_app.sh
#Author		: Teja Priyanka Adivikolanu
#Purpose	: This script will install google-cloud-sdk and will create, update and
#		  delete a deployment in GCP using Deployment Manager
#Arguments	: takes one argument
#		  deploy - to deploy the application
#		  delete - to delete the deployment
#########################################################################################


#########################################################################################
#FunctionName	: usage
#Purpose	: prints the usage of script when invalid argumets are passed
#Arguments	: none
#########################################################################################
usage(){
	echo "ERROR: invalid arguments for $0"
	echo "USAGE:To deploy application - $0 deploy"
	echo "USAGE:To delete deployment - $0 delete"
}

#########################################################################################
#FunctionName   : create_deployment
#Purpose        : create a new deployment in GCP using deployment-manager
#Arguments      : none
#########################################################################################
create_deployment(){
	gcloud deployment-manager deployments create $MY_GCP_DEPLOYMENT --config $MY_GCP_CONFIG
}

#########################################################################################
#FunctionName   : update_deployment
#Purpose        : update an already existing deployment in GCP using deployment-manager
#Arguments      : none
#########################################################################################
update_deployment(){
	gcloud deployment-manager deployments update $MY_GCP_DEPLOYMENT --config $MY_GCP_CONFIG
}

#########################################################################################
#FunctionName   : delete_deployment
#Purpose        : delete an existing deployment in GCP using deployment-manager
#Arguments      : none
#########################################################################################
delete_deployment(){
	gcloud deployment-manager deployments delete $MY_GCP_DEPLOYMENT -q
}




#########################################################################################
#MAIN BODY
#########################################################################################

#verifying the arguments passed
if [ $# -ne 1 ]
then
        usage
else
	MODE=$1
fi


#source the properties
. ./deploymentmanager.properties


#installing google-cloud-sdk
export CLOUD_SDK_REPO="cloud-sdk"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
apt-get update && apt-get -y install google-cloud-sdk


#Authorizing Google Cloud Platform
gcloud auth activate-service-account --key-file $MY_GCP_KEYFILE


#Setting up GCP project and zone for deployment
gcloud config set project $MY_GCP_PROJECT
gcloud config set compute/region $MY_GCP_REGION
gcloud config set compute/zone $MY_GCP_ZONE


case $MODE in
"deploy")		#deploy the application
	if [ ! `gcloud deployment-manager deployments list --simple-list|grep $MY_GCP_DEPLOYMENT` ]
	then
		create_deployment
	else
		update_deployment
	fi
	;;
"delete")		#delete the application
	delete_deployment
	;;
*)
	usage
	;;
esac
