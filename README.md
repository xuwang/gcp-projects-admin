# Google Cloud Project Management with Terraform

Use terraform to provision and manage organizational GCP projects.

This allows project management by codification:

* All projects/members/roles/apis are declarative
* All changes are versioned and auditable
* Unified project setup and configuration cross the organization
* Eliminate imperative manual operations
* Enable further automation


## Prerequisites

* [Install Google Cloud SDK](https://cloud.google.com/container-engine/docs/before-you-begin)
* [Install Terraform v0.8.8+](https://www.terraform.io/intro/getting-started/install.html) 
* A GCP orgnization service account which must have the following IAM roles:
  * roles/storage.admin
  * roles/resourcemanager.projectCreator 
  * roles/owner
  * roles/billing.admin
* GCP orgnization ID
* GCP orgnization Billing ID


## Provision a new GCP project

### Setup GCP organization credentials

Edit common/env.sh:

```
# gcp service account key abslute file path
export GOOGLE_APPLICATION_CREDENTIALS=
# setup terraform remote state bucket project id
export GCP_ADMIN_PROJECT_ID=
# setup gcp organization id
export TF_VAR_org_id=
# setup gcp organization billing id
export TF_VAR_billing_id=
```

### Create terraforms for a new project

* Copy projert terraform templates:

  ```
  $ cd projects
  $ cp -r project-example <new-project-id>
  $ cd <new-project-id>
  ```
  _Note_: The \<new-project-id\> must be unique on GCP.
  A project ID cannot be changed after the project is created, so if you are creating a new project, be sure to choose an ID that you'll be comfortable using for the lifetime of the project.

* Modify `iam.tf` to bind project members and service accounts to roles, then

  ```
  # get help
  $ make help

  # dry run
  $ make plan

  # provision the project
  $ make apply
  ```
  _Note_: [Terraform reference for IAM is here](https://www.terraform.io/docs/providers/google/)

  That's it.

## Modify an exsiting GCP project

Go to the projects/\<project-name\> dir and 

  * modify service-account.tf to add/delete service accounts
  * modify iam.tf to bind project members and service accounts to roles
  * modify services.tf to enable/disable service apis

  as needed, then

  ```
  $ make plan
  $ make apply
  ```
  
## Technical Nodes

### Project Members
GCP user accounts are managed by Google Directory API and not covered by this repo currently. 

### Destroy a project is not immediate

Destroy a project will not be "destroyed immediately" instead it will be shut down and scheduled to be deleted after 7 days. 
A destroyed project name will not be available for reuse in 7 days.