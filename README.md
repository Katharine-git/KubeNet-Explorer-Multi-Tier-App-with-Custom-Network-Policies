# KubeNet-Explorer-Multi-Tier-App-with-Custom-Network-Policies

Networking is the backbone of Kubernetes.

I've set up a mini-project that will help you setup a cluster from scratch, deploy resources and build a basic network within the cluster.

#Steps to follow:
🧩 Step-by-Step Deployment Guide
🪴 1️⃣ Make Sure Your Cluster Is Running

If you’re using Minikube:

minikube start --driver=docker
minikube addons enable ingress


Then confirm:

kubectl get nodes
kubectl get pods -A


You should see one node in Ready state and several kube-system pods running.

📂 2️⃣ Clone and Enter the Project
git clone https://github.com/<your-username>/k8s-networking-lab.git
cd k8s-networking-lab

🧾 3️⃣ Make the Script Executable

Before running:

chmod +x scripts/deploy.sh scripts/cleanup.sh

🚀 4️⃣ Run the Deployment Script

Now deploy everything:

bash scripts/deploy.sh


What this does:

Creates the 3 namespaces (frontend, backend, database)

Deploys MongoDB, Backend, and Frontend

Applies NetworkPolicies

Sets up Ingress for external access

🧠 5️⃣ Verify Deployment

Check everything is up:

kubectl get pods -A
kubectl get svc -A
kubectl get ingress -A


You should see:

MongoDB in the database namespace

Backend and Frontend pods running

An ingress rule under the frontend namespace

🌐 6️⃣ Access the Frontend

Add this entry to your local /etc/hosts file:

127.0.0.1  frontend.local


Then open in your browser:
👉 http://frontend.local

You should see the default Nginx welcome page (served from your frontend pod via Ingress).

🧩 7️⃣ Test Networking

Use these commands to confirm isolation:

✅ Backend → Database should succeed:

kubectl exec -n backend -it $(kubectl get pod -n backend -l app=backend -o jsonpath='{.items[0].metadata.name}') -- ping mongodb.database.svc.cluster.local


❌ Frontend → Database should fail:

kubectl exec -n frontend -it $(kubectl get pod -n frontend -l app=frontend -o jsonpath='{.items[0].metadata.name}') -- ping mongodb.database.svc.cluster.local


This confirms your NetworkPolicies are working.

🧹 8️⃣ Cleanup When Done

When you’re finished testing:

bash scripts/cleanup.sh


This deletes all namespaces and resets the cluster to a clean state.

✅ Summary Flow
Step	Command	Purpose
1️⃣	minikube start	Start cluster
2️⃣	bash scripts/deploy.sh	Deploy resources
3️⃣	kubectl get pods -A	Verify running pods
4️⃣	curl frontend.local	Test ingress
5️⃣	bash scripts/cleanup.sh	Tear down lab
#Expected outputs
1. After Cluster Start

Command:

minikube start --driver=docker


✅ Expected output:

😄  minikube v1.34.0 on Ubuntu 22.04
✨  Using the docker driver
👍  Starting control plane node minikube in cluster minikube
🔎  Verifying Kubernetes components...
🌟  Enabled addons: default-storageclass, storage-provisioner, ingress
🏄  Done! kubectl is now configured to use "minikube"


Verify:

kubectl get nodes


✅ Output:

NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   1m    v1.30.0

2. After Running bash scripts/deploy.sh

You should see messages like:

Creating namespaces...
namespace/frontend created
namespace/backend created
namespace/database created

Deploying MongoDB...
service/mongodb created
deployment.apps/mongodb created

Deploying Backend...
service/backend created
deployment.apps/backend created

Deploying Frontend...
service/frontend created
deployment.apps/frontend created

Applying NetworkPolicies...
networkpolicy.networking.k8s.io/backend-db-access created
networkpolicy.networking.k8s.io/frontend-isolated created

Applying Ingress...
ingress.networking.k8s.io/frontend-ingress created

✅ Deployment complete!

3. Verify Pods and Services

Command:

kubectl get pods -A


✅ Expected output:

NAMESPACE   NAME                          READY   STATUS    RESTARTS   AGE
database    mongodb-7c9f5dd78f-4jtzs      1/1     Running   0          30s
backend     backend-7c8fbb6d96-hqzqg      1/1     Running   0          28s
frontend    frontend-6dcbd67b4f-b9grf     1/1     Running   0          25s


Command:

kubectl get svc -A


✅ Expected output:

NAMESPACE   NAME         TYPE        CLUSTER-IP       PORT(S)          AGE
database    mongodb      ClusterIP   10.96.32.11      27017/TCP        30s
backend     backend      ClusterIP   10.96.88.42      8080/TCP         28s
frontend    frontend     ClusterIP   10.96.54.23      80/TCP           25s

4. Verify Ingress

Command:

kubectl get ingress -A


✅ Expected output:

NAMESPACE   NAME              CLASS    HOSTS             ADDRESS          PORTS   AGE
frontend    frontend-ingress  nginx    frontend.local    127.0.0.1        80      10s


Browser Test:

Add to /etc/hosts:
127.0.0.1 frontend.local

Visit: http://frontend.local

✅ You should see either:

The Nginx welcome page, or

A simple “Frontend is running” message if you customized it.

5. Network Policy Test

Backend → Database (✅ should succeed):

kubectl exec -n backend -it $(kubectl get pod -n backend -l app=backend -o jsonpath='{.items[0].metadata.name}') -- ping -c 2 mongodb.database.svc.cluster.local


✅ Expected:

PING mongodb.database.svc.cluster.local (10.96.32.11): 56 data bytes
64 bytes from 10.96.32.11: icmp_seq=0 ttl=64 time=0.742 ms
64 bytes from 10.96.32.11: icmp_seq=1 ttl=64 time=0.625 ms


Frontend → Database (should fail):

kubectl exec -n frontend -it $(kubectl get pod -n frontend -l app=frontend -o jsonpath='{.items[0].metadata.name}') -- ping -c 2 mongodb.database.svc.cluster.local


Expected:

ping: mongodb.database.svc.cluster.local: Name or service not known
command terminated with exit code 1


That’s the proof your NetworkPolicy is correctly isolating traffic.

6. Cleanup

Command:

bash scripts/cleanup.sh


✅ Expected output:

Deleting namespaces...
namespace "frontend" deleted
namespace "backend" deleted
namespace "database" deleted

✅ Cleanup complete!

💡 Success Checklist
Step	Check	Status
Cluster started	kubectl get nodes → Ready	✅
Namespaces created	kubectl get ns	✅
Pods running	kubectl get pods -A	✅
Ingress reachable	Browser → frontend.local	✅
NetworkPolicy working	Backend→DB ✅, Frontend→DB 
