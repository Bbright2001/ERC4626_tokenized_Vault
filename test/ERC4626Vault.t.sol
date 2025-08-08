// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ERC4626Vault} from "../src/ERC4626Vault.sol";

contract ERC4626VaultTest is Test {
    ERC4626Vault public vault;
    address public depositor;
    address public admin;
    address public daiAddr;

    function setUp() public {}
}
