/*
--FILE_TOOLS--
04/14/16 
Author: Darragh Duffy - darragh.duffy.giant@gmail.com

v1.1 - 
--create structs with functions in order to retrieve instanced info - rather than use global vairables
--

To-Do:
--Can the tool read from preset metadata rather than explicit file naming

*/
struct fileInfoRetrieve (

/*
Get base information on the max file. If the maxfile returns
undefined or does not meet the criteria the class returns blanks
Array:fileProjInfo:(#1 - Project Code,#2 - EP Number,#3 - "SH",#4 - Shot Number,#5 - File Type "ANM",#6 - SH Type "Default"/"SCREEN"/"A")
*/
private
init,

public
fileFilterCount = 0,
filePath = "",
fileName = "",
fileType = "",
fileProj = #("GJ", "DNG", "ABG","XXX"),
fileProjInfo = #(),


	fn getBaseFileInfo =
	(
		if maxFilePath != "" then
		(
			filePath = maxFilePath
			fileName = maxFileName
			fileTypeFilter = FilterString fileName "." --Takes the file type out from the "." in string (i.e".max")
			fileType = ("." + fileTypeFilter[2])
			fileName = trimright fileName fileType 
			fileNameFilter = FilterString fileName "_" --Breaks the name of the asset into specific parts based on a "_"
			fileFilterCount = fileNameFilter.count

			if fileNameFilter.count >=2 then
			(

				fileProjInfo = fileNameFilter

			)
		)
		else
		(
			fileProjInfo = #()
		)
	),

testA = getBaseFileInfo() --Runs function and populates the public variables

)

struct fileSHInfo (
/*
Based on information obtained from the fileInfoRetrieve class it will setup the SHOT info needed for max tools
Array:fileProjInfo:
#1 - EPNumber: Returns the Episode number of a working file
#2 - EPNumberSelection: Numerical value used to decifer the index of the EP in a Season (10 integer is episode number 10)
#3 - EPShotNumber: is the 4 digit number of the shot ("0010")
#4 - EPShotType: Specific to ANM files where some are SCREEN, BG and other shots
#5 - EPCode: Returns the 3 letter episode code ("NYC" for New York City)



*/

private
init,

public
projCode = "",
projNumberSelection = 1,
EPNumber = "101",
EPNumberSelection = 1,
EPCode = "XXX",
EPShotNumber = "0010",
EPShotType = "Default",


	fn setSHInfo  fileProjInfoArray  fileProjArray = 
	(

	-- getSHNumber getFileType getSHType 
		if fileProjInfoArray !="" then 
		(
			getSHCount = fileProjInfoArray.count
			
			for i = 1 to fileProjArray.count do 
			(
				if fileProjArray[i] == fileProjInfoArray[1] then
				(
					projNumberSelection = i
				)
				else if fileProjInfoArray[1] == undefined then
				(
					projNumberSelection = fileProjArray.count
				)
			)


			for i = 1 to fileProjInfoArray.count do 
			(
				if fileProjInfoArray[i] == "SH" do 
				(
					EPShotNumber = fileProjInfoArray[i+1]
				)
			)


			if getSHCount >= 5 then
			(
				--This section should read from an xml instead. 
				--The EPISODES info could be obtained from the PREVIS tool
				EPNumber = fileProjInfoArray[2]
				for i = 1 to EPISODE_NUMBERS.count do
				(
					
					if EPISODE_NUMBERS[i] == EPNumber do
					(
						EPNumberSelection = i
					)

				)
				EPCode = EPISODE_CODES[EPNumberSelection]
				

				if fileProjInfoArray[6] != undefined then
				(
					EPShotType =  fileProjInfoArray[6]
				)
				else 
				(
					
					EPShotType = "Default"
				)
			)
		)
		else
		(
			EPNumber = ""
			EPNumber = ""
			projCode = #("GJ","DNG")


		)
	)
)

rx = dotnetobject "System.Text.RegularExpressions.Regex" "\*_SH_[0-9]{2}_ANM.*"
filename = maxFileName
rx.isMatch filename


