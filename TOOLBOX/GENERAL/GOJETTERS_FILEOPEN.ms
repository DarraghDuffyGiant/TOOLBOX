FileIn "C:\\SVN\\GOJETTERS\\TOOLBOX\\GENERAL\\FILE_TOOLS_WIP.ms"

fn fileOpenProjFolder  = (

	fileOpenInfo = fileInfoRetrieve()
	fileOpenInfo.filePath
	fileOpenInfoStrings = filterString fileOpenInfo.filePath "\\"

	if fileOpenInfoStrings[1] == "C:" and fileOpenInfoStrings[2] == "SVN" then
	(
		currentProjPath = pathConfig.getCurrentProjectFolder() 
		fileProjPath = (fileOpenInfoStrings[1] + "\\" + fileOpenInfoStrings[2] + "\\" + fileOpenInfoStrings[3])
		if fileProjPath != currentProjPath do
		(
			pathConfig.setCurrentProjectFolder fileProjPath
			messageBox ("Project Folder now set to " +fileProjPath)
		)
	)
	else 
	(
		messageBox "Please save and commit file to SVN directory"
	)
)
fileOpenProjFolder()

callbacks.removeScripts id:#GIANT
callbacks.addScript #filePostOpen "fileOpenProjFolder()" id:#GIANT




