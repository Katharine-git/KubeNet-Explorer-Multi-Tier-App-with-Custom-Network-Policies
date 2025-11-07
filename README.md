# KubeNet-Explorer-Multi-Tier-App-with-Custom-Network-Policies

Networking is the backbone of Kubernetes.

I've set up a mini-project that will help you setup a cluster from scratch, deploy resources and build a basic network within the cluster.

🧩 1️⃣ After Cluster Start

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

📦 2️⃣ After Running bash scripts/deploy.sh

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

🧠 3️⃣ Verify Pods and Services

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

🌐 4️⃣ Verify Ingress

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

🔒 5️⃣ Network Policy Test

Backend → Database (✅ should succeed):

kubectl exec -n backend -it $(kubectl get pod -n backend -l app=backend -o jsonpath='{.items[0].metadata.name}') -- ping -c 2 mongodb.database.svc.cluster.local


✅ Expected:

PING mongodb.database.svc.cluster.local (10.96.32.11): 56 data bytes
64 bytes from 10.96.32.11: icmp_seq=0 ttl=64 time=0.742 ms
64 bytes from 10.96.32.11: icmp_seq=1 ttl=64 time=0.625 ms


Frontend → Database (❌ should fail):

kubectl exec -n frontend -it $(kubectl get pod -n frontend -l app=frontend -o jsonpath='{.items[0].metadata.name}') -- ping -c 2 mongodb.database.svc.cluster.local


❌ Expected:

ping: mongodb.database.svc.cluster.local: Name or service not known
command terminated with exit code 1


That’s the proof your NetworkPolicy is correctly isolating traffic.

🧹 6️⃣ Cleanup

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
NetworkPolicy working	Backend→DB ✅, Frontend→DB ❌
