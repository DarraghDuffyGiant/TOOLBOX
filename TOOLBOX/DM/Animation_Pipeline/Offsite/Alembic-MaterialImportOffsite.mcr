/*
	Boulder Mat importer version 1 (Offsite)
*/


macroScript Import_Materials_Offsite
	category:"Boulder Offsite"
	toolTip:"Import Materials Offsite"
(
try(destroyDialog importADataRollout) catch()
		
	ASSET_DATA_FOLDER = @"V:\BBC\GO JETTERS\Assets\ASSET_DATA\"
	
	function collectNamedDuplicates objNames = 
	(
		re = dotNetClass "System.Text.RegularExpressions.Regex"
		reOpt = dotNetClass "System.Text.RegularExpressions.RegexOptions"
		objCollection = #()
		
		
		if(classof objNames != Array) then
		(
			objNames = #(objNames)
		)
		
		
		/*first we convert the name into a regular expression (make the numbers tokens)*/
		
		for objName in objNames do
		(
			pattern = re.Replace objName @"\d" @"\d"
			
			for obj in objects do
			(
				sName = obj.name
				match = re.match sName pattern reOpt.IgnoreCase
				if(match.success) then
				(
					append objCollection obj			
				)
			)
		)

		return objCollection
	)
	
	function deSerialiseObjects filename doBasic doMats matFile= 
	(
		matfile = loadTempMaterialLibrary matFile
		--Load the xml assembly
		dotNet.loadAssembly "system.xml"
		--Create an xml document object.
		xmlDoc=dotNetObject "system.xml.xmlDocument"
		
		xmlDoc.load filename
		
		docEle=xmlDoc.documentElement
		tsMod = Turbosmooth()
		tsMod.useRenderIterations = on
		tsMod.renderIterations = 2
		tsMod.iterations = 0
						
		
		
		if docEle!=undefined and docEle.name=="Root" then
		(		
			
			for i = 0 to docEle.ChildNodes.count-1 do
			(
				xmlNode = docEle.ChildNodes.itemOf[i]
				objectName = ( xmlNode.attributes.getNamedItem "name" ).value
				
				objs =#()
				
				obj = getNodeByName objectName
				
				if(obj != undefined) then
				(
					objs =#(obj)
				)
				
				for obj in objs do
				(				
					if(doBasic) then
					(
						obj.renderable = ((xmlNode.attributes.getNamedItem "renderable" ).value) as booleanClass			
						obj.castShadows = (( xmlNode.attributes.getNamedItem "castShadows" ).value) as booleanClass
						obj.receiveshadows = (( xmlNode.attributes.getNamedItem "receiveshadows" ).value) as booleanClass
						obj.ApplyAtmospherics = (( xmlNode.attributes.getNamedItem "ApplyAtmospherics" ).value) as booleanClass
						obj.inheritVisibility = (( xmlNode.attributes.getNamedItem "inheritVisibility" ).value) as booleanClass
						obj.renderOccluded = (( xmlNode.attributes.getNamedItem "renderOccluded" ).value) as booleanClass
						obj.primaryVisibility = (( xmlNode.attributes.getNamedItem "primaryVisibility" ).value) as booleanClass
						obj.secondaryVisibility = (( xmlNode.attributes.getNamedItem "secondaryVisibility" ).value) as booleanClass
						obj.gbufferchannel = (( xmlNode.attributes.getNamedItem "gbufferchannel" ).value) as integer					
					)
					
					tsValue = (( xmlNode.attributes.getNamedItem "turbosmooth" ).value) as integer
					
					if( tsValue > 0) then
					(		
					
						if(obj.modifiers[#Turbosmooth] == undefined) then
						(
							addModifier obj tsMod
						)
					)
					
					
					if(doMats) then
					(
						matName = (( xmlNode.attributes.getNamedItem "material" ).value)
					
						
						for mat in matFile do
						(
							if mat.name == matName then
							(
								obj.material = mat
							)
						)
						
						
					)				
					
				)
				
			)
			
		)
	)
	
	function doImport assetName  = 
	(
		
		filename = (ASSET_DATA_FOLDER + assetName + @"\" +assetName + "_Object_Properties.xml")
		matfile = ASSET_DATA_FOLDER + assetName + @"\" +assetName + ".mat"			
		deSerialiseObjects filename true true matfile		
	)

	function getAssetList assetFolder =
	(
		if(doesFileExist assetFolder) then
		(
			assetDefs = getDirectories (assetFolder + "*.*")
			assets = #()
			
			for assetDef in assetDefs do
			(
				assetName  = pathConfig.stripPathToLeaf assetDef -- strip the parent leaves from the path
				assetName  = (filterString assetName @"\")[1] -- strip the backslash out of the name
				append assets assetName
			)
		)
		return assets
	)

	function filterAssetCollection assets searchTerm=
	(
		searchTerms = filterString searchTerm ","
		
		filteredList = #()
		
		for asset in assets do
		(
			for term in searchTerms do
			(
				term = (toLower term)
				term = "*" + term + "*"
				if( matchPattern (tolower asset) pattern:term) then
				(
					append filteredList asset
				)
			)
		)
		return filteredList
	)

	rollout importADataRollout "Import Asset Data" width:384 height:384
	(
				
		multiListBox lbxAssetDefs "Layers" pos:[8,8] width:368 height:22				
		edittext edtFilter "" pos:[40,320] width:168 height:24
		label lblFilter "Filter" pos:[8,328] width:32 height:16
		button btnImport "Import" pos:[8,352] width:368 height:24		
		button btnRefresh "Refresh" pos:[216,320] width:160 height:24
		
		/*
			Rollout Events
		*/	
		
		on importADataRollout open do
		(
			
			
			assetCollection = getAssetList ASSET_DATA_FOLDER
			
			lbxAssetDefs.items = assetCollection
			
		)
		on edtFilter changed txt do
		(
			if(txt == "") then (txt ="*")
			filteredAssetCollection = filterAssetCollection assetCollection txt
			lbxAssetDefs.items = filteredAssetCollection
		)
		on btnImport pressed do
		(
			selectedLayers = lbxAssetDefs.selection
				
				for selected in selectedLayers do
				(				
					
					assetName= lbxAssetDefs.items[selected]			
					
					doImport assetName 					
				)
		)
		on btnRefresh pressed do
		(
			assetDataFolder = ASSET_DATA_FOLDER

			
			assetCollection = getAssetList assetDataFolder
			
			lbxAssetDefs.items = assetCollection
		)
	)
	
CreateDialog importADataRollout
)
