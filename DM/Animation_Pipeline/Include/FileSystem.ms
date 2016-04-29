

function getAlembicFolder = 
(
	if(maxfilepath !="") then
	(
		alembicFolder = maxfilepath + "Alembic"
		
		if NOT(doesfileExist alembicFolder) then
			(
				makeDir alembicFolder				
			)
			
		return alembicFolder
	)
)


function GetAssetDataFolder = 
(
	/*assetData = pathConfig.getCurrentProjectFolder() + @"\ASSET_DATA\"
	
	assert (doesfileexist assetData) message:"Asset Data folder not found"
	*/
	assetData  =@"V:\BBC\GO JETTERS\PRODUCTION\ASSETS\ASSET_DATA\"
	return assetData
)



fn makePathsAbsolute = 
	(
		sceneBitmaps = (getClassInstances BitmapTexture)

		for bm in sceneBitmaps do
		(
			filename = bm.filename
			if(filename !=undefined) then
			(
			if( not pathConfig.isAbsolutePath(filename)) then
				(
					bm.filename = pathConfig.convertPathToAbsolute bm.filename
				)
			)
		)
)

