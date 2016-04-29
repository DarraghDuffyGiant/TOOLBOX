


struct ExportJobDef
(
	--private
	Filename = "",
	aMembers = #(),
	aClassBlacklist = #(),
	aModifierBlacklist = #(),
	ExportString = "filename=%;in=%;out=%;step=1;substep=1;purepointcache=false;normals=true;uvs=true;materialids=true;exportselected=true;flattenhierarchy=true;particlesystemtomeshconversion=true;transformCache=false;validateMeshTopology=false;renameConflictingNodes=false;mergePolyMeshSubtree=false;mergePolyMeshSubtree=false;storageFormat=hdf5;facesets=partitioningFacesetsOnly",
	
	public
	
	function Report =		
	(
		for nNode in aMembers do
		(
			format "name: % class: %\n" nNode.name (classof nNode) as string
		)
		
	),
	
	function BlackListModifier cModifierClass = 
	(
		append aModifierBlacklist cModifierClass
	),
	
	function BlackListClass cClass =
	(
		append aClassBlacklist cClass
	),
	
	function isModifierClassBlacklisted cModifier =
	(
		bResult = false
			
		for cBlacklistMod in aModifierBlacklist do
		(
			if(cModifier == cBlacklistMod) then
			(
				bResult = true
			)
		)
		return bResult
	),
	
	function PreProcessNode nNode bruteForce:false= 
	(
		/*Make sure the node isnt frozen if it is it wont export (we export by selection... frozen nodes wont export)*/
		unfreeze nNode
		
		if(nNode != undefined) then
		(		
			/*Disable Blacklisted modifiers*/			
			for mMod in nNode.modifiers do
			(
				cModifier = ( classof mMod )
				if( isModifierClassBlacklisted cModifier) then
				(
					mMod.enabled = false
				)
			)
			
			/*Apply an Edit_Poly Modifier to the to of the stack, This sorts out lots of Export issues linked to changing Geo*/
			
			mEPoly = edit_mesh()
			
			if(validmodifier nNode mEPoly) then
			(
				addmodifier nNode mEPoly
			)		
			
			/*If A Worldspace Modifier is present (they're always at the top) then we need to use a mesher
			we rename the old mesh and replace it in the export job with a mesher. 
			*/
			if(nNode.modifiers[1] != undefined and bruteforce) then
			(
				if(superclassof nNode.modifiers[1] == SpacewarpModifier) then
				(	
					nMesher = mesher()
					nMesher.pick = nNode
					
					sOldName = nNode.name
					nNode.name = nNode.name + "_WSM"
					nMesher.name = sOldName
					return nMesher
				)
				
			)
			if(superClassof nNode.baseObject == Shape) then
			(
				format "Node is a shape:%\n" nNode.name
			)
		)
		return nNode
		
	),
	
	function IsClassBlacklisted cNodeClass = 
	(
		bResult = false
			
		for cClass in aClassBlacklist do
		(
			if(cNodeClass == cClass) then
			(
				bResult = true
			)
		)
		return bResult
	),		

	function AddObject nNode bruteforce:false =
	(		
		if(nNode != undefined) then
		(
			cNodeClass = classof nNode
			
			/*Filter out non Geometry nodes and blacklisted classes*/
			if (NOT(IsClassBlacklisted cNodeClass) and ((superclassof nNode == GeometryClass) or (superclassof nNode.baseObject == Shape)) ) then
			(
				nNode = ( PreProcessNode nNode bruteforce: bruteforce)
				append aMembers nNode
			)
		)
	),
	
	function AddObjectCollection aCollection  bruteforce:false =
	(
		for nNode in aCollection do
		(
			
			AddObject nNode bruteforce: bruteforce
		)
	),
	
	function AddLayer oLayerObject bruteforce:false = 
	(
		bIsLayerDefined =  (oLayerObject != undefined)
		
		assert (bIsLayerDefined) message:"Layer is undefined"
		
		if(bIsLayerDefined) then
		(
			aLayerNodes = #()
			result = oLayerObject.nodes &aLayerNodes		
			AddObjectCollection aLayerNodes bruteforce:bruteforce
		)
		
		
	),
	
	function Export  =
	(
	
		inFrame = ((animationRange.start.frame  ) as integer) as string
		outFrame = ((animationRange.end.frame  )as integer) as string
		
		jobString = stringstream ""
		
		format ExportString Filename inFrame outFrame to: jobString	
		
		
		select aMembers
		print jobString
		result = ExocortexAlembic.createExportJobs(jobString as string)		
			
	)		
)
/*
ExportJob = ExportJobDef()
ExportJob.BlackListClass ParticleGroup
ExportJob.BlackListClass PF_Source
ExportJob.BlackListModifier Turbosmooth

--ExportJob.ExportString = (AlembicExportSettings()).GeometryExport

ExportJob.addObject(selection[1])
ExportJob.Report()
--ExportJob.Export ((@"C:\Users\rfletcher\Desktop\Alembic_Test\MUDHEAD_GEO1.abc") )

*/
/*
ExportJob.BlackListClass PolyMeshObject
ExportJob.AddLayer (layerManager.getLayerfromname "MUDHEAD_GEO")
ExportJob.Report()
ExportJob.Export ((@"C:\Users\rfletcher\Desktop\Alembic_Test\MUDHEAD_Parti.abc") )
*/

