on run argv
	
	if script = class of argv then
		set today to (current date)
	else
		set today to (item 1 of argv)
	end if
	
	
	
	set today_weekday to weekday of today
	
	if today_weekday ≤ Thursday then
		set prev_thursday to (today - ((today_weekday as integer) + 2) * days)
	else
		set prev_thursday to (today - ((today_weekday as integer) - 5) * days)
	end if
	
	set this_dd to day of prev_thursday
	if this_dd < 10 and this_dd > 0 then
		set this_dd to ("0" & this_dd)
	end if
	
	set this_mm to run script (POSIX file "/Users/IceHe/Documents/AppleScript/Lib/month2mm.applescript") with parameters {prev_thursday}
	set this_yyyy to year of prev_thursday
	set this_yy to (this_yyyy mod 100)
	
	
	
	set this_thursday to (prev_thursday + 7 * days)
	
	set next_dd to day of this_thursday
	if next_dd < 10 and next_dd > 0 then
		set next_dd to ("0" & next_dd)
	end if
	
	set next_mm to run script (POSIX file "/Users/IceHe/Documents/AppleScript/Lib/month2mm.applescript") with parameters {this_thursday}
	set next_yyyy to year of this_thursday
	set next_yy to (next_yyyy mod 100)
	
	
	
	############
	# Launch at boot
	############
	
	run script (POSIX file "/Users/IceHe/Documents/AppleScript/Evernote/evernote_launch.applescript")
	
	
	
	tell application "Evernote"
		
		############
		# Export Job Report
		############
		
		set note_name to this_yy & this_mm & this_dd & " Job Report"
		set exported_note_name to this_yy & "_" & this_mm & "_" & this_dd & " Job Report"
		set exported_note_path to "/Users/IceHe/Documents/Enex/job_report/" & exported_note_name
		
		run script (POSIX file "/Users/IceHe/Documents/AppleScript/Evernote/note_export_html.applescript") with parameters {note_name, exported_note_path}
		
		
		
		############
		# Rename Job Report
		############
		
		set report_name_tail to " 何志远周报.md"
		
		set prev_thursday_str to (this_yyyy & "-" & this_mm & "-" & this_dd) as string
		set report_name to (prev_thursday_str & report_name_tail) as string
		set report_path to (exported_note_path & "/" & note_name & ".resources/" & report_name)
		
		set this_thursday_str to (next_yyyy & "-" & next_mm & "-" & next_dd) as string
		set next_report_name to (this_thursday_str & report_name_tail) as string
		set next_report_path to (exported_note_path & "/" & note_name & ".resources/" & next_report_name)
		
		set cmd to ("mv \"" & report_path & "\" \"" & next_report_path & "\"") as string
		do shell script cmd
		
		
		
		############
		# Mod Job Report
		############
		
		set cmd to "/usr/local/bin/python3 /Users/IceHe/Documents/Python/Mod_New_Job_Report.py \"" & next_report_path & "\" \"" & prev_thursday_str & "\" \"" & this_thursday_str & "\""
		
		log next_report_path
		log prev_thursday_str
		log this_thursday_str
		log cmd
		
		do shell script cmd
		
		
		
		############
		# Import Job Report
		############
		
		set next_job_report_note to (next_yy & next_mm & next_dd & " Job Report") as string
		
		#create note title next_job_report_note notebook "Job" with html "" attachments (POSIX file next_report_path)
		create note title next_job_report_note notebook "Job" with html "" attachments (POSIX file next_report_path)
		
		run script (POSIX file "/Users/IceHe/Documents/AppleScript/Evernote/attachment_append.applescript") with parameters {note_name, next_report_path}
		
	end tell
	
	return true
	
end run