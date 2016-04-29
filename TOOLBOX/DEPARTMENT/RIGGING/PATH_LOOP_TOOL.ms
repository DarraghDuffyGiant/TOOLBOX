(

pathObjectArray = #()
pathObjectNameArray = #()
pathPointArray = #()
pathAmount = "10"
pathNameMain = "Object"
pathLoop = undefined


rollout UI "PATH LOOP"
(	
	fn filterLine obj = superclassof obj == Shape 
	fn filterObj obj = if superclassof obj == GeometryClass or superclassof obj == helper then return true

	pickbutton choosePath "Pick Path" width:100 filter:filterLine
	pickbutton chooseObject "Pick Object" width:100 filter:filterObj 
	MultiListBox pathLoopObjs "Objects to Path"  items:pathObjectNameArray width:150 offset:[0,0]
	edittext setPathName "Name of Path Objects: " fieldWidth:50 text:pathNameMain
	edittext setPathAmount "Number of Path Objects: " fieldWidth:50 text:pathAmount

	button makePathButt "Make Path Loop" offset:[0,10] width:110 height:110

	on choosePath picked obj do
	(
		choosePath.text = obj.name
		pathLoop = getnodebyname obj.name
	)

	on chooseObject picked obj do
	(
		pathObjectName = obj.name
		appendIfUnique  pathObjectNameArray pathObjectName
		pathLoopObjs.items = pathObjectNameArray
	)

	on makePathButt pressed do
	(
		if pathLoop != undefined then
		(
			local pathAmount = setPathAmount.text as integer
			local pathLoopLen = curvelength pathLoop
			pathLoopRatio = pathLoopLen/pathAmount*.01

			eM = emptyModifier()
			addModifier pathLoop eM

			def=attributes pathLoopAttrib
			(
				parameters dynPar rollout:dynRoll
				(
					multiTrack type:#float UI:pathLoopSpeed 
				)
				rollout dynRoll "Dynamics"
				(
					spinner pathLoopSpeed "Speed" Range:[-1,1,0.1] type: #float
				)
			)

			custAttributes.add eM def

			pathLoopAttr = pathLoop.modifiers[#Attribute_Holder].pathLoopAttrib.multiTrack.controller = bezier_float()


			for i = 1 to pathAmount do
			(

				--setup path rig
				pointMain = Point pos:[0,0,0] name:(pathNameMain + "_" + i as string + "_RG") box:True 

				pointPC = Path_Constraint follow:True axis:1 axisflip:true
				pointExpr = float_script ()
				pointPathVal = (i/pathAmount as float)
				pointExpr.addtarget "SPEED" pathLoopAttr
				pointExpr.setexpression  ("(mod (" + pointPathVal as string + "+F/100*SPEED) 1)")


				pointMain.position.controller = pointPC
				pointPC.appendTarget pathLoop 100
				pointMain.pos.controller.percent.controller = pointExpr

				append pathPointArray pointMain

			)


			if pathObjectNameArray.count>0 then
			(

				for i = 1 to (pathAmount-1) do
				(
					pathObjInex = random 1 pathObjectNameArray.count
					pathObj = getNodeByName pathObjectNameArray[pathObjInex]
					newPathObject = maxOps.cloneNodes pathObj cloneType:#instance newNodes:&nnl #nodialog
					append pathObjectArray nnl
					print pathObjectArray

				)
				for i = 1 to pathPointArray.count do
				(
					if pathObjectArray[i] != undefined do
					(
						pathObjectArray[i].transform = pathPointArray[i].transform
						pathObjectArray[i].parent = pathPointArray[i]
					)
				)
			)
			else
			(
				print "Nothing here"
			)
		)
		else
		(
			messageBox "Select a path!!"
		)


	)
) 


createDialog UI 250 400
)

