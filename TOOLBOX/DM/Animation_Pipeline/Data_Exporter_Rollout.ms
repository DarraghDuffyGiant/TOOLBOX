	
	DependsOnTool.loadTool toolName:"AssetCheckerTool"
	
	rollout exportADataRollout "Export Asset Data" width:384 height:528
	(
		
		multiListBox lbxLayers "Layers" pos:[8,32] width:368 height:22				
				
				
		edittext edtFilter "" pos:[40,344] width:168 height:24
		edittext edtName "" pos:[208,8] width:168 height:18 enabled:false
		label lblFilter "Filter" pos:[8,352] width:32 height:16
		button btnExport "Export" pos:[8,376] width:368 height:24		
		
		checkbox chkExportSelection "Export Selected Objects" pos:[8,7] width:136 height:16		
		
		checkbutton chkbBasicData "Object Data" pos:[8,400] width:368 height:24 checked:true			
			
		checkbutton ckbRenderElements "Render Elements" pos:[8,448] width:368 height:24 checked:true		
		
		checkbutton ckbMatIDs "Export MatIDs" pos:[8,472] width:368 height:24 enabled:true checked:false
		checkbutton ckbMaterials "Material Data" pos:[8,424] width:368 height:24 checked:true
		button btnRefresh "Refresh" pos:[216,344] width:160 height:24
		label lblName "Name" pos:[168,8] width:39 height:18 enabled:false
		
		/*
			Rollout Events
		*/		
	
		include "$userscripts\\Animation_Pipeline\\Include\\FileSystem.ms"
		include "$userscripts\\Animation_Pipeline\\Include\\DATA_IO\\Serialise_Objects.ms"
		include "$userscripts\\Animation_Pipeline\\Include\\DATA_IO\\Serialise_Elements.ms"	
		include "$userscripts\\Animation_Pipeline\\Include\\DATA_IO\\Serialise_MatIDs.ms"
		include "$userscripts\\Animation_Pipeline\\Include\\DATA_IO\\Export_Materials.ms"		
		include "$userscripts\\Animation_Pipeline\\Include\\ExportRolloutFunctions.ms"
		
			
		checkbox chkSanityCheck "Sanity Check" pos:[8,501] width:368 height:24 checked:false
		
		
		on exportADataRollout open do
		(
			assetDataFolder = getAssetDataFolder()
		
			if( not(doesfileexist assetDataFolder ) ) then
			(
				makedir assetDataFolder
			)
			
			assert (doesfileexist assetDataFolder) message: "Asset Folder does not exist" options:#(#dialog)
			
			lbxLayers.items =getLayerList edtFilter.text
		)
		on edtFilter changed text do
		(
			lbxLayers.items =getLayerList edtFilter.text
		)
		on btnExport pressed do
		(
			-- check to see if the max session has a filename / filepath
			if(maxfilename != "") then
			(
				if(chkExportSelection.state) then
				(
					Export edtName.text selection chkbBasicData.state ckbRenderElements.state ckbMatIDs.state ckbMaterials.state ( getAssetDataFolder() )
				)
				else
				(
					selectedLayers = lbxLayers.selection
					
					for selected in selectedLayers do
					(				
						layerNodes = #()
						layer = LayerManager.getLayerFromName lbxLayers.items[selected]			
						result = layer.nodes &layerNodes	
						
						if(chkSanityCheck.state) then
						(
							AssetCheckerTool.DoChecks(layerNodes)
						)
						else
						(
							Export layer.name layerNodes chkbBasicData.state ckbRenderElements.state ckbMatIDs.state ckbMaterials.state ( getAssetDataFolder() )
						)
						
					)
				)
			)
			else
			(
				messagebox "Error: Script cannot be run on an unsaved max file"
			)
		)
		on chkExportSelection changed state do
		(
			edtName.enabled = state
			lblName.enabled = state
		)
		on btnRefresh pressed do
		(
			lbxLayers.items =getLayerList ""
		)
	)
--createDialog exportADataRollo