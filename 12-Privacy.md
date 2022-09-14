# Ethernaut challenge 12 Privacy

Very similar to challenge 8, this challenge is about reading 'private' vars. The difference however, we must navigate packed vars, where they may or may not be in a storage slot, alone or packed :

```
  SLOT0     bool public locked = true;
  SLOT1     uint256 public ID = block.timestamp;
  SLOW2     uint8 private flattening = 10;
  SLOT2     uint8 private denomination = 255;
  SLOT2     uint16 private awkwardness = uint16(now);
  SLOT3,4,5 bytes32[3] private data;
```
Where each index of the data array will take up a full 32Byte storage slot.

```
  function unlock(bytes16 _key) public {
    require(_key == bytes16(data[2]));
    locked = false;
  }
```

We will need to extract the information in the `data` array at index 2 and cast it to a type  `bytes16`.

This can be done using the web3 utility as before. 

```
web3.eth.getStorageAt(address, idx, function (error, result) {
      if (error) {
        reject(error);
      } else {
        resolve(result);
      }
    )
```