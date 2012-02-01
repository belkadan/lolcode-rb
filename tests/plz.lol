HAI 1.3

CAN HAS "test"

O HAI IM simple_test IM LIEK test
	MAH name R "O NOES (condition)"
	HOW IZ I testin
		PLZ
			"test", DO NOT WANT IT
			ME IZ checkin FAIL AN "should have failed by now"
		O NOES BOTH SAEM IT AN "test"
			ME IZ checkpointin
		KTHX
		ME IZ expectpointin 1

		PLZ
			"test", DO NOT WANT IT
		O NOES BOTH SAEM IT AN "boo"
			ME IZ checkin FAIL AN "should not be caught here"
		O NOES WIN
			BTW this is a catch-all even though it has nothing to do with "it"
			ME IZ checkpointin
		KTHX
		ME IZ expectpointin 2

		PLZ
			"test", DO NOT WANT IT
		O NOES WIN
			ME IZ checkin BOTH SAEM IT AN "test" AN "should be IT in the O NOES"
			ME IZ checkpointin
		KTHX
		ME IZ expectpointin 3
	IF U SAY SO

	I IZ runnin
KTHX

O HAI IM catch_liek_test IM LIEK test
	MAH name R "O NOES (ITZ A)"
	HOW IZ I testin
		O HAI IM thing
		KTHX

		PLZ
			I HAS A problem ITZ LIEK A thing
			problem HAS A name ITZ "you"
			DO NOT WANT problem
		O NOES ITZ A test
			ME IZ checkin FAIL AN "should not be caught here"
		O NOES ITZ A thing
			ME IZ checkin BOTH SAEM IT'Z name AN "you" AN "the real object"
			ME IZ checkpointin
		KTHX
		ME IZ expectpointin 1
	IF U SAY SO

	I IZ runnin
KTHX

O HAI IM o_wel_test IM LIEK test
	MAH name R "O WEL"
	HOW IZ I testin
		PLZ
			BTW nothing goes wrong here
		O NOES ITZ A test
			ME IZ checkin FAIL AN "should not be caught here"
		O WEL
			ME IZ checkpointin
		KTHX
		ME IZ expectpointin 1

		PLZ
			DO NOT WANT NOOB
		O NOES WIN
			ME IZ checkpointin
		O WEL
			ME IZ checkpointin
		KTHX
		ME IZ expectpointin 3
	IF U SAY SO

	I IZ runnin
KTHX

O HAI IM nested_test IM LIEK test
	MAH name R "PLZ (nested)"
	HOW IZ I testin
		PLZ
			PLZ
				"test", DO NOT WANT IT
			O NOES BOTH SAEM IT AN "bug"
				BTW Not caught in this block
			O WEL
				ME IZ checkpointin
			KTHX
		O NOES BOTH SAEM IT AN "test"
			ME IZ checkpointin
		O NOES WIN
			ME IZ checkin FAIL AN "should not be caught here"
		O WEL
			ME IZ checkpointin
		KTHX
		ME IZ expectpointin 3
	IF U SAY SO

	I IZ runnin
KTHX

O HAI IM cross_procedural_exceptions_test IM LIEK test
	MAH name R "DO NOT WANT (cross-procedural)"

	HOW IZ I errorin
		DO NOT WANT NOOB
	IF U SAY SO

	HOW IZ I testin
		PLZ
			ME IZ errorin
			ME IZ checkin FAIL AN "should have failed by now"
		O NOES WIN
			ME IZ checkpointin
		KTHX
		ME IZ expectpointin 1
	IF U SAY SO

	I IZ runnin
KTHX

