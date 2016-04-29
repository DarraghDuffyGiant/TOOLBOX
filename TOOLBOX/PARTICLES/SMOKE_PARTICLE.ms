testObj = getnodebyname "PFSOURCE001"


fn particleRate sourceObj t =
(
	local rate = 60.0
	local oldPos = at time (t-1f) testObj.pos
	local curPos = at time t testObj.pos

	if oldPos != curPos then
	(
		diff = curPos - oldPos
		len = length(diff) 

		if len < 10.0 then
		(
			print (len as string + " is low level")
			$'Birth 001'.rate = 80
		)		
		else if len < 25.0 then
		(
			print (len as string + " is mid level")
			$'Birth 001'.rate = 120
		)
		else if len < 200.0  then
		(
			print (len as string + " is high level")
			$'Birth 001'.rate = 200
		)
	)
	else
	(
		print "Not moving"
	)

)

particleRate testObj currentTime 