if test -f ~/.kube/config
then
echo " Kubeadm installed..✅"

else
# Package Installation
echo "[TASK 1] Update /etc/hosts file ☝"
sudo bash -c 'cat > /etc/hosts'<<EOF
10.0.0.10   master
10.0.0.10   localhost
10.0.0.11   worker1
10.0.0.12   worker2
EOF

gpasswd -a vagrant root

echo "[TASK 2] Installing Pre-requistes ☝"

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf 
overlay 
br_netfilter 
EOF

sudo modprobe overlay 
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf net.bridge.bridge-nf-call-iptables = 1 
net.ipv4.ip_forward = 1 
net.bridge.bridge-nf-call-ip6tables = 1 
EOF

sudo sysctl --system > /dev/null 2>&1

echo "[TASK 3] Setting up containerD ☝"

sudo apt-get update > /dev/null 2>&1 && sudo apt-get install -y containerd > /dev/null 2>&1

sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null 2>&1

sudo systemctl restart containerd

sudo swapoff -a

sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

echo "[TASK 4] Setting up KUBEADM Pre-requisites 🏁"

sudo apt-get update > /dev/null 2>&1 && sudo apt-get install -y apt-transport-https curl > /dev/null 2>&1

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - > /dev/null 2>&1

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update > /dev/null 2>&1

sudo apt-get install -y kubelet kubeadm kubectl > /dev/null 2>&1

sudo apt-mark hold kubelet kubeadm kubectl > /dev/null 2>&1

echo "[TASK 5] Creating new cluster 🎢"

sudo kubeadm init --pod-network-cidr 192.168.99.0/16 --apiserver-advertise-address 10.0.0.10 > /dev/null 2>&1

mkdir -p ~/.kube
sudo cp /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config

sleep 30

echo "[TASK 6] Creating CNI cluster network 🏁"

mkdir -p /home/vagrant/.kube
sudo cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown $(id vagrant -u):$(id vagrant -g) /home/vagrant/.kube/config

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml > /dev/null 2>&1
sleep 5

joinCommand=$(kubeadm token create --print-join-command 2>/dev/null)
echo "$joinCommand --ignore-preflight-errors=all" > /home/vagrant/joincluster.sh

fi

echo "Cluster Created Successfully ✅"