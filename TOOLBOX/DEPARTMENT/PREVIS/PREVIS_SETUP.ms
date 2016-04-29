
/*
--PREVIS TOOL--
09/09
Author: Darragh Duffy - darragh.duffy.giant@gmail.com

v1.1 - 
--Added list boxes to CHARS to show variants
*/

FileIn "C:\\SVN\\GOJETTERS\\TOOLBOX\\GENERAL\\GOJETTERS_INIT.ms"
FileIn "C:\\SVN\\GOJETTERS\\TOOLBOX\\GENERAL\\GENERAL_TOOLS.ms"
FileIn "C:\\SVN\\GOJETTERS\\TOOLBOX\\GENERAL\\SVN_TOOLS.ms"


FirstDialog = newRolloutFloater "PREVIS SETUP" 500 800


rollout SHOTRollout "1. Shot details:"
(
	/*
	--dropdownlist PROJECT_DDL "Project:" items:#("GOJETTERS") offset:[0,0] width:100 --Dropdown to decide on Project
	dropdownlist EPISODE_DDL "Episode:" items:EPISODES selection:10 offset:[0, 0] width:100
	edittext SH_ET "Shot Number: 'SH_' " offset:[0, 20] width:180 text:"0010"
	dropdownlist SH_TYPE_DDL "TYPE:" items:#("DEFAULT", "SCREEN", "BG", "OTHER") offset:[200, -42] width:100
	*/
	ListBox ADD_SKY_LB "Pick SKY type:" items:SKIES selection:2 offset:[0, 0] width:125 HEIGHT:4
	label BG_VIEW_LBL "Viewport in SELECTED BG:" pos:[150, 20]
	button ACTIVE_VIEW_BTN "Activate"  offset:[-60, 0]
	button DEACTIVE_VIEW_BTN "Deactivate"  offset:[-60, 0]
	label CLOUD_TYP_LBL "3D CLOUD TYPE:" pos:[10, 100]
	checkbox ADD_DAY_CLOUDS_CB "DAY" offset:[0, 0]
	checkbox ADD_NIGHT_CLOUDS_CB "NIGHT" offset:[50, -20]
	label CYCL_SET_LBL "CLOUD CYCLE TYPE:" pos:[10, 140]
	checkbox ADD_DAY_CYC_SET_CB "DAY" offset:[0, 0]
	checkbox ADD_NGT_CYC_SET_CB "NIGHT" offset:[50, -20]
	checkbox ADD_CAM_CB "ADD SH CAMERA" pos:[150, 120]
	button CREATE01_BTN "Create PREVIS shot file"  pos:[310, 75] width:150 HEIGHT:50



	--collect information on the shot in question
	on EPISODE_DDL selected i do
	(
		global EPISODE_NUMBER_ACT = EPISODE_NUMBERS[i AS INTEGER]
		global EPISODE_CODES_ACT = EPISODE_CODES[i AS INTEGER]
		global EPISODE_ASSETS_ACT = EPISODE_ASSETS[i AS INTEGER]
	)
	/*
	on CREATE01_BTN pressed do
	(	
		if SH_TYPE_DDL.text == "DEFAULT" then
		(
			if SH_ET.text !="" then
			(
				SH_PATH =  (EPISODE_ROOT_DIR) +\	--ROOT FOLDER (C:\SVN\EPISODES\)
				(PROJ_CODE + "_"+ EPISODE_NUMBER_ACT + "_"+ EPISODE_CODES_ACT) + "\\" +\  --EPISODE FOLDER (GJ_110_LFG)
				(PROJ_CODE + "_"+ EPISODE_NUMBER_ACT + "_3D") + "\\" +\  --EPISODE 3D FOLDER (GJ_110_3D)
				(PROJ_CODE + "_"+ EPISODE_NUMBER_ACT + "_SH") + "_" + SH_ET.text + "\\" +\ --EPISODE SHOT FOLDER (GJ_110_LFG_0010)
				(PROJ_CODE + "_"+ EPISODE_NUMBER_ACT + "_SH" + "_" + SH_ET.text + "_ANM.max") 
				
				if doesFileExist SH_PATH == true then 
				(

					fileSVNLock SH_PATH
				)
				else 
				(
					fileSVNLock SH_PATH
				)
			)
			else 
			(
				messagebox "Please enter a valid shot number"
			)
		)
		else if SH_TYPE_DDL.text == "SCREEN" then
		(
			print "SCREEN"
		)
	)
	*/

	

	on ADD_SKY_LB selected val do
	(
		global SKIES_INDEX = ADD_SKY_LB.selection
		environmentMap = bitmapTexture filename:SKIES_LOC[SKIES_INDEX]
	)

	on CREATE01_BTN pressed do
	(
		--ADDS DAY CLOUDS 
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
				GroupLayers ()
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
				GroupLayers ()
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
				GroupLayers ()
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
				GroupLayers ()
			)
			else
			(
				messageBox "Clouds already in shot"
			)
		)--IF NIGHT CLOUD CYCLE SET TICKED

		--ADDS SHOT CAMERA
		if ADD_CAM_CB.triState != 0 do
		(
			camSH = freeCamera name:"CAM_101_SH_0010_v001"

			if LayerManager.count > 1 then
			(
				for i = 1 to LayerManager.count-1 do 
				(
					local layer = LayerManager.getLayer i

					if layer.name == "CAM_GRP" then 
					(
						layer.addnode camSH
					)
					else if layer.name != "CAM_GRP" then
					(
						layer = LayerManager.newLayerFromName "CAM_GRP"
						layer.addnode camSH
					)
				)
			)
			else
			(
				layer = LayerManager.newLayerFromName "CAM_GRP"
				layer.addnode camSH
			)
		) --ADDS SHOT CAMERA TICKED
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

