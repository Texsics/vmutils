#!/bin/bash

function isRunning {

	isRunning=$(/usr/bin/vmrun -T ws list | grep -io "$1")
	
	if [[ ! -z $isRunning  ]]
	then
		return 0
	else
		return 1
	fi	

}

function shutDown {

	isRunning $1

	if [[ $? == 0  ]]
	then
		path=$(find /home/user/VMs -name $1)
		echo "VM $1 is running, shutting down the VM..."
		/usr/bin/vmrun -T ws stop $path
	fi
}

shutDown DebianServer_x64.vmx

echo -e "Starting Debian instance..."
/usr/bin/vmrun -T ws start /home/user/VMs/Linked/DebianServer_x64_linked.vmx nogui


echo -e "\nGetting instance IP..."
IP=$(/usr/bin/vmrun -T ws getGuestIPAddress /home/user/VMs/Linked/DebianServer_x64_linked.vmx -wait)
echo -e "\nInstance IP: $IP"
