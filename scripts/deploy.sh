#!/bin/bash
set -e

echo "🚀 Starting Kubernetes Networking Lab deployment..."

# Create namespaces
echo "📁 Creating namespaces..."
kubectl apply -f manifests/namespaces.yaml

# Deploy database
echo "🗄️  Deploying MongoDB..."
kubectl apply -f manifests/database/deployment.yaml
kubectl apply -f manifests/database/service.yaml
kubectl apply -f manifests/database/networkpolicy.yaml

# Deploy backend
echo "⚙️  Deploying Backend..."
kubectl apply -f manifests/backend/deployment.yaml
kubectl apply -f manifests/backend/service.yaml

# Deploy frontend
echo "💻 Deploying Frontend..."
kubectl apply -f manifests/frontend/deployment.yaml
kubectl apply -f manifests/frontend/service.yaml
kubectl apply -f manifests/frontend/ingress.yaml

echo "✅ Deployment complete!"
echo "➡️  Access frontend via http://frontend.local (add to /etc/hosts)"
