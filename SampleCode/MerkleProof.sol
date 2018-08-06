pragma solidity ^0.4.23;
pragma substance;


contract Unique {
    string fn;

    string ln;

    bytes20  val;

    bytes32 sId;

    function function1() public {

        bytes memory x = new bytes(4);
        uint256 y= merkleprove(x, sId, sId);
    }

}
