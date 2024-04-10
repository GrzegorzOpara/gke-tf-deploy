# GKE deployment on GCP using Terraform
This code helps deploy GKE cluster on GCP using terraform and cloud build (manual trigger)


## Prerequisites
### GCP
- GCS Bucket to store tf state file: 

  ```sh
  PROJECT_ID=$(gcloud config get-value project)
  REGION=europe-west1

  gcloud storage buckets create gs://$PROJECT_ID-gcs-tf --project $PROJECT_ID --location $REGION --uniform-bucket-level-access
  ```
  
### APIs
- Cloud Build API, Secret Manager API, Cloud Resource Manager API

  ```sh
  gcloud services enable cloudbuild.googleapis.com
  gcloud services enable container.googleapis.com
  gcloud services enable secretmanager.googleapis.com
  gcloud services enable cloudresourcemanager.googleapis.com
  gcloud services enable cloudfunctions.googleapis.com
  gcloud services enable run.googleapis.com
  ```

### Cloud Build configuration
1. Create github host connection (https://pantheon.corp.google.com/cloud-build/connections/create)
2. Link the terraform repository
3. Grant **project editor** and **network admin** permissions to Cloud Build Service Account

    ```sh
    PROJECT_ID=$(gcloud config get-value project)

    CLOUDBUILD_SA="$(gcloud projects describe $PROJECT_ID --format 'value(projectNumber)')@cloudbuild.gserviceaccount.com"

    gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$CLOUDBUILD_SA --role roles/editor

    gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$CLOUDBUILD_SA --role roles/compute.networkAdmin
    ```
4. Grant permissions to Cloud Build Service Account to access GCS Bucket with state file (https://cloud.google.com/docs/terraform/resource-management/store-state#before_you_begin)

    ```sh
    PROJECT_ID=$(gcloud config get-value project)
    CLOUDBUILD_SA="$(gcloud projects describe $PROJECT_ID --format 'value(projectNumber)')@cloudbuild.gserviceaccount.com"

    gcloud iam roles create tf_gcs_mgt --project=$PROJECT_ID --file=./misc/terraform_gcs_role.yaml

    gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:$CLOUDBUILD_SA --role=projects/$PROJECT_ID/roles/tf_gcs_mgt 
    ```
  5. Deploy Cloud Run trigger using gcloud:

  gcloud builds triggers create cloud-source-repositories \
    --repo=REPO_NAME \
    --branch-pattern=BRANCH_PATTERN \ # or --tag-pattern=TAG_PATTERN
    --build-config=BUILD_CONFIG_FILE \
    --service-account=SERVICE_ACCOUNT \
    --require-approval

gcloud builds triggers create cloud-source-repositories --repo="GrzegorzOpara/gke-tf-deploy" --tag-pattern='^\d+\.\d+\.\d+\$' --build-config=cloudbuild.yaml 