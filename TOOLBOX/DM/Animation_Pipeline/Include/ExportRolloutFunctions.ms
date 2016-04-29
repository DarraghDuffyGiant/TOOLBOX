

function GetLayerList searchTerm =
(	
	searchTerms = filterString searchTerm ","
	layers = #()
		for i = 0 to layerManager.count-1 do
		(
		  ilayer = layerManager.getLayer i
			
			if searchTerm != "" then
			(
				for term in searchTerms do
				(
					if( (findstring ilayer.name term) !=undefined ) then
					(
						append layers ilayer.name
					)
				)
			)
			else
			(
				append layers ilayer.name
			)
			
		)
		
		return layers
)

/* Filter the provided object list and return only those objects of the given class*/
function filterObjectListByClass objectList c = 
(
	filteredList = #()
	
	for obj in objectList do
	(
		if( isKindOf obj GeometryClass ) then
		(
			append filteredList obj
		)
	)
	return filteredList	
)

function disableModifierByClass objectList classNameString =
(
	for obj in objectList do
	(	
		
		m = obj.modifiers[classNameString]
		
		if (m != undefined) then
		(
			m.enabled = false
		)
		
	)	
)

/*Export the currently selected layers / selection*/
	function Export assetName objList doBasic doElements doMatIDs doMaterials data_folder= 
	(		
		if(not doesFileExist data_folder) then
		(
			messagebox "Asset Data folder does not exist"
			return undefined
		)		
		
		
		disableModifierByClass objList "TurboSmooth"
		exportFolder = data_folder + assetName
		assetPath = exportFolder + "\\"+ assetName
		
		if(doBasic OR doElements OR doMatIDs) then
		(
			if(NOT (doesFileExist exportFolder) )then
			(
				makeDir exportFolder
			)
		)
		
		if(doBasic) then
		(			
			serialiseObjects objList (assetPath + "_Object_Properties.xml")
		)
		
		if(doElements) then
		(
			--print "eleemmememeements"
			serialiseRenderElements (assetPath +"_RenderElements.xml")
		)
		
		if(doMatIDs) then
		(
			SerialiseMatIDs objList (assetPath + "_MatIDs.xml")
		)
		
		if(doMaterials) then
		(			
			ExportObjectMaterials objList (assetPath +".MAT")
		)
		
		
	)

function ExportObjectList objectList filename = 
(
	--first make sure were only dealing with geometry
	objectList = filterObjectListByClass objectList GeometryClass
	
	--check for turbosmooth modifiers and turn them off
	disableModifierByClass objectList "TurboSmooth"

	jobString = "filename="
	jobString += (filename+".abc")
	jobString += ";in=" + ((animationrange.start) as string)
	jobString += ";out=" + ((animationrange.end) as string)
	jobString +=";step=1;substep=1;purepointcache=false;normals=true;uvs=true;materialids=true;exportselected=true;flattenhierarchy=true;automaticinstancing=true;transformCache=false;validateMeshTopology=false;renameConflictingNodes=false;mergePolyMeshSubtree=false;mergePolyMeshSubtree=false;storageFormat=hdf5;facesets=partitioningFacesetsOnly"

	select objectList

	ExocortexAlembic.createExportJobs(jobString)
)

