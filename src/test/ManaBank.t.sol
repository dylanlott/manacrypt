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
}

