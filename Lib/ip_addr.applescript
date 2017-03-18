on run argv
	
	set is_show_ip to false
	
	if script � class of argv then
		if true = (item 1 of argv) then
			set is_show_ip to true
		end if
	end if
	
	# Physical
	set cur_ip to do shell script "/sbin/ifconfig en7|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d 'addr:'"
	
	if cur_ip = "" then
		# Wireless
		set cur_ip to do shell script "/sbin/ifconfig en0|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d 'addr:'"
	end if
	
	if cur_ip � "" then
		do shell script "echo '" & cur_ip & "' | tr -d \"\\n\" | pbcopy"
		
		if is_show_ip then
			display alert "IP: " & cur_ip
		end if
	end if
	
end run