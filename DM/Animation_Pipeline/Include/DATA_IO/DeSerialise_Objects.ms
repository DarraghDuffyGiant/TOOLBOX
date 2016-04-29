function deSerialiseObjects filename doBasic doMats matFile doLoose:true= 
(
	if not(doesFileExist filename) then
	(
		return 0
	)
	matfile = loadTempMaterialLibrary matFile
	include "$userscripts\\Animation_Pipeline\\Include\\CommonFunctions.ms"
	
	--Load the xml assembly
	dotNet.loadAssembly "system.xml"
	--Create an xml document object.
	xmlDoc=dotNetObject "system.xml.xmlDocument"
	
	xmlDoc.load filename
	
	docEle=xmlDoc.documentElement
	
	
	--create an array of turbosmooth modifiers indexed by their Render Itterations
	--this makes it really easy to keep TS mods with the same itteration number instanced
	aTsMods = #()
	
	iMaxTsLevel = 4
	for i=1 to iMaxTsLevel do
	(
		append aTsMods (turbosmooth useRenderIterations:true renderIterations:i iterations:0)
	)
	
	
	
	
	if docEle!=undefined and docEle.name=="Root" then
	(		
		
		for i = 0 to docEle.ChildNodes.count-1 do
		(
			xmlNode = docEle.ChildNodes.itemOf[i]
			objectName = ( xmlNode.attributes.getNamedItem "name" ).value
			
			objs = #()
			
			if(doLoose) then
			(
				objs = collectNamedDuplicates objectName
			)
			else
			(
				obj = (getNodebyName objectName)
				
				if(obj !=undefined) then
				(
					objs = #(obj)
				)
				
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
						--assign a pre instanced ts mod to the object, the aMin caps the ts iteration to the pre defined max value
						--avoiding out of range errors and also reducing the chance of stupidly high itteration values being used by accident.
						
						addModifier obj aTsMods[aMin #(tsValue,iMaxTsLevel)]
					)
				)
				
				
				if(doMats) then
				(
					matName = (( xmlNode.attributes.getNamedItem "material" ).value)
					
					
					for mat in matFile do
					(
						if mat.name == matName then
						(
							--format "applying: % to: %\n" mat.name obj.name
							obj.material = mat
						)
					)
					
					
				)				
				
			)
			
		)
		
	)
)

