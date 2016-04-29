
for i = 1 to 10 do
(
	MergeMAXFile "C:\\Users\\Giant_17\\Desktop\\JUNK\\EVERYJETTER_FEMALE_EJF4_PRX.max" #select #mergeDups #useSceneMtlDups quiet:true
)


EJ_NAME = undefined
EJ_TYPE = undefined
EJ_SCALE = undefined
EJ_FILENAME = maxFileName
EJ_FILENAMEPARTS = filterString EJ_FILENAME "_"

for i in EJ_FILENAMEPARTS do
(
	if matchPattern i pattern:"EJ*" then
	(
		EJ_NAME = i
		EJ_TYPE = i[3]
	)
)

if EJ_TYPE == "M" then
(
	EJ_SCALE = .100
)
else if EJ_TYPE == "F" then
(
	EJ_SCALE = .920
)
else if EJ_TYPE == "C" then
(
	EJ_SCALE = .640
)


proxy_MSH = "C:\\SVN\\GOJETTERS\\CHARS\\EVERYJETTER\\EVERYJETTER_PROXY\\EVERYJETTER_PROXY.max"
MergeMAXFile proxy_MSH #select #mergeDups #useSceneMtlDups quiet:true

for i in selection do
(
	s = i.name
	newS = replace s 1 3 EJ_NAME
	i.name = newS
)

clearSelection()

----------------------------------------

layerGEO = (layerManager.getLayerFromName ("EJM_MALE_PRXY"))
layerGEONAME = layerGEO.name 
layerGEONEWNAME = replace layerGEONAME 1 3 EJ_NAME
layerGEO.setname layerGEONEWNAME

MAIN_LOC_PXY = getnodebyname (EJ_NAME+"_MAIN_LOC_PXY")
MAIN_LOC_PXY.scale.x = EJ_SCALE
MAIN_LOC_PXY.scale.y = EJ_SCALE
MAIN_LOC_PXY.scale.z = EJ_SCALE

----------------------------------------
face_MSH =  getnodebyname (EJ_NAME + "_C_Male_Face_MSH")
rig_MSH =  getnodebyname (EJ_NAME + "_C_Male_MainRig_MSH")
main_MSH =  getnodebyname (EJ_NAME + "_C_Male_Main_MSH")
skinProxy_MSH = getnodebyname (EJ_NAME + "_proxy")	

--face_MSH.ishidden = true
rig_MSH.ishidden = true
main_MSH.ishidden = true
----------------------------------------



meshArray = #(face_MSH, rig_MSH,main_MSH,skinProxy_MSH)
select meshArray