rollout SETRollout "2. Set import:"
(
	ListBox SETS_LB "Core Sets" items:SETS width:150 height:8 position:[0,0]
	MultiListBox SETPROPS_MLB "Set Props: CTRL + select" selection:#(1) items:SETPROPS[1] width:150 height:8 offset:[155,-130]
	button SETS_ADD_BTN "ADD"  offset:[150,-140]

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

		GroupLayers ()
	)
)

rollout CHARRollout "3. Character import:"
(
	/*
	TO ADD:
	1.DELTE ASSET FUNCTION

	*/
	ListBox MAIN_CHARS_LB "Main CHARS" items:MAIN_CHARS width:150
	ListBox CHARS_VAR_LB "CHAR Variants" items:CHAR_VARIANTS[1] width:150 offset:[160,-158] tooltip:"CTRL + select multiples for the Grimbots" visible:on
	MultiListBox GRIMBOTS_VAR_LB "GRIMBOT Variants" items:GRIMBOTS_VARIANTS width:150 offset:[160,-158] tooltip:"CTRL + select multiples for the Grimbots" visible:off
	
	button CHAR_INC_BTN "INCLUDE" offset:[150,-150] visible:on
	button CHAR_ADD_BTN "ADD" offset:[150,100] visible:on
	button GRIMBOT_ADD_BTN "ADD" offset:[150,-27] visible:off

	local CHARS_INDEX = 1
	local CHARS_VAR_INDEX = 1
	local GRIMBOTS_INDEX = 1
	local GRIMBOTS_VAR_INDEX = #()


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
			GRIMBOT_ADD_BTN.visible = on
			CHAR_ADD_BTN.visible = off
		)
		else
		(
			GRIMBOTS_VAR_LB.visible = off
			CHARS_VAR_LB.visible = on
			GRIMBOT_ADD_BTN.visible = off
			CHAR_ADD_BTN.visible = on
		)
	)

	on CHARS_VAR_LB selected val do 
	(
		CHARS_VAR_INDEX = CHARS_VAR_LB.selection
	)

	on CHAR_ADD_BTN pressed do
	(
		global CHAR_FINAL = MAIN_CHARS_LOC[CHARS_INDEX][CHARS_VAR_INDEX]
		mergeAsset CHAR_FINAL
		GroupLayers ()
	)

	on GRIMBOTS_VAR_LB selectionEnd do 
	(
		GRIMBOTS_VAR_INDEX = GRIMBOTS_VAR_LB.selection
		GRIMBOTS_INDEX = GRIMBOTS_VAR_INDEX as array
	)

	on GRIMBOT_ADD_BTN pressed do
	(
		for i = 1 to GRIMBOTS_INDEX.count do
		(
			local pathGrimbot = ASSETS_ROOT_DIR + "CHARS\\GRIMBOT\\GRIMBOT_00" + GRIMBOTS_INDEX[i] as string + "\\GRIMBOT_00" + GRIMBOTS_INDEX[i] as string + "_MAIN\\GRIMBOT_00" + GRIMBOTS_INDEX[i] as string + "_MAIN_PRD.max"
			mergeAsset pathGrimbot
			GroupLayers ()
		)
	)
)

rollout VEHICLERollout "4. Vehicle import:"
(
	ListBox VEHICLE_LB "Vehicles" items:VEHICLES width:150 height:5 position: [0,0]
	ListBox VEHICLE_VAR_LB "Vehicle Variants" items:VEHICLES_VARIANTS[1] width:150 height:5 offset:[160,-90]
	button VEHICLE_ADD_BTN "ADD" checked:False triState:0 offset:[150,-80]

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



/*
addrollout PREVIEWRollout FirstDialog
*/





