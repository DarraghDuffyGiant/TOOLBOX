FileIn "C:\\SVN\\GOJETTERS\\TOOLBOX\\GENERAL\\GOJETTERS_INIT.ms"

fn getFileInfo = 
(
	/*
	Puts variables into an array from file name and path to construct the file info I.E "GJ_110_LFG"
	1: File path
	2: Max file Name
	3: Project code number
	4: Episode number
	5: Shot number
	6: Shot type (SCREEN/BG, etc.)
	*/
	if maxFileName != "" then
	(
		filePath = maxFilePath 
		fileName = maxFileName 
		fileName = trimright fileName ".max"
		fileNameFilter = FilterString fileName "_"
		fileNameFilterCount = fileNameFilter.count
		if fileNameFilter[fileNameFilterCount] == "ANM" then
		(
			fileProjName = fileNameFilter[1]
			fileEPNumber = fileNameFilter[2]
			fileSHNumber = fileNameFilter[4]
			fileSHType = fileNameFilter[5]
			fileInfo = #(filePath,fileName,fileProjName,fileEPNumber,fileSHNumber,fileSHType)

			for i = 1 to EPISODE_NUMBERS.count do
			(
				if i !=undefined do
				(
					if EPISODE_NUMBERS[i] == fileEPNumber then
					(
						EPISODE_NUMBER = i
						append fileInfo EPISODE_NUMBER
					)
				)
			)
		)
		else if fileNameFilter[fileNameFilter.count] == "PRD" then
		(
			messageBox "Not a SH file. This is a PRD file"
		)

	) --end if
	else 
	(
		print "File not saved as asset type (ANM/PRD)"
	)
	return fileInfo
)

fn prepFileInfo fileInfo projCode   = 
(	
	print fileInfo fileInfo[3]
	if fileInfo[3] == projCode then
	(
		print "match"
	)

)

fn getEPCode fileInfoArray =
(
	local fileInfo = fileInfoArray
	for i = 1 to EPISODE_NUMBERS.count do
	(
		if fileInfo[4] == EPISODE_NUMBERS[i] then 
		(
			return EPISODE_CODES[i]
			print EPISODE_CODES[i]
		)
	)
)

fn getSHFile fileInfoArray =
(
	/*
	*Takes information from shot file name ("GJ_138_SH_0010_ANM") and creates the directory information for folder/file creation
	*/
	local fileInfo = fileInfoArray
	EPCODE = getEPCode()
	local SH_FILE_PATH =  (EPISODE_ROOT_DIR) +\	--ROOT FOLDER (C:\SVN\EPISODES\)
	(fileInfo[3] + "_"+ fileInfo[4] + "_"+  EPCODE) + "\\" +\  --EPISODE FOLDER (GJ_110_LFG)
	(fileInfo[3] + "_"+ fileInfo[4] + "_3D") + "\\" +\  --EPISODE 3D FOLDER (GJ_110_3D)
	(fileInfo[3] + "_"+ fileInfo[4] + "_SH" + "_" + fileInfo[5]) + "\\" +\ --EPISODE SHOT FOLDER (GJ_110_LFG_0010)
	(fileInfo[3] + "_"+ fileInfo[4] + "_SH" + "_" + fileInfo[5] + "_ANM.max") 

	return SH_FILE_PATH
)

fn getSHFolder fileInfoArray =
(
	/*
	*Takes information from shot file name ("GJ_138_SH_0010_ANM") and creates the directory information for folder/file creation
	*/
	local fileInfo = fileInfoArray
	EPCODE = getEPCode()
	local SH_FOLDER_PATH =  (EPISODE_ROOT_DIR) +\	--ROOT FOLDER (C:\SVN\EPISODES\)
	(fileInfo[3] + "_"+ fileInfo[4] + "_"+  EPCODE) + "\\" +\  --EPISODE FOLDER (GJ_110_LFG)
	(fileInfo[3] + "_"+ fileInfo[4] + "_3D") + "\\" +\  --EPISODE 3D FOLDER (GJ_110_3D)
	(fileInfo[3] + "_"+ fileInfo[4] + "_SH" + "_" + fileInfo[5]) --EPISODE SHOT FOLDER (GJ_110_LFG_0010)


	return SH_FOLDER_PATH
)


fn getFileInfoFromTool fileInfoArray = 
(
	/*
	Puts variables into an array from file name and path to construct the file info I.E "GJ_110_LFG"
	1: File path
	2: Max file Name
	3: Project code number
	4: Episode number
	5: Shot number
	6: Shot type (SCREEN/BG, etc.)
	*/
	local fileInfo = fileInfoArray
	EPCODE = getEPCode()
	local SH_FOLDER_PATH =  (EPISODE_ROOT_DIR) +\	--ROOT FOLDER (C:\SVN\EPISODES\)
	(fileInfo[3] + "_"+ fileInfo[4] + "_"+  "EPCODE") + "\\" +\  --EPISODE FOLDER (GJ_110_LFG)
	(fileInfo[3] + "_"+ fileInfo[4] + "_3D") + "\\" +\  --EPISODE 3D FOLDER (GJ_110_3D)
	(fileInfo[3] + "_"+ fileInfo[4] + "_SH" + "_" + fileInfo[5]) --EPISODE SHOT FOLDER (GJ_110_LFG_0010)

	return fileInfo 
)