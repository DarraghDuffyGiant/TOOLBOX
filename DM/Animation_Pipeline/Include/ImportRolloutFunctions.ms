
/*
function DoDataImport assetName doObjDat doMatData doElement doMatIDs doLoose= 
(
	if(doObjDat or doMatData) then
	(
		filename = (getAssetDataFolder() + assetName + @"\" +assetName + "_Object_Properties.xml")
		matfile = getAssetDataFolder() + assetName + @"\" +assetName + ".mat"
		
		deSerialiseObjects filename doObjDat doMatData matfile doLoose:doLoose
	)
	
	if(doElement) then
	(
		print "doing elements"
		deSerialiseRenderElements (getAssetDataFolder() + assetName + @"\" +assetName + "_RenderElements.xml")
	)
	
	if(doMatIDs) then
	(
		deSerialiseMatIDs (getAssetDataFolder() + assetName + @"\" +assetName + "_MatIDs.xml")
	)
)*/


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

