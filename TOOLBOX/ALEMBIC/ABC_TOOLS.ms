include "C:\\SVN\\GOJETTERS\\TOOLBOX\\GENERAL\\GENERAL_TOOLS_WIP.ms"
include "C:\\SVN\\GOJETTERS\\TOOLBOX\\GENERAL\\MESH_TOOLS.ms"

struct exportAlembicFunctions (

	ExportString = "filename=%;in=%;out=%;step=1;substep=1;purepointcache=false;normals=true;uvs=true;materialids=true;exportselected=true;flattenhierarchy=true;particlesystemtomeshconversion=true;transformCache=false;validateMeshTopology=false;renameConflictingNodes=false;mergePolyMeshSubtree=false;mergePolyMeshSubtree=false;storageFormat=hdf5;facesets=partitioningFacesetsOnly",
	
	--anmSceneLayerTool.sceneLayerObjects

	fn preProcessNode obj = 
	(
		--NEED to get TS info into XML file
		layerMeshSmoothTool = meshSmoothFunctions()
		layerMeshTool = meshGeneralTools()

		layerMeshSmoothTool.setIsolineDisplayonNode obj false
		layerMeshTool.deleteModifiers obj Turbosmooth
	),


	function exportLayerNodes filePathString layerName layerObjects =
	(

			--alembicFilePath = alembicProjSetup.setABCFile alembicProjSetup.projAlembiFolder alembicFileSHInfo.EPShotNumber layerName
			a=fileFolderFunctions()
			a.testForFile filePathString

			if a.folderExists == false or (a.folderExists) and (a.folderOverwrite) then
			(	
				for obj in layerObjects do
				(

					preProcessNode obj 

				)

			inFrame = ((animationRange.start.frame  ) as integer) as string
			outFrame = ((animationRange.end.frame  )as integer) as string
			
			jobString = stringstream ""
			
			format ExportString filePathString inFrame outFrame to: jobString	
			
			
			select layerObjects

			result = ExocortexAlembic.createExportJobs(jobString as string)		
		
			)
			else
			(
				print "Don't overwrite files"
			)
		)	


		
)
/*
** Collect the materials for the current objectset and export them as a mat file.
*/
struct importAlembicFunctions (

	fn collectMaterials objs filename =
	(
		materials = #()
		materialTable = createfile (filename+".def") 
		materials = materialLibrary()

		
		for obj in objs do
		(
			if(obj.material != undefined) then
			(
				--store which mat the object is assinged to 			
				appendifunique materials obj.material
				matIdx = findItem materials obj.material
				print matIdx
				format "%,%\n" obj.name matIdx to:materialTable
			)
		)	
		
		result = saveTempMaterialLibrary  materials (filename + ".mat")
		close materialTable
		
	)
)