#!/bin/sh
mine stop
sleep 5
cd /opt/miners/
git clone https://github.com/vehre/neo-gpuminer.git cgminer-neoscrypt
cd /opt/miners/cgminer-neoscrypt
make clean
sleep 5
chmod +x autogen.sh
./autogen.sh
sleep 2
CFLAGS="-O2 -Wall -march=native -I /opt/AMDAPP/include/" LDFLAGS="-L/opt/AMDAPP/lib/x86" ./configure --enable-opencl
sleep 5
make install
sleep 5
clear
cp example.conf /etc/bamt/neoscrypt.conf
cd /etc/bamt/
patch /etc/bamt/bamt.conf <<.
115a116
>   cgminer_opts: --api-listen --config /etc/bamt/neoscrypt.conf
124a126
>   # Cgminer 3.7.7b "neoscrypt"
130a133
>   miner-cgminer-neoscrypt: 1
.
patch /opt/bamt/common.pl <<.
1151a1151,1510
>       } elsif (\${\$conf}{'settings'}{'miner-cgminer-neoscrypt'}) {
>         \$cmd = "cd /opt/miners/cgminer-neoscrypt;/usr/bin/screen -d -m -S cgminer-neoscrypt /opt/miners/cgminer-neoscrypt/cgminer --neoscrypt \$args";
>         \$miner = "cgminer-neoscrypt";
.
cd /etc/bamt/
patch /etc/bamt/neoscrypt.conf <<.
19a20,23
> "kernel" : "neoscrypt",
> "api-listen": true,
> "api-port": "4028",
> "api-allow": "W:127.0.0.1",
> 
.
echo 'Neoscrypt Miner Installed.'
echo 'Please review your /etc/bamt/bamt.conf to enable.'
echo 'Configure /etc/bamt/neoscrypt.conf with pool'