O HAI IM subexpr_exceptions_test IM LIEK test
	MAH name R "DO NOT WANT (subexpressions)"

	HOW IZ I errorin
		DO NOT WANT "deliberate"
	IF U SAY SO

	HOW IZ I srs, SRS ME IZ errorin, IF U SAY SO
	HOW IZ I i_has_a_liek, I HAS A thing ITZ LIEK ME IZ errorin, IF U SAY SO
	HOW IZ I i_has_a_itz, I HAS A thing ITZ ME IZ errorin, IF U SAY SO
	HOW IZ I i_has_a, SRS ME IZ errorin MKAY HAS A thing, IF U SAY SO
	HOW IZ I o_hai_im_liek, O HAI IM foo IM LIEK ME IZ errorin, KTHX, IF U SAY SO
	HOW IZ I how_iz_i, HOW IZ SRS ME IZ errorin MKAY testin, IF U SAY SO, IF U SAY SO
	HOW IZ I visible, VISIBLE ME IZ errorin, IF U SAY SO
	HOW IZ I gimmeh, GIMMEH SRS ME IZ errorin, IF U SAY SO
	HOW IZ I r_sink, SRS ME IZ errorin MKAY R NOOB, IF U SAY SO
	HOW IZ I r_source, I R ME IZ errorin, IF U SAY SO
	HOW IZ I is_now_a_type, NOOB IS NOW A SRS ME IZ errorin, IF U SAY SO
	HOW IZ I is_now_a_var, SRS ME IZ errorin MKAY IS NOW A NOOB, IF U SAY SO
	HOW IZ I mebbe, FAIL, O RLY?, YA RLY, MEBBE ME IZ errorin, OIC, IF U SAY SO
	HOW IZ I o_noes_liek, PLZ, DO NOT WANT NOOB, O NOES ITZ A SRS ME IZ errorin MKAY, KTHX, IF U SAY SO
	HOW IZ I o_noes, PLZ, DO NOT WANT NOOB, O NOES ME IZ errorin, KTHX, IF U SAY SO
	HOW IZ I found_yr, FOUND YR ME IZ errorin, IF U SAY SO
	HOW IZ I do_not_want, DO NOT WANT ME IZ errorin, IF U SAY SO
	HOW IZ I monadic, NOT ME IZ errorin, IF U SAY SO
	HOW IZ I dyadic_left, BOTH SAEM ME IZ errorin MKAY AN NOOB, IF U SAY SO
	HOW IZ I dyadic_right, BOTH SAEM NOOB AN ME IZ errorin, IF U SAY SO
	HOW IZ I variadic, SMOOSH ME IZ errorin, IF U SAY SO
	HOW IZ I maek_type, MAEK NOOB A SRS ME IZ errorin, IF U SAY SO
	HOW IZ I maek_val, MAEK ME IZ errorin MKAY A NOOB, IF U SAY SO
	HOW IZ I iz_me, SRS ME IZ errorin MKAY IZ checkin WIN AN "", IF U SAY SO
	HOW IZ I iz_arg, ME IZ checkin ME IZ errorin MKAY AN "", IF U SAY SO
	HOW IZ I mah, MAH SRS ME IZ errorin, IF U SAY SO
	HOW IZ I z, ME'Z SRS ME IZ errorin, IF U SAY SO
	HOW IZ I yarn, ":{SRS ME IZ errorin}:)", IF U SAY SO

	HOW IZ I testin
		BTW FIXME replace with a loop
		PLZ, ME IZ srs,           O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ i_has_a_liek,  O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ i_has_a_itz,   O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ i_has_a,       O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ o_hai_im_liek, O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ how_iz_i,      O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ visible,       O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ gimmeh,        O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ r_sink,        O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ r_source,      O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ is_now_a_type, O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ is_now_a_var,  O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ mebbe,         O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ o_noes_liek,   O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ o_noes,        O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ found_yr,      O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ do_not_want,   O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ monadic,       O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ dyadic_left,   O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ dyadic_right,  O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ variadic,      O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ maek_type,     O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ maek_val,      O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ iz_me,         O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ iz_arg,        O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ mah,           O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ z,             O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		PLZ, ME IZ yarn,          O NOES BOTH SAEM IT AN "deliberate", ME IZ checkpointin, KTHX
		BTW FIXME loops aren't tested here...

		ME IZ expectpointin 27
	IF U SAY SO

	I IZ runnin
KTHX

KTHXBAI