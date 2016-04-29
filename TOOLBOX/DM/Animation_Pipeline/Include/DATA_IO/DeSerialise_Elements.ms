
function deSerialiseRenderElements filename doLooseNaming:false= 
(
	--clearListener()
		
	include "$userscripts\\Animation_Pipeline\\Include\\CommonFunctions.ms"
	
	fileExists = (doesFileExist filename)
	
	if not(fileExists) then
	(
		message = "deSerialiseRenderElements:\nFile does not exist:" + filename
		assert fileExists message:message
		return 0
	)
		

	/*Check if an element exists with this name
	*/


/**
 * @param  {[String]}
 * @return {[RenderElement]}
 */
	function getElementByName elementName = 
	(
		elementName = trimRight(trimleft( toLower elementName )) --Enforce lowecase when doing string checks
		
		mgr = maxOps.GetCurRenderElementMgr()
		elementCount =  mgr.NumRenderElements()	
		
		for i = 0  to (elementCount-1) do
		(
			element = ( mgr.GetRenderElement i )					

			currentElementName =  trimRight(trimleft(toLower(getProperty element #elementName)))
			
		 --format "checking:% against:%\n" currentElementName elementName
			
			if (elementName == currentElementName) then
			(
				--format "found\n"
				return element
			)
		)
		
		return undefined	
	)
	
	function addElement elementClass = 
	(
		mgr = maxOps.GetCurRenderElementMgr()		
		mgr.AddRenderElement ( elementClass() )
		elementCount = mgr.NumRenderElements()
		element = ( mgr.GetRenderElement (elementCount-1) )
	)
	
	wasOpen = renderSceneDialog.isOpen()
	
	if(wasOpen) then
	(
		renderSceneDialog.Close()
	)
	
	--Load the xml assembly
	dotNet.loadAssembly "system.xml"
	--Create an xml document object.
	xmlDoc=dotNetObject "system.xml.xmlDocument"
	
	xmlDoc.load filename
	
	docEle=xmlDoc.documentElement
	
	--compatible classes of value that can be transfered by this script
	compatibleTypes = #(integer,string,booleanClass,arrayParameter,bitmapTexture)
	
	if docEle!=undefined and docEle.name=="Root" then
	(		
		for i = 0 to docEle.ChildNodes.count-1 do
		(
			elementXML = docEle.ChildNodes.itemOf[i]
			
			elementName = (elementXML.attributes.getNamedItem "name").value
			elementClass = (elementXML.attributes.getNamedItem "class").value			
			
			element = ( getElementByName elementName )
			
			format "Name:%\n" elementName
			
			bUseNewElement = false
			
			--if the element does not exist already create a new element else use the old one and append to it.
			if(element == undefined) then
			(
				--format "element name:% is undefined, creating a new one\n" elementName
				bUseNewElement= true
				-- add the element to the element manager
				element = addElement(execute elementClass)
			)
			
			--Deserialise the elements properties
			if( element != undefined) then
			(		
				for j=0 to elementXML.ChildNodes.count-1 do
				(
					propertyXML = elementXML.ChildNodes.itemOf[j]
					
					--Extract the property attributes
					propName = (propertyXML.attributes.getNamedItem "name").value
					propClass = execute( (propertyXML.attributes.getNamedItem "class").value ) --execute gives us the class object rather than a string
					propValue = (propertyXML.attributes.getNamedItem "value").value
					--print propClass
					--there is no point in setting undefined values
					if(propClass != undefinedClass) then
					(			
						--Check if this attribute is of a class we can use
						if( (findItem compatibleTypes propClass) != 0) then
						(							
							case propClass of
							(
								ArrayParameter:
								(								
									nameList = filterString propValue ","									

									
									if(doLooseNaming) then 
									(
										expandedNameList = collectNamedDuplicates nameList
									)
									else
									(									
										expandedNameList = for sName in nameList collect (getNodeByName sName)									
									)
									
									-- if this is an existing element then join new node list with the old one
									if(not bUseNewElement) then
									(
										--format "Incoming Name List:%\n" expandedNameList
										aExistingMembers = #()			
										aExistingMembers = getProperty element propName
										
										for nNode in aExistingMembers do
										(
											appendIfUnique expandedNameList nNode
										)
										
										--format "Expanded Node List:%\n" expandedNameList
									)
									
									setProperty element propName  expandedNameList
									
								)
								BitmapTexture:
								(
									bm =bitmapTexture()
									bm.filename = propValue									
									setProperty element propName bm 
								)
								default:
								(
									try
									(
										propValue = propValue as propClass
										setProperty element propName propValue
									)
									catch()
								)
								
							)
							
						)
					)
					
				)
			)
			else
			(
				
			)
			
			
			
		)
	)
	if(WasOpen) then
	(
		RenderSceneDialog.Open()
	)
)

--deSerialiseRenderElements @"V:\BBC\GO JETTERS\PRODUCTION\ASSETS\ASSET_DATA\XULI_MESH_HIDDEN\XULI_MESH_HIDDEN_RenderElements.xml"