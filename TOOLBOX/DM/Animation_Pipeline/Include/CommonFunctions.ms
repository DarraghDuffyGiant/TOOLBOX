

function collectNamedDuplicates objNames = 
(
	
	
	clearListener()
	re = dotNetClass "System.Text.RegularExpressions.Regex"
	reOpt = dotNetClass "System.Text.RegularExpressions.RegexOptions"
	objCollection = #()
	
	--format "OBJ NAMES:%\n" objNames
	
	if(classof objNames != Array) then
	(
		--print "redefining as array"
		objNames = #(objNames)
	)
	
	
	/*first we convert the name into a regular expression (make the numbers tokens)*/
	
	for objName in objNames do
	(
		pattern = re.Replace objName @"\d" @"\d*"
		
		for obj in objects do
		(
			
			sName = obj.name
			--format "\nNAME:% PATTERN:%\n" sName pattern
			match = re.match sName pattern reOpt.IgnoreCase
			
			if(match.success) then
			(
				append objCollection obj			
			)
		)
	)

	return objCollection
)

