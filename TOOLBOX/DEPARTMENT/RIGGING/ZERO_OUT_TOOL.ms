(
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
		
	a = selection as array
	zero_out a
)

