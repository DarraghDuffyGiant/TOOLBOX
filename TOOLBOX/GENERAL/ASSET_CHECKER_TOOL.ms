/*

STRUCT: nodeTester:

	(SetCheckFunction):
	(SetFixFunction):
	(Check):

STRUCT: AssetCheckerTool:

	(AddCheck):
	(ExecuteChecks):
	(Report):
	(GetFailedChecks):

*/



struct nodeTester (
	
	private

    checkFunction,
    fixFunction,    
    --arrTargetClasses = #(),

    public 
 	bCanFix = false,
    bCanCheck = false,
    sCheckName = "",
    sCheckError = "",

    fn SetCheckFunction fnCheck sCheckName sCheckError  =
    (
    	if(classof fnCheck == MAXScriptFunction) then 
    	(
    		checkFunction = fnCheck
    		bCanCheck = true 
    		this.sCheckError = sCheckError
    		this.sCheckName = sCheckName
    		--this.arrTargetClasses = arrTargetClasses
		)

	),

	fn SetFixFunction fnFix = 
	(
		if(classof fnFix == MAXScriptFunction) then 
		(
			fixFunction = fnFix
			bCanFix = true 
		)
	),

	fn Check nNode =
	(
		if (bCanCheck) then
		(
			if(isValidNode nNode) then 
			(
				return (checkFunction nNode)
			)
			else
			(
				return true
			)
		)
		else
		(
			return true
		)
	)
)


struct AssetCheckerTool 
(	
	private 
	/*
		Sanity Checks are stored in Arrays, each array value is a datapair consisting of a nodeTester object and an array set aside to store failed nodes
		#(Datapair(check:nodeTester,failedNodes:#()))
	*/
	arrSanityChecks = #(),

	public

	rUI,

	/*
		Add the given checker to the Sanity Checker
	*/
	function AddCheck oChecker = (
		if(classof oChecker == nodeTester) then 
		(
			if(oChecker.bCanCheck) then 
			(
				append arrSanityChecks (DataPair check:oChecker failedNodes:#())
			)
			else 
			(
				assert (oChecker.bCanCheck) "checker has not been correctly initialised"
			)
		)
		else
		(
			assert (classof oChecker == nodeTester) "oChecker needs to be of class nodeTester"
		)
	),

	/*
		Run all checks
	*/	
	function ExecuteChecks arrObjectList = 
	(
		--format "executing checks\n"
		if(classof arrObjectList != undefined) then 
		(
			if(classof arrObjectList == ObjectSet) or (classof arrObjectList == Array) or (classof arrObjectList == SelectionSet) then 			
			(
				/*
					Itterate through the sanity checks and run them on the scene
					if any checks fail then store them in an indexed sub array of arrFailedChecks
					the index in arrFailedChecks matches the index of the checker in arrSanityChecks
				*/

				for idx = 1 to arrSanityChecks.count do
				(

					sanityCheck = arrSanityChecks[idx].check

					--format "Got Checker:%\n" sanityCheck.sCheckName

					/*If a check returns false store the node*/
					for nNode in  arrObjectList do 
					(
						
						bResult = sanityCheck.Check nNode 

						--format "state:%\n" bResult
						
						if not(bResult) then
						(
							append arrSanityChecks[idx].failedNodes nNode
						)

					)
				)
			)
		)
	),

	/*
		Print a report of failed checks to the maxscript console
	*/
	function Report =
	(
		format "\nSanity Checker Report\n==========================================================\n"

		for sanityCheck in arrSanityChecks do 
		(
			arrFails = sanityCheck.failedNodes
			format "Check Name:\"%\"\n" sanityCheck.check.sCheckName
			format "Failed Nodes:\n"
			for nNode in arrFails do 
			(
				format "\t %\n" nNode.name 
			)
			format "\n"
		)

		format "==========================================================\n"
	),

	/*
		Return an Array of failed checks and the nodes that failed them 
		this returns an array of data pairs.

		#( Datapair( check: nodeTester, failedNodes: #(node*) ) )
	*/
	function GetFailedChecks = 
	(
		arrFails = #()

		for sanityCheck in arrSanityChecks do 
		(

			
			if(sanityCheck.failedNodes.count > 0) then 
			(

				append arrFails sanityCheck
			)
		)

		return arrFails
	)
)

/*
The UI for the Asset Checker
*/
rollout rAssetCheckerUI "Failed Checks!" width:500 height:500
(
	local arrAssetCheckerUI = #()
	
	listBox 'lbxFailedChecks' "Failed Checks" pos:[8,8] width:488 height:35 align:#left
	
	
	function ShowFails arrFails = 
	(
		arrAssetCheckerUI = arrFails

		arrCheckNames = #()
		for failedCheck in arrAssetCheckerUI do 
		(
			print failedCheck.check.sCheckName
			append arrCheckNames failedCheck.check.sCheckName
		)
		lbxFailedChecks.items = arrCheckNames
	)

	on rAssetCheckerUI open do 
	(		
	)

	on lbxFailedChecks selected idx do 
	(
		select arrAssetCheckerUI[idx].failedNodes
	)
)

--AssetCheckerTool.rUI = rAssetCheckerUI
/*
sanityChecker = AssetCheckerTool()


check1 = nodeTester()

checkFn = fn anon nNode = 
(
	--format "Checking %\n" nNode.name 
	if (superClassOf nNode == GeometryClass) then
	(
		return (nNode.material != undefined)
	)
	else
	(
		return true 
	)
)
check1.SetCheckFunction checkFn "Undefined Material" "Node has no Material"

check2 = nodeTester()
checkFn2 = fn anon nNode = 
(
	if(superClassOf nNode == GeometryClass) then 
	(
		return (nNode.modifiers[#TurboSmooth] !=  undefined)
	)
	else
	(
		return true 
	)
)
check2.SetCheckFunction checkFn2 "No TurboSmooth" "Node has no TurboSmooth"


sanityChecker.AddCheck check1
sanityChecker.AddCheck check2

sanityChecker.ExecuteChecks(geometry)

sanityChecker.Report()
arrFailedChecks = (sanityChecker.GetFailedChecks())
format "Checks failed: %\n" arrFailedChecks.count 

CreateDialog rFailedChecks
rFailedChecks.ShowFails arrFailedChecks
*/
