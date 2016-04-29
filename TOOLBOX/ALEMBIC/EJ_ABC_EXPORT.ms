/*
[RETRIEVE_INFO]
	-FILE_LOC
	-EJ_NAME
	-EJ_ANIM
[EXPORT_ALEMBIC]
[CREATE_NODES_FOR_PFLOW]
[FILE CLEANUP]
	-LAYERS
	-FROZEN GEO
*/
FileIn "C:\\SVN\\GOJETTERS\\TOOLBOX\\GOJETTERS_INIT.ms"
FileIn "C:\\SVN\\GOJETTERS\\TOOLBOX\\ALEMBIC\\ALEMBIC_EXPORT.ms"

mainDialog = newRolloutFloater "EJ ALEMBIC EXPORT" 500 600

EJ_TYPES = #("MALE","FEMALE", "CHILD")
ANIM_TYPES = #("IDLE","CHEER", "WALK", "RUN")
ANIM_VAR = #(#("NEUTRAL","SCARED"),#("NEUTRAL", "EXTREME"),#("NEUTRAL"),#("NEUTRAL"))
EJ_NO = #(#("EJM1","EJM2"),#("EJF1","EJF2"),#("EJC1","EJC2"))

rollout EJAlembicExpRollout "EXPORT"
(
	local EJ_TYPES_VAL = 1
	local ANIM_TYPES_VAL = 1
	local ANIM_VAR_VAL = 1	

	edittext EJ_NAME "EJ NAME: " pos:[20, 20] fieldWidth:150 text:"EJ_MAIN"
	button EJ_EXP_GETNAME_BTN "GET NAME"  offset:[20, -25]
	ListBox EJ_TYPE "EJ type" items:EJ_TYPES pos:[10, 50] width:100 height:10
	ListBox EJ_ANM_TYPE "Animation Type" items:ANIM_TYPES offset:[150, -155] width:100 height:10
	ListBox EJ_ANM_VAR "Variant" items:ANIM_VAR[ANIM_TYPES_VAL] offset:[300, -155]  width:100 height:10
	button EJ_EXP_BTN "EXPORT"  pos:[250, 250]

	on EJ_TYPE selected val do 
	(
		EJ_TYPES_VAL = val
	)

	on EJ_ANM_TYPE selected val do 
	(
		ANIM_TYPES_VAL = val
		if ANIM_TYPES[val] != undefined then 
		(
			EJ_ANM_VAR.items = ANIM_VAR[ANIM_TYPES_VAL]
		)
		else 
		(
			ANIM_VAR.items = #(1)
		)
	)

	on EJ_ANM_VAR selected val do 
	(
		ANIM_VAR_VAL = val
	)


	on EJ_EXP_BTN pressed do
	(

		local EJ_TYPE_DIR = "EVERYJETTER_" + EJ_TYPES[EJ_TYPES_VAL]
		local EJ_ANIM_DIR = "EVERYJETTER_" + EJ_TYPES[EJ_TYPES_VAL] +"_"+ ANIM_TYPES[ANIM_TYPES_VAL]
		local EJ_VAR_DIR = 	"EVERYJETTER_" + EJ_TYPES[EJ_TYPES_VAL] +"_"+  ANIM_TYPES[ANIM_TYPES_VAL] +"_"+  ANIM_VAR[ANIM_TYPES_VAL][ANIM_VAR_VAL]


		EJ_PATH =  (ASSETS_ROOT_DIR +"CHARS\\EVERYJETTER\\EVERYJETTER_ALEMBIC" + "\\" + EJ_TYPE_DIR + "\\" + EJ_ANIM_DIR + "\\" + EJ_VAR_DIR)

		if EJ_TYPES[EJ_TYPES_VAL] == "MALE" then
		(
			if EJ_NAME.text == "EJ_MAIN" then
			(
				exportLayerNodes EJ_PATH EJ_VAR_DIR
			)
			else
			(
				print EJ_NAME.text
				--exportLayerNodes EJ_PATH 		
			)

		)

		else if EJ_TYPES[EJ_TYPES_VAL] == "FEMALE" then
		(

		)
		else if EJ_TYPES[EJ_TYPES_VAL] == "CHILD" then
		(

		)
	)

	on EJ_EXP_GETNAME_BTN pressed do
	(
		print fileName 
	)
)

rollout EJAlembicImpRollout "IMPORT"
(
	local EJ_TYPES_VAL = 1
	local ANIM_TYPES_VAL = 1
	local ANIM_VAR_VAL = 1	

	--edittext EJ_NAME "EJ NAME: " pos:[20, 20] fieldWidth:150 text:"EJ_MAIN"
	ListBox EJ_IMP_TYPE "EJ type" items:EJ_TYPES pos:[10, 50] width:100 height:10
	ListBox EJ_IMP_NO "EJ Code" items:EJ_NO[1] offset:[120, -155] width:100 height:10
	ListBox EJ_ANM_VAR "Variant" items:ANIM_VAR[ANIM_TYPES_VAL] offset:[240, -155]  width:100 height:10
	button EJ_IMP_BTN "IMPORT"  pos:[250, 250]

	on EJ_TYPE selected val do 
	(
		EJ_TYPES_VAL = val
	)

	on EJ_ANM_TYPE selected val do 
	(
		/*
		ANIM_TYPES_VAL = val
		if ANIM_TYPES[val] != undefined then 
		(
			EJ_ANM_VAR.items = ANIM_VAR[ANIM_TYPES_VAL]
		)
		else 
		(
			ANIM_VAR.items = #(1)
		)
		*/
	)

	on EJ_ANM_VAR selected val do 
	(
		--ANIM_VAR_VAL = val
	)

	on EJ_EXP_BTN pressed do
	(

	)
)

addrollout EJAlembicExpRollout mainDialog
addrollout EJAlembicImpRollout mainDialog


