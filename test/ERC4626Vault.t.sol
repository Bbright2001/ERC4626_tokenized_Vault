// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ERC4626Vault} from "../src/ERC4626Vault.sol";
import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor(string memory MockDaiToken, string memory MDT) ERC20("MockDaiToken", "MDT") {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

contract ERC4626VaultTest is Test {
    ERC4626Vault public vault;
    address public depositor;
    address public admin;
    MockERC20 public mockDai;

    function setUp() public {
        mockDai = new MockERC20("MockDaiToken", "MDT");
        vault = new ERC4626Vault(address(mockDai), "TestVaultToken", "TVT");
        depositor = address(0x1);
        admin = address(this);

        mockDai.mint(depositor, 1000 * 1e18);
    }

    function test_deposit() public {
        vm.startPrank(depositor);
        console.log(vault.balanceOf(depositor));
        console.log("MockDai balance: ", mockDai.balanceOf(depositor));
        mockDai.approve(address(vault), 1000 * 1e18);
        assertEq(mockDai.allowance(depositor, address(vault)), 1000 * 1e18);
        vault.deposit(200 * 1e18, depositor);
        assertEq(vault.balanceOf(depositor), 200 * 1e18);
        assertEq(mockDai.balanceOf(address(vault)), 200 * 1e18);
        vm.stopPrank();
    }

    function test_withdraw() public {
        vm.startPrank(depositor);
        mockDai.approve(address(vault), 1000 * 1e18);
        vault.deposit(300 * 1e18, depositor);
        vault.withdraw(200 * 1e18, depositor, depositor);
        assertEq(mockDai.balanceOf(address(vault)), 100 * 1e18);
    }
}
