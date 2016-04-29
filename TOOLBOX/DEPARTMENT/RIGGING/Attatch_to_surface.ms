-- By Michael O'Callaghan
-- Tool for Attaching multiple objects to a surface using attatchment constraints. it only works if the surface is an Editable Mesh (not poly)


rollout UI "Attach to Surface"
(
-- 		UI stuff, button size etc:
		pickbutton choose_Surface "Pick Surface" offset:[0,20] width:100
		
		button surf_Attatch_Butt "Attach to Surface" offset:[0,10] width:110 height:110
	
-- 		This function deals with casting a ray from the selected object to the surface. 
-- 		this will give me the values  i need to feed into the attatchment constraints as an array value using the "intersectRayEx" command
-- 		Note: "Ray_to_surface" here is the functions name and "obj" , "surf" and "surf_gap" are the variables that need to be defined whenever the function is later called.
		fn Ray_to_surface obj surf surf_gap=
		(
-- 			Here the ray is created at the objects position plus a slight gap so its a little above the surface (thats the "surf_gap") and is given a  direction vector in this case -1 on the Z axis and associated to the variable "new_ray"
			new_ray = ray (obj.position + [0,0,surf_gap]) [0,0,-1]
-- 			Here I use the "intersectRayEx" constructor to create the array value for the intersection point, this includes the face niumber and coordinates within the face on the surface and associates it to the variable "new_intersect"
			new_intersect = intersectRayEx surf new_ray
-- 			This saves the values to be called later in the script
			return new_intersect 
		)
			
-- 		This function creates a dummy where each object in the array is and assigns an attatchment constraint to it.
-- 		Note "Attatch_to_surface" is the function name and  "obj" , "surf" and  "faceparam" are variables to be defined when the function is called
		fn Attatch_to_surface obj surf faceparam=
		(
-- 			here I create the dummy at the objects pocition
			new_Dummy = Dummy length:30 width:30 height:30 position:obj.position name: (obj.name+"_DH") 
			
-- 			here I define the variable "new_attach" as being an attachment constraint 
			new_attach = attachment()
-- 			here I state that the position controler of the dummy (.pos.controller) should be the attachment constraint of the previous variable
			new_Dummy.pos.controller = new_attach
			
-- 			All these "new_attach." lines are me defining specific properties of the attachment constraint
-- 			Here what surface to be attached to, (the variable "surf")
			new_attach.node = surf
-- 			allignto surface is turned on:
			new_attach.align = true
				
-- 			Manual update is turned on
			new_attach.manupdate = true
			
-- 			here using a method specific to the Attachment contraint to create a new key at 0 and then fill its values
			AttachCtrl.addNewKey new_attach 0
			current_key = AttachCtrl.getKey new_attach 1
-- 			
			/*the value here always seems to be 1 over the number you feed it, so I add a -1 to compensate. 
			faceparam will be an array from the ray casting function, using the [] to call specific lines in the array and then specific info in there 
			so "[2]" is line 2 and "[3][1]" is line 3 value 1*/
			current_key.face = (faceparam[2])-1
			current_key.coord = [faceparam[3][1], faceparam[3][2]]

-- 			here I force it to update with the new values. without this although the values seem right the dummy will move to wrong place
			AttachCtrl.update new_attach
-- 			turn off manual update so it will lock
			new_attach.manupdate = false
				
-- 			Here I parent the original object to the dummy with attachment constraint
			obj.parent = new_Dummy
		)
			
-- 		Event associated with 1st button. this defines the surface variable I wil use when calling the above functions.
		on choose_Surface picked obj do
		(
			if classof choose_Surface.object == Editable_mesh and isValidNode choose_Surface.object then 
			(
-- 			This is where the buttons text is changed to the name of the surface object to signify that its been selected
			choose_Surface.text = obj.name
			)
			else 
			(
				messagebox "Surface must be Editable MESH"
			)
		)

--        Event associated with second button. this is when the above functions are called. by now all variables are defined and the script can do its thing
		on surf_Attatch_Butt pressed do
-- 		this "with undo on" thing saves the process in memory as an undoable step so I can ctrl-z back from it 
		with undo on
		(    
-- 		     "selection as Array" allows to select a bunch of objects and treat them as an array so I can apply the functions to multiple objects
	 	    my_objs = (selection as Array)
		
			if choose_Surface.object != undefined and isValidNode choose_Surface.object then 
			(
				-- 	here "i" stands for "index" its a variable defining each object in a selection. so, in "i" do this from the first to the max count (my_objs.count)
				for i = 1 to my_objs.count do 
				(
	-- 				here I call the first function and assign its resulting valua as a variable for the second function
					ray_data = Ray_to_surface my_objs[i] choose_Surface.object 100.0
-- 					print ray_data
	-- 				here I call the second function and use the variable
					if ray_data != undefined then
					(
						Attatch_to_surface my_objs[i] choose_Surface.object ray_data
					)
					else
					(
						print (my_objs[i].name + "  " + (i as string) + " isn't touching the ground")
					)
				)
			)
			else
			(
				messagebox "No surface selcted"
			)
		)-- end undo
)
		

-- thisdefines the size of the UI box
createDialog UI 200 200