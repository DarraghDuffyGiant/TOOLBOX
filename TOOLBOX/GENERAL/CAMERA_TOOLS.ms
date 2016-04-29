/*
To-Do:
--In a fresh scene the camera does not go immediately into the CAM_GRP layer
*/

struct generalCameraFunctions (

/*
Number of tools for use with the previs/alembic export tools.
It tests and works with camera found in the scene that match certain criteria
*/

public
camExists = False,
camLayerExists = False,
camGroupNames = #(),
camName = "",
camLayerName = "",
	
	fn getCamInfo = (
	/*
	Checks scene for shot cameras and adds them to the camGroupNames array for further use
	*/	
		sceneCams = for i in cameras collect i.name
		for o in sceneCams do
		(
			camNameFilter = FilterString o "_"
			for camNamePart in camNameFilter do
			(
				if matchPattern camNamePart pattern:"CAM" then
				(
					append camGroupNames o
				)
			)
		)
	),


	fn testForCam camNameString =(	
	/*
	Runs the getCamInfo function firstly to see if a shot camera exists.
	Test the camGroupNames array - sets the exixts variable based on result
	Arg:
	camNameString - string - used to test against string obtained from scene camera
	*/	
		getCamInfo()

		if camGroupNames != undefined then
		(
			if findItem camGroupNames camNameString == 0 then
			(
				camExists =  false
			)
			else
			(
				camExists =  true
			)
		)
	),

	fn createCam camName =(
	/*
	if the camExists variable is false it will create a new camera.
	Arg:
	cameName - string - obtained from file tool function 
	*/	

		if camExists == false then
		(
			cam = freeCamera name:camName
			camName = cam.name
			camExists =  true
		)
		else
		(
			messageBox "Camera already exists"
		)

	),

	fn testForCamLayer camLayerName camName = (
	/*
	Looks at layermanager to find if the layer with argument name exists
	Arg:
	camLayerName - string - used to test/create layer name
	*/	
		if LayerManager.count > 1 then
		(
			for i = 1 to LayerManager.count-1 do 
			(
				layer = LayerManager.getLayer i

				if layer.name == camLayerName then 
				(
					camLayerExists = true
				)
				else if layer.name != camlayerName then
				(

					layer = LayerManager.newLayerFromName camLayerName
					camLayerExists = true				
				)
			)
		)
		else
		(
			layer = LayerManager.newLayerFromName camLayerName
		)

		if camExists != false and camLayerExists != false do 
		(	
			local cam = getNodeByName camName
			local layer = LayerManager.getLayerFromName camLayerName
			layer.addnode cam
		)	
	),

	fn lockCamTransforms =
	(
		sel = $
		curCam = try(getActiveCamera()) catch()
		if curCam != undefined do (
		camType = curCam.type
		if camType == #target then (
		setTransformLockFlags curCam #all
		setTransformLockFlags curCam.target #all
		)
		else (
		setTransformLockFlags curCam #all
		)
		) -- cam != undefined
		UNLOCK CAMERA 
		 sel = $
		curCam = try(getActiveCamera()) catch()
		if curCam != undefined do (
		camType = curCam.type
		if camType == #target then (
		setTransformLockFlags curCam #none
		setTransformLockFlags curCam.target #none
		)
		else (
		setTransformLockFlags curCam #none
		)
		) -- cam != undefined
	)

)

struct outputCameraFunctions (


	function saveCam cams camPathSave =
	(

		for cam in cams do
		(
			camNameFilter = filterString cam.name "_"
			
			if camNameFilter[1] == camName then
			(
				local filePath = camPathSave + cam.name

				viewport.setcamera cam
				forceCompleteRedraw()	
				img = gw.getViewportDib()
				img.filename = filePath + ".jpg"
				save img

			)
			else
			(
				print "Camera name doesn't follow naming convention"
			)
		)
	),

	fn batchRender camArr path: imagename: ext: =
	(

	--EXAMPLE: batchRender #($Front, $Back, $Left, $Right) path:@"\\Server\outputs" imagename:"teapot" ext:".tif"
	local batch = batchRenderMgr, appendPath = pathConfig.appendPath
	batch.netRender = on

	for c in camArr do
	(
		imagename = imagename + "_" + c.name + "view" + ext
		view = batch.CreateView c
		view.overridePreset = on
		view.outputFilename = appendPath path imagename
		view.name = c.name
	)
	)
)

