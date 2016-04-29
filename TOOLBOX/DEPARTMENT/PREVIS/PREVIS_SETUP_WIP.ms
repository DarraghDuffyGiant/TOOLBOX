try closeRolloutFloater FirstDialog catch()
include "C:\\SVN\\GOJETTERS\\TOOLBOX\\GENERAL\\FILE_TOOLS_WIP.ms"
include "C:\\SVN\\GOJETTERS\\TOOLBOX\\GENERAL\\SVN_TOOLS.ms"
include "C:\\SVN\\GOJETTERS\\TOOLBOX\\GENERAL\\CAMERA_TOOLS.ms"
include "C:\\SVN\\GOJETTERS\\TOOLBOX\\GENERAL\\GENERAL_TOOLS_WIP.ms"
include "C:\\SVN\\GOJETTERS\\TOOLBOX\\GENERAL\\GOJETTERS_INIT_WIP.ms"
/*
--PREVIS TOOL--

The PREVIS tool will update based on filename info if the file is already open. 
If the file isnt open it will add default info.

09/09
Author: Darragh Duffy - darragh.duffy.giant@gmail.com

To-Do:
--Clean up the add cloud section
--Make it so the tool isnt dependant on an array of info on project specific listing
--Make it so if there is no recognised project that the drop down initiates the required info 
*/


previsFileInfo = fileInfoRetrieve()
previsFileSHInfo = fileSHInfo()
previsProjSetup = fileProjSetup()
previsProjSetup.getProj previsFileInfo.fileProjInfo[1]
previsFileSHInfo.setSHInfo previsFileInfo.fileProjInfo previsFileInfo.fileProj
previsProjSetup.setSHFilePath previsFileInfo.fileName previsFileInfo.fileProjInfo[1] previsProjSetup.projEpisodeFolder previsFileSHInfo.EPNumber previsFileSHInfo.EPCode previsFileSHInfo.EPShotNumber previsFileInfo.fileType


/*

previsFileInfo.fileProjInfo
previsFileSHInfo.projCode
previsFileSHInfo.EPNumber
previsFileSHInfo.EPNumberSelection
previsFileSHInfo.EPShotNumber
previsFileSHInfo.EPShotType
previsFileSHInfo.EPCode

previsProjSetup.projRootFolder
previsProjSetup.projRenderFolder
previsProjSetup.projRefFolder
previsProjSetup.setFileName
previsProjSetup.filePathFull
previsProjSetup.filePathFolder
*/

FirstDialog = newRolloutFloater "PREVIS SETUP" 500 800

