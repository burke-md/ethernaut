# Ethernaut challenge 18 Magic Numbewr

This challenge requires us to call a function and pass in the address of a contract. This particular contract must return the value '42' in no more than 10 opcodes. In order to acheive this there are a few pieces we must put together:

- Write and deploy a contract via bytecode alone
- Understand the two parts(create and runtime) of the bytecode

## Given code (runtime):
```
Step1: PUSH1 '42' (0x2A) onto the stack

60 2A

Step2: PUSH1 data location onto the stack

60 50

Step3: MSTORE (pop of location in memory to write, and data to be written, then write data to appropriate location)

52

Step4: PUSH1 size of data onto the stack (32 bytes base 10 is 0x20)

60 20 

Step5: PUSH1 location in memory of data

60 50

Step6: RETURN data from memory (pop off location and size)

F3
```

The bytecode for the run time portion of this contract is: 
`602A60505260206050F3`

## The creation bytecode:

The goal of the creation byte code is to copy the runtime bytecode into memory and return the size and location(in memory) of the runtime bytecode.

```
Step1: PUSH1 `10` (0x0A) onto stack (size of runtime code in bytes)

60 0A

Step2: PUSH1 unknown (will be determined by length of creation bytecode) location of runtime byte code (directly after creation code)

60 0C

Step3: PUSH1 0x00 onto stack - this is location in memory to write runtime bytecode too

60 00

Step4: CODECPOY Will pop three items off stack and move runtime to memory

39

Step5: PUSH1 0x0A push size of runtime bytecode onto stack

60 0A

Step6: PUSH1 0x00 push location(memory) of runtime byte code onto stack

60 00

Step7: RETURN Pops off size and location from stack and returns values

F3
```

Creation bytecode: `600A600C600039600A6000F3`

Complete bytecode is formed by concatinating the creation and runtime together (in that order)

`0x600A600C600039600A6000F3602A60505260206050F3`

## Hack:

Within the ethernaut terminal we will deploy our contract via bytecode

```
bytecode = '600A600C600039600A6000F3602A60505260206050F3'
tx = await web3.eth.sendTransaction({from: player, data: bytecode})
```

Note: `tx` will store an object returned from the command with some information we will need.

Now we will use this to call the function within ethernaut challenge 18:

` await contract.setSolver(tx.contractAddress);`