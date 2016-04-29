function collectMaterials objectList = 
(
	materials = materialLibrary()
	
	for o in objectList do
	(
		if isKindOf o GeometryClass then
		(
			if o.material != undefined then
			(
				appendIfUnique materials o.material
			)
		)
	)
	
	return materials
)

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

function exportObjectList objectList exportName = 
(
	/* collect scene data */
	
	objectList = filterObjectListByClass objectList GeometryClass
	materialList = CollectMaterials objectList
	disableModifierByClass objectList "TurboSmooth"
	
	
	/*Export Scene Data */
	alembicFolder = getAlembicFolder()
	filename = alembicFolder + "\\"+ exportName
	saveTempMaterialLibrary  materialList (filename + ".mat")
	SerialiseObjectList objectList materialList (filename + ".sceneData")

	jobString = "filename="
	jobString += (filename+".abc")
	jobString += ";int=" + (animationrange.start as string)
	jobString += ";out=" + (animationrange.end as string)
	
	jobString +=";step=1;substep=1;purepointcache=false;normals=false;uvs=true;materialids=true;exportselected=true;flattenhierarchy=true;automaticinstancing=true;transformCache=false;validateMeshTopology=false;renameConflictingNodes=false;mergePolyMeshSubtree=false;mergePolyMeshSubtree=false;storageFormat=hdf5;facesets=partitioningFacesetsOnly"
	select objectList
	ExocortexAlembic.createExportJobs(jobString)
)


function collectMaterials objectList = 
(
	materials = materialLibrary()
	
	for o in objectList do
	(
		if isKindOf o GeometryClass then
		(
			if o.material != undefined then
			(
				appendIfUnique materials o.material
			)
		)
	)
	
	return materials
)

fn serialiseObjectList objectList materialList filename= 
(	
	serialised = createFile filename
	start = (filterString (animationrange.start as string) "f")[1]
	end = (filterString (animationrange.end as string) "f")[1]
	format "%,%\n" start end to:serialised
	for o in objectList do
	(
		n = o.name
		m = o.material
		matIndex = 0
		if o.material != undefined then
		(
				matIndex = findItem materialList o.material
		)
		
		i = getTurboSmoothIterations o
		
		format "%,%,%\n"  n matIndex i to:serialised
	)
	
	close serialised
	
)