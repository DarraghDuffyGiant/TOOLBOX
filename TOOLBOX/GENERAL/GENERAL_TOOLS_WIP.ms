include "C:\\SVN\\GOJETTERS\\TOOLBOX\\GENERAL\\SVN_TOOLS.ms"


struct sceneLayerFunctions (

public
sceneLayerNames = #(),
sceneLayerObjects = #(),
sceneLayerFindNames = #(),


	fn checkLayersForName layerToken =
	(
		/*
			Function to get names of layers in scene
		*/
		for i = 1 to LayerManager.count-1 do 
		(
			layer = LayerManager.getLayer i
			layerFilterString = FilterString layer.name "_"
			if findItem layerFilterString layerToken != 0 do
			(
				append sceneLayerNames layer.name
			)
		)-- end for i
	),-- end fn

	fn getLayerObjects layerName  =
	(
		/*
			Function to get object list from layers in scene
		*/

		if layerName != undefined then
		(
			layerNodes = #()
			layer = LayerManager.getLayerFromName layerName
			result = layer.nodes &layerNodes
			sceneLayerObjects = layerNodes	
		)
	),-- end fn


	fn groupLayers layerToken =
	(
		/*
		Function to group layers in hierarchy in one single layer using the prefix of each layer
		*/
		
		local layerNames = #()			--Array to save the layers' prefix
		local groupLayers = #()			--Array to save the new group layers


		for i = 1 to LayerManager.count-1 do 
		(
			layer = LayerManager.getLayer i

			curName = FilterString layer.name "_"
			
			-- If the layer's prefix doesn't exist yet, create new Parent layer, else add layer to exist layer.
			if findItem layerNames curName[1] == 0 then 
			(
				append layerNames curName[1]
				
				-- If the group layer doesn't exist, create new layer, else use the existing group layer
				if LayerManager.getLayerFromName (curName[1]  + "_" +  layerToken) == undefined then
				(
					newParentLayer = LayerManager.newLayerFromName (curName[1]  + "_" +  layerToken)
				)
				else
				(
					newParentLayer = LayerManager.getLayerFromName (curName[1] + "_" + layerToken)
				)-- end if else

				LAYER.setParent newParentLayer

				append groupLayers newParentLayer
			)
			else 
			(
				layerNumber = findItem layerNames curName[1]

				LAYER.setParent groupLayers[layerNumber]
			)-- end if else
		)-- end for i
	)-- end fn

)

fn deleteEmptyLayers =
(
	delete $*ParticleView*
	deletedLayerCount = 0 
	local deflayer = layermanager.getlayer 0 
	deflayer.current = true
	for i = Layermanager.count-1 to 1 by-1 do
	    (  
	        layer = layermanager.getLayer i  
	        local thislayername = layer.name 
	        layer.nodes &theNodes  
	        if thenodes.count== 0 then (LayerManager.deleteLayerbyname thislayername;deletedLayerCount +=1)
	    ) 
	    --if not deletedLayerCount == 0 then Messagebox ("Number of layers removed - " + deletedLayerCount as string) title:"Layer Manager"
)

fn deleteAllRel assetPath =
(
	/*
	Function that will delete all objects in a MAX scene that 
	are contained within 
	*/

	sceneObjectsNames = getMAXFileObjectNames assetPath quiet:true 	--Retrieve all the files from given max file
	sceneObjects = #()												--Empty array that will be filled with objects for delete 

	for i in sceneObjectsNames do
	(
		SCENE_NODE = getnodebyname i 
		append sceneObjects SCENE_NODE
	)
	delete sceneObjects
)

fn deleteLayers layerNames =
(
	for i = 1 to layerNames.count do
	(
		layermanager.deleteLayerByName layerNames[i]
	)-- end for i
) --end fn




fn getLayerSuffixName layerSuffix =
(
	/*
		Function to get names of layers in scene
	*/
	LAYER_NAMES = #()			--Array to save the layers' prefix
	BAD_LAYER_NAMES = #()			--Array to save the new group layers

	for i = 1 to LayerManager.count-1 do 
	(
		LAYER = LayerManager.getLayer i
		PART_NAME = FilterString LAYER.name "_"
		LAST_PART_NAME = PART_NAME[PART_NAME.count]
		append LAYER_NAMES LAST_PART_NAME
	)-- end for i
	for i = 1 to LAYER_NAMES.count-1 do
	(
		if LAYER_NAMES[i] == layerSuffix then 
		(
			print (layerSuffix as string + " has correct name")
		)
		else if LAYER_NAMES[i] != layerSuffix then
		(
			BAD_LAYER = LayerManager.getLayer i
			print BAD_LAYER
		)
	)
)-- end fn



