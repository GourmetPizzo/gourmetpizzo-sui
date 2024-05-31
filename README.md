# GourmetPizzo Contracts

This repository contains five main Sui Move modules: `Mission`, `PizzoNFT`, `PizzoToken`, `Total`, and `User`. Each module provides specific functionalities related to user missions, NFTs, tokens, and user management.

## Modules

### 1. Mission

**Contract Address:** `0x98604b50a89c6bdfa7f6bc9d632df7da2e322c4738586b9cc417f4fe8051c2be`

**Purpose:** Tracks user missions, including attendance, Twitter check-ins, and invite status.

**Methods:**
- `create_user_mission(ctx: &mut TxContext): Mission` - Creates a new mission for a user.
- `check_in(mission: &mut Mission, today: u64)` - Marks attendance for the current day.
- `twitter_check(mission: &mut Mission)` - Marks the Twitter check-in as completed.
- `invite_check(mission: &mut Mission)` - Marks the invite check-in as completed.
- `get_twitter_status(mission: &Mission): bool` - Returns the Twitter check-in status.
- `get_invite_status(mission: &Mission): bool` - Returns the invite check-in status.
- `get_attendance_status(mission: &Mission, today: u64): bool` - Returns the attendance status for a specific day.
- `create_and_transfer_mission(ctx: &mut TxContext)` - Helper function to create a mission and transfer it to a user.
- `test_create_user_mission()` - Test function for creating a user mission.
- `test_check_in()` - Test function for the check-in functionality.
- `test_twitter_check()` - Test function for the Twitter check functionality.
- `test_invite_check()` - Test function for the invite check functionality.
- `test_get_mission_status()` - Test function for getting mission status.
- `test_drop_mission()` - Test function for dropping a mission.

### 2. PizzoNFT

**Contract Address:** `0x98604b50a89c6bdfa7f6bc9d632df7da2e322c4738586b9cc417f4fe8051c2be`

**Purpose:** Mints and manages custom NFTs with metadata on Sui.

**Methods:**
- `name(nft: &PizzoNFT): &string::String` - Returns the name of the NFT.
- `description(nft: &PizzoNFT): &string::String` - Returns the description of the NFT.
- `url(nft: &PizzoNFT): &Url` - Returns the URL of the NFT.
- `mint_to_sender(name: vector<u8>, description: vector<u8>, url: vector<u8>, ctx: &mut TxContext)` - Mints a new NFT and transfers it to the sender.
- `transfer(nft: PizzoNFT, recipient: address, ctx: &mut TxContext)` - Transfers the NFT to a recipient.
- `update_description(nft: &mut PizzoNFT, new_description: vector<u8>, ctx: &mut TxContext)` - Updates the description of the NFT.
- `burn(nft: PizzoNFT, ctx: &mut TxContext)` - Burns the NFT.

### 3. PizzoToken

**Contract Address:** `0x98604b50a89c6bdfa7f6bc9d632df7da2e322c4738586b9cc417f4fe8051c2be`

**Purpose:** Manages fungible tokens (PIZZOTOKEN) with minting, burning, and transfer functionalities.

**Methods:**
- `init(witness: PIZZOTOKEN, ctx: &mut TxContext)` - Initializes the token contract and sets up the treasury cap.
- `mint(treasury_cap: &mut TreasuryCap<PIZZOTOKEN>, amount: u64, recipient: address, ctx: &mut TxContext)` - Mints new tokens and transfers them to a recipient.
- `burn(treasury_cap: &mut TreasuryCap<PIZZOTOKEN>, coin: Coin<PIZZOTOKEN>)` - Burns tokens.
- `balance_of(owner: address): u64` - Returns the balance of tokens for a specific owner.
- `test_init(ctx: &mut TxContext)` - Test function for initializing the token contract.

### 4. Total

**Contract Address:** `0x98604b50a89c6bdfa7f6bc9d632df7da2e322c4738586b9cc417f4fe8051c2be`

**Purpose:** Integrates user, mission, and token reward management.

**Methods:**
- `create_total(ctx: &mut TxContext): Total` - Creates a new Total object.
- `mint_tokens(treasury_cap: &mut TreasuryCap<PIZZOTOKEN>, amount: u64, recipient: address, ctx: &mut TxContext)` - Mints tokens and transfers them to a recipient.
- `get_token_balance(owner: address): u64` - Returns the token balance of a specific owner.
- `awards_mint(treasury_cap: &mut TreasuryCap<PIZZOTOKEN>, recipients: vector<address>, amounts: vector<u64>, ctx: &mut TxContext)` - Mints and awards tokens to multiple recipients.
- `user_game_end(total: &mut Total, user_addr: address, points: u64, ctx: &mut TxContext)` - Ends a user's game session and updates their points.
- `check_mission(total: &mut Total, mission_addr: address, mission_type: vector<u8>, today: u64, ctx: &mut TxContext)` - Checks and updates the status of a mission.

### 5. User

**Contract Address:** `0x98604b50a89c6bdfa7f6bc9d632df7da2e322c4738586b9cc417f4fe8051c2be`

**Purpose:** Tracks user points and scores.

**Methods:**
- `create_user(ctx: &mut TxContext): User` - Creates a new user.
- `user_point_solstice(point: &Point, cur_point: u64): u64` - Returns the highest single point score.
- `update_point(user: &mut User, cur_point: u64, ctx: &mut TxContext)` - Updates a user's points.
- `get_user_point(user: &User, addr: address): UserPoints` - Returns a user's points.
- `test_user_module()` - Test function for the user module.

This README provides a summary of each module, including the contract address, purpose, and available methods.