# FakeRAID devices detection
[[ $USEDMRAID = [Yy][Ee][Ss] && -x $(type -P dmraid) ]] &&
	status "Activating FakeRAID arrays" dmraid -i -ay
