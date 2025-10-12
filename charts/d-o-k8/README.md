# Medplum Helm Kubernetes Deployment (DigitalOcean Edition)

## Prerequisites

- DigitalOcean Kubernetes Cluster (DOKS)
- cert-manager (installed)
- NGINX Ingress Controller (installed)
- DigitalOcean Managed Postgres (configured, credentials in env/secret)

## Instructions

1. **Install cert-manager and NGINX Ingress Controller**

   See DigitalOcean docs:
   - [cert-manager](https://docs.digitalocean.com/products/kubernetes/how-to/add-tls-ingress/)
   - [Ingress](https://docs.digitalocean.com/products/kubernetes/how-to/configure-ingress/)

2. **Apply the ClusterIssuer:**
   ```bash
   kubectl apply -f d-o-k8/cert-manager-issuer.yaml
   ```

3. **Customize `values.yaml`:**
   - Set backend image if different.
   - Set `.Values.ingress.domain` to `fhir.afiax.africa`
   - If you deploy frontend in cluster, replicate ingress/service for `ehr.afiax.africa`

4. **Deploy Medplum with Helm:**
   ```bash
   helm install medplum . -f values.yaml --namespace medplum --create-namespace
   ```

5. **DNS:**
   - Point `fhir.afiax.africa` (and `ehr.afiax.africa` if using cluster frontend) A record to your DigitalOcean LoadBalancer IP.

6. **Frontend:**
   - If static, consider DigitalOcean Spaces + CDN for `ehr.afiax.africa`
   - If dynamic/SSR, deploy as a container in DOKS or use App Platform

---

### Notes

- All secrets (DB creds, etc.) should be managed via Kubernetes secrets or environment variables.
- For production, set up resource requests/limits and persistence.
- For bots, see Knative documentation if needed.
