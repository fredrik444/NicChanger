
$FilePath = "c:\tools\Network_Interface1.csv"


import-CSV $FilePath | ForEach-Object {
	$VM = $_.VM
	$VMPowerstate = $_.Powerstate
	
	if ($VMPowerstate -eq "PoweredOff") { #Må tenke litt på hva vi gjør her. Trenger vi å skru den på først, for at den skal lagre IP settings via scheduled task?
		get-vm $VM|get-networkadapter|set-networkadapter -type vmxnet3 -Confirm:$false
		write-host "Nic changed on:" $VM
		Start-VM $VM #-RunAsync
		write-host $VM "started"
	}
	elseif ($VMPowerstate -eq "PoweredOn") {
		Shutdown-VMGuest $VM -Confirm:$false
		get-vm $VM|get-networkadapter|set-networkadapter -type vmxnet3
		Start-VM $VM
	}
	else {
	Write-host $VM " in unknown state, let's not try to change the NIC on this VM.."
}