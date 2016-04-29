try closeRolloutFloater ABCExportDialog catch()

include "C:\\SVN\\GOJETTERS\\TOOLBOX\\GENERAL\\FILE_TOOLS_WIP.ms"
include "C:\\SVN\\GOJETTERS\\TOOLBOX\\GENERAL\\SVN_TOOLS.ms"
include "C:\\SVN\\GOJETTERS\\TOOLBOX\\GENERAL\\MESH_TOOLS.ms"
include "C:\\SVN\\GOJETTERS\\TOOLBOX\\GENERAL\\CAMERA_TOOLS.ms"
include "C:\\SVN\\GOJETTERS\\TOOLBOX\\GENERAL\\GENERAL_TOOLS_WIP.ms"
include "C:\\SVN\\GOJETTERS\\TOOLBOX\\GENERAL\\GOJETTERS_INIT_WIP.ms"
include "C:\\SVN\\GOJETTERS\\TOOLBOX\\ALEMBIC\\ABC_TOOLS.ms"
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


alembicFileInfo = fileInfoRetrieve()
alembicFileSHInfo = fileSHInfo()
alembicProjSetup = fileProjSetup()
alembicExportObj = exportAlembicFunctions()
alembicFileFolderOp = fileFolderFunctions()

anmSceneLayerTool = sceneLayerFunctions()
anmSceneLayerTool.checkLayersForName "MESH"


alembicProjSetup.getProj alembicFileInfo.fileProjInfo[1]
--Get SHOT info 
alembicFileSHInfo.setSHInfo alembicFileInfo.fileProjInfo alembicFileInfo.fileProj
--Set file path for shot
alembicProjSetup.setSHFilePath alembicFileInfo.fileName alembicFileInfo.fileProjInfo[1] alembicProjSetup.projEpisodeFolder alembicFileSHInfo.EPNumber alembicFileSHInfo.EPCode alembicFileSHInfo.EPShotNumber alembicFileInfo.fileType
--Set file path for ABC export
--Get ABC info


/*
anmSceneLayerTool.sceneLayerObjects
anmSceneLayerTool.sceneLayerNames

alembicFileInfo.fileProjInfo[1]
alembicFileSHInfo.EPNumber
alembicFileSHInfo.EPNumberSelection
alembicFileSHInfo.EPShotNumber
alembicFileSHInfo.EPShotType
alembicFileSHInfo.EPCode

alembicProjSetup.projAlembiFolder
alembicProjSetup.assetType
alembicProjSetup.projRootFolder
alembicProjSetup.projRenderFolder
alembicProjSetup.projRefFolder
alembicProjSetup.setFileName
alembicProjSetup.filePathFull
alembicProjSetup.filePathFolder
*/



ABCExportDialog = newRolloutFloater "Export Alembic" 500 800 --bgcolor:(color 0 0 0) 

rollout SHOTRollout "1. Shot details:"
(

	--PROJ/FOLDER SETTINGS
	dropdownlist PROJECT_DDL "Project:" items:alembicFileInfo.fileProj selection:alembicFileSHInfo.projNumberSelection pos:[10,10] width:100 --Dropdown to decide on Project
	dropdownlist EPISODE_DDL "Episode:" items:EPISODES selection:alembicFileSHInfo.EPNumberSelection offset:[120,-45] width:100
	label SH_LBL "SH:" pos:[250,12] width:120 
	edittext SH_ET "" offset:[230,0] width:80 text:alembicFileSHInfo.EPShotNumber
	label SH_TYPE_LBL "SH Type:" pos:[350,12] width:120 
	edittext SH_TYPE_ET "" text:alembicFileSHInfo.EPShotType pos:[340,30] width:100

)

rollout CHARRollout "3. Character EXPORT:"
(

	--TO ADD:
	--1.DELTE ASSET FUNCTION
	local CHARS_INDEX = 1
	local CHARS_VAR_INDEX = 1
	local GRIMBOTS_INDEX = 1
	local ABC_MSH_INDEX = #()
	local CHARS_TOT_NAME_ARRAY = #()
	local CHARS_TOT_PATH_ARRAY = #()

	MultiListBox ABC_MSH_LB "Existing Mesh to export" items:anmSceneLayerTool.sceneLayerNames width:150 pos:[10,10] 
	button CHAR_EXP_BTN "EXPORT SHOT ABC" pos:[200,10] visible:on
	button OPEN_DIR_BTN "OPEN DIR"  pos:[225, 45] width:60 HEIGHT:40



	on ABC_MSH_LB selectionEnd do 
	(
		ABC_MSH_INDEX = ABC_MSH_LB.selection
	)

	on CHAR_EXP_BTN pressed do
	(

		if ABC_MSH_INDEX.count != 0 then
		(
			for i in ABC_MSH_INDEX do 
			(
				layerObjects =  anmSceneLayerTool.getLayerObjects anmSceneLayerTool.sceneLayerNames[i]
				alembicFilePath = alembicProjSetup.setABCFile alembicProjSetup.projAlembiFolder alembicFileSHInfo.EPShotNumber anmSceneLayerTool.sceneLayerNames[i]
				alembicExportObj.exportLayerNodes alembicFilePath anmSceneLayerTool.sceneLayerNames[i] layerObjects
			)
		)
		else
		(
			messageBox "Mesh layer export list empty"
		)
	)

	on OPEN_DIR_BTN pressed do 
	(
		alembicFileFolderOp.openFileDir alembicProjSetup.filePathFolder
	)
)

--
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
		mergeAsset VEHICLES_LOC[VEHICLES_INDEX][VEHICLES_VAR_INDEX]
		GroupLayers ()
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


addrollout SHOTRollout ABCExportDialog
--addrollout SETRollout ABCExportDialog
addrollout CHARRollout ABCExportDialog
--addrollout VEHICLERollout ABCExportDialog
--addrollout TOOLRollout ABCExportDialog

--ABCExportDialog.rollouts[4].open = false
--ABCExportDialog.rollouts[5].open = false


--addrollout PREVIEWRollout FirstDialog






