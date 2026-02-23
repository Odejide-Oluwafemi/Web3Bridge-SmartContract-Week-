// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.3;

contract SaveEther {
    mapping (address => uint256) public balances;

    event DepositSuccessful(address indexed sender, uint256 indexed amount);
    event WithdrawSuccessful(address indexed receiver, uint256 indexed amount);

    function deposit() external payable {
        require (msg.value > 0, "Can't deposit zero value");
        balances[msg.sender] = balances[msg.sender] + msg.value;

        emit DepositSuccessful(msg.sender, msg.value);
    }

    function withdraw(uint amount) external {
        require (msg.sender != address(0), "Address zero detected");

        uint256 userSavings = balances[msg.sender];
        require (userSavings > 0, "Insufficient funds");

        balances[msg.sender] = userSavings - amount;

        (bool success, ) = msg.sender.call{value: balances[msg.sender]}("");
        require (success, "Transfer Failed");

        emit WithdrawSuccessful(msg.sender, amount);
    }

    function getUserSavings() external view returns (uint256) {
        return balances[msg.sender];
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    fallback() external payable { }
    receive() external payable { }
}