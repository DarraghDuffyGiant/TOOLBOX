
fn fileSvnCommit setPath logMessage = 
(
	if doesFileExist setPath != false then
	(
		try
		(
			
			HiddenDOSCommand  ("TortoiseProc.exe /command:commit /path:"  + setPath + " /logmsg:" + logMessage + "/closeonend:0") donotwait:false exitCode:&exitcode
			--messageBox (setPath + " is committed")
		)
		catch
		( 
			messageBox "Problem with SVN Commit"
		)
	)
	else if doesFileExist setPath == false then
	(
		fileSvnUpdate setPath
		HiddenDOSCommand  ("TortoiseProc.exe /command:commit /path:"  + setPath + " /logmsg:" + logMessage + "/closeonend:0") donotwait:false exitCode:&exitcode
	)
	else
	(
		print "DONE!"
	)

)

fn fileSvnUpdate setPath = 
(
	if doesFileExist setPath == true then
	(
		try
		(
			
			HiddenDOSCommand  ("TortoiseProc.exe /command:update /path:"  + setPath + " /closeonend:1") donotwait:false exitCode:&exitcode
			print (setPath + " is up to date")
		)
		catch
		( 
			messageBox "Problem with SVN Update"
		)
	)
	else if doesFileExist setPath == false then
	(
		print (setPath + " is not there")
		STRIP_NAME =  trimleft setPath "C:\\SVN"
		HiddenDOSCommand ("TortoiseProc.exe /command:checkout /path:" + setPath + " /url:" + PROJ_URL + STRIP_NAME + " /closeonend:2 /blockpathadjustments /notempfile /noninteractive --quiet")
	)
	else
	(
		print "DONE!"
	)
)



fn fileSVNLock setPath =
(

	if doesFileExist setPath == true then
	(
		try
		(
			
			HiddenDOSCommand  ("TortoiseProc.exe /command:lock /path:"  + setPath + " /closeonend:2") donotwait:false exitCode:&exitcode
		)
		catch
		( 
			messageBox "Problem with SVN Update"
		)
	)
	else if doesFileExist setPath == false then
	(
		print (setPath + " is not there")
		STRIP_NAME =  trimleft setPath "C:\\SVN"
		HiddenDOSCommand ("TortoiseProc.exe /command:checkout /path:" + setPath + " /url:" + PROJ_URL + STRIP_NAME + " /closeonend:1 --quiet") donotwait:false exitCode:&exitcode
		HiddenDOSCommand  ("TortoiseProc.exe /command:lock /path:"  + setPath + " /closeonend:1") donotwait:false exitCode:&exitcode
		--messageBox (setPath + " is now locked")
	)
	else
	(
		print "DONE!"
	)
)


fn fileOptionsCheckout filePath =
(
	rollout fileOptionsCheckoutDialog "File Options"
	(		
		label theQuestoinLabel "Would you like to CHECKOUT the following?" 
		label theAssetLabel ASSET_CORE_ROOT offset:[0,10]
		button yes_BTN "YES" offset:[0,10] width:100
		button no_BTN "NO" offset:[0,10] width:100

		on yes_BTN pressed do
		(
			print "KEEP"
		)
		on no_BTN pressed do
		(
			DestroyDialog fileOptionsCheckoutDialog
		)
	)
	createDialog fileOptionsCheckoutDialog  250 125
)

fn getLogMessage =
(
	rollout SVNLogRollout "Log Commit Message:" 
	(
		label LOG_LBL "Add log message:" 
		edittext LOG_ET text:" " height:100
		button GIVE_LOG_BTN "Commit" pos:[75,150]

		on GIVE_LOG_BTN pressed do
		(
			global SVNLog = LOG_ET.text	
			DestroyDialog SVNLogRollout
		)
	)
	createDialog SVNLogRollout 250 200 modal:true
)