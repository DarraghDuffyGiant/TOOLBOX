--Set MAT location
--Add new MAT
--Set FINAL pFlow settings for the Smoke
--LookAt Shot camera



fn getShotCam =
(

	global shotCAMNames = #("No Cams")

	for c in cameras where classOf c == freeCamera do
	(
		append shotCAMNames c.name
	)
	return shotCAMNames
)



fn getShapFacing =
(
	global shapeFacingNames = #()

	for i in objects where (i.classid)[2] == 515064320 do
	(
		if classOf i == Shape_Facing do append shapeFacingNames i.name
	)

	return shapeFacingNames
)


fn assignShotCam shapeFace shotCam = 
(	
	shapeFaceObj = getNodeByName shapeFace
	shotCamObj = getNodeByName shotCam

	if shapeFaceObj != undefined then
	(
		shapeFaceObj.Look_At_Object = shotCamObj
	)
)


fn grimHQSmokeFix =
(
	--GRIMHQ_MAINEX
	GRIM_HQ_MAIN = getnodebyname "GRIMHQ_CTRL_MID_BODY_MASTER_SA"

	$GRIMHQ_MAINEX_PositioIcon.multiplier = 100


	$GRIMHQ_MAINEX_Scale.X_Scale_Factor.controller = bezier_float ()
	$GRIMHQ_MAINEX_Scale.Y_Scale_Factor.controller = bezier_float ()
	$GRIMHQ_MAINEX_Scale.Z_Scale_Factor.controller = bezier_float ()
	$GRIMHQ_MAINEX_Scale.type = 4
	$GRIMHQ_MAINEX_Scale.Constrain_Scale = off
	$GRIMHQ_MAINEX_Scale.X_Scale_Factor = 99.0
	$GRIMHQ_MAINEX_Scale.Y_Scale_Factor = 99.0
	$GRIMHQ_MAINEX_Scale.Z_Scale_Factor = 99.0
	$GRIMHQ_MAINEX_Scale.Constrain_Scale = on
	$GRIMHQ_MAINEX_Scale.Constrain_Scale_Variation = off
	$GRIMHQ_MAINEX_Scale.X_Scale_Variation = 1.05
	$GRIMHQ_MAINEX_Scale.Y_Scale_Variation = 1.05
	$GRIMHQ_MAINEX_Scale.Z_Scale_Variation = 1.05
	$GRIMHQ_MAINEX_Scale.Constrain_Scale_Variation = on
	$GRIMHQ_MAINEX_Scale.bias = 3

	a = $GRIMHQ_MAINEX_Speed.Speed.controller.setExpression "1250 + VAL*50"
	$GRIMHQ_MAINEX_Speed.variation = 700
	$GRIMHQ_MAINEX_Speed.Divergence = 2


	$GRIMHQ_MAINEX_Force.Influence = 200

	$GRIMHQ_MAINEX_Spin.SpinRate = 150
	$GRIMHQ_MAINEX_Spin.variation = 20
	$GRIMHQ_MAINEX_Delete.Life_Span = 9600
	$GRIMHQ_MAINEX_Delete.variation = 960

	--GRIMHQ_L_EX_Force
	$GRIMHQ_L_EX_Scale.X_Scale_Factor.controller = bezier_float ()
	$GRIMHQ_L_EX_Scale.Y_Scale_Factor.controller = bezier_float ()
	$GRIMHQ_L_EX_Scale.Z_Scale_Factor.controller = bezier_float ()
	$GRIMHQ_L_EX_Scale.type = 1
	$GRIMHQ_L_EX_Scale.Constrain_Scale = off
	$GRIMHQ_L_EX_Scale.Constrain_Scale_Variation = off
	$GRIMHQ_L_EX_Scale.X_Scale_Factor = 100.0
	$GRIMHQ_L_EX_Scale.Y_Scale_Factor = 100.0
	$GRIMHQ_L_EX_Scale.Z_Scale_Factor = 100.0
	$GRIMHQ_L_EX_Scale.X_Scale_Variation = 10
	$GRIMHQ_L_EX_Scale.Y_Scale_Variation = 10
	$GRIMHQ_L_EX_Scale.Z_Scale_Variation = 10
	$GRIMHQ_L_EX_Scale.Constrain_Scale = on
	$GRIMHQ_L_EX_Scale.Constrain_Scale_Variation = on
	$GRIMHQ_L_EX_Scale.bias = 2

	$GRIMHQ_L_EX_Force.Influence = 300
	a = $GRIMHQ_L_EX_Speed.Speed.controller.setExpression "1300 + VAL*50"
	$GRIMHQ_L_EX_Speed.variation = 10

	--GRIMHQ_R_EX_Force
	$GRIMHQ_R_EX_Scale.X_Scale_Factor.controller = bezier_float ()
	$GRIMHQ_R_EX_Scale.Y_Scale_Factor.controller = bezier_float ()
	$GRIMHQ_R_EX_Scale.Z_Scale_Factor.controller = bezier_float ()
	$GRIMHQ_R_EX_Scale.type = 1
	$GRIMHQ_R_EX_Scale.Constrain_Scale = off
	$GRIMHQ_R_EX_Scale.Constrain_Scale_Variation = off

	$GRIMHQ_R_EX_Scale.X_Scale_Factor = 100.0
	$GRIMHQ_R_EX_Scale.Y_Scale_Factor = 100.0
	$GRIMHQ_R_EX_Scale.Z_Scale_Factor = 100.0
	$GRIMHQ_R_EX_Scale.X_Scale_Variation = 10
	$GRIMHQ_R_EX_Scale.Y_Scale_Variation = 10
	$GRIMHQ_R_EX_Scale.Z_Scale_Variation = 10
	$GRIMHQ_R_EX_Scale.Constrain_Scale = on
	$GRIMHQ_R_EX_Scale.Constrain_Scale_Variation = on
	$GRIMHQ_R_EX_Scale.bias = 2

	$GRIMHQ_R_EX_Force.Influence = 300

	a = $GRIMHQ_R_EX_Speed.Speed.controller.setExpression "1300 + VAL*50"
	$GRIMHQ_R_EX_Speed.variation = 10
)

