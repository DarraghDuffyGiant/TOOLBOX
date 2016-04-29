/*Robert Fletcher 2015*/

macroScript Import_Animation_Offsite
	category:"Boulder Offsite"
	toolTip:"Import Alembic Offsite"
(
	fn makePathsAbsolute = 
	(
		sceneBitmaps = (getClassInstances BitmapTexture)

		for bm in sceneBitmaps do
		(
			filename = bm.filename
			if( not pathConfig.isAbsolutePath(filename)) then
				(
					bm.filename = pathConfig.convertPathToAbsolute bm.filename
				)
		)
	)
	function loadSceneData filename loadDuration useTS  = 
	(		
		file = openFile filename
		header = readline file
		header = filterString header ","
		
		objectCollection = #()
		
		ts = Turbosmooth()
				ts.useRenderIterations = true
				ts.iterations = 0
				ts.renderIterations = 2
		framerate = 25
		if(loadDuration) then
		(
			animationrange = interval (header[1] as integer) (header[2] as integer)
		)
		
		while not(eof file) do
				(				
					
					txt = readline file
					txt = filterstring txt ","
					objName = txt[1]
					--matID = txt[2] as integer 
					matName = txt[2]
					
					obj = getnodebyname objName		
					if (obj == undefined) then
					(
						format "obj:% was not found in this file" objName
						continue
					)
					print ("adding" + obj.name + " to collection")
					
					objectCollection = (append objectCollection obj)
					
					
					--obj.material = materials[matID]
					format "useTS:% class:%\n" useTS (classof obj)
					if(useTS) then
					(
						--print (classof obj)
						if(classof obj == PolyMeshObject) then
						(					
							
							addModifier obj ts
						)
					)	
					
				)			
				close file
				
				if not(objectCollection == undefined) then
				(
					
					select objectCollection
				)
				else
				(
					print "selection was undefined"
				)
	)

	function getAnimation = 
	(
		animations = #()
		alembicFolder = maxfilepath + "\\Alembic"
		files = getFiles (alembicFolder + "\\*.abc")
		return files
		
	)

	rollout importRollout "Import Animation" width:256 height:446
	(
		multiListBox lbx_layers "Animation" pos:[8,8] width:240 height:23
		
		button btn_import "Import" pos:[48,384] width:152 height:32	
	
		
		
		checkbox chkTurboSmooth "Apply Turbosmooth" pos:[8,336] width:240 height:24 checked:true		
		
		checkbox chk_InOut "Import Animation Range" pos:[8,360] width:240 height:24 checked:true
		
				
		on importRollout open do
		(
			files = getAnimation()
			names = #()
			for f in files do
			(
				filename  = filenameFromPath f
				append names filename
			)
			lbx_layers.items = names
		)
		on btn_import pressed do
		(
			alembicFolder = maxfilepath + "\\Alembic"
			files = getFiles (alembicFolder + "\\*.abc")
			selectedLayers = lbx_layers.selection
			
			for selected in selectedLayers do
			
			(	
				
				filename =files[selected]
				shortfilename = (filenameFromPath filename)
				shortfilename = (filterstring shortfilename ".")[1]
				
				
				defFile = (alembicFolder +"\\"+ shortfilename +".sceneData")
			
				layer = LayerManager.getLayerFromName shortfilename
				
				if (layer ==undefined) then
				(
					layer = layerManager.newLayer()
					layer.setName shortfilename
					layer.current = true
				)
				
				layerNodes = #()				
				result = layer.nodes &layerNodes
				
				(LayerManager.getLayer 0).current = true
				
				jobString = "filename=" + (filename as string)
				jobString+=";normals=false;uvs=true;attachToExisting=true;loadGeometryInTopologyModifier=false;loadTimeControl=false;loadCurvesAsNurbs=false;loadUserProperties=false;meshSmoothModifiers=false;materialIds=true;objectDuplication=copy"
				
				ExocortexAlembic.createImportJob(jobString)
				
				if(doesFileExist defFile) then
				(
					loadSceneData defFile true true 
				)
				
				selectionSets[shortfilename]  = selection
				
		
				
			)		
			makePathsAbsolute()
			
		)
	
	)

	createDialog importRollout
)
