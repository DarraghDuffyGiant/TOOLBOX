function getAnimation = 
(
	animations = #()
	alembicFolder = maxfilepath + "\\Alembic"
	files = getFiles (alembicFolder + "\\*.abc")
	return files
	
)

rollout importRollout "Import Animation" width:256 height:424
(
	multilistbox lbx_layers "Animation" pos:[8,8] width:240 height:23
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
			ts = Turbosmooth()
			ts.useRenderIterations = true
			ts.iterations = 0
			ts.renderIterations = 2
			filename =files[selected]
			shortfilename = (filenameFromPath filename)
			shortfilename = (filterstring shortfilename ".")[1]
			matlib = (alembicFolder +"\\"+ shortfilename +".mat")
			materials = loadTempMaterialLibrary matlib
			print materials[1]
			defFile = (alembicFolder +"\\"+ shortfilename +".sceneData")
		
						
			layer = layerManager.newLayer()
			layer.setName shortfilename
			layer.current = true
			
			
			jobString = "filename=" + (filename as string)
			jobString+=";normals=false;uvs=true;attachToExisting=true;loadGeometryInTopologyModifier=false;loadTimeControl=false;loadCurvesAsNurbs=false;loadUserProperties=false;meshSmoothModifiers=false;materialIds=true;objectDuplication=copy"
			ExocortexAlembic.createImportJob(jobString)
			
			file = openFile defFile
			header = readline file
			header = filterString header ","
			
			if(chk_InOut.checked) then
			(
				animationrange = interval (header[1] as integer) (header[2] as integer)
			)
			
	
			
			while not(eof file) do
			(
				
				txt = readline file
				txt = filterstring txt ","
				objName = txt[1]
				matID = txt[2] as integer 
				obj = getnodebyname objName				
				obj.material = materials[matID]
				
				if(chkTurboSmooth.checked) then
				(
					addModifier obj ts
				)	
				
			)			
			
			
			
		)
		
	)
	on chkTurboSmooth changed state do
	(
		
		)
	on chk_InOut changed state do
	(
		
		)
)

createDialog importRollout


