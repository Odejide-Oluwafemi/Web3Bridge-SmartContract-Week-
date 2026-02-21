# Day 1 Assignment
Implement the editTask function
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Todo {
    struct Task {
        uint8 id;
        string title;
        bool isComplete;
        uint256 timeCompleted;
    }

    Task[] public tasks;
    uint8 todo_id;

    function createTask(string memory _title) external {
        todo_id = todo_id + 1;
        // Task memory task = Task(id, _title, false, 0);
        // task id = 1
        Task memory task = Task({id: todo_id, title: _title, isComplete: false, timeCompleted: 0});
        tasks.push(task);
        // this helps us to increment the id for subsequent calls or tasks
        // that would be created.
    }

    function getAllTasks() external view returns (Task[] memory) {
        return tasks;
    }

    function markComplete(uint8 _id) external {
        for (uint8 i; i < tasks.length; i++) {
            if (tasks[i].id == _id) {
                if (!tasks[i].isComplete) {
                    tasks[i].isComplete = true;
                    tasks[i].timeCompleted = block.timestamp;
                }
            }
        }
    }

    function deleteTask(uint8 _id) external {
        for (uint8 i; i < tasks.length; i++) {
            if (tasks[i].id == _id) {
                tasks[i] = tasks[tasks.length - 1];
                tasks.pop();
            }
        }
    }

    function editTask(uint8 _id, string memory _title, bool _isComplete) external {
        for (uint8 i; i < tasks.length; i++) {
            if (tasks[i].id == _id) {
                tasks[i].title = _title;
                tasks[i].isComplete = _isComplete;

                if (!_isComplete) {
                    tasks[i].timeCompleted = 0;
                }
            }
        }
    }
}
```

---

# Day 2 Assignment

### Assignment 1

## requirements

- Where are your structs, mappings and arrays stored.
- How they behave when executed or called.
- Why don't you need to specify memory or storage with mappings

```
When declared at the contract level (outside a function), they are all stored in Storage (written to the blockchain).

Within the scope of a function, whenever a Struct or Array is refereced, it is stored in Memory.

Mappings on the other hand are still stored in Storage even when referenced in a function. They are storage only types, i.e. they cannot be created dynamically, and do not store their data contiguously.

```

---

### Assignment 2

## requirements

- Look up ERC20 standard Understand it like your life depends on it, because it does.
- Write in Code the complete ERC20 implementation from scratch without using any libraries.

```solidity
contract MyERC20 is IMyERC20 {
    // Errors
    error MyERC20__AddressZeroError();
    error MyERC20__InsufficientFunds();
    error MyERC20__InsufficientAllowance();
    error MyERC20__ThisAmountOfNewTokenCannotBePurchased();

    uint256 public constant ETH_TO_TOKEN_PRICE = 0.001 ether; // this means that 0.001 ETH == 1 unit of Token, so 1 ETH will be equal to 1000 token
    string private NAME;
    string private SYMBOL;
    uint8 private DECIMALS;
    uint256 private TOTAL_SUPPLY;
    address public immutable OWNER;

    mapping(address owner => uint256 amount) _balances;
    mapping(address owner => mapping(address spender => uint256 amount)) _allowances;

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _totalSupply
    ) {
        NAME = _name;
        SYMBOL = _symbol;
        DECIMALS = _decimals;
        TOTAL_SUPPLY = _totalSupply;
        _balances[address(this)] = _totalSupply;
        OWNER = msg.sender;
    }

    function buyToken() external payable returns (bool) {
        uint amountBought = getTokenQuantityForEth(msg.value);

        if (balanceOf(address(this)) < amountBought)
            revert MyERC20__ThisAmountOfNewTokenCannotBePurchased();

        _balances[address(this)] -= amountBought;
        _balances[msg.sender] += amountBought;

        emit Transfer(address(this), msg.sender, amountBought);

        return true;
    }

    modifier onlyOwner() {
        require(msg.sender == OWNER, "Only Owner can call this function");
        _;
    }

    function withdraw() external onlyOwner {
        (bool success, ) = payable(OWNER).call{value: address(this).balance}(
            ""
        );
        require(success);
    }

    function getTokenQuantityForEth(uint ethAmount) public pure returns (uint) {
        return ethAmount / ETH_TO_TOKEN_PRICE;
    }

    function checkRemainingSupply() external view returns (uint) {
        return balanceOf(address(this));
    }

    function balanceOf(address _owner) public view returns (uint256) {
        if (_owner == address(0)) revert MyERC20__AddressZeroError();
        return _balances[_owner];
    }

    function transfer(
        address _to,
        uint256 _value
    ) public returns (bool success) {
        if (_balances[msg.sender] < _value) revert MyERC20__InsufficientFunds();

        _balances[msg.sender] -= _value;
        _balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool) {
        if (_allowances[_from][msg.sender] < _value)
            revert MyERC20__InsufficientAllowance();

        if (_balances[_from] < _value) revert MyERC20__InsufficientFunds();

        _balances[_from] -= _value;
        _balances[_to] += _value;
        _allowances[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        if (!(_balances[msg.sender] > 0 && _balances[msg.sender] >= _value))
            revert MyERC20__InsufficientFunds();

        _allowances[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) public view returns (uint256) {
        return _allowances[_owner][_spender];
    }

    function name() external view override returns (string memory) {
        return NAME;
    }

    function decimals() external view override returns (uint256) {
        return DECIMALS;
    }

    function totalSupply() external view override returns (uint256) {
        return TOTAL_SUPPLY;
    }

    receive() external payable {}
}
```

---

# Day 3
### Classwork
Write a smart contract that can save both ERC20 and ether for a user.

Users must be able to:
* check individual balances,
* deposit or save in the contract.
* withdraw their savings

### Assignment
Create a School management system where people can:

- Register students & Staffs.
- Pay School fees on registration.
- Pay staffs also.
- Get the students and their details.
- Get all Staffs.
- Pricing is based on grade / levels from 100 - 400 level.
- Payment status can be updated once the payment is made which should include the timestamp.

---

# Day 6: Assessment
### Deployments
* Todo: [0x6fdE1CDfD96e56a9713751D4aA51862389A9E6A5](https://sepolia-blockscout.lisk.com/address/0x6fdE1CDfD96e56a9713751D4aA51862389A9E6A5?tab=index)
* SaveEther: [0x03e0Db364E8E721b232602eeB7CE80Da37875e5e](https://sepolia-blockscout.lisk.com/address/0x03e0Db364E8E721b232602eeB7CE80Da37875e5e)
* MyERC20: [0xf7E57954868f91b6e4ace2eFD776c31b380d1434](https://sepolia-blockscout.lisk.com/address/0xf7E57954868f91b6e4ace2eFD776c31b380d1434)
* School Management: [0xF2e984a6daD2F590A89Dc4487B951ba599607a75](https://sepolia-blockscout.lisk.com/address/0xF2e984a6daD2F590A89Dc4487B951ba599607a75)
* SaveToken: [0xC459c1eF554bA4C918a75BFA95060622261B6BE0](https://sepolia-blockscout.lisk.com/address/0xC459c1eF554bA4C918a75BFA95060622261B6BE0)

###  Added Task
* \- Remove a registered student
* \- Suspend Staff