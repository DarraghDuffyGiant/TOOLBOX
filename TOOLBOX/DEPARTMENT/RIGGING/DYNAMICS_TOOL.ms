-- author: Darragh Duffy 
-- email: darraghduffy86@gmail.com
-- web: www.darraghduffy.com
-- Date: April 2012

--ReadMe: This tool has been tried and tested in 3D Studio Max 2011/2012. It has not been tested on previous versions, but it should work


rollout UI "Dynamics"
(	
	
	edittext Char_txt "CharName:" fieldWidth:200 labelOnTop:true text: "Char"
	edittext Side_txt "CharPos(e.g Left/Right/Middle):" fieldWidth:200 labelOnTop:true text: "Side"
	spinner Bone_txt "BoneCount:" fieldWidth:30 labelOnTop:true type:#integer range:[1,10,6] offset:[-125,10]
	button Imp_DynBld "Create Dynamics Build" offset:[60,-25]

	
	button rigIt_but "Rig Dyn!"
	
	--parent array function 
	fn parentArray objArray =
		for i =1 to objArray.count do
		(
			if objArray[i +1] != undefined then
			(		
				objArray[i +1].parent = objArray[i]
			)
		)
		
	--zero_out function
	fn zero_out obj tcb:false=
		(
		if classof obj == array then 
			(
			for i = 1 to obj.count do
				(
				if classof obj[i] == array then zero_out obj[i]
				else 
					(
						hlpr = Point pos:[0,0,0] isSelected:on centermarker:off axistripod:off cross:off Box:off constantscreensize:off drawontop:off size:1 
						if tcb == true then hlpr.rotation.controller = tcb_rotation()
						temp = obj[i].parent
						hlpr.transform = obj[i].transform
						hlpr.name = (obj[i].name+"_zero")
						obj[i].parent = hlpr
						hlpr.parent = temp
					)--end else
				)--end for i
			)--end if classof
		else
			(
				hlpr = Point pos:[0,0,0] isSelected:on centermarker:off axistripod:off cross:off Box:off constantscreensize:off drawontop:off size:1;
				if tcb == true then hlpr.rotation.controller = tcb_rotation()
				temp = obj.parent
				hlpr.transform = obj.transform
				obj.parent = hlpr
				hlpr.name = (obj.name+"_zero")
				hlpr.parent = temp
			)--end else
			hlpr
		)--end fn
	
	--create NubBone function
	fn makeNubBone lastBone =
	(  
		local nameArray = filterstring lastBone.name "_"
		local nameIndex = findItem nameArray "Bone"
		deleteItem nameArray nameIndex
		insertItem  "Rig" nameArray nameIndex
		local nameIndex2 = findItem nameArray "BF"
		deleteItem nameArray nameIndex2
		insertItem  "Nub" nameArray nameIndex2
		appendIfUnique     nameArray "BH"

		for i = 1 to nameArray.count-1 do
		(
			nameArray[i] += "_"
		)
		
		local pos = lastBone.transform[4] -- get the position of the last bone.
		local xDir = lastBone.transform[1] -- get the vector of the X point.
	 
		local startPoint = pos + xDir * lastBone.length
		local endPoint = startPoint + xDir * lastBone.width
	 
		local nubBone = boneSys.createBone startPoint endPoint lastBone.transform[3] -- create the bone.
	 
		nubBone.width = lastBone.width
		nubBone.height = lastBone.height
		nubBone.wireColor = lastBone.wireColor
	 
		nubBone.parent = lastBone
		nubBone.name = ""
-- 		nubBone.isHidden = true
		
		for i = 1 to nameArray.count do
		(
			nubBone.name += nameArray[i]
		)
	 
	   return nubBone
	)--end fn
	
	
	--create createBone function
	fn createBone lastBone bLength  bWidth =
    (   
       local pos = lastBone.transform[4] -- get the position of the last bone.
       local xDir = lastBone.transform[1] -- get the vector of the X point.
     
       local startPoint = pos + xDir * bLength
       local endPoint = startPoint + xDir * bWidth
     
       local newBone = boneSys.createBone startPoint endPoint lastBone.transform[3] -- create the bone.
     
       newBone.width = bLength
       newBone.height = bWidth
       newBone.wireColor = lastBone.wireColor
     
       newBone.parent = lastBone
     
       return newBone
    )--end fn
	

	on Imp_DynBld pressed do
	(
		with undo on
		(
			global myBoneArray = #() 
			global CharName = Char_txt.text
			global SideName = Side_txt.text
			
			pHelper = point name:(CharName+"_Rig_"+SideName+"_RootPt_DH") box:on cross: off
			for i = 1 to Bone_txt.value do
			(
				if i == 1 then
				(
					dynBone = 	createBone  pHelper	 0	 20.0
					dynBone.width = 10
					dynBone.height = 10
				)
				else
				(
					dynBone = createBone  myBoneArray[i-1]	 20.0	 20.0
					dynBone.width = 10
					dynBone.height = 10
				)
				
				dynBone.name = (CharName+"_Bone_"+SideName+"_Bn00" + i as string +"_BF")
				append myBoneArray dynBone
				setTransformLockFlags dynBone #{1,2,7,8,9}
				
				if i == Bone_txt.value then
				(
					nub = makeNubBone myBoneArray[i]
					append myBoneArray nub
				)
				
			)
			
-- 			parentArray myBoneArray
			
			global skinrig_layer = layermanager.getlayerfromname (CharName+"_BONES")
			global rig_layer = layermanager.getlayerfromname (CharName+"_RIG")
			global ctrls_layer = layermanager.getlayerfromname (CharName+"_EXTRA_CTRL")

			---Layer Setup
			if (skinrig_layer != undefined) then
			 (
				print (skinrig_layer.name +" exists")
			 )
			else
			(
				global skinrig_layer = LayerManager.newLayerFromName (CharName+"_BONES")
			)
			
			if (rig_layer != undefined) then
			 (
				print (rig_layer.name +" exists")
			 )
			else
			(
				global rig_layer = LayerManager.newLayerFromName (CharName+"_RIG")
			)
			
			if (ctrls_layer != undefined) then
			 (
				print (ctrls_layer.name +" exists")
			 )
			else
			(
				global ctrls_layer = LayerManager.newLayerFromName (CharName+"_EXTRA_CTRL")
			)
		)
	)

	on rigIt_but pressed do
	(
		with undo on
		(
			IkArray = #() -- Make Control Array 
			myCtrlArray = #() -- Make Control Array 	
			sprArr = #() -- Make Spring Array 
			pointArray = #()
			posListArr = #() -- Make IKSolver Position List Array 

			
			---Make Points for Dyn system based off placed joints
			for i = 1 to myBoneArray.count do
			(
				dynPoint = point name:(CharName+"_Rig_"+SideName+"_Pt00" + i as string +"_DH") box: on cross: off size: 5
				dynPoint.transform = myBoneArray[i].transform
				append pointArray dynPoint
			)
			
			---Parent PHelpers
			parentArray pointArray
			
			---Create IKChains
			for i=1 to pointArray.count-1 do
			( 
				if pointArray[i +1] != undefined then
				(		
					HIChain = iksys.ikchain  pointArray[i] pointArray[i+1] "IKHiSolver" 
					HIChain.name = (CharName+"_Rig_"+SideName+"_Dyn-IKChain_00"+ (i as string) +"_DH")
					HIChain.transform.controller.goalSize = 5
					append IkArray HIChain
				)
			)
			
			---Parent PHelpers
			parentArray IkArray
			pHelper = getnodebyname (CharName+"_Rig_"+SideName+"_RootPt_DH") 
			IkArray[1].parent = pHelper
			pointArray[1].parent = pHelper
			zero_out IkArray
			
			---Create CTRLs
			for i = 1 to myBoneArray.count do --Create Controls--
			(
				DynCTRL = Circle size:10.0 name:(CharName+"_Ctrl_"+SideName+"_Dyn_00"+(i as string)+"_SA")
				DynCTRL.transform = myBoneArray[i].transform
				DynCTRL.objectoffsetrot = eulerAngles 0 90 0
				setTransformLockFlags DynCTRL #{1,2,3,7,8,9}
				append  myCtrlArray DynCTRL
			)
			

			for i=1 to IkArray.count do
			(
				posList = Position_List ()
				springCTRL = SpringPositionController ()
				IkArray[i].controller[2][1].controller = posList
				posList[1].controller = springCTRL
				
				springCTRL[#X_effect].value = 100.0
				springCTRL[#Y_effect].value = 100.0
				springCTRL[#Z_effect].value = 100.0
				
				append sprArr springCTRL
				append posListArr posList

				orientCTRL = Orientation_Constraint relative:True 
				IkArray[i].controller[2][2].controller = orientCTRL
				orientCTRL.appendTarget myCtrlArray[i+1] 100 
			)
			

			---Parent PHelpers
			parentArray myCtrlArray
			pHelper.parent = myCtrlArray[1]
			zero_out myCtrlArray
			
			
			--Add attributes
			
			b=myCtrlArray[1]
			eM=emptyModifier()
			addModifier b eM

			def=attributes DynAttrib
			(
				parameters dynPar rollout:dynRoll
				(
					SpringsNodes			type:#MaxObjectTab tabSize:0 tabSizeVariable:true
					BonesNodes			type:#MaxObjectTab tabSize:0 tabSizeVariable:true
					stateCB					type:#Boolean			ui:(DynCB)				default:false
					iters						type:#float				ui:(DynIterSP)			default:1.0
					
					multiTrack 				type:#float 			UI:myMultSpinner 	default:0.5	
				)
				rollout dynRoll "Dynamics"
				(
					checkbutton		DynCB		"DYNAMICS OFF" 			offset:[0,0]  width:120	height:50 checked:false
		
					Group ""
					(
						spinner 	myMultSpinner "Mulitplier: " 				Range:[0,1,0.5]					fieldWidth:35
						spinner		DynIterSP		"Dynamics Iterations: "	Range:[1,3,1]	type:#integer	fieldWidth:20 	align:#center
					)
					
					
					fn updateButton =
					(
						if DynCB.state == true then
						(
							DynCB.caption = "DYNAMICS ON"
						)
						else
						(
							DynCB.caption = "DYNAMICS OFF"
						)
					)
					
					on DynRoll open do
					(					
						updateButton()
					)

					on DynCB changed state do
					(
						if state == on then
						(
							DynCB.caption = "DYNAMICS ON"
							
							for o in SpringsNodes do
							(
								try(
								o.node.transform.controller.IK_Goal.controller.Position.controller.Spring.controller.steps = DynIterSP.value
								) catch()
							)
							
							for o in BonesNodes do
							(
								o.node.pos.controller.weight[1] = 0.0
								o.node.rotation.controller.weight[1] = 0.0
				
								o.node.pos.controller.weight[2] = 100.0
								o.node.rotation.controller.weight[2] = 100.0
							)
						)
						else
						(
							DynCB.caption = "DYNAMICS OFF"
							
							for o in SpringsNodes do
							(
								try(
								o.node.transform.controller.IK_Goal.controller.Position.controller.Spring.controller.steps = 0
								) catch()
							)
							
							for o in BonesNodes do
							(
								o.node.pos.controller.weight[1] = 100.0
								o.node.rotation.controller.weight[1] = 100.0
				
								o.node.pos.controller.weight[2] = 0.0
								o.node.rotation.controller.weight[2] = 0.0
							)
						)
					)
					
					on DynIterSP changed newVal do
					(
						if DynCB.state == true then
						(
							for o in SpringsNodes do
							(
								try(
								o.node.transform.controller.IK_Goal.controller.Position.controller.Spring.controller.steps = DynIterSP.value
								) catch()
							)
						)
					)
				)
			)

			custAttributes.add eM def
			
			for o in IkArray do
			(
				append myCtrlArray[1].modifiers[#Attribute_Holder].DynAttrib.SpringsNodes (nodeTransformMonitor node:o forwardTransformChangeMsgs:false)
			)
			
			for o in myBoneArray do
			(
				append myCtrlArray[1].modifiers[#Attribute_Holder].DynAttrib.BonesNodes (nodeTransformMonitor node:o forwardTransformChangeMsgs:false)
			)
			
			
			MultiVal = myCtrlArray[1].modifiers[#Attribute_Holder].DynAttrib.multiTrack.controller = bezier_Float()
			
			
			for i = 1 to posListArr.count do
			(
				posListArr[i][3][1].controller = MultiVal
			)
			
			for i = 1 to myBoneArray.count do
			(
				bonePcController = position_Constraint relative:False--create controller
				boneOcController = orientation_Constraint relative:False--create controller
			
				myBoneArray[i].position.controller = bonePcController
				myBoneArray[i].rotation.controller = boneOcController
				
				bonePcController.appendTarget myCtrlArray[i] 100
				bonePcController.appendTarget   pointArray[i] 0
				
				boneOcController.appendTarget   myCtrlArray[i] 100
				boneOcController.appendTarget   pointArray[i] 0
			)
			
			
			---Cleanup
				
			for i =1 to myBoneArray.count do 
			(			
				skinrig_layer.addNode myBoneArray[i]
				
				if  i == myBoneArray.count then
				(
					rig_layer.addNode myBoneArray[i]
				)					
			)
			
			for i in myCtrlArray do 
			(
				ctrls_layer.addNode i
			)
			
			for i =1 to myCtrlArray.count do 
			(
				ctrlZero = myCtrlArray[i].parent
				rig_layer.addNode ctrlZero
			)

			for i in IkArray do 
			(
				rig_layer.addNode i
			)
			
			for i = 1 to IkArray.count do
			(
				ikZero = IkArray[i].parent
				rig_layer.addNode ikZero
			)
			
			for i in pointArray do 
			(
				rig_layer.addNode i
			)
			
			rig_layer.addNode pHelper
		
		)
	)
) 



createDialog UI 250 160
























