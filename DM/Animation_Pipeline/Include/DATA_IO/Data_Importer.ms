

function DataImport assetName doObjDat:false doMatData:false doElement:false doMatIDs:false doLooseNames:false doSceneData:false = 
(
	
	include "$userscripts\\Animation_Pipeline\\Include\\FileSystem.ms"
	include "$userscripts\\Animation_Pipeline\\Include\\DATA_IO\\DeSerialise_Objects.ms"
	include "$userscripts\\Animation_Pipeline\\Include\\DATA_IO\\DeSerialise_Elements.ms"	
	include "$userscripts\\Animation_Pipeline\\Include\\DATA_IO\\DeSerialise_MatIDs.ms"
	include "$userscripts\\Animation_Pipeline\\Include\\DATA_IO\\DeSerialise_SceneData.ms"
	include "$userscripts\\Animation_Pipeline\\Include\\DATA_IO\\Import_Materials.ms"		

	if(doObjDat or doMatData) then
	(
		
		filename = (getAssetDataFolder() + assetName + @"\" +assetName + "_Object_Properties.xml")
		matfile = getAssetDataFolder() + assetName + @"\" +assetName + ".mat"
		--format "assetname:%\n" assetName
		--print (classof filename)
		--print "!!!:Filename:" + filename
		

		if((doesFileExist filename) and (doesFileExist matfile)) then
		(
			deSerialiseObjects filename doObjDat doMatData matfile doLoose:doLooseNames
		)
	)
	
	if(doElement) then
	(
		filename = (getAssetDataFolder() + assetName + @"\" +assetName + "_RenderElements.xml")
		if(doesFileExist filename) then
		(
			deSerialiseRenderElements filename doLooseNaming:doLooseNames
		)
	)
	
	if(doMatIDs) then
	(
		filename = (getAssetDataFolder() + assetName + @"\" +assetName + "_MatIDs.xml")
		print "working on the farm"
		print filename
		
		if(doesFileExist filename) then
		(
			deSerialiseMatIDs filename
		)
	)
	
	if(doSceneData) then
	(
		sFilename = assetName + "_SceneData.xml"
		sFilePath = pathConfig.AppendPath maxfilepath "Alembic"
		sFullPath = pathConfig.AppendPath sFilePath sFilename
		
		--filename = (getAssetDataFolder() + assetName + @"\" +assetName + "_SceneData.xml")
		deSerialise_SceneData sFullPath
	)
)


--DataImport "LARS_MESH" doObjDat:true doMatData:true doElement:true doMatIDs:false doLooseNames:false doSceneData:true