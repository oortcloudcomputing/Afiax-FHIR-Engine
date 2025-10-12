#!/bin/bash
set -e

NAMESPACE="medplum"

echo "🧹 Cleaning up Medplum deployment in DigitalOcean Kubernetes..."

echo "📦 Uninstalling Helm releases..."
helm uninstall medplum -n $NAMESPACE 2>/dev/null || echo "No medplum backend Helm release found"
helm uninstall medplum-frontend -n $NAMESPACE 2>/dev/null || echo "No medplum frontend Helm release found"

echo "🗑️ Deleting Knative bots..."
kubectl delete kservice --all -n $NAMESPACE 2>/dev/null || echo "No Knative services found"

echo "🔑 Deleting Medplum secrets..."
kubectl delete secret medplum-db-secret -n $NAMESPACE 2>/dev/null || echo "No db secret found"
kubectl delete secret medplum-redis-secret -n $NAMESPACE 2>/dev/null || echo "No redis secret found"

echo "🚦 Deleting cert-manager resources (ClusterIssuer, etc)..."
kubectl delete clusterissuer letsencrypt-nginx 2>/dev/null || echo "No ClusterIssuer found"

echo "🚪 Deleting namespace..."
kubectl delete namespace $NAMESPACE 2>/dev/null || echo "No medplum namespace found"

echo "✅ Cleanup complete!"