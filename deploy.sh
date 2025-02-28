#!/bin/bash

# Gather user input

# Ensure required APIs are enabled
gcloud services enable compute.googleapis.com


# Create new project if needed
gcloud projects create YOUR_PROJECT_ID --name="Shared VPC Host"

# Set the project that'll host the Shared VPC
gcloud config set project YOUR_PROJECT_ID

# Create VPC
gcloud compute networks create shared-vpc-network --subnet-mode=custom --bgp-routing-mode=regional

# Create subnets if needed
gcloud compute networks create shared-vpc-network --subnet-mode=custom --bgp-routing-mode=regional

# Setup VPC sharing
gcloud compute shared-vpc enable YOUR_PROJECT_ID

# Share VPC with other project(s)
gcloud compute shared-vpc associated-projects add SERVICE_PROJECT_ID --host-project=YOUR_PROJECT_ID

# Grant necessary IAM roles to users or service accounts in the service projects to use the shared VPC
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID --member=user:EMAIL_OR_SERVICE_ACCOUNT --role=roles/compute.networkUser
