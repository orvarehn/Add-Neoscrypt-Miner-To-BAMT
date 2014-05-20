#!/bin/sh
mine stop
sleep 5
cd /opt/miners/
git clone https://github.com/kR105/cgminer.git cgminer-blake
cd /opt/miners/cgminer-blake
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
cp example.conf /etc/bamt/blake.conf
cd /etc/bamt/
patch /etc/bamt/bamt.conf <<.
115a116
>   cgminer_opts: --api-listen --config /etc/bamt/blake.conf
124a126
>   # Cgminer 3.7.2 "blake"
130a133
>   miner-cgminer-blake: 1
.
patch /opt/bamt/common.pl <<.
1477a1478,1480
>       } elsif (\${\$conf}{'settings'}{'miner-cgminer-blake'}) {
>         \$cmd = "cd /opt/miners/cgminer-blake;/usr/bin/screen -d -m -S cgminer-blake /opt/miners/cgminer-blake/cgminer --blake256 \$args";
>         \$miner = "cgminer-blake";
.
cd /etc/bamt/
patch /etc/bamt/blake.conf <<.
19a20,23
> "api-listen": true,
> "api-port": "4028",
> "api-allow": "W:127.0.0.1",
> 
.
echo 'Blake Miner Installed.'
echo 'Please review your /etc/bamt/bamt.conf to enable.'
echo 'Configure /etc/bamt/blake.conf with pool'
