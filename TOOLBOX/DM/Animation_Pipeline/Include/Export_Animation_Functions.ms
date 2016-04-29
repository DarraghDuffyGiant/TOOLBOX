
function getAssetNames sDirectory = 
(	
	
	if( doesFileExist sDirectory ) then
	(
		
		aNames = #()
		aDirs = getDirectories ( pathConfig.AppendPath sDirectory "*.*" )
		
		for sDir in aDirs do
		(
			sName = pathConfig.stripPathToLeaf  sDir
			
			/*Strip off the \ from the folder name*/
			sName = (filterstring sName @"\")[1]
			
			append aNames sName
		)
		
		
		return aNames
		
	)
	
)

function getExportableAssets = 
(
	aLayerNames 	= #()
	iLayerCount = LayerManager.count
		
	for i = 1 to (iLayerCount-1) do
	(
		oLayer = LayerManager.getLayer i
		if(oLayer != undefined) then
		(
			sName = oLayer.name
			append aLayerNames sName
		)
	)
	
	return aLayerNames
	
)

function PopulateListbox lbx aList sSearchTerms  =
(
	aItems = #()
	
	aSearchTerms = filterString sSearchTerms ","
	
		for sItem in aList do
		(
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


function doAnimationExport aObjectList sExportFolder sExportName bruteforce:false= 
(
	/*Exporting Particle Systems as a single cache doesnt seem to work with exocortex, so we collect them and export them seperately*/
	aExportJobs = #()	
	
	/*First We make the primary Export Job
		Particle classes are blacklisted so that they wont be added to the main cache
	*/
	ExportJob = ExportJobDef()	
	ExportJob.BlackListClass ParticleGroup
	ExportJob.BlackListClass PF_Source	
	ExportJob.AddObjectCollection aObjectList bruteforce:bruteforce
	
	ExportJob.filename = pathConfig.appendPath sExportFolder (sExportName + ".abc")
	ExportJob.Export()
	
)







