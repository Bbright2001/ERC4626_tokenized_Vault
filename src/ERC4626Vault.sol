//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import {ERC4626} from "lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC4626.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/utils/safeERC20.sol";
import {Math} from "lib/openzeppelin-contracts/contracts/utils/math/Math.sol";

contract ERC4626Vault is ERC4626 {
    using SafeERC20 for IERC20;
    using Math for uint256;


    IERC20 public immutable DAI;
    uint256 public constant stakingCap = 100_000 ** 1e18; //100,000 Dai
    bool public isPaused;
    address owner

    error stakingPaused();
    error stakingCapExceeded();
    error onlyOwnerAction();
    error InvalidTokenAddress()

    modifier onlyWhenNotPaused() {
        if (isPaused == true) revert stakingPaused();
        _;
    }
    modifier withinStakingCap(uint256 amount) {
        if (totalAsset() + amount <= stakingCap) revert stakingCapExceeded();
        _;
    }

    modifier onlyOwner() {
        if ( owner != msg.sender) revert onlyOwnerAction();
        _;
    }

    constructor 
    (address DaiTokenAddress,
    string memory BTOKEN,
    string memory BTK)
    ERC4626(IERC20(DaiTokenAddress))
    ERC20(BTOKEN, BTK)
     public{
        owner = msg.sender;

        if (DaiTokenAddress == address(0)) revert InvalidTokenAddress();

         DAI = IERC20(DaiTokenAddress);
    }
}
