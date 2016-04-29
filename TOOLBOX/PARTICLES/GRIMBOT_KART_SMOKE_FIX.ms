custom_attribute = attributes Smoke_controls
(	
	parameters smoke_param		rollout:smoke_roll
	(			
		position_node				type:#MaxObject												--Object to check position changes for calculate particle rate
		particle_node				type:#MaxObject												--Particle Emitter
		birth_node					type:#MaxObject												--Particle Birth node
		main_event_node				type:#MaxObject												--Main Particle event for turn on/off particle system
		smoke_state					type:#Boolean 		ui:(smoke_CB)		default:false		--Particle turn on/off button
		init_frame					type:#integer 		ui:(init_frame_SP)	default:0			--Initial animation frame
		last_frame					type:#integer 		ui:(last_frame_SP)	default:100			--End animation frame
		
	)-- end parameters
	
	rollout smoke_roll "SMOKE CONTROLS"
	(
		---------------- USER INTERFACE DECLARATION -------------------
		
		group ""
		(
			checkbutton		smoke_CB		"SMOKE OFF" 			offset:[0,-7.5]  width:120	height:50 checked:false
		)
		
		group ""
		(				
			label				init_frame_label	"Start Frame:"			across:2
			label				last_frame_label	"End Frame:"			across:2 offset:[5,0]
			spinner				init_frame_SP		range:[0, 10000, 0]		type:#integer	fieldWidth:50 	across:2 	align:#left	offset:[1,0]	
			spinner				last_frame_SP		range:[0, 10000, 100]	type:#integer	fieldWidth:50	across:2		align:#left 	offset:[10,0]
			button				reset_all_B			"Reset All"				offset:[-7,0]  	width:60	height:25 	checked:false across:2
			button				reset_range_B		"Reset Range"			offset:[0,0]  	width:75	height:25 	checked:false across:2			
		)
		
		group ""
		(
			button				do_it_B					"Do It!"						offset:[0,-5] 	width:80	height:40 	checked:false
		)
		
		---------------- END DECLARATION -------------------
		
		
		--------------- ROLLOUT FUNCTIONS ----------------
		
		fn update_UI =
		(
			if smoke_CB.state == true then
			(
				smoke_CB.caption = "SMOKE ON"
			)
			else
			(
				smoke_CB.caption = "SMOKE OFF"
			)
		)-- end update_UI
		
		fn particleRate sourceObj t =
		(

			local default_rate 	= 200
			--local initial_scale 	= 10.0
			--local middle_scale	= 60.0
			--local final_scale		= 1.0
			local oldPos = at time (t-1f) sourceObj.pos
			local curPos = at time t sourceObj.pos

			if oldPos != curPos then
			(
				diff = curPos - oldPos
				len = length(diff)
				len_m = len

				birth_node.node.rate = default_rate + (2 * len_m)

			)--end if
			else
			(
				print ("Not moving at frame " + t as string)
				birth_node.node.rate = default_rate
			)-- end else
		)-- end fn particleRate
		
		fn deleteKeysByRange con deleteRange =
		(
			for o in con.keys.count to 1 by -1 do
			(
				if (con.keys[o].time >= deleteRange.start) and (con.keys[o].time <= deleteRange.end) do deleteKey con o
			)
		)--end fn deleteKeysByRange
		
		--------------- END ROLLOUT FUNCTIONS ----------------
		
		
		--------------- ROLLOUT EVENTS ---------------------------
			
		on smoke_roll open do
		(
			--Update UI when the rollout is open
			update_UI()
		)-- end smoke_roll open
		
		on reset_all_B pressed do
		(
			with undo on
			(
				deleteKeys #(birth_node.node.rate.controller)
				birth_node.node.rate = 60.0
			)
		)--end on reset_all_B pressed
		
		on reset_range_B pressed do
		(
			with undo on
			(
				deleteKeysByRange birth_node.node.rate.controller 					(interval (init_frame_SP.value)  (last_frame_SP.value))
			)
		)--end on reset_range_B pressed
		
		on smoke_CB changed state do
		(
			if state == on then
			(
				smoke_CB.caption = "SMOKE ON"
				
				particle_node.node.baseObject.activateParticles on
				main_event_node.node.baseObject.Activate on
			)--end if
			else
			(
				smoke_CB.caption = "SMOKE OFF"
				particle_node.node.baseObject.activateParticles off
				main_event_node.node.baseObject.Activate off
			)--end else
		)--end on smoke_CB changed
			
		on do_it_B pressed do
		(
			with undo on
			(
				deleteKeysByRange birth_node.node.rate.controller 					(interval (init_frame_SP.value)  (last_frame_SP.value))
				
				for i = init_frame_SP.value to last_frame_SP.value do
				(
					animate on
					(
						at time i
						(
							particleRate particle_node.node i
						)--end at time i
					)--end animate on
				)--end for i
			)--end with undo on
		)--end on do_it_B pressed
		
		--------------- END ROLLOUT EVENTS ---------------------------
	)-- end rollout 
)-- end custom_attribute

