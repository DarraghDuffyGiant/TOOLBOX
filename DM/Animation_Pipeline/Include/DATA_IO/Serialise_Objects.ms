
function serialiseObjects objList filename = 
(	
	/*
		Export object properties as an XML file
	*/
	dotNet.loadAssembly "system.xml"
	xmlDoc=dotNetObject "system.xml.xmlDocument"
	root=xmlDoc.createElement "Root"
	
	xmlDoc.appendChild root


	--Names for elements can't include anything but alpha characters.
	for obj in objList do
	(
			
			newElement=xmlDoc.createElement "node"
		
			/*Store Object Attributes*/
			newElement.setAttribute "name" obj.name
			newElement.setAttribute "renderable" (obj.renderable as string)
			newElement.setAttribute "castShadows" (obj.castShadows as string)
			newElement.setAttribute "receiveshadows" (obj.receiveshadows as string)
			newElement.setAttribute "ApplyAtmospherics" (obj.ApplyAtmospherics as string)
			newElement.setAttribute "inheritVisibility" (obj.inheritVisibility as string)
			newElement.setAttribute "renderOccluded" (obj.renderOccluded as string)
			newElement.setAttribute "primaryVisibility" (obj.primaryVisibility as string)
			newElement.setAttribute "secondaryVisibility" (obj.secondaryVisibility as string)		
			newElement.setAttribute "gbufferchannel" (obj.gbufferchannel as string)
		
			if(obj.modifiers[#Turbosmooth] != undefined) then
			(
				ts = obj.modifiers[#Turbosmooth]
				tsIterations = ts.iterations

				if(ts.renderIterations > tsIterations) then 
				(
					tsIterations = ts.renderIterations
				)
				newElement.setAttribute "turbosmooth" (tsIterations as string)
			)
			else
			(
				newElement.setAttribute "turbosmooth" ("0")
			)
			
			/*Store the name of the material that was applied to the object
			*/
			matName = "undefined"
			if(obj.material != undefined) then
			(
				matName = obj.material.name 
			)
			
			newElement.setAttribute "material" matName
			
			root.appendChild newElement
		
				
	)


	xmlDoc.save (filename)
)