fn xrefObjectSet setPath =
(
	fileSvnUpdate setPath

	if doesFileExist setPath == true do
	(
		if objXRefMgr.recordCount>0 then 
		(
			for i = 1 to objXRefMgr.recordCount do 
			(
				XREF_OBJ = objXRefMgr.GetRecord i
				XREF_OBJ_PATH = XREF_OBJ.srcFileName

				if setPath != XREF_OBJ_PATH then 
				(
					objXRefMgr.AddXRefItemsFromFile setPath xrefOptions:#(#mergeMOodifiers,#mergeControllers)
				)
				else if setPath == XREF_OBJ_PATH then
				(
					print "SET IS ALREADY XREFFED"
				)
			)
		)
		else 
		(
			objXRefMgr.AddXRefItemsFromFile setPath xrefOptions:#(#mergeModifiers,#mergeControllers)
		)
	)
)

fn mergeAsset assetPath groupLayerToken = 
(
	--fileSvnUpdate assetPath
	MergeMAXFile assetPath  #noRedraw #useMergedMtlDups quiet:true
	sceneLayerFunctions.groupLayers groupLayerToken
)
/*
fn duplicateFind =
(
	local OBJ_ARRAY = #()
	local OBJNAME_ARRAY = #()
	local DUPLIST_ARRAY = #()
	
	for x = 1 to $objects.count do 
	(
		append OBJ_ARRAY $objects[x]
	)

	for x = 1 to $objects.count do 
	(
		append OBJNAME_ARRAY $objects[x].name
	)
	sort OBJNAME_ARRAY
	
	for y = 1 to (OBJNAME_ARRAY.count - 1) do
	(
		if OBJNAME_ARRAY[y] == OBJNAME_ARRAY[(y+1)] do
		(
			append DUPLIST_ARRAY OBJNAME_ARRAY[y]
		)
	)

	return DUPLIST_ARRAY	
)

---FILE OPTIONS --

fn fileTestPRV =
(
	fileNameRaw = maxfilename 
	fileNameTrim = trimright  maxfilename ".max"

	if MatchPattern fileNameTrim pattern:"GJ_*_SH_*_ANM" ignoreCase:true then
	(
		fileNameParts = FilterString fileNameTrim "_"

		for i = 1 to EPISODES.count do
		(
			if MatchPattern EPISODES[i] pattern:(fileNameParts[1] +"_"+ fileNameParts[2] + "_*") do 
			(
				SHPath = (EDITS_ROOT_DIR + "EPISODES\\" + EPISODES[i] + "\\")
				SHFolder = (fileNameParts[1] +"_"+ fileNameParts[2] + "_2D" + "\\")
				SHPreviewFolder = (fileNameParts[1] +"_"+ fileNameParts[2] + "_2D_PREVIEWS" + "\\")
				SHPreview = (fileNameTrim + "_prv")
				SHPRV = (SHPath + SHFolder + SHPreviewFolder + SHPreview)
				return SHPRV
			)
		)
	)
	else
	(
		messageBox "This is not a PREVIS file"
	)
)

fn createPRV =
(
	a = fileTestPRV()
	if doesFileExist a == false then
	(	
		createPreview outputAVI:true percentSize:50 dspFrameNums:true start:0 end:5
		MaxDefaultPreviewFile = ((getdir #preview) + "\\_scene.avi" )
		copyFile MaxDefaultPreviewFile a
	)
	else 
	(
		fileOptions()
	)
)

fn fileOptions =
(
	rollout fileOptionsDialog "File Options"
	(		
		label theLabel "Shot file already exists. Overwrite?" 
		button yes_BTN "YES" offset:[0,10] width:100
		button no_BTN "NO" offset:[0,10] width:100
		
		on yes_BTN pressed do
		(
			print "SAVE PATH"
		)
		on no_BTN pressed do
		(
			DestroyDialog fileOptionsDialog
		)
	)
	createDialog fileOptionsDialog  250 100
)
*/
--- PARTICLES ---

fn getShotCam =
(	
	/*
	Searches the max file for both free and target cameras. Returns the names of existing cameras in an array
	*/

	global shotCAMNames = #()

	for c in cameras where classOf c == freeCamera or classOf c == targetCamera do
	(
		append shotCAMNames c.name
	)
	return shotCAMNames

)-- end fn getShotCam


fn getShapFacing =
(
	/*
	Searches the max file for shape facing operators. Returns the names of existing cameras in an array
	*/

	global shapeFacingNames = #()

	for i in objects where (i.classid)[2] == 515064320 do
	(
		if classOf i == Shape_Facing do append shapeFacingNames i.name
	)

	return  shapeFacingNames
)-- end fn getShapFacing


fn getMaterialStatic =
(
	/*
	Searches the max file for shape facing operators. Returns the names of existing cameras in an array
	*/

	global pMaterialNames = #()

	for i in objects where (i.classid)[2] == 515064320 do
	(
		if classOf i == Material_Static do append pMaterialNames i.name
	)

	return  pMaterialNames
)--end fn getMaterialStatic


fn assignShotCam shotCam = 
(
	/*
	Assigns a camera to the Shape_Facing operator.

	Arguments:
	shotCam - takes the name of the desired camera
	*/

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


