#!/bin/bash
set -e

echo "🧹 Cleaning up Kubernetes Networking Lab..."
kubectl delete ns frontend backend database --ignore-not-found
echo "✅ Cleanup complete!"
