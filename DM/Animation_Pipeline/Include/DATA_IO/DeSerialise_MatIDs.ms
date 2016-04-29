
function deSerialiseMatIDs filename = 
(
	
/*
<DOC> Go through an objects modifiers and find the index of the last worldspace / smooth modifier
Arguments:
	<node> nNode:		the object to check
Return:
	<number>		the index of the last WSM / Smooth modifier.
*/

	function GetModifierIndexBeforeWSM_SMOOTH nNode = 
	(
		iIndex = 1
		
		if(nNode != undefined) then
		(
			if(validModifier nNode Edit_Poly) then
			(
				aSmoothModifierClasses  =#(Turbosmooth,MeshSmooth,Subdivide,Tessellate,OpenSubdiv)
				aModifiers  =nNode.modifiers
				iCount = aModifiers.count
				
				
				for i = 1 to iCount do
				(
					cModSuperClass = superclassof aModifiers[i]
					cModClass = classof aModifiers[i]
					
					if(cModSuperClass == SpacewarpModifier) then
					(
						if(i > iIndex) then
						(
							iIndex = i
						)
					)
					
					for cClass in aSmoothModifierClasses do
					(
						if (cModClass == cClass) then
						(
							if(i > iIndex) then
							(
								iIndex = i
							)
						)
					)
					
				)			
			)	
		)
		return iIndex
	)
	

	if not(doesFileExist filename) then
	(
		return 0 
	)
	--Load the xml assembly
	dotNet.loadAssembly "system.xml"
	--Create an xml document object.
	xmlDoc=dotNetObject "system.xml.xmlDocument"
	
	xmlDoc.load filename
	
	docEle=xmlDoc.documentElement
	with redraw off
	(
		with undo off
		(
			if docEle!=undefined and docEle.name=="Root" then
			(		
				for i = 0 to docEle.ChildNodes.count-1 do
				(
					xmlNode = docEle.ChildNodes.itemOf[i]
					
					--get the name of the node to target then select that node
					nodeName = ( (xmlNode.attributes.getNamedItem "Name").value )			
					--nNode = execute nodeName
					nNode = getNodeByName nodeName
					print nodeName
					print nNode
					
					if(nNode !=undefined) then
					(
						select nNode
						format "Node:%\n" nNode.name
						--Create an edit_poly modifier as a container for the imported Mat IDs
						epoly = edit_poly()
						epoly.name = "Material IDs"
						
						iIndex = GetModifierIndexBeforeWSM_SMOOTH nNode
						
						addModifier nNode ePoly before:iIndex				
						format "Modifiers:%\n" nNode.modifiers
						
						modPanel.setCurrentObject ePoly
						
						subObjectLevel = 4
						
						--Itterate through the stored matIDs and apply them
						for j = 0 to (xmlNode.ChildNodes.count-1) do
						(
							epoly.setSelection #Face #{}
							xmlMatID = xmlNode.ChildNodes.itemOf[j]
							matID  = ( (xmlMatID.attributes.getNamedItem "ID").value ) as integer
							facelist = #()
							
							faceList = (xmlMatID.attributes.getNamedItem "FaceList").value 			
							facelist = filterString facelist "#,()"
							
						
							
							--for some reason converting the array to a bitarry doesnt work for me :(
							for f in faceList do
							(
								f = f as integer
								if( f != undefined) then
								(
									epoly.Select #Face #{f}
								)
							)		
							
							-- now apply the matID
							epoly.SetOperation #SetMaterial							
							epoly.materialIDToSet = (matID-1)	--MatIDs are zero based when you set them.. but not when you get them :S
							epoly.Commit()				
						)
						
						subObjectLevel = 0
					)
				)
				
			)
		)
	)
)


--deSerialiseMatIDs @"V:\BBC\GO JETTERS\PRODUCTION\ASSETS\ASSET_DATA\GOGRAB_MESH\GOGRAB_MESH_MatIDs.xml"

