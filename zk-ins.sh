#!/bin/bash
VER=$1
POOL=$2
ADDR=$3
WORKER=$4

echo "This script will install nvidia driver/CUDA and ZKWORK prover in your ubuntu system, and auto configure it to run on boot"

# if no VER or ADDR quit
if [ -z "$VER" ] || [ -z "$ADDR" ] || [ -z "$POOL" ] || [ -z "$WORKER" ] ; then
  echo "Usage: $0 <zkwork-version> <pool> <receive-address> <worker-name>"
  echo "Example: $0 0.2.2 aleo.hk.zk.work:10003 aleo1spkkxewxj2dl2lgdps9xr28093p5nxsvjv55g2unmqfu0hmwyuysmf4qp3 myworker"
  exit 1
fi

echo "deb http://cz.archive.ubuntu.com/ubuntu jammy main" >> /etc/apt/sources.list && apt update && DEBIAN_FRONTEND=noninteractive apt install libc6 -y && apt install -y g++-11

ubuntu-drivers install

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb

dpkg -i cuda-keyring_1.1-1_all.deb
apt-get update
apt-get -y install cuda-toolkit-12-6

wget https://gh-proxy.com/https://github.com/6block/zkwork_aleo_gpu_worker/releases/download/v$VER/aleo_prover-v$VER.tar.gz

tar -xvf aleo_prover-v$VER.tar.gz -C /opt

# geneate run/stop scripts
echo "#!/bin/bash
cd /opt/aleo_prover
./aleo_prover --address $ADDR --pool $POOL --custom_name $WORKER >> prover.log 2>&1
echo \$! > aleo_prover.pid
" > /opt/aleo_prover/start.sh
chmod +x /opt/aleo_prover/start.sh

echo "#!/bin/bash
kill -9 \$(cat /opt/aleo_prover/aleo_prover.pid)
" > /opt/aleo_prover/stop.sh
chmod +x /opt/aleo_prover/stop.sh

# add systemd service to run PWD/aleo_prover/run_prover.sh
echo "[Unit]
Description=Aleo Prover
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/aleo_prover
ExecStart=/opt/aleo_prover/start.sh
ExecStop=/opt/aleo_prover/stop.sh
Restart=always

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/aleo.service

systemctl daemon-reload
systemctl enable aleo.service
reboot


