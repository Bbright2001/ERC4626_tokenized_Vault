## ERC4626 TOKENIZED VAULT IMPLEMENTATION

## ✅ Core Setup
Define contract that inherits from ERC4626

Accepts  ANY ERC20 as the underlying asset

## 📦 State Variables
dai: ERC20 token address (DAI)

stakingCap: Maximum allowed total assets

bool isPaused: Flag to pause staking

## 🧩 Libraries (using  for)
Use a SafeERC20 library for DAI transfers

using SafeERC20 for IERC20;

Optionally: Math library for precision math operations

## 🛡️ Modifiers
onlyWhenNotPaused: Restricts functions when isPaused is true

withinStakingCap: Ensures deposit doesn’t exceed stakingCap

onlyOwner: Access control (if needed)

## Lifecycle Functions
1. Constructor
Initialize DAI address, vault metadata

Set staking cap (optional)

## Core Vault Functions (ERC-4626 overrides)
2. deposit(amount, receiver)
Modifier: onlyWhenNotPaused, withinStakingCap

Use library to safely transfer DAI

  transfer DAI from sender to vault
    calculate shares to mint
    mint shares to receiver
    return shares minted


3. withdraw(amount, receiver, owner)
Modifier: onlyWhenNotPaused

Burn shares

Use library to transfer DAI back to receiver

4. mint(shares, receiver)
Similar to deposit, but user specifies shares

Calculate required DAI amount

5. redeem(shares, receiver, owner)
Similar to withdraw, user specifies shares to burn

🔍 View Functions
6. totalAssets()
Return total amount of DAI held

7. previewDeposit(amount)
Simulate how many shares will be minted for a deposit

8. previewWithdraw(amount)
Simulate how many shares need to be burned for a withdrawal

## Admin Functions (Owner-only)
9. pauseVault()
Modifier: onlyOwner

Set isPaused = true

10. unpauseVault()
Modifier: onlyOwner

Set isPaused = false

11. setStakingCap(newCap)
Modifier: onlyOwner

Update the staking limit

🧪 Optional: Testing Utilities
forceDepositWithoutTransfer() — for mock testing

emergencyWithdraw() — for rescue scenarios

## building difficulties
