# 🔍 Connectivity Tests

### 1️⃣ From Backend → Database (should succeed)
```bash
kubectl exec -n backend -it $(kubectl get pod -n backend -l app=backend -o jsonpath='{.items[0].metadata.name}') -- ping mongodb.database.svc.cluster.local
