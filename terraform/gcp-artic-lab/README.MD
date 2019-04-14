# GCP: Artic Lab

This project needs the follow tools.

* [Terraform](https://www.terraform.io/downloads.html)
* [Helm](https://github.com/helm/helm/releases)
* [GCloud SDK](https://cloud.google.com/sdk/)

## Initial Setup

### GCloud SDK

Run the following command to setup the GCloud SDK.

```
gcloud init
```

Create credential file for running Terraform as your user account.

```
gcloud auth application-default login
```

Install `kubectl`.

```
gcloud components install kubectl
```

### Helm

Initialize your Helm client with the below.

```
helm init --client-only
```

### Terraform

Manually create a storage bucket in GCP for holding Terraform state. Bucket name should be `artic-lab-storage`.

Initialize Terraform

```
terraform init
```

### Kubernetes

Get your credentials for using `kubectl`

```
gcloud container clusters get-credentials [gke-nginx or gke-istio]
```

Set preferred namespace to work in.

```
kubectl config set-context $(kubectl config current-context) --namespace=<insert-namespace-name-here>
```