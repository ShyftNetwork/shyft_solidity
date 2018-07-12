pragma solidity ^0.4.19;

contract HelpMe {
	event emitMe();

	// uncomment this function to get a stack too deep error at compilation
/*	function stackTooDeep(
		uint _a,
		uint _b,
		uint _c,
		uint _d,
		uint _e,
		uint _f,
		uint _g,
		uint _h,
		uint _i,
		uint _j,
		uint _k,
		uint _l,
		uint _m,
		uint _n,
		uint _o,
		uint _p){}

	function vmError() {
		require(false);
		//revert();
	}

	function useAllGas() {
		assert(false);
		//throw();
	}

	function emitEvent() {
		emitMe(); // this will cause a warning with newer versions of solc
	}
*/
	function unbalancedStack() {
		uint iVar1;
		uint iVar2;
		uint iVar3;

		assembly

		iVar3
		    iVar2
//		    { let iVar1 := add(iVar1, 1) }
		    iVar3 :=9
		}
	}
	function emitEvent() {
		emitMe(); // this will cause a warning with newer versions of solc
	}
}