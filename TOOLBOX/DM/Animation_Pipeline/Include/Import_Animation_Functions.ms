include "$userscripts\\Animation_Pipeline\\Include\\DATA_IO\\Data_Importer.ms" 

function loadSceneData filename  = 
	(		
		file = openFile filename
		header = readline file
		header = filterString header ","
		
		objectCollection = #()
		

		framerate = 25
		
	
		animationrange = interval (header[1] as integer) (header[2] as integer)
		
		
		close file			
	)


function getAnimation alembicFolder = 
(
	animations = #()	
	files = getFiles (alembicFolder + "\\*.abc")
	return files	
)

function PopulateListbox lbx aList sSearchTerms  =
(
	aItems = #()
	
	aSearchTerms = filterString sSearchTerms ","
	
		for sItem in aList do
		(
			sItem = (filenamefrompath  sItem)
			sItem = (filterString sItem ".")[1]
			if(sSearchTerms.count > 0) then
			(
				for sSearchTerm in aSearchTerms do
				(
					if sSearchTerm != "" then
					(
							if( (findstring sItem sSearchTerm) !=undefined ) then
							(
								append aItems sItem
							)
					)
					else
					(
						print sItem
						append aItems sItem
					)				
				)
			)
			else
			(
				append aItems sItem
			)
			
		)
		
	lbx.items = aItems
		
)

function DoAnimationImport aNames sAlembicFolder sDataFolder doLoose= 
(
	
	assert (classof aNames == Array) message: "aNames is not an array"
	assert (doesFileExist sAlembicFolder) message: "sAlembicFolder does not exist"
	assert (doesFileExist sDataFolder) message: "sDataFolder does not exist"
	

	
	
	for sName in aNames do
	(	
		
		
		sceneData = (pathConfig.appendPath  sAlembicFolder (sName + ".sceneData"))
		if(doesFileExist sceneData) then
		(
			loadSceneData sceneData
		)
		
		/* Grab a list of scene objects. We use these later to see what objects have been imported by alembic*/
		aObjBefore = for obj in objects collect obj
		
		
		/*Resolve the alembic filename*/
		filename = pathConfig.appendPath  sAlembicFolder (sName + ".abc")		
		
		/*Create a layer for the alembic if it does not exist, if it does then use that*/
		layer = ""
		layer = LayerManager.getLayerFromName sName
		
		if(layer == undefined) then
		(
				layer = LayerManager.newLayerFromName sName
		)
		
		/*make the layer current so that imported objects are added into it*/
		layer.current = true
		
		
		/*First Import the geometry*/
		jobString = "filename=" + (filename as string)
		jobString+=";normals=false;uvs=true;attachToExisting=true;loadGeometryInTopologyModifier=false;loadTimeControl=false;loadCurvesAsNurbs=false;loadUserProperties=false;meshSmoothModifiers=false;materialIds=true;objectDuplication=copy"				
		ExocortexAlembic.createImportJob(jobString)
		--doObjDat:false doMatData:false doElement:false doMatIDs:false doLooseNames:false doSceneData:false
		
		DataImport sName doObjDat:true doMatData:true doElement:true doMatIDs:false doLooseNames:doLoose doSceneData:true
		
		(LayerManager.GetLayer 0).current = true
		
		/*Collect Nodes that are not members of the aObjBefore Array, This gives us any new objects added to the scene during import
		*/
		aNewObj = for obj in objects where ((findItem aObjBefore obj) == 0) collect obj
		
		/*Create Selection set for Alembic*/		
		selectionSets[sName] = aNewObj
		
		/*Object processing goes here*/
		for obj in aNewObj do
		(
			case (classof obj) of
			(
				FreeCamera:
				(
					freeze obj
					obj.clipManually = false
				)
				TargetCamera:
				(
					freeze obj
					obj.clipManually = false
				)
			)
		)
		
		
	)	
)