struct fileProjSetup (
/*
Based on information obtained from file name this populates information variables.
When the function discovers that the file is of a certain project it 
will initiate project specific information directories.
It will also test for asset types and preload relevant tools. I.E - A SET file preloads SET_CHECK tools
*/
private
init,
inputArray,


public
assetType = "",
projRootFolder = "",
projEpisodeFolder = "",
projRenderFolder = "",
projRefFolder = "",
projAlembiFolder = "",
setFileName = "",
filePathFull = "",
filePathFolder = "",
fileABCPath = "",

	fn getAssetType fileNameArray = (
	/*
	Discovers the file type of the maxfile that is open or selected based on the naming of the file.
	I.E.- If there is "ANM" in the name then it reads an anm file.
	*/
		testArray = fileNameArray

		CHAR = DataPair "Character" "_C_" 
		PROP = DataPair "Prop" "_P_"		
		SETS = DataPair "Set" "_S_"	
		ANM =  DataPair "Animation" "_ANM_"
			
		for i in testArray do
		(
			if matchPattern i pattern:ANM.v2 then
			(
				print ("This is an " + ANM.v1)
				assetType = ANM.v1
			)
		)
	),

	fn getProj getProjCode = (
	/*
	Intitiates information directories. Based on discovering the project code.
	*/
		if getProjCode == "GJ" then
		(
			FileIn "C:\\SVN\\GOJETTERS\\TOOLBOX\\GENERAL\\GOJETTERS_INIT_WIP.ms"
			projRootFolder = ASSETS_ROOT_DIR
			projEpisodeFolder = EPISODE_ROOT_DIR
			projRenderFolder = RENDERS_ROOT_DIR
			pathConfig.setCurrentProjectFolder projRootFolder
		)
		else if getProjCode == "DNG" then
		(
			FileIn "C:\\SVN\\GOJETTERS\\TOOLBOX\\GENERAL\\DNG_INIT_WIP.ms"
			projRootFolder = PROJ_ROOT_DIR
			projRenderFolder = RENDERS_ROOT_DIR
			projAlembiFolder = ALEMBIC_ROOT_DIR		
			--pathConfig.setCurrentProjectFolder projRootFolder
		)
		else 
		(
			print "Default Proj values"
			EPISODES =#()
			SKIES = #()

		)

	),

	fn setSHFilePath fileName projCode projRoot EPNum  EPCode SHNum fileType = (
	/*
	Puts variables into an array from file name and path to construct the file info I.E "GJ_110_LFG"

	EPISODE shot directory structure:
	1: ROOT FOLDER (C:\SVN\EPISODES\)
	2: EPISODE FOLDER (GJ_110_LFG)
	3: EPISODE 3D FOLDER (GJ_110_3D)
	4: EPISODE SHOT FOLDER (GJ_110_LFG_0010)
	*/

		if fileName != "" then
		(
			filePathFolder =  (projRoot) +\	--ROOT FOLDER (C:\SVN\EPISODES\)
			(projCode + "_"+ EPNum + "_"+  EPCode) + "\\" +\  --EPISODE FOLDER (GJ_110_LFG)
			(projCode + "_"+ EPNum + "_"+  "3D") + "\\" +\  --EPISODE 3D FOLDER (GJ_110_3D)
			(projCode + "_"+ EPNum +  "_SH_" + SHNum) --+ "\\" +\   --EPISODE SHOT FOLDER (GJ_110_LFG_0010)

			setFileName = (projCode+ "_"+ EPNum +  "_SH_" + SHNum + "_ANM" + fileType) --EPISODE SHOT FILE NAME (GJ_110_LFG_0010_ANM.max)

			filePathFull = (filePathFolder + "\\" + setFileName)
		)
	),

	fn setABCFile alembicRoot SHNum meshLayerName= (
	/*
	Puts variables into an array from file name and path to construct the file info I.E "GJ_110_LFG"

	EPISODE shot directory structure:
	1: ROOT FOLDER (C:\SVN\EPISODES\)
	2: EPISODE FOLDER (GJ_110_LFG)
	3: EPISODE 3D FOLDER (GJ_110_3D)
	4: EPISODE SHOT FOLDER (GJ_110_LFG_0010)

	fileName SHNum fileType 
	*/


		if fileName != "" then
		(
			filePathFolder =  (alembicRoot) +\	--ROOT FOLDER (C:\SVN\EPISODES\)
			("SH" + "_"+ SHNum)

			setFileName = (meshLayerName + ".abc") --EPISODE SHOT FILE NAME (GJ_110_LFG_0010_ANM.max)

			fileABCPath = (filePathFolder + "\\" + setFileName)

		)
	)
)


struct fileFolderFunctions (
    -- Struct body.
    public
    folderExists = false,
    folderOverwrite = false,

    fn testForFile folderPath = (

		if doesFileExist folderPath == true then
		(
			folderExists = true
			local fileNameFilter = filterstring folderPath "\\"
			local fileName = fileNameFilter.count
			folderOverwrite = queryBox "already exists. Overwrite?" title:"Overwrite File"
		)
		else
		(
			folderExists = false
			--messagebox ("Folder doesn't exist")
		)

    ),


    fn createFolderInc folderPath = (


		if doesFileExist folderPath != false then
		(
			messagebox (" Folder ALREADY existS")
		)
		else
		(
			messagebox (" Folder doesn't exist")
		)

    ),

	fn openFileDir folderPath = (
	/*
	Checks if a folder exists based on file path info and opens the director
	*/	
		print folderPath

		if doesFileExist folderPath != false then
		(
			shellLaunch "explorer.exe" folderPath
		)
		else
		(
			messagebox (" Folder doesn't exist")
		)
	)
)

