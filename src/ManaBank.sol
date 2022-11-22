// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

contract ManaBank {
    // balances maps address to account balances
    mapping (address => uint256) private balances;
    // the owner of the bank contract.
    address public owner;
    // constructor sets the owner to the msg.sender
    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "not owner"); 
        _;
    } 

    // deposit a non-zero amount into the bank. it returns the 
    // user's balance in the bank after the deposit.
    function deposit() public payable returns (uint256) {
        // increment balance by amount sent to contract
        require(msg.value != 0);
        balances[msg.sender] += msg.value;
        return balances[msg.sender];
    }

    // balance returns the sender's balance in the ManaBank 
    function balance() public view returns (uint256) {
        return balances[msg.sender];
    }

    // withdraw checks that the amount is a valid withdrawal amount 
    // and then transfers it to the account and returns the sender's 
    // remaining balance in the bank.
    function withdraw(uint256 amount) public returns (uint256) {
        require(amount <= balances[msg.sender], "insufficient funds");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        return balances[msg.sender];
    }
}