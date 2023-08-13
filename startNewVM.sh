#!/bin/bash

function isRunning {

	isRunning=$(/usr/bin/vmrun -T ws list | grep -io "$1")
	
	if [[ ! -z $isRunning  ]]
	then
		path=$(find /home/user/VMs -name $1)
		echo "VM is running, shutting down the VM..."
		/usr/bin/vmrun -T ws stop $path
	fi

}

isRunning DebianServer_x64.vmx

instanceExist=$(ls /home/user/VMs/* |grep -io DebianServer_x64_linked.vmx)

if [[ ! -z $instanceExist  ]]
then
	echo -e "Une instance existe déjà, voulez-vous la supprimer ? [y/N]"
	read  ans
	if [[ $ans == y  ]]
	then
		isRunning DebianServer_x64_linked.vmx
		/usr/bin/vmrun -T ws deleteVM /home/user/VMs/Linked/DebianServer_x64_linked.vmx
	fi
fi

echo -e "\nCloning debian11 instance..."
/usr/bin/vmrun -T ws clone /home/user/VMs/DebianServer_x64/DebianServer_x64.vmx /home/user/VMs/Linked/DebianServer_x64_linked.vmx -cloneName=Debian11_Instance linked 

echo -e "\nStarting new debian11 instance"
/usr/bin/vmrun -T ws start /home/user/VMs/Linked/DebianServer_x64_linked.vmx nogui

IP=$(/usr/bin/vmrun -T ws getGuestIPAddress /home/user/VMs/Linked/DebianServer_x64_linked.vmx -wait)
echo -e "\nInstance IP: $IP"
