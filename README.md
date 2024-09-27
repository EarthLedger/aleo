## Usage:  
Install and run zk.work aleo prover in a fresh ubuntu22.04 server machine, the script will auto install nvidia drivers and cuda toolkit.
the scirpt requires 3 parameters: [zk.work version], [server address], [your aleo wallet address]  
after install, the machine will auto restart, then please goto zk.work website to check your running status  
below demo using will install zk.work 0.2.2-full package, please replace the aleo wallet address to yours  
```shell
curl https://gh-proxy.com/https://raw.githubusercontent.com/EarthLedger/aleo/refs/heads/main/zk-ins.sh | bash -s 0.2.2 aleo.hk.zk.work:10003 aleo14jy6z0h384m6tyqdlx6djflk6d0wp7fug4xqz05wp95ppqaqaygsgagv4t
```
