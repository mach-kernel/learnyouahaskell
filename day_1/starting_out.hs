doubleMe x = x + x

-- doubleUs x y = x*2 + y*2
doubleUs x y = (doubleMe x) + (doubleMe y)

doubleSmallNumber x = if x > 100
	then x
	else x * 2

doubleSmallNumberInline x = if x > 100 then x else x*2

doubleSmallNumberAnd1Anyway x = (if x > 100 then x else x*2) + 1