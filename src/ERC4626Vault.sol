//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import {ERC4626} from "lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC4626.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {Math} from "lib/openzeppelin-contracts/contracts/utils/math/Math.sol";
import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract ERC4626Vault is ERC4626 {
    using SafeERC20 for IERC20;
    using Math for uint256;

    IERC20 public immutable DAI;
    uint256 public constant stakingCap = 100_000 * 1e18; //100,000 Dai
    bool public isPaused;
    address owner;

    error stakingPaused();
    error stakingCapExceeded();
    error onlyOwnerAction();
    error InvalidTokenAddress();
    error invalidDepositAmount();
    error invalidWithdrawAmount();

    event deposited(uint256 amount);
    event withdrawSuccessful();
    event redeemed();

    modifier onlyWhenNotPaused() {
        if (isPaused == true) revert stakingPaused();
        _;
    }
    modifier withinStakingCap(uint256 amount) {
        if (super.totalAssets() + amount > stakingCap)
            revert stakingCapExceeded();
        _;
    }

    modifier onlyOwner() {
        if (owner != msg.sender) revert onlyOwnerAction();
        _;
    }

    constructor(
        address DaiTokenAddress,
        string memory name,
        string memory symbol
    ) ERC4626(IERC20(DaiTokenAddress)) ERC20(name, symbol) {
        owner = msg.sender;

        name = "BTOKEN";
        symbol = "BTK";

        if (DaiTokenAddress == address(0)) revert InvalidTokenAddress();

        DAI = IERC20(DaiTokenAddress);
    }

    // core functions
    function deposit(
        uint amount,
        address receiver
    )
        public
        override
        onlyWhenNotPaused
        withinStakingCap(amount)
        returns (uint256)
    {
        if (amount <= 0) revert invalidDepositAmount();
        if (receiver == address(0)) revert InvalidTokenAddress();
        if (amount > DAI.balanceOf(msg.sender)) revert invalidDepositAmount();
        if (amount > DAI.allowance(msg.sender, address(this)))
            revert invalidDepositAmount();

        emit deposited(amount);
        return super.deposit(amount, receiver);
    }

    function withdraw(
        uint amount,
        address receiver,
        address _owner
    ) public override onlyWhenNotPaused returns (uint256) {
        if (receiver == address(0) || _owner == address(0))
            revert InvalidTokenAddress();
        if (amount > super.balanceOf(_owner)) revert invalidWithdrawAmount();

        emit withdrawSuccessful();

        return super.withdraw(amount, receiver, _owner);
    }

    function mint(
        uint256 shares,
        address receiver
    ) public override onlyWhenNotPaused returns (uint256) {
        if (receiver == address(0)) revert InvalidTokenAddress();
        if (shares <= 0) revert invalidDepositAmount();
        if (shares > DAI.balanceOf(msg.sender)) revert invalidDepositAmount();
        if (shares > DAI.allowance(msg.sender, address(this)))
            revert invalidDepositAmount();

        emit redeemed();
        return super.mint(shares, receiver);
    }
}