pathMAT = ""
fileMAT = "GRIM_SMOKE"
typeMAT = ".mat"
libMAT = pathMAT+"\\"+fileMAT+typeMAT
getShotCam()

rollout UI "GRIM HQ SMOKE"
(	

	edittext pathMAT_TXT "Smoke MAT in:" fieldWidth:325 labelOnTop:true text: libMAT
	button applyMAT_BUT "Apply Smoke MAT" 
	ListBox shotCam_LB "Pick SHOT cam for SMOKE:" items:shotCAMNames height:4 offset: [0,20]
	button shotCams_BUT "Find Cams" 
	button fixGrim_BUT "Fix Grim" 

	on applyMAT_BUT pressed do 
	(
		libMAT = pathMAT_TXT.text

		if doesFileExist libMAT then
		(
			smokeMAT = loadTempMaterialLibrary libMAT

			if $GRIMHQ_MAINEX_MaterialStatic != undefined then
			(
				$GRIMHQ_MAINEX_MaterialStatic.Assigned_Material = smokeMAT[1]
			)
			else
			(
				messageBox "Main GrimHQ Smoke particle object not present"
			)

			if $GRIMHQ_L_EX_MaterialStatic != undefined then
			(
				$GRIMHQ_L_EX_MaterialStatic.Assigned_Material = smokeMAT[1]
			)
			else
			
			(
				messageBox "Left Chimney Smoke particle object not present"
			)

			if $GRIMHQ_R_EX_MaterialStatic != undefined then
			(
				$GRIMHQ_R_EX_MaterialStatic.Assigned_Material = smokeMAT[1]
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
	on shotCams_BUT pressed do
	(
		shotCams = getShotCam ()
		shotCam_LB.items = shotCams
	)

	on shotCam_LB selected val do 
	(
		assignShotCam "GRIMHQ_MAINEX_ShapeFacing" shotCAMNames[val]
		assignShotCam "GRIMHQ_R_EX_ShapeFacing" shotCAMNames[val]
		assignShotCam "GRIMHQ_L_EX_ShapeFacing" shotCAMNames[val]
	)

	on fixGrim_BUT pressed do
	(
		grimHQSmokeFix()
	)
) 

createDialog UI 350 250

if $GRIMHQ_MAINEX_MaterialStatic == undefined do print "nope"