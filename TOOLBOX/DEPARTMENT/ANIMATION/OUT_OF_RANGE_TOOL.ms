(

	if SetType_R != undefined do (destroydialog SetType_R)
	
	Fn settype_fn =
	(
		if selection.count > 0 then
		(
			if SetType_R.pos_ck.checked == true do
			(
				for x in selection do (setbeforeORT x.position.controller (execute (SetType_R.settypeIN_ddl.selected)))
				for x in selection do (setafterORT x.position.controller (execute (SetType_R.settypeOUT_ddl.selected)))
			)
			
			if SetType_R.rot_ck.checked == true do
			(
				for x in selection do (setbeforeORT x.rotation.controller (execute (SetType_R.settypeIN_ddl.selected)))
				for x in selection do (setafterORT x.rotation.controller (execute (SetType_R.settypeOUT_ddl.selected)))
			)
	
			if SetType_R.scl_ck.checked == true do
			(
				for x in selection do (setbeforeORT x.scale.controller (execute (SetType_R.settypeIN_ddl.selected)))
				for x in selection do (setafterORT x.scale.controller (execute (SetType_R.settypeOUT_ddl.selected)))
			)
		)
		else
		(
			messagebox "Select objects to be affected" title:"Error"
		)
	)
	rollout SetType_R "Set out of range type"
	(
		checkbox pos_ck ":Pos" across:3 checked:true
		checkbox Rot_ck ":Rot" checked:true
		checkbox Scl_ck ":Scl" checked:true
		dropdownlist settypeIN_ddl "Set Type In:" items:#("#Constant", "#Cycle", "#Loop", "#PingPong", "#Linear", "#ReletiveRepeat")
		dropdownlist settypeOUT_ddl "Set Type Out:" items:#("#Constant", "#Cycle", "#Loop", "#PingPong", "#Linear", "#ReletiveRepeat")
		button settypes_bt "Set Types"
		
		on setTypes_bt pressed do
		(
			settype_fn()
		)
		
	)
		createdialog SetType_R 150 150
)