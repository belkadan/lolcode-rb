HAI 1.3

CAN HAS "test"

O HAI IM yarn_tester IM LIEK test
	MAH name R "Yarn literals"
	HOW IZ I testin
		ME IZ checkin BOTH SAEM ":(3B)" AN ";" AN "hex interpolation" MKAY
		
		I HAS A SPOINK ITZ 5
		ME IZ checkin BOTH SAEM ":{SPOINK}" AN "5" AN "variable interpolation" MKAY
	IF U SAY SO

	I IZ runnin
KTHX

O HAI IM longness_test IM LIEK test
	MAH name R "LONGNESS"
	HOW IZ I testin
		I HAS A empty ITZ ""
		I HAS A full ITZ "abc"
		ME IZ checkin BOTH SAEM empty'Z LONGNESS AN 0 AN "empty string" MKAY
		ME IZ checkin BOTH SAEM full'Z LONGNESS AN 3 AN "simple string" MKAY
	IF U SAY SO

	I IZ runnin
KTHX

O HAI IM longness_mutation_test IM LIEK test
	MAH name R "LONGNESS (mutation)"
	HOW IZ I testin
		PLZ
			I HAS A str ITZ "a"
			str'Z LONGNESS R 3
		O NOES WIN
			ME IZ checkpointin
		KTHX
		ME IZ expectpointin 1
	IF U SAY SO

	I IZ runnin
KTHX

KTHXBAI