for obj in selection do
(
	if validModifier obj Skin do
	(
		for m = 1 to obj.modifiers.count do
		(
			if classof obj.modifiers[m] == skin then
			(
				obj.modifiers[#Skin].enabled = false
			)
		)
	)
)

for obj in selection do
(
	if validModifier obj skin_wrap do
	(
		for m = 1 to obj.modifiers.count do
		(
			if classof obj.modifiers[m] == skin_wrap then
			(
				obj.modifiers[#skin_wrap].enabled = false
			)
		)
	)
)

for obj in selection do
(
	if validModifier obj skin_MORPH do
	(
		for m = 1 to obj.modifiers.count do
		(
			if classof obj.modifiers[m] == skin_MORPH then
			(
				obj.modifiers[#skin_morph].enabled = false
			)
		)
	)
)

for obj in selection do
(
	if validModifier obj MORPHer do
	(
		for m = 1 to obj.modifiers.count do
		(
			if classof obj.modifiers[m] == MORPHer then
			(
				obj.modifiers[#morpher].enabled = false
			)
		)
	)
)



clearSelection()

----------------------------------------
/*
face_MSH =  getnodebyname (EJM_NAME + "_C_Male_Face_MSH")
rig_MSH =  getnodebyname (EJM_NAME + "_C_Male_MainRig_MSH")
main_MSH =  getnodebyname (EJM_NAME + "_C_Male_Main_MSH")
skinProxy_MSH = getnodebyname (EJM_NAME + "_proxy")	
	
delete face_MSH 
delete rig_MSH 
delete main_MSH
delete skinProxy_MSH
*/
----------------------------------------

EJ_RIG = # ((EJ_NAME+"_L_Toes_SKNRIG"), (EJ_NAME+"_L_TwistLeg04_SKNRIG"), (EJ_NAME+"_L_TwistLeg01_SKNRIG"),\
	(EJ_NAME+"_R_Toes_SKNRIG"), (EJ_NAME+"_R_TwistLeg04_SKNRIG"), (EJ_NAME+"_R_TwistLeg01_SKNRIG"),\
	(EJ_NAME+"_Spine01_SKNRIG"), (EJ_NAME+"_Spine03_SKNRIG"), (EJ_NAME+"_Head01_SKNRIG"),\
	(EJ_NAME+"_L_Twist01_SKNRIG"), (EJ_NAME+"_L_Twist04_SKNRIG"), (EJ_NAME+"_L_Hand_SKNRIG"),\
	(EJ_NAME+"_R_Twist01_SKNRIG"), (EJ_NAME+"_R_Twist04_SKNRIG"), (EJ_NAME+"_R_Hand_SKNRIG"),\
	(EJ_NAME+"_L_thumb_02_SKNRIG"), (EJ_NAME+"_L_Index_02_SKNRIG"), (EJ_NAME+"_L_Maj_02_SKNRIG"), (EJ_NAME+"_L_Anul_02_SKNRIG"),\
	(EJ_NAME+"_R_thumb_02_SKNRIG"), (EJ_NAME+"_R_Index_02_SKNRIG"), (EJ_NAME+"_R_Maj_02_SKNRIG"), (EJ_NAME+"_R_Anul_02_SKNRIG"))

EJ_MSH = #(EJ_NAME+"_FOOT_LEFT_PXY", EJ_NAME+"_LOWERLEG_LEFT_PXY", EJ_NAME+"_UPPERLEG_LEFT_PXY",\
	EJ_NAME+"_FOOT_RIGHT_PXY", EJ_NAME+"_LOWERLEG_RIGHT_PXY", EJ_NAME+"_UPPERLEG_RIGHT_PXY",\
	EJ_NAME+"_LOWERBODY_PXY", EJ_NAME+"_UPPERBODY_PXY", EJ_NAME+"_HEAD_PXY",\
	EJ_NAME+"_UPPERARM_LEFT_PXY", EJ_NAME+"_FOREARM_LEFT_PXY", EJ_NAME+"_HAND_LEFT_PXY",\
	EJ_NAME+"_UPPERARM_RIGHT_PXY", EJ_NAME+"_FOREARM_RIGHT_PXY", EJ_NAME+"_HAND_RIGHT_PXY",\
	EJ_NAME+"_THUMB_LEFT_PXY", EJ_NAME+"_FINGER_1_LEFT_PXY", EJ_NAME+"_FINGER_2_LEFT_PXY", EJ_NAME+"_FINGER_3_LEFT_PXY",\
	EJ_NAME+"_THUMB_RIGHT_PXY", EJ_NAME+"_FINGER_1_RIGHT_PXY", EJ_NAME+"_FINGER_2_RIGHT_PXY", EJ_NAME+"_FINGER_3_RIGHT_PXY")

for i = 1 to EJ_MSH.count do
(
	obj =  getnodebyname EJ_MSH[i]
	rig = getnodebyname EJ_RIG[i]
	obj.parent = rig
)


headMSH = getnodebyname (EJ_NAME+"_HEAD_PXY")	
jawMRP =  headMSH.modifiers[#Morpher][1]
eMRP =  headMSH.modifiers[#Morpher][2]
oMRP =  headMSH.modifiers[#Morpher][3]
fvMRP =  headMSH.modifiers[#Morpher][4]
lSadMRP =  headMSH.modifiers[#Morpher][5]
rSadMRP =  headMSH.modifiers[#Morpher][6]
lSmileMRP =  headMSH.modifiers[#Morpher][7]
rSmileMRP =  headMSH.modifiers[#Morpher][8]

	
jawCTRL = getnodebyname (EJM_NAME+"_Ctrl_JAW")
eCTRL = getnodebyname (EJM_NAME+"_Ctrl_E")
oCTRL = getnodebyname (EJM_NAME+"_Ctrl_O")
fvCTRL = getnodebyname (EJM_NAME+"_Ctrl_FV")
lSmileCTRL = getnodebyname (EJM_NAME+"_Ctrl_Smile_L")
rSmileCTRL = getnodebyname (EJM_NAME+"_Ctrl_Smile_R")
lSadCTRL = getnodebyname (EJM_NAME+"_Ctrl_Smile_L")
rSadCTRL = getnodebyname (EJM_NAME+"_Ctrl_Smile_R")

	

paramWire.connect jawCTRL.pos.controller.Z_Position.controller[#Limited_Controller__Bezier_Float] jawMRP "-Limited_Controller__Bezier_Float*10"
paramWire.connect eCTRL.pos.controller.X_Position.controller[#Limited_Controller__Bezier_Float] eMRP "Limited_Controller__Bezier_Float*10"
paramWire.connect oCTRL.pos.controller.X_Position.controller[#Limited_Controller__Bezier_Float] oMRP "Limited_Controller__Bezier_Float*10"
paramWire.connect fvCTRL.pos.controller.X_Position.controller[#Limited_Controller__Bezier_Float] fvMRP "Limited_Controller__Bezier_Float*10"

paramWire.connect lSmileCTRL.pos.controller[#Z_Position] lSmileMRP  "Z_Position*2"
paramWire.connect lSadCTRL.pos.controller[#Z_Position] lSadMRP "-Z_Position*2"
paramWire.connect rSmileCTRL.pos.controller[#Z_Position] rSmileMRP  "Z_Position*2"
paramWire.connect rSadCTRL.pos.controller[#Z_Position] rSadMRP "-Z_Position*2"

