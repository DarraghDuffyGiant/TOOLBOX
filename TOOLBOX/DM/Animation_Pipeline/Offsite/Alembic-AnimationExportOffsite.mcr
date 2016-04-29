
/*Robert Fletcher 2015*/

macroScript Export_Animation_Offsite
	category:"Boulder Offsite"
	toolTip:"Export Alembic Offsite"
(

	function getAlembicFolder = 
	(
		alembicFolder = maxfilepath + "Alembic"
		
		if NOT(doesfileExist alembicFolder) then
			(
				makeDir alembicFolder
				
			)
		return alembicFolder
			
	)

	Function CollectMaterials objectList = 
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

	function getTurboSmoothIterations obj =
	(
		ts = obj.modifiers["TurboSmooth"]
		if ts != undefined then
		(
			return ts.iterations
		)
		else
		(
			return 0
		)
	)

	Function SerialiseObjectList objectList materialList filename= 
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
			matName = ""
			
			if o.material != undefined then
			(
					matIndex = findItem materialList o.material
					matName = m.name
			)
			
			i = getTurboSmoothIterations o
			
			
			format "%,%,%\n"  n matName i to:serialised
		)
		
		close serialised
		
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

	function disableModifierByClass objectList classNameString =
	(
		mList = #() --list of modifiers
		sList = #() --list of their states
		result = #() -- container for both lists
		
		for obj in objectList do
		(	
			
			m = obj.modifiers[classNameString]
			
			if (m != undefined) then
			(
				append mList m
				append sList m.enabled 
				m.enabled = false
			)
		)
		
		append result cList
		append result sList
		
		return result
	)

	function restoreModifierList modifierList = 
	(
		mList = modifierList[1]
		sList  = modifierList[2]

		for i= 1 to modifierList.length do
		(
			
		)
			
	)

	function exportObjectList objectList exportName= 
	(
		/* collect scene data */
		alembicFolder = getAlembicFolder()
		filename = alembicFolder + "\\"+ exportName
		
		disableModifierByClass objectList "TurboSmooth"
		objectList = filterObjectListByClass objectList GeometryClass
		materialList = CollectMaterials objectList
		
		
		 SerialiseObjectList objectList materialList (filename + ".sceneData")
		
		/*Export Scene Data */
		alembicFolder = getAlembicFolder()
		filename = alembicFolder + "\\"+ exportName
		
		--saveNodes cameras (filename + "_cams.max") quiet:true
		jobString = "filename="
		jobString += (filename+".abc")
		jobString += ";in=" + ((animationrange.start) as string)
		jobString += ";out=" + ((animationrange.end) as string)
		jobString +=";step=1;substep=1;purepointcache=false;normals=true;uvs=true;materialids=true;exportselected=true;flattenhierarchy=true;automaticinstancing=true;transformCache=false;validateMeshTopology=false;renameConflictingNodes=false;mergePolyMeshSubtree=false;mergePolyMeshSubtree=false;storageFormat=hdf5;facesets=partitioningFacesetsOnly"
		
		emMod = edit_mesh()
		
		select objectList
		
		for obj in objectList do
		(
			if(validmodifier obj emMod) then
			(
				addmodifier obj emMod
			)
		)	
		
		
		ExocortexAlembic.createExportJobs(jobString)			
		
	)
	
	function exportCameras = 
	(
		/* collect scene data */
		
		
		for cam in cameras do
		(
			If((classof cam == TargetCamera) or (classof Cam == FreeCamera)) then
			(
				cam.nearclip = 1.0
			)
		)
		select cameras
		exportName = "Cameras"
	
		alembicFolder = getAlembicFolder()
		filename = alembicFolder + "\\"+ exportName	
		
		
		jobString = "filename="
		jobString += (filename+".abc")
		jobString += ";in=" + ((animationrange.start) as string)
		jobString += ";out=" + ((animationrange.end) as string)
		jobString +=";step=1;substep=1;purepointcache=false;normals=true;uvs=true;materialids=true;exportselected=true;flattenhierarchy=true;automaticinstancing=true;transformCache=false;validateMeshTopology=false;renameConflictingNodes=false;mergePolyMeshSubtree=false;mergePolyMeshSubtree=false;storageFormat=hdf5;facesets=partitioningFacesetsOnly"
		print "Exporting Cam"
		ExocortexAlembic.createExportJobs(jobString)	
		
	)
	
	function populateLayerList searchTerm =
	(
		layers = #()
		searchTerms = filterString searchTerm ","
		
			for i = 0 to layerManager.count-1 do
			(
			  ilayer = layerManager.getLayer i
				
				for searchTerm in searchTerms do
				(
				if searchTerm != "" then
					(
						if( (findstring ilayer.name searchTerm) !=undefined ) then
						(
							append layers ilayer.name
						)
					)
					else
					(
						append layers ilayer.name
					)
				)
				
			)
			
			return layers
	)

	rollout exportRollout "Export Animation" width:384 height:376
	(
		multilistbox lbxLayers "Layers" pos:[8,32] width:368 height:22
		button btnExport "Export" pos:[160,344] width:104 height:24
		edittext edtFilter "" pos:[40,344] width:112 height:24 text:"mesh,geo,hidden"
		label lblFilter "Filter" pos:[8,352] width:32 height:16
		button btnCancel "Cancel" pos:[272,344] width:104 height:24
		checkbox chkExportSelection "Export Selected Objects" pos:[8,7] width:136 height:16		
		edittext edtName "" pos:[208,8] width:168 height:18 enabled:false
		label lblName "Name" pos:[168,8] width:39 height:18 enabled:false
		
		on chkExportSelection changed theState do
		(
			lbxLayers.enabled = (not theState)
			edtFilter.enabled = (not theState)
			edtName.enabled = theState
			lblName.enabled = theState
			lblFilter.enabled = (not theState)
		)
		
		on edtFilter changed theVal do
		(
			lbxLayers.items =PopulateLayerlist edtFilter.text
		)
		on exportRollout open do
		(
			lbxLayers.items =PopulateLayerlist edtFilter.text
		)
		
		on btnExport pressed do
		(
			if( chkExportSelection.checked and (edtName.text != "") ) then
			(
				exportObjectList selection edtName.text 
			)
			else
			(
				selectedLayers = lbxLayers.selection
				
				for selected in selectedLayers do
				(				
					layerNodes = #()
					layer = LayerManager.getLayerFromName lbxLayers.items[selected]			
					result = layer.nodes &layerNodes	
					exportObjectList layerNodes layer.name
				)
				
				
			)
			exportCameras()	
		)
		
		
		on btnCancel pressed do
		(
			destroyDialog exportRollout
		)
		
	)
	
	createDialog exportRollout
)
