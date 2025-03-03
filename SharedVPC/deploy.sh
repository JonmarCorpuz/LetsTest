#!/bin/bash

# Text Color
WHITE="\033[0m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
GREEN="\033[0;32m"

# Infinte Loop
ALWAYS_TRUE=true

# Echo requirements

# - Organization required
# - Host project required
# - Service project(s) required

# Gather user input
while [[ $ALWAYS_TRUE=true ]];
do 

    read -p "$(echo -e ${YELLOW}[REQUIRED]${WHITE} Please enter the project ID of the project where you want to host your VPC in:) " HostProjectID

    if ! gcloud projects describe $HostProjectID &> /dev/null;
    then 
        echo "" && echo -e "${RED}[ERROR 1]${WHITE} A project with the ${ProjectID} project ID doesn't exists within your organization or you don't have access to it." && echo ""
    else
        # Set the project that'll host the Shared VPC
        echo "1"
        if gcloud config set project $HostProjectID &> /dev/null;
        then 
            gcloud config set project $HostProjectID
        
            # Ensure required APIs are enabled
            echo "2"
            gcloud services enable compute.googleapis.com
        
            # Setup VPC sharing
            echo "3"
            if ! gcloud compute shared-vpc enable $HostProjectID;
            then 
                break
            fi
            echo "4"
            gcloud compute shared-vpc enable $HostProjectID
            break
        fi
    fi 

done 

while [[ $ALWAYS_TRUE=true ]];
do 

    read -p "$(echo -e ${YELLOW}[REQUIRED]${WHITE} Would you like to create a new VPC? [Y] or [N]) " CreateNewVPC
    $CreateNewVPC = "${CreateNewVPC^^}"

    if [[ "$CreateNewVPC" == "Y" ]];
    then 
        read -p "$(echo -e ${YELLOW}[REQUIRED]${WHITE} Please enter the name you would like to give your new VPC:) " NetworkName
        
        if ! gcloud network describe $NetworkName &> /dev/null ;
        then
            # Create VPC
            gcloud compute networks create $NetworkName --subnet-mode=custom --bgp-routing-mode=regional
        else
            echo "Something"
        fi
    else
        break
    fi 

done 

while [[ $ALWAYS_TRUE=true ]];
do 

    read -p "$(echo -e ${YELLOW}[REQUIRED]${WHITE} Please enter the project ID of the service project you want to add to the shared VPC:) " ServiceProjectID

    if ! gcloud describe project $ServiceProjectID;
    then 
        echo "" && echo -e "${RED}[ERROR 1]${WHITE} A project with the ${ProjectID} project ID doesn't exists within your organization or you don't have access to it." && echo ""
    else
        # Share VPC with other project(s)
        gcloud compute shared-vpc associated-projects add $ServiceProjectID --host-project=$HostProjectID
        
        read -p "$(echo -e ${YELLOW}[REQUIRED]${WHITE} Would you like to add another service project to the shared VPC? [Y] or [N]) " AddAnotherProject
        $AddAnotherProject = "${AddAnotherProject^^}"

        if $AddAnotherProject == "N";
        then
            break
        fi
    fi 

done 

# Grant necessary IAM roles to users or service accounts in the service projects to use the shared VPC
gcloud projects add-iam-policy-binding $HostProjectID --member=user:EMAIL_OR_SERVICE_ACCOUNT --role=roles/compute.networkUser
