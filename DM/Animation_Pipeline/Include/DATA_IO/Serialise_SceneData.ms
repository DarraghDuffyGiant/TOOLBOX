
function Serialise_SceneData filename = 
(
	dotNet.loadAssembly "system.xml"
	xmlDoc=dotNetObject "system.xml.xmlDocument"
	root=xmlDoc.createElement "Root"
	
	xmlDoc.appendChild root
	
	sceneElement=xmlDoc.createElement "Scene"
	sceneElement.setAttribute "framerate" ( framerate as string )
	sceneElement.setAttribute "animationrange" ( animationrange as string )
	
	
	root.appendChild sceneElement
	xmlDoc.save (filename)
	edit filename
)

--Serialise_SceneData ((getDir #userscripts)+"\\sceneData.xml")