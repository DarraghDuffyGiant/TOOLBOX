function SerialiseMatIDs objList filename = 
(
	/*
	*Load Nessisary Assemblys
	*/
	dotNet.loadAssembly "system.xml"
	
	fn getMatIDInfo obj = 
	/*Extract a list of used Material IDs and a list containing nested lists of matID's indexed by matID	
	*/
	(
		usedIDs = #()
		idFaces = #()
		
		epoly = edit_poly()
		if(validModifier obj edit_poly) then
		(
			addModifier obj epoly
			numFaces = polyop.getNumFaces obj
			
			for i = 1 to numFaces do
			(
				
				id = polyop.getFaceMatID obj i
				appendIfUnique usedIDs id
				
				--Store faces in sub array of idFaces indexed by their Mat ID
				if(idFaces[id] == undefined) then
				(
					idFaces[id] = #(i) -- if the sub array doesnt exist then add it
				)
				else --if the sub array exists then append face i  to it.
				(
					append idFaces[id] i 
				)
			)
			
		)
		
		deleteModifier obj epoly	
		
		return #(usedIDs,idFaces)
	)

	
	-- Start a new XML document and create its root node
	xmlDoc=dotNetObject "system.xml.xmlDocument"
	xmlRoot=xmlDoc.createElement "Root"
	xmlDoc.appendChild xmlRoot
	
	for obj in objList do
	(	
		if not(ValidModifier obj edit_poly) then
		(
			continue
		)
		
		xmlNode = xmlDoc.createElement "Node"				
		xmlRoot.appendChild xmlNode
		
		xmlNode.setAttribute "Name" obj.name
		
		matIDInfo = ( getMatIDInfo obj )		
		usedIDs = matIDInfo[1]
		idFaces = matIDInfo[2]	
		
			
		
		for id in usedIDs do
		(
			xmlMatID = xmlDoc.createElement "MatID"
			xmlNode.appendChild xmlMatID			
				
			idList = idFaces[id]
			
			faceList = stringStream ""
			format "#(" to:faceList
			
			for idx = 1 to idList.count do
			(
				if(idx < idList.count) then
				(
					format "%," idList[idx] to:faceList
				)
				else
				(
					format "%)" idList[idx] to:faceList
				)
			)
			
			xmlMatID.setAttribute "ID" (id as string)
			xmlMatID.setAttribute "FaceList" faceList
			free faceList
			
			
		)--end id in usedIDs
		
	) --end obj in objList
	
	--Save the xmlDoc object to a file. 
	xmlDoc.save (filename)
	
)

/*
filename = ((getDir #userscripts)+"\\MatIDs.xml")
SerialiseMatIDs selection filename
edit (filename)
*/


