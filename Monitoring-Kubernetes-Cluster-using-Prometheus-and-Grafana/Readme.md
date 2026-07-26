# Project 4.4 -- Monitoring Kubernetes Cluster using Prometheus and Grafana (AWS EKS + Terraform)

## Objective

Deploy Prometheus and Grafana on a Terraform-created AWS EKS cluster and
monitor Kubernetes resources.

## Prerequisites

-   AWS CLI configured
-   kubectl installed
-   Helm installed
-   Existing EKS cluster
-   Terraform project

## 1. Verify Cluster

``` bash
aws eks list-clusters
aws eks update-kubeconfig --region ap-south-2 --name Monitoring-Kubernetes-eks
kubectl get nodes
kubectl get pods -A
```

## 2. Install Monitoring Stack

``` bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

kubectl create namespace monitoring

helm install prometheus prometheus-community/prometheus -n monitoring
helm install grafana grafana/grafana -n monitoring
```

Verify:

``` bash
kubectl get pods -n monitoring
```

## 3. Get Grafana Credentials

Username:

``` text
admin
```

Password:

``` bash
kubectl get secret grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode && echo
```

## 4. Port Forward

Grafana:

``` bash
kubectl port-forward svc/grafana 3000:80 -n monitoring
```

Prometheus:

``` bash
kubectl port-forward svc/prometheus-server 9090:80 -n monitoring
```

Open: - http://localhost:3000 - http://localhost:9090

## 5. Configure Grafana

Connections → Data Sources → Prometheus

Datasource URL:

``` text
http://prometheus-server.monitoring.svc.cluster.local
```

Click **Save & Test**.

Expected:

    Successfully queried the Prometheus API

## 6. Import Dashboards

Dashboard IDs: - 6417 -- Kubernetes Cluster Monitoring - 1860 -- Node
Exporter Full - 15759 -- Kubernetes Views (Nodes)

Import: Dashboards → Import → Enter ID → Load → Select Prometheus
datasource → Import.

## 7. Metrics Server

Problem:

``` text
kubectl top nodes
error: Metrics API not available
```

Fix:

``` bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

Verify:

``` bash
kubectl get pods -n kube-system | grep metrics-server
kubectl top nodes
kubectl top pods -A
```

## 8. Useful Commands

``` bash
kubectl get pods -n monitoring
kubectl get svc -n monitoring
kubectl get pvc -n monitoring
kubectl get storageclass
helm list -n monitoring
kubectl top nodes
kubectl top pods -A
```

## 9. Troubleshooting

### Prometheus Pending

``` bash
kubectl describe pod <pod> -n monitoring
kubectl get pvc -n monitoring
kubectl get storageclass
```

### Grafana cannot connect

Use:

``` text
http://prometheus-server.monitoring.svc.cluster.local
```

Not:

``` text
http://localhost:9090
```

### Metrics API not available

Install Metrics Server.

### Dashboard shows N/A

Some dashboards expect kubelet/cAdvisor metrics or kube-prometheus-stack
metrics. Node, pod, deployment and basic metrics can still work
correctly.

## 10. Cleanup

``` bash
helm uninstall prometheus -n monitoring
helm uninstall grafana -n monitoring
kubectl delete namespace monitoring
kubectl delete -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
cd terraform
terraform destroy
```

## Screenshots

1.  aws eks list-clusters
2.  kubectl get nodes
3.  kubectl get pods -n monitoring
4.  Prometheus UI
5.  Grafana login
6.  Successful datasource
7.  Imported dashboard
8.  kubectl top nodes
9.  kubectl top pods -A
10. Helm list

## Concepts Learned

-   EKS Monitoring
-   Prometheus
-   Grafana
-   Helm
-   Metrics Server
-   Node Exporter
-   kube-state-metrics
-   Port Forwarding
-   Kubernetes Monitoring