rollout SHOTRollout "1. Shot details:"
(


	--PROJ/FOLDER SETTINGS
	dropdownlist PROJECT_DDL "Project:" items:previsFileInfo.fileProj selection:previsFileSHInfo.projNumberSelection pos:[10,10] width:100 --Dropdown to decide on Project
	dropdownlist EPISODE_DDL "Episode:" items:EPISODES selection:previsFileSHInfo.EPNumberSelection offset:[120,-45] width:100
	label SH_LBL "SH:" pos:[250,12] width:120 
	edittext SH_ET "" offset:[230,0] width:80 text:previsFileSHInfo.EPShotNumber
	dropdownlist SH_TYPE_DDL items: "SH Type:" pos:[350,12] width:120 
	edittext SH_TYPE_ET "" text:previsFileSHInfo.EPShotType pos:[340,30] width:100

	--SKY/CLOUD SETTINGS
	ListBox ADD_SKY_LB "Pick SKY type:" items:SKIES selection:2 pos:[10,75] width:125 HEIGHT:5
	label CLOUD_TYP_LBL "3D CLOUD TYPE:" pos:[150, 75]
	checkbox ADD_DAY_CLOUDS_CB "DAY" pos:[150, 100]
	checkbox ADD_NIGHT_CLOUDS_CB "NIGHT" offset:[200,-20]
	label CYCL_SET_LBL "CLOUD CYCLE TYPE:" pos:[150, 120]
	checkbox ADD_DAY_CYC_SET_CB "DAY" pos:[150, 140]
	checkbox ADD_NGT_CYC_SET_CB "NIGHT" offset:[200, -20]

	--CAM/SVN BUTTONS
	checkbox ADD_CAM_CB "ADD SH CAMERA" pos:[10, 175]
	button OPEN_DIR_BTN "OPEN DIR"  pos:[280, 75] width:50 HEIGHT:50
	button GET_LOCK_BTN "LOCK"  pos:[340, 75] width:50 HEIGHT:50
	button COMMIT_BTN "COMMIT"  pos:[400, 75] width:50 HEIGHT:50
	button CREATE01_BTN "CREATE"  pos:[340, 130] width:100 HEIGHT:50

	on PROJECT_DDL selected i do
	(	
		previsProjSetup.getProj previsFileInfo.fileProj[i]
		EPISODE_DDL.items = EPISODES
	)

	on ADD_SKY_LB selected val do
	(
		environmentMap = bitmapTexture filename:SKIES_LOC[1]
		global SKIES_INDEX = ADD_SKY_LB.selection
		environmentMap = bitmapTexture filename:SKIES_LOC[SKIES_INDEX]
	)

	on GET_LOCK_BTN pressed do
	(
		fileSVNLock FilePath
	)

	on OPEN_DIR_BTN pressed do
	(
		fileFolderFunctions.openFileDir previsProjSetup.filePathFolder
	)

	on COMMIT_BTN pressed do
	(
		fileSvnCommit previsProjSetup.filePathFull "Mesasge"
	)

	on CREATE01_BTN pressed do
	(
		local camName  = ("CAM"+"_"+previsFileSHInfo.EPNumber+"_SH_"+previsFileSHInfo.EPShotNumber+"_V001")
		local camLayerName ="CAM_GRP"

		--ADDS SHOT CAMERA
		if ADD_CAM_CB.triState != 0 do
		(
			d = generalCameraFunctions()
			d.testForCam camName
			d.createCam camName
			d.testForCamLayer camLayerName camName
		)


		if ADD_DAY_CLOUDS_CB.triState != 0 do
		(
			local cloudDayLayer = #()

			for i = 1 to LayerManager.count-1 do 
			(
				layer = LayerManager.getLayer i

				if layer.name == "CLOUDS_GRP" then 
				(
					append  cloudDayLayer i
				)
			)
			if cloudDayLayer[1] == undefined then
			(
				mergeAsset CLOUDS_LOC[1]
				GroupLayers "GRP"
			)
			else
			(
				messageBox "Clouds already in shot"
			)
		)--IF ADDS DAY CLOUDS TICKED

		--ADDS NIGHT CLOUDS 
		if ADD_NIGHT_CLOUDS_CB.triState != 0 do
		(
			local cloudNightLayer = #()

			for i = 1 to LayerManager.count-1 do 
			(
				layer = LayerManager.getLayer i

				if layer.name == "CLOUD-NIGHT_GRP" then 
				(
					append  cloudNightLayer i
				)
			)
			if cloudNightLayer[1] == undefined then
			(
				mergeAsset CLOUDS_LOC[2]
				GroupLayers "GRP"
			)
			else
			(
				messageBox "Clouds already in shot"
			)
		)--IF ADDS NIGHT CLOUDS TICKED

			--ADDS DAY CLOUD CYCLE SET
		if ADD_DAY_CYC_SET_CB.triState != 0 do
		(
			local cloudCycleLayer = #()

			for i = 1 to LayerManager.count-1 do 
			(
				layer = LayerManager.getLayer i

				if layer.name == "DAY-SKY-CYCLE_GRP" then 
				(
					append  cloudCycleLayer i
				)
			)

			if cloudCycleLayer[1] == undefined then
			(
				--print "merge day cycle"
				mergeAsset CYCLE_SETS_LOC[1]
				GroupLayers "GRP"
			)
			else
			(
				messageBox "Clouds already in shot"
			)
		)--IF DAY CLOUD CYCLE SET TICKED

		--ADDS NIGHT CLOUD CYCLE SET
		if ADD_NGT_CYC_SET_CB.triState != 0 do
		(
			local cloudCycleLayer = #()

			for i = 1 to LayerManager.count-1 do 
			(
				layer = LayerManager.getLayer i

				if layer.name == "NIGHT-SKY-CYCLE_GRP" then 
				(
					append  cloudCycleLayer i
				)
			)

			if cloudCycleLayer[1] == undefined then
			(
				--print "merge day cycle"
				mergeAsset CYCLE_SETS_LOC[2]
				GroupLayers "GRP"
			)
			else
			(
				messageBox "Clouds already in shot"
			)
		)--IF NIGHT CLOUD CYCLE SET TICKED
	)
)


