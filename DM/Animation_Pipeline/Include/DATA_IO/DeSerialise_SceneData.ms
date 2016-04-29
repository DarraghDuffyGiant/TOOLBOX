
function deSerialise_SceneData filename = 
(
	if not(doesFileExist filename) then
	(
		return 0
	)
	--matfile = loadTempMaterialLibrary matFile
	--include "$userscripts\\Animation_Pipeline\\Include\\CommonFunctions.ms"
	
	--Load the xml assembly
	dotNet.loadAssembly "system.xml"
	--Create an xml document object.
	xmlDoc=dotNetObject "system.xml.xmlDocument"
	
	xmlDoc.load filename
	
	docEle=xmlDoc.documentElement
		
	
	if docEle!=undefined and docEle.name=="Root" then
	(		
		sceneXmlNode = docEle.ChildNodes.itemOf[0]
		iFrameRate = ( sceneXmlNode.attributes.getNamedItem "framerate" ).value
		tSceneInterval = ( sceneXmlNode.attributes.getNamedItem "animationrange" ).value
		
		try
		(
			framerate = (iFrameRate as number)
			animationrange = (execute tSceneInterval)
		)
		catch
		(
			print (getCurrentException())
		)
		
		
		
	)
)

