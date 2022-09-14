# Ethernaut challenge 8 Vault

The crux here is understanding that while the word `private` is often used throughout solidity programming, it is in fact used to limit a variable's scope, rather than the intuitive idea of accessibility.

We will use the web3 utility to read the private var 'password'.

```
web3.eth.getStorageAt(address, idx, function (error, result) {
      if (error) {
        reject(error);
      } else {
        resolve(result);
      }
```

Keep in mind that `getStorageAt` returns a promise, so there is a little extra to deal with here. 

Additionally the web3 utility can be used to further 'decrypt' the password => `web3.utils.hexToAscii()`