rollout SETRollout "2. Set import:"
(
	ListBox SETS_LB "Core Sets" items:SETS width:150 height:6 pos:[0,0]
	MultiListBox SETPROPS_MLB "Set Props: CTRL + select" selection:#(1) items:SETPROPS[1] width:150 height:6 offset:[155,-105]
	button SETS_ADD_BTN "ADD"  offset:[150,-80]

	local SETS_INDEX = 1
	local SETPROPS_INDEX = #(1)

	on SETS_LB selected val do 
	(
		SETS_INDEX = val
		if SETPROPS[val] != undefined then 
		(
			SETPROPS_MLB.items = SETPROPS[val]
		)
		else 
		(
			SETPROPS_MLB.items = #(1)
		)
	)

	on SETPROPS_MLB selectionEnd do 
	(
		SETPROPS_INDEX_COLLECT = SETPROPS_MLB.selection
		SETPROPS_INDEX = SETPROPS_INDEX_COLLECT as array
		print SETPROPS_INDEX[1]
	)

	on SETS_ADD_BTN pressed do 
	(
		if SETS[SETS_INDEX] != "NONE" do
		(
			
			xrefObjectSet SETSLOC[SETS_INDEX]
		)

		for i IN SETPROPS_INDEX do
		(
			if i != 1 do
			(
				mergeAsset SETPROPSLOC[SETS_INDEX][i]
			)
		)

		GroupLayers "GRP"
	)
)



