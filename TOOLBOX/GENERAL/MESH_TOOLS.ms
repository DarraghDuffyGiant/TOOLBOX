
struct meshGeneralTools (
meshList = #(),
meshModifierClassList =#(),

	fn captureModifiers obj =(

		if obj != undefined then 
		(
			for i in obj.modifiers do 
			(
				local modClass = classOf i
				append meshModifierClassList modClass
			)
		)
	),

	function deleteModifiers obj modName =(

		local modClassArray =#()
		local modClassIndex =#()
		local modifierCount = obj.modifiers.count

		if obj != undefined and modName != undefined then
		(
			for i = 1 to modifierCount do 
			(
				modClass = classOf obj.modifiers[i]
				append modClassArray modClass
				append modClassIndex i
			)

			if modClassArray != undefined then
			(
				for i = 1 to modClassArray.count do
				(
					if modClassArray[i] == modName then
					(
						deleteModifier obj modClassIndex[i]
					)
				)
			)
		)
	)
)



struct  meshSmoothFunctions (

	function setIsolineDisplayonNode obj state  = 
	(
		if(obj != undefined) then
		(
			if( isKindOf obj GeometryClass ) then
			(
				for m in obj.modifiers do
				(
					if(classof m == TurboSmooth) then
					(
						m.isolinedisplay = state
					)
				)
			)
		)
	)--end fn

)




