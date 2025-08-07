// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ERC4626Vault} from "../src/ERC4626Vault.sol";

contract ERC4626VaultTest is Test {
    ERC4626Vault public vault;
    address public depositor;
    address public admin;
    address public daiAddr;

    function setUp() public {
        vault = new ERC4626Vault(daiAddr, "BTOKEN", "BTK");
        depositor = address(0x1);
        admin = address(this);
        daiAddr = address(DAI());
    }

    function test_vaultDeposit() public {
        vm.deal(daiAddr, depositor, 2e18);
        vm.prank(depositor);
        vm.approve(1e18, address(vault));
        vm.prank(depositor);
        vault.deposit(10 ether, depositor);
    }
}
