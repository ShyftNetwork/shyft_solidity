pragma solidity ^0.4.19;

contract HelpMe {
	event emitMe();

	// uncomment this function to get a stack too deep error at compilation
function getUser(){

           int[] MyVariable1;
           int[] MyVariable2;
           int[] MyVariable3;
           int[] MyVariable4;
           int[] MyVariable5;
           int[] MyVariable6;
           int[] MyVariable7;
           int[] MyVariable8;
           int[] MyVariable9;
           int[] MyVariable10;
           int[] MyVariable11;
           int[] MyVariable12;
           int[] MyVariable13;
           int[] MyVariable14;
           int[] MyVariable15;
           int[] MyVariable16;

           MyVariable1 [0] = 3;
           return ();
       }

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

	function unbalancedStack() {
		uint iVar1;
		uint iVar2;
		uint iVar3;

	assembly
{
            iVar3 :=9
//		    { let iVar1 := add(iVar1, 1) }
		    iVar3 :=9
//		    { let iVar1 := add(iVar1, 1) }

		}

	}
	function emitEvent1() {
		emitMe(); // this will cause a warning with newer versions of solc
	}

}