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

rollout UI "SHAPE FACING TOOL"
(	

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
) 

createDialog UI 350 250

