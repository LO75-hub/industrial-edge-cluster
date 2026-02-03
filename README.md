Industrial Edge Cluster Simulation (Virtual Environment)
This repository provides a sandbox environment to develop, test, and validate Cloud-Native applications destined for resource-constrained Edge devices. It uses a virtualized cluster architecture to simulate physical hardware (e.g., Raspberry Pi nodes) for development and CI/CD purposes.
Overview
The primary goal of this project is to eliminate hardware dependency during the initial development cycles of IoT/Edge applications. By leveraging Multipass for virtualization and K3s for orchestration, it recreates an industrial-grade infrastructure on a single development machine.
Key Technical Specs:
Orchestration: K3s (Lightweight Kubernetes)
Virtualization: Multipass (Ubuntu instances)
Provisioning: Automated Bash/Ansible bootstrapping
Application Stack: Python/Flask (Simulated Industrial Sensors)
Networking: NodePort routing for external access
Project Architecture
The cluster follows a standard Master/Worker topology, optimized for low resource consumption:
1 Master Node (edge-master): Runs the Control Plane and API Server.
N Worker Nodes (edge-worker): Executes containerized workloads.
Service Layer: NodePort implementation to expose sensor data to the local network for external monitoring systems.
Getting Started
Prerequisites
Multipass (Canonical) installed.
kubectl installed on the host machine.
1. Bootstrap the Infrastructure
Run the provisioning script to launch the VMs and initialize the K3s cluster:
code
Bash
chmod +x infra/bootstrap-cluster.sh
./infra/bootstrap-cluster.sh
2. Configure Local Access
To manage the cluster from your host terminal:
code
Bash
# Sync kubeconfig with the master node IP
MASTER_IP=$(multipass info edge-master | grep IPv4 | awk '{print $2}')
multipass exec edge-master sudo cat /etc/rancher/k3s/k3s.yaml > k3s-config.yaml
sed -i "s/127.0.0.1/${MASTER_IP}/g" k3s-config.yaml
export KUBECONFIG=$(pwd)/k3s-config.yaml
3. Deploy Workloads
Apply the manifests to start the simulated industrial sensors:
code
Bash
kubectl apply -f k8s/
Monitoring & Metrics
The simulated sensors expose industrial telemetry (Temperature, Vibration, Status) in JSON format.
You can query the metrics via the designated NodePort:
code
Bash
curl http://<MASTER_IP>:30001/metrics
Performance & Optimization
The environment is tuned for limited resources:
K3s is installed with --disable traefik and --disable servicelb to maximize available RAM for applications.
Container images utilize Alpine/Slim bases to reduce pull latency and storage footprint.

