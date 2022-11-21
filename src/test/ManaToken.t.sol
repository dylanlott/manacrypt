// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {console} from "forge-std/console.sol";
import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";

import {Utils} from "./utils/Utils.sol";
import {ManaToken} from "../ManaToken.sol";

contract ManaBaseSetup is ManaToken, Test {
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

contract WhenTransferringManaTokens is ManaBaseSetup {
    uint256 internal maxTransferAmount = 12e18;

    function setUp() public virtual override {
        ManaBaseSetup.setUp();
        console.log("When transferring ManaTokens...");
    }
    
    function transferManaToken(
        address from, 
        address to, 
        uint256 amount
    ) public returns (bool) {
        vm.prank(from);
        return this.transfer(to, amount);
    }
}

contract WhenAliceHasSufficientFunds is WhenTransferringManaTokens {
    using stdStorage for StdStorage;
    uint256 internal mintAmount = maxTransferAmount;

    function setUp() public override {
        WhenTransferringManaTokens.setUp();
        console.log("when Alice has sufficient funds...");
        // mint the max amount for test
        _mint(alice, mintAmount);
    }

    function itTransfersManaAmountCorrectly(
        address from, 
        address to,
        uint256 txAmount
    ) public {
        uint256 fromBalanceBefore = balanceOf(from);
        bool success = transferManaToken(from, to, txAmount);
        assertTrue(success);
        assertEqDecimal(balanceOf(from), fromBalanceBefore - txAmount, decimals());
    }

    function testTransferHalfManaTokens() public {
        itTransfersManaAmountCorrectly(alice, bob, maxTransferAmount / 2);
    }
}