// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

contract ManaBank {
    // balances maps address to account balances
    mapping (address => uint256) private balances;

    constructor() public payable {

    }
}