fn fixGrimbotKart = 
(
	pFlowSys = #("GRIMBOT_KART_SMOKE_SYSTEM_LCHIMNEY","GRIMBOT_KART_SMOKE_SYSTEM_RCHIMNEY")

	for i in pFlowSys do
	(
		pFlow = getnodebyname i

		if pFlow.modifiers[1] != (EmptyModifier()) then
		(
			/*Check if the object has an attribute holder (empty modifier), if doesn't exist, add the attribute holder modifier and
			the rollout declaration to it. if exists, add the rollout declaration to it. 
			*/
			suspendEditing which:#modify
			e_mod = (EmptyModifier ())
			addModifier pFlow e_mod
			e_mod.name = "Smoke_Controls"
			custAttributes.add pFlow.modifiers[1] custom_attribute
			resumeEditing which:#modify
		)
		else
		(
			custAttributes.add pFlow.modifiers[1] custom_attribute
		)
	)
		-- Add one node to a MaxObject variable	
		$GRIMBOT_KART_R_EX_Birth.Rate.controller = bezier_float ()
		$GRIMBOT_KART_L_EX_Birth.Rate.controller = bezier_float ()

		$GRIMBOT_KART_SMOKE_SYSTEM_LCHIMNEY.modifiers[1].Smoke_controls.position_node 		= (nodeTransformMonitor node:$GRIMBOT_KART_SMOKE_SYSTEM_LCHIMNEY 	forwardTransformChangeMsgs:false)
		$GRIMBOT_KART_SMOKE_SYSTEM_LCHIMNEY.modifiers[1].Smoke_controls.particle_node 		= (nodeTransformMonitor node:$GRIMBOT_KART_SMOKE_SYSTEM_LCHIMNEY 	forwardTransformChangeMsgs:false)
		$GRIMBOT_KART_SMOKE_SYSTEM_LCHIMNEY.modifiers[1].Smoke_controls.birth_node 			= (nodeTransformMonitor node:$'GRIMBOT_KART_L_EX_Birth'  	forwardTransformChangeMsgs:false)
		$GRIMBOT_KART_SMOKE_SYSTEM_LCHIMNEY.modifiers[1].Smoke_controls.main_event_node 	= (nodeTransformMonitor node:$'GRIMBOT_KART_SMOKE_LCHIMNEY' 	forwardTransformChangeMsgs:false)

		$GRIMBOT_KART_SMOKE_SYSTEM_RCHIMNEY.modifiers[1].Smoke_controls.position_node 	= (nodeTransformMonitor node:$GRIMBOT_KART_SMOKE_SYSTEM_RCHIMNEY  	forwardTransformChangeMsgs:false)
		$GRIMBOT_KART_SMOKE_SYSTEM_RCHIMNEY.modifiers[1].Smoke_controls.particle_node 	= (nodeTransformMonitor node:$GRIMBOT_KART_SMOKE_SYSTEM_RCHIMNEY 	forwardTransformChangeMsgs:false)
		$GRIMBOT_KART_SMOKE_SYSTEM_RCHIMNEY.modifiers[1].Smoke_controls.birth_node 		= (nodeTransformMonitor node:$'GRIMBOT_KART_R_EX_Birth'  	forwardTransformChangeMsgs:false)
		$GRIMBOT_KART_SMOKE_SYSTEM_RCHIMNEY.modifiers[1].Smoke_controls.main_event_node 	= (nodeTransformMonitor node:$'GRIMBOT_KART_SMOKE_RCHIMNEY' 	forwardTransformChangeMsgs:false)
		
)

fixGrimbotKart ()


/************************************************************************/
/************************************************************************/
/************************************************************************/
/************************************************************************/
/************************************************************************/




fn getShotCam =
(

	global shotCAMNames = #("No Cams")

	for c in cameras where classOf c == freeCamera do
	(
		append shotCAMNames c.name
	)
	return shotCAMNames
)
getShotCam()

fn getShapFacing =
(
	global shapeFacingNames = #()

	for i in objects where (i.classid)[2] == 515064320 do
	(
		if classOf i == Shape_Facing do append shapeFacingNames i.name
	)

	return  shapeFacingNames
)

--getShapFacing()

fn assignShotCam shotCam = 
(	
	shapeFaceObj = getShapFacing()
	shotCamObj = getNodeByName shotCam

	for i in shapeFaceObj do
	(
		shapeFace = getNodeByName i
		if shapeFace != undefined then
		(
			shapeFace.Look_At_Object = shotCamObj
		)
	)
)

pathMAT = "C:\SVN\GOJETTERS\MAX\materiallibraries"
fileMAT = "GRIM_SMOKE"
typeMAT = ".mat"
libMAT = pathMAT+"\\"+fileMAT+typeMAT

rollout UI "GRIM HQ SMOKE"
(	


	edittext pathMAT_TXT "Smoke MAT in:" fieldWidth:325 labelOnTop:true text:libMAT
	button applyMAT_BUT "Apply Smoke MAT" 
	ListBox shotCam_LB "Pick SHOT cam for SMOKE:" items:shotCAMNames height:4 offset: [0,20]
	button shotCams_BUT "Find Cams" 

	on shotCams_BUT pressed do
	(
		shotCams = getShotCam ()
		shotCam_LB.items = shotCams
	)

	on shotCam_LB selected val do 
	(
		assignShotCam shotCAMNames[val]

	)

	on applyMAT_BUT pressed do 
	(
		libMAT = pathMAT_TXT.text

		if doesFileExist libMAT then
		(
			smokeMAT = loadTempMaterialLibrary libMAT


			if $GRIMBOT_KART_L_EX_MaterialStatic != undefined then
			(
				$GRIMBOT_KART_L_EX_MaterialStatic.Assigned_Material = smokeMAT[1]
			)
			else
			
			(
				messageBox "Left Chimney Smoke particle object not present"
			)

			if $GRIMBOT_KART_R_EX_MaterialStatic != undefined then
			(
				$GRIMBOT_KART_R_EX_MaterialStatic.Assigned_Material = smokeMAT[1]
			)
			else
			
			(
				messageBox "Right ChimneySmoke particle object not present"
			)
		)
		else
		(
			messageBox "Smoke MAT not in directory"
		)
	)
) 

createDialog UI 350 250