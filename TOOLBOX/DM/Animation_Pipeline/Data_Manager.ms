
/*
	Boulder Media, Data transfer manager, Robert Fletcher 2015
	Tab Control code from http://paulneale.com/tutorials/dotNet/tabControl/tabControl.htm
	
*/

--Destroy the dialog if it is already open 
try(destroyDialog rDataManager)catch()

--Create a rollout
rollout rDataManager "Data Manager" width:420 height:580
(
	--Add a dot net tab control
	dotNetControl tabs "system.windows.forms.tabControl" width:(rDataManager.width-30) height:25 
	--Add a sub rollout.
	subRollout subRoll "Sub" width:(rDataManager.width-30) height:(rDataManager.height-30) offset:[0,-5]
	
	--Add rollouts to the subRollout based on which tab is currently selected. 
	fn addTabRollout index=
	(
		--Remove any existing rollouts first. 
 		for x in subRoll.rollouts do removeSubRollout subRoll x
		
		sub=case index of
		(
			default:
			(
				include "$userscripts\\Animation_Pipeline\\Data_Importer_Rollout.ms"
			)
			1:
			(
				include "$userscripts\\Animation_Pipeline\\Data_Exporter_Rollout.ms"
			)	
		)
		addSubRollout subRoll sub
	)
	
	--Tab initilization function.
	fn initTabs tab labels:#() =
	(
		--Clear any existing tabs incase we do an update of them at some point. 
		tab.tabPages.clear()
		--Set the size mode so that we can control their width. 
		tab.sizeMode=tab.sizeMode.fixed
		--Set the width of every tab.
		tab.itemSize=dotnetObject "System.Drawing.Size" ((tab.width/labels.count)-2) 25
		
		--Loop through all the labels that we pass to the function and add a tab by the same name. 
 		for x in labels do tab.tabPages.add x
	)
	
	--When the mouse button is released on a tab get the selected tab and pass it to our addTabRollout function. 
	on tabs MouseUp senderArg arg do
	(
-- 		showProps arg
		addTabRollout senderArg.SelectedIndex
	)
	
	--When the rollout opens initilize the tab control
	on rDataManager open do
	(
-- 		showProps tabs
		
		initTabs tabs labels:#("Import", "Export")
		addTabRollout 0
	)
)
--Create the dialog

createDialog rDataManager
cui.registerDialogBar rDataManager style:#(#cui_floatable)
--cui.dockDialogBar rDataManager #cui_dock_left