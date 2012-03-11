HAI 1.3

O HAI IM test
	O HAI IM failure
		I HAS A reason
	KTHX

	HOW IZ I failin YR caption
		I HAS A problem ITZ LIEK MAH failure
		problem'Z reason R caption
		DO NOT WANT problem
	IF U SAY SO

	HOW IZ I checkin YR work AN YR caption
		NOT work, O RLY?
			YA RLY, ME IZ failin caption
		OIC
	IF U SAY SO

	I HAS A name ITZ "(cheezburger)"
	I HAS A counter
	I HAS A enabled ITZ WIN

	HOW IZ I checkpointin
		MAH counter R SUM OF MAH counter AN 1
	IF U SAY SO

	HOW IZ I expectpointin YR count
		DIFFRINT count AN MAH counter, O RLY?
		YA RLY
			ME IZ failin SMOOSH "Missed checkpoint " AN count AN " (currently at " AN MAH counter AN ")" MKAY
		OIC
	IF U SAY SO

	HOW IZ I runnin
		NOT MAH enabled, O RLY?
		YA RLY
			VISIBLE NOOB ":>" MAH name
			GTFO
		OIC


		MAH counter R 0
		PLZ
			ME IZ testin MKAY
			VISIBLE WIN ":>" MAH name
		O NOES ITZ A test'Z failure
			I HAS A problem ITZ IT'Z reason
			VISIBLE FAIL ":>" MAH name
			VISIBLE ":>" problem ":)"
		O NOES WIN
			VISIBLE FAIL ":>" MAH name
			VISIBLE ":>DO NOT WANT: " IT ":)"
		KTHX
	IF U SAY SO

	HOW IZ I disabled
		MAH enabled R FAIL
	IF U SAY SO

	HOW IZ I testin
		BTW inherited objects should define this!
		ME IZ failin "test not defined"
	IF U SAY SO
KTHX

ME IZ frist, O RLY?
YA RLY
	O HAI IM meta_test IM LIEK test
		MAH name R "SANITY"
		HOW IZ I testin
			O HAI IM fail_test IM LIEK test
				MAH name R "fail_test"
				HOW IZ I testin
					ME IZ checkin FAIL AN "expected to fail" MKAY
				IF U SAY SO
			KTHX
			O HAI IM direct_fail_test IM LIEK test
				MAH name R "direct_fail_test"
				HOW IZ I testin
					ME IZ failin "expected to fail" MKAY
				IF U SAY SO
			KTHX
			O HAI IM win_test IM LIEK test
				MAH name R "win_test"
				HOW IZ I testin
					ME IZ checkin WIN AN "expected to WIN" MKAY
				IF U SAY SO
			KTHX

			PLZ
				fail_test IZ testin
				ME IZ failin "expected a problem from fail_test"
			O NOES ITZ A test'Z failure
				ME IZ checkpointin
			KTHX
			ME IZ expectpointin 1

			PLZ
				win_test IZ testin
				ME IZ checkpointin
			O NOES ITZ A test'Z failure
				ME IZ failin "expected no problems from win_test"
			KTHX
			ME IZ expectpointin 2

			PLZ
				direct_fail_test IZ testin
				ME IZ failin "expected a problem from direct_fail_test"
			O NOES ITZ A test'Z failure
				ME IZ checkpointin
			KTHX
			ME IZ expectpointin 3
		IF U SAY SO

		I IZ runnin
	KTHX
OIC

KTHXBYE