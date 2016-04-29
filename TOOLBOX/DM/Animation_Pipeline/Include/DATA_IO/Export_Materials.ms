
Function ExportObjectMaterials objectList filename= 
(
	materials = materialLibrary()
	
	for o in objectList do
	(
		if isKindOf o GeometryClass then
		(
			if o.material != undefined then
			(
				appendIfUnique materials o.material
			)
		)
	)
	
	saveTempMaterialLibrary  materials filename	
)