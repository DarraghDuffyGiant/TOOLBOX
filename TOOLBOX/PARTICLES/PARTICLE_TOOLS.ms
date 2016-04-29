ParticlesDialog = newRolloutFloater "PARTICLE TOOL" 300 100
 
rollout particleGenRollout "General Tools:"
(
	button PART_ON_BTN "Particles On"  
	button PART_OFF_BTN "Particles Off"  
	
	on PART_ON_BTN pressed do
	(
		for i in objects where classOf i == PF_Source do 
		(
			i.Quantity_Viewport = 100.0
			i.baseObject.activateParticles on
		)
	)

	on PART_OFF_BTN pressed do
	(
		for i in objects where classOf i == PF_Source do 
		(
			i.Quantity_Viewport = 0.0
			i.baseObject.activateParticles off
		)
	)
)
addrollout particleGenRollout ParticlesDialog

