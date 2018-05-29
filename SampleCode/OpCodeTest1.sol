pragma solidity ^0.4.21;
pragma substance;
contract Unique {

string fn;
string ln;
bytes20  val;
bytes32 sId;

	function function1(string s, string y, bytes20 i) public returns (bytes20){
	    	fn =s;
    		ln =y;
    		sId =i;
address AttestAddr;
uint64 RlpDict;
uint64 uiRevokeRet;
uint256 ThirdInput;
uint256 xx;
uint256 uiNonce;
bool bRetVal;
//byte ReturnValue="";
xx =0;
ThirdInput=0;
	getattest(RlpDict,RlpDict);
	bRetVal=checktattestvalid(AttestAddr,uiNonce);
	uiRevokeRet=getrevoke(AttestAddr,RlpDict);
	uiRevokeRet=topoint(AttestAddr,RlpDict);
    	//keccak256(s,y,i);
	}

	function getOut()constant public returns (bytes20 ){
    		return val;
	}
}

