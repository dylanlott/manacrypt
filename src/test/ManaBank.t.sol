pragma solidity >=0.8.0;

import {console} from "forge-std/console.sol";
import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";

import {Utils} from "./utils/Utils.sol";
import { ManaBank } from "../ManaBank.sol";

contract ManaBankSetup is ManaBank, Test {
    Utils internal utils;
    address payable[] internal users;
    
    address internal alice;
    address internal bob;

    // setup will make 2 test users with 100 ether
    function setUp() public virtual {
        utils = new Utils();
        users = utils.createUsers(2);
        alice = users[0];
        vm.label(alice, "Alice");
        bob = users[1];
        vm.label(bob, "Bob");
    }
}

contract WhenDepositingTokens is ManaBankSetup {
    function setUp() public virtual override {
        ManaBankSetup.setUp();
        console.log("When depositing tokens into ManaBank");
    }

    function transferTokenToBank(
        address from,
        uint256 transferAmount
    ) public returns (uint256) {
        vm.prank(from);
        return this.deposit{value: transferAmount}();
    }

    function testDepositOne() public {
        uint256 amount  = transferTokenToBank(alice, 1);
        assertEq(amount, 1, "failed to deposit correct amount");
        vm.prank(alice);
        assertEq(this.balance(), 1);
    }

    function testDepositDecimal() public {
        uint256 amount  = transferTokenToBank(alice, 1 ether/2);
        assertEq(amount, 1 ether/2, "failed to deposit correct amount");
        vm.prank(alice);
        assertEq(this.balance(), 1 ether/2, "failed to deposit correct amount");
    }
}


contract WhenWithdrawingTokens is ManaBankSetup {
    function setUp() public virtual override {
        ManaBankSetup.setUp();
        vm.prank(alice);
        this.deposit{value: 50}();
        vm.prank(bob);
        this.deposit{value: 25}();
        console.log("When withdrawing tokens from ManaBank");
    }

    function withdrawFromBank(
        address withdrawer,
        uint256 amount
    ) public returns (uint256) {
        vm.prank(withdrawer);
        return this.withdraw(amount);
    }

    function testWithdrawHalf() public {
        vm.prank(alice);
        uint256 full = this.balance();
        uint256 remaining = withdrawFromBank(alice, full / 2);
        assertEq(remaining, 25);
    }
}