// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";

import {Todo} from "src/Day 1/Todo.sol";
import {MyERC20} from "src/Day 2/MyERC20.sol";
import {SaveEther} from "src/Day 2/SaveEther.sol";
import {SchoolManagementSystem} from "src/Day 3/AssignmentDay3.sol";
import {SaveToken} from "src/Day 3/ClassworkDay3.sol";

contract DeployScript is Script {
    Todo public todo;
    MyERC20 public myERC20;
    SaveEther public saveEther;
    SchoolManagementSystem public schoolManagementSystem;
    SaveToken public saveToken;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        todo = new Todo();
        saveEther = new SaveEther();
        myERC20 = new MyERC20("School Token", "STK", 18, 10000e18);

        schoolManagementSystem = new SchoolManagementSystem(myERC20);
        saveToken = new SaveToken(myERC20);

        vm.stopBroadcast();
    }
}
