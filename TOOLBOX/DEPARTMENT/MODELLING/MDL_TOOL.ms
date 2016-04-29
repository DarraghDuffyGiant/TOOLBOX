FileIn "C:\\SVN\\GOJETTERS\\TOOLBOX\\GENERAL_TOOLS.ms"

mainDialog = newRolloutFloater "MODEL CHECKIN" 500 500
 
rollout MDLCheckRollout "1. Shot details:"
(
	label MDL_INC_NAMES_LBL "Incorrect naming in the following:" offset:[-150, 0]
	ListBox MDL_NAME_LAYERS_DDL "Layers:" items:#() offset:[0, 0] width:100
	ListBox MDL_NAME_MSH_DDL "Mesh:" items:#() offset:[150, -160] width:100
	ListBox MDL_MAME_MTL_DDL "Material:" items:#() offset:[300, -155] width:100
	label MDL_DUP_NAMES_LBL "Duplicate naming in the following:" offset:[-150, 0]
	ListBox MDL_DUPE_LAYERS_DDL "Layers:" items:#() offset:[0, 0] width:100
	ListBox MDL_DUPE_MSH_DDL "Mesh:" items:#() offset:[150, -155]  width:100
	button MDL_CHECK_BTN "Check MDL for CHECKIN"  offset:[0, 0]

	on MDL_CHECK_BTN pressed do 
	(

		MDL_DUPE_MSH_DDL.items = duplicateFind ()
	)

	on MDL_DUPE_MSH_DDL selected val do 
	(

		clearSelection()
		OBJ = getNodeByName MDL_DUPE_MSH_DDL.items[val]
		select OBJ

	)
)

addrollout MDLCheckRollout mainDialog



