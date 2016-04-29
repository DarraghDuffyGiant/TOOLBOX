fn RelativePathsCallback = 
(
	callNP = callbacks.notificationParam()
	if callNP[1] !=3 then
	(
		fileBitMaps = GetClassInstances bitmaptex 
		global badFilePaths = #()
		global badFileNames = #()

		for theBitmap in fileBitMaps do
		(
			if(theBitmap.filename !=undefined) then
			(
				theBitmapFilename = theBitmap.filename
				sNewPath = pathConfig.convertPathToRelativeTo  theBitmapFilename (PathConfig.getCurrentProjectFolder())
				theBitmap.filename = sNewPath

				sNewPathBreak = FilterString sNewPath "\\"
				if sNewPathBreak[1] !="." do
				(
					append badFilePaths sNewPath
				)
					
				local fileBitmapType = (FilterString sNewPathBreak[sNewPathBreak.count]  ".")
				if fileBitmapType[2] == "psd" do
				(
					append badFileNames sNewPath
				)
			)
		)--end fn for rel paths and bad name collections

		rollout filePathRollout "Incorrect File Path"
		(
			listbox badFilePath "Wrong Location:" items:badFilePaths height:5
			listbox badFileName "Wrong file type:" items:badFileNames height:5
			--button badFileClose "OK" 
			/*
			on badFileClose pressed do
			(
				DestroyDialog FirstDialog
			)
			*/
		)

		if badFilePaths.count > 1 then
		(
			FirstDialog = newRolloutFloater "File Save Paths" 500 250
			addrollout filePathRollout FirstDialog
		)
		else 
		(
			print "File is clean"
		)
	) 
)



callbacks.removeScripts id:#GIANT
callbacks.addScript #filePreSaveProcess "RelativePathsCallback()" id:#GIANT


/*
a= undefined
fn saveTest =
(	
	a = callbacks.notificationParam()
	if a[1] == 1 then
	(
		print "saved!!"
	)
	else if a[1] == 2 then
	(
		print "held!!"
	) 
	else if a[1] == 3 then
	(
		print "Auto!!"
	) 
)

callbacks.removeScripts id:#GIANT
callbacks.addScript #filePreSaveProcess "saveTest()" id:#GIANT