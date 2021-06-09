## Dalle flask service

### Installation

`pip install -r requirements.txt`

## Usage

change model_paths.json with your dalle checkpoints

`python3 dalle_service.py 1234`


## Deployment to Openfaas

1. [Install Openfaas](https://docs.openfaas.com/deployment)

2. Label and Taint you k8s GPU node(s)

```bash
kubectl labels nodes node1 gpu=installed
kubectl taint nodes node1 gpu:NoSchedule
```

3. Create a Profile to that allows functions to run on this node

```bash
kubectl apply -f- << EOF
kind: Profile
apiVersion: openfaas.com/v1
metadata:
  name: withgpu
  namespace: openfaas
spec:
    tolerations:
    - key: "gpu"
      operator: "Exists"
      effect: "NoSchedule"
    affinity:
      nodeAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: gpu
                operator: In
                values:
                - installed
EOF
```

4. Build & Deploy

```bash
faas-cli up -f dalle-service-openfaas.yml
```

5. Call

```bash
echo "a cat with wings" | faas-cli invoke dalle-service-openfaas
```