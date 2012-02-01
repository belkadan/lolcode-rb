HAI 1.3

CAN HAS "test"

O HAI IM numbar_test IM LIEK test
	HOW IZ I expectin value AN actual
		I HAS A higher ITZ SUM OF actual AN 0.001
		I HAS A lower ITZ DIFF OF actual AN 0.001

		ME IZ checkin...
			BOTH SAEM BIGGR OF lower AN actual...
				AN SMALLR OF higher AN actual...
			AN SMOOSH "Expected " AN value AN " but got " AN actual MKAY
	IF U SAY SO
KTHX

O HAI IM op_test IM LIEK numbar_test
	MAH name R "NUMBAR ops"

	HOW IZ I testin
		ME IZ expectin 1.0 AN SUM OF 0.5 AN 0.5 MKAY
		ME IZ expectin 0.5 AN DIFF OF 1.0 AN 0.5 MKAY
	IF U SAY SO

	I IZ runnin
KTHX

O HAI IM convert_test IM LIEK numbar_test
	MAH name R "NUMBAR conversion"

	HOW IZ I testin
		ME IZ expectin 2.0 AN SUM OF 1.0 AN 1 MKAY
		ME IZ expectin 2.0 AN SUM OF 1 AN 1.0 MKAY
		ME IZ expectin 0.5 AN QUOSHUNT OF 1 AN 2.0 MKAY
		ME IZ expectin 0.5 AN QUOSHUNT OF 1.0 AN 2 MKAY
		
		BTW in this case both arguments are NUMBRs and there is NO conversion
		ME IZ expectin 0 AN QUOSHUNT OF 1 AN 2 MKAY
	IF U SAY SO

	I IZ runnin
KTHX

O HAI IM div_zero_test IM LIEK test
	MAH name R "DIV 0"

	HOW IZ I testin
		PLZ
			QUOSHUNT OF 10.0 AN 0.0
		O NOES WIN
			ME IZ checkpointin
		KTHX
		ME IZ expectpointin 1

		PLZ
			MOD OF 10.0 AN 0.0
		O NOES WIN
			ME IZ checkpointin
		KTHX
		ME IZ expectpointin 2
	IF U SAY SO

	I IZ runnin
KTHX

KTHXBAI
