
function serialiseRenderElements filename = 
(
	/*Load DotNet assemblys for XML handling*/
	dotNet.loadAssembly "system.xml"

	xmlDoc=dotNetObject "system.xml.xmlDocument"
	root=xmlDoc.createElement "Root"
	xmlDoc.appendChild root
	
	/*Get the current render element manager*/
	mgr = maxOps.GetCurRenderElementMgr()	
	elementCount = mgr.NumRenderElements()
	
	if(elementCount == 0) then
	(
		return 0
	)
	
	for i= 0 to (elementCount-1) do
	(
		
		element = mgr.GetRenderElement i		
		
		if(element != undefined) then
		(
			newXMLElement=xmlDoc.createElement "RenderElement"
			root.appendChild newXMLElement
			
			newXMLElement.setAttribute "name" (getProperty element #elementName)
			newXMLElement.setAttribute "class" ((classOf element) as string )
			propNames = getPropNames element
			
			for prop in propNames do
			(
				if(prop == #bitmap) then
				(
					continue
				)
				
				--get the name and class of the property
				propValue = getProperty element prop
				propClass = ( (classof propValue) as string )			

				--certain classes need to be pre processed 
				case propClass of
				(
					"ArrayParameter":--if the property is of class ArrayParameter then reformat it so its easier to parse later
					(
						if(propValue.count >0) then
						(
							newPropValue =""
						
							for obj in propValue do
							(
								if(obj !=undefined) then 
								(
									newPropValue += (obj.name +",")
								)
							)
							try
							(
							newPropValue[newPropValue.count] = ""
							)
							catch()
							--newPropValue+=")"
							propValue = newPropValue
						)
					)
					"Bitmaptexture" :--save the filename of the bitmap for later reconstruction
					(
						propValue = propValue.filename
					)
				)
				
				
				newXMLProp = xmlDoc.createElement  "Property"
				newXMLProp.setAttribute "name" (prop as string)
				newXMLProp.setAttribute "class" propClass
				newXMLProp.setAttribute "value" (propValue as string)
				newXMLElement.appendChild newXMLProp				
				
			)
				

		)
	)
	--Save the xmlDoc object to a file. 
	xmlDoc.save (filename)
	--Open the file in Max to see the result. 
)
--serialiseRenderElements @"V:\BBC\GO JETTERS\PRODUCTION\ASSETS\ASSET_DATA\JETPAD_RAINBOW_DOOR\bla.xml"