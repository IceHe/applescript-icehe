on run argv
	
	try
		
		if script = class of argv then
			set today to (current date)
		else
			set today to (item 1 of argv)
		end if
		
		
		
		if Monday ≠ weekday of today then
			return false
		end if
		
		set yesterday to (today - 1 * days)
		
		
		
		set day_dd to day of yesterday
		if day_dd < 10 and day_dd > 0 then
			set day_dd to ("0" & day_dd)
		end if
		
		set month_mm to run script (POSIX file "/Users/IceHe/Documents/AppleScript/Lib/month2mm.scpt") with parameters {yesterday}
		set year_yyyy to year of yesterday
		set year_yy to (year_yyyy mod 100)
		
		set note_name to (year_yyyy & "/" & month_mm & " stu") as string
		
		
		
		# 判断：本月的综合日志，否已不存在
		set is_stat to (run script (POSIX file "/Users/IceHe/Documents/AppleScript/Evernote/note_exist.scpt") with parameters {note_name})
		
		if is_stat = false then
			return false
		end if
		
		
		
		# 确认：是否进行后续操作（昨日的时间日志必须正确且完整，统计数据才会正确！）
		tell application "Evernote"
			display alert ¬
				"Confirm" message ¬
				"Ready to Stat Last Week?" as informational ¬
				buttons {"Cancel", "Now!"} ¬
				default button 1 ¬
				giving up after 60
		end tell
		
		if "Now!" ≠ (button returned of result) then
			return false
		end if
		
		
		
		# 对本月的时间日志进行格式简化
		run script (POSIX file "/Users/IceHe/Documents/AppleScript/Evernote/note_simplify_format.scpt") with parameters {note_name}
		
		
		
		# 启动终端，然后调用有关Python进行后续操作
		run script (POSIX file "/Users/IceHe/Documents/AppleScript/Lib/cmds_in_iterm.scpt") with parameters {{"/Users/IceHe/Documents/Python/Week_Time_Stat.py " & (short date string of today)}}
		
		return true
		
	on error
		
		return "error"
		
	end try
	
end run