
	rollout importADataRollout "Import Asset Data" width:384 height:504
	(
		--Includes 
		include "$userscripts\\Animation_Pipeline\\Include\\FileSystem.ms"
		include "$userscripts\\Animation_Pipeline\\Include\\DATA_IO\\DeSerialise_Objects.ms"
		include "$userscripts\\Animation_Pipeline\\Include\\DATA_IO\\DeSerialise_Elements.ms"	
		include "$userscripts\\Animation_Pipeline\\Include\\DATA_IO\\DeSerialise_MatIDs.ms"
		include "$userscripts\\Animation_Pipeline\\Include\\DATA_IO\\Import_Materials.ms"	
		include "$userscripts\\Animation_Pipeline\\Include\\DATA_IO\\Data_Importer.ms"		
		include "$userscripts\\Animation_Pipeline\\Include\\ImportRolloutFunctions.ms"	
		
	
		local assetCollection
		local filteredAssetCollection
		
		multiListBox lbxAssetDefs "Layers" pos:[8,8] width:368 height:22				
		edittext edtFilter "" pos:[40,320] width:168 height:24
		label lblFilter "Filter" pos:[8,328] width:32 height:16
		button btnImport "Import" pos:[8,352] width:368 height:24	
		checkbutton chkbBasicData "Object Data" pos:[8,376] width:368 height:24 checked:true						
		checkbutton ckbRenderElements "Render Elements" pos:[8,424] width:368 height:24 checked:false	
		checkbutton ckbMatIDs "MatIDs" pos:[8,448] width:368 height:24 checked:false
		checkbutton ckbMaterials "Material Data" pos:[8,400] width:368 height:24 checked:true
		button btnRefresh "Refresh" pos:[216,320] width:160 height:24
		checkbox chkLooseNaming "Use Loose Naming" pos:[8,472] width:368 height:32
		
		/*
			Rollout Events
		*/			
		
		
		on importADataRollout open do
		(
			assetDataFolder = getAssetDataFolder()
			
			assetCollection = getAssetList assetDataFolder
			
			lbxAssetDefs.items = assetCollection
			
		)
		
		
		on edtFilter changed txt do
		(
			if(txt == "") then (txt ="*")
			filteredAssetCollection = filterAssetCollection assetCollection txt
			lbxAssetDefs.items = filteredAssetCollection
		)
		
		
		on btnImport pressed do
		(
			selectedLayers = lbxAssetDefs.selection
				
				for selected in selectedLayers do
				(				
					
					assetName= lbxAssetDefs.items[selected]			
					
					DataImport assetName doObjDat:chkbBasicData.state doMatData: ckbMaterials.state doElement:ckbRenderElements.state doMatIDs: ckbMatIDs.state doLooseNames:chkLooseNaming.state doSceneData:false
					
					
				)
		)
		
		on btnRefresh pressed do
		(
			assetDataFolder = getAssetDataFolder()
			
			assetCollection = getAssetList assetDataFolder
			
			lbxAssetDefs.items = assetCollection
		)
	)