rollout CHARRollout "3. Character import:"
(

	--TO ADD:
	--1.DELTE ASSET FUNCTION
	local CHARS_INDEX = 1
	local CHARS_VAR_INDEX = 1
	local GRIMBOTS_INDEX = 1
	local GRIMBOTS_VAR_INDEX = #()
	local CHARS_TOT_NAME_ARRAY = #()
	local CHARS_TOT_PATH_ARRAY = #()

	ListBox MAIN_CHARS_LB "Main CHARS" items:MAIN_CHARS width:150 pos:[0,0] 
	ListBox CHARS_VAR_LB "CHAR Variants" items:CHAR_VARIANTS[1] width:150 offset:[160,-158] tooltip:"CTRL + select multiples for the Grimbots" visible:on
	MultiListBox GRIMBOTS_VAR_LB "GRIMBOT Variants" items:GRIMBOTS_VARIANTS width:150 offset:[160,-158] tooltip:"CTRL + select multiples for the Grimbots" visible:off
	ListBox CHARS_TOT_LB "" items:CHARS_TOT_NAME_ARRAY width:150 height:5 pos:[325,35] tooltip:"" visible:ON

	--Far right column for list of slected and Get/Add/Del buttons
	--button CHAR_GET_BTN "GET" pos:[335,120] visible:on
	button CHAR_ADD_BTN "ADD" pos:[375,120] visible:on
	--button CHAR_DEL_BTN "DEL" pos:[415,120] visible:on
	button CHAR_INC_BTN "INCLUDE" pos:[330,10] visible:on
	button CHAR_RST_BTN "RESET" pos:[420,10] visible:on

	on MAIN_CHARS_LB selected val do 
	(
		CHARS_INDEX = val
		if CHAR_VARIANTS[val] != undefined then 
		(
			CHARS_VAR_LB.items = CHAR_VARIANTS[val]
		)
		else 
		(
			CHARS_VAR_LB.items = #()
		)

		if CHARS_INDEX == 7 then
		(
			GRIMBOTS_VAR_LB.visible = on
			CHARS_VAR_LB.visible = off
		)
		else
		(
			GRIMBOTS_VAR_LB.visible = off
			CHARS_VAR_LB.visible = on
		)
	)

	on CHARS_VAR_LB selected val do 
	(
		CHARS_VAR_INDEX = CHARS_VAR_LB.selection

	)

	on GRIMBOTS_VAR_LB selectionEnd do 
	(
		GRIMBOTS_VAR_INDEX = GRIMBOTS_VAR_LB.selection
		GRIMBOTS_INDEX = GRIMBOTS_VAR_INDEX as array
	)

	on CHAR_INC_BTN pressed do
	(
		if CHARS_INDEX <= 6 then 
		(
			if CHAR_VARIANTS[CHARS_INDEX][CHARS_VAR_INDEX] != undefined then
			(
				append CHARS_TOT_NAME_ARRAY CHAR_VARIANTS[CHARS_INDEX][CHARS_VAR_INDEX]
				append CHARS_TOT_PATH_ARRAY MAIN_CHARS_LOC[CHARS_INDEX][CHARS_VAR_INDEX]
				
			)
		)
		else if CHARS_INDEX == 7 then 
		(
			if GRIMBOTS_INDEX.count !=0 do 
			(
				for i = 1 to GRIMBOTS_INDEX.count do 
				(
					GRIMBOT_NUMBER = GRIMBOTS_INDEX[i] as integer 
					append CHARS_TOT_NAME_ARRAY GRIMBOTS_VARIANTS[GRIMBOT_NUMBER]
					append CHARS_TOT_PATH_ARRAY MAIN_CHARS_LOC[7][GRIMBOT_NUMBER]
				)
			)
		)
		else 
		(
			messagebox "Select a CHAR"
		)

		CHARS_TOT_LB.items = CHARS_TOT_NAME_ARRAY
	)

	on CHAR_RST_BTN pressed do 
	(
		CHARS_TOT_NAME_ARRAY = #()
		GRIMBOTS_VAR_INDEX = #()
		CHARS_TOT_NAME_ARRAY = #()
		CHARS_TOT_PATH_ARRAY = #()
		CHARS_TOT_LB.items = CHARS_TOT_NAME_ARRAY
	)

	on CHAR_ADD_BTN pressed do
	(
		if 	CHARS_TOT_PATH_ARRAY != undefined do
		(
			for i in CHARS_TOT_PATH_ARRAY do
			(
				mergeAsset i "GRP"
			)
		)
	)

	on CHAR_GET_BTN pressed do
	(
	)

	on GRIMBOT_ADD_BTN pressed do
	(
		for i = 1 to GRIMBOTS_INDEX.count do
		(
			local pathGrimbot = ASSETS_ROOT_DIR + "CHARS\\GRIMBOT\\GRIMBOT_00" + GRIMBOTS_INDEX[i] as string + "\\GRIMBOT_00" + GRIMBOTS_INDEX[i] as string + "_MAIN\\GRIMBOT_00" + GRIMBOTS_INDEX[i] as string + "_MAIN_PRD.max"
			mergeAsset pathGrimbot
		)
	)
)


rollout VEHICLERollout "4. Vehicle import:"
(
	ListBox VEHICLE_LB "Vehicles" items:VEHICLES width:150 height:4 pos: [0,0]
	ListBox VEHICLE_VAR_LB "Vehicle Variants" items:VEHICLES_VARIANTS[1] width:150 height:4 offset:[150,-80]
	button VEHICLE_ADD_BTN "ADD" checked:False triState:0 offset:[150,-50]

	local VEHICLES_INDEX = 1
	local VEHICLES_VAR_INDEX = 1

	on VEHICLE_LB selected val do 
	(
		VEHICLES_INDEX = val
		if VEHICLES_VARIANTS[val] != undefined then 
		(
			VEHICLE_VAR_LB.items = VEHICLES_VARIANTS[val]
		)
		else 
		(
			VEHICLE_VAR_LB.items = #()
		)
	)

	on VEHICLE_VAR_LB selected val do 
	(
		VEHICLES_VAR_INDEX = VEHICLE_VAR_LB.selection
	)

	on VEHICLE_ADD_BTN pressed do
	(
		mergeAsset VEHICLES_LOC[VEHICLES_INDEX][VEHICLES_VAR_INDEX] "GRP"
		--GroupLayers 
	)
)

rollout TOOLRollout "4. Shot Tools:"
(
	label PRT_SECT_LBL "Particle Tools:" pos:[10, 10]
	button PART_ON_BTN "Particles On"  	offset:[-200, 0] width:75 
	button PART_OFF_BTN "Particles Off" offset:[-200, 0] width:75 
	label ANM_SECT_LBL "Anm Tools:" pos:[120, 10]
	button OOR_BTN "Out of Range Tool" offset:[-100, 0] width:100
	label VIEW_BG_LBL "Active Viewport BG:" pos:[200, 10]
	button ACTIVE_VIEW_BTN "Activate"  offset:[0, 0]
	button DEACTIVE_VIEW_BTN "Deactivate"  offset:[0, 0]
	label DEL_LYR_LBL "Layers:" pos:[320, 10]
	button DEL_LYR_BTN "Del Emtpy Layers"  offset:[100, 0]

	on PART_ON_BTN pressed do
	(
		for i in objects where classOf i == PF_Source do 
		(
			i.Quantity_Viewport = 50.0
			i.baseObject.activateParticles on
		)
	)

	on PART_OFF_BTN pressed do
	(
		for i in objects where classOf i == PF_Source do 
		(
			i.Quantity_Viewport = 0.0
			i.baseObject.activateParticles off
		)
	)
	
	on OOR_BTN pressed do
	(
		FileIn "C:\\SVN\\GOJETTERS\\TOOLBOX\\ANIMATION\\OUT_OF_RANGE_TOOL.ms"
	)	

	on ACTIVE_VIEW_BTN pressed do
	(
		actionMan.executeAction 0 "619"
	)
	on DEACTIVE_VIEW_BTN pressed do
	(
		actionMan.executeAction 0 "617" 
	)
	on DEL_LYR_BTN pressed do
	(
		deleteEmptyLayers()
	)
)


/*
rollout PREVIEWRollout "4. Create Preview:"
(
	editText PRV_EP_LB "EP" items:VEHICLES width:150 height:15 position: [0,0]
	editText PRV_SH_LB "SH" items:VEHICLES_VARIANTS[1] width:150 height:15 offset:[165,-20]
	button PRV_GET_BTN "GET"  offset:[120,-20]
	button PRV_CREATE_BTN "CREATE" offset:[175,-25]

	on PRV_GET_BTN selected val do 
	(
		
	)

	on PRV_CREATE_BTN selected val do 
	(
		VEHICLES_VAR_INDEX = VEHICLE_VAR_LB.selection
	)
)
*/


addrollout SHOTRollout FirstDialog
addrollout SETRollout FirstDialog
addrollout CHARRollout FirstDialog
addrollout VEHICLERollout FirstDialog
addrollout TOOLRollout FirstDialog

FirstDialog.rollouts[4].open = false
--FirstDialog.rollouts[5].open = false


--addrollout PREVIEWRollout FirstDialog






