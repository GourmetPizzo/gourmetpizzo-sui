# GourmetPizzo Contracts

This repository contains five main Sui Move modules: `Mission`, `PizzoNFT`, `PizzoToken`, `Total`, and `User`. Each module provides specific functionalities related to user missions, NFTs, tokens, and user management.


```plaintext
+-------------------+        +-------------------+        +-------------------+
|                   |        |                   |        |                   |
|     Mission       |------->|       User        |<------>|    PizzoNFT       |
|                   |        |                   |        |                   |
|  - create         |        |  - create_user    |        |  - mint           |
|  - check_in       |        |  - update_point   |        |  - transfer       |
|  - twitter_check  |        |  - get_user_point |        |  - update_desc.   |
|  - invite_check   |        |                   |        |  - burn           |
+-------------------+        +-------------------+        +-------------------+
        ^                                                       ^
        |                                                       |
        |                                                       |
        |                                                       |
        |                                                       |
        v                                                       v
+-------------------+                                         +-------------------+
|                   |                                         |                   |
|      Total        |---------------------------------------->|    PizzoToken     |
|                   |                                         |                   |
|  - create_total   |                                         |  - init           |
|  - mint_tokens    |                                         |  - mint           |
|  - get_balance    |                                         |  - burn           |
|  - award_tokens   |                                         |  - balance_of     |
|  - end_game       |                                         |                   |
|  - check_mission  |                                         |                   |
+-------------------+                                         +-------------------+
```

### Legend:

- **Mission Module**: Manages user missions including attendance, Twitter check-ins, and invite status.
- **User Module**: Tracks user points and scores.
- **PizzoNFT Module**: Mints and manages custom NFTs.
- **PizzoToken Module**: Manages fungible tokens with minting, burning, and transferring functionalities.
- **Total Module**: Integrates user, mission, and token reward management.

### Module Interactions:

- The `Mission` module updates user activities and sends data to the `User` module.
- The `User` module maintains user records and interacts with the `Mission` and `Total` modules.
- The `PizzoNFT` module mints and transfers NFTs based on user achievements tracked by the `Total` and `User` modules.
- The `PizzoToken` module mints and manages tokens, integrated with the `Total` module for awarding tokens to users.
- The `Total` module acts as a central hub, coordinating interactions between other modules to manage missions, user data, and rewards.


## Modules

### 1. Mission

**Contract Address:** `0x98604b50a89c6bdfa7f6bc9d632df7da2e322c4738586b9cc417f4fe8051c2be`  
**Purpose:** Tracks user missions, including attendance, Twitter check-ins, and invite status.

| Method | Description | Parameters | Returns |
| ------ | ----------- | ---------- | ------- |
| `create_user_mission(ctx: &mut TxContext): Mission` | Creates a new mission for a user. | `ctx: &mut TxContext` - Transaction context. | `Mission` |
| `check_in(mission: &mut Mission, today: u64)` | Marks attendance for the current day. | `mission: &mut Mission` - The mission to update. `today: u64` - The current day timestamp. | - |
| `twitter_check(mission: &mut Mission)` | Marks the Twitter check-in as completed. | `mission: &mut Mission` - The mission to update. | - |
| `invite_check(mission: &mut Mission)` | Marks the invite check-in as completed. | `mission: &mut Mission` - The mission to update. | - |
| `get_twitter_status(mission: &Mission): bool` | Returns the Twitter check-in status. | `mission: &Mission` - The mission to query. | `bool` |
| `get_invite_status(mission: &Mission): bool` | Returns the invite check-in status. | `mission: &Mission` - The mission to query. | `bool` |
| `get_attendance_status(mission: &Mission, today: u64): bool` | Returns the attendance status for a specific day. | `mission: &Mission` - The mission to query. `today: u64` - The day timestamp to check. | `bool` |
| `create_and_transfer_mission(ctx: &mut TxContext)` | Helper function to create a mission and transfer it to a user. | `ctx: &mut TxContext` - Transaction context. | - |

### 2. PizzoNFT

**Contract Address:** `0x98604b50a89c6bdfa7f6bc9d632df7da2e322c4738586b9cc417f4fe8051c2be`  
**Purpose:** Mints and manages custom NFTs with metadata on Sui.

| Method | Description | Parameters | Returns |
| ------ | ----------- | ---------- | ------- |
| `name(nft: &PizzoNFT): &string::String` | Returns the name of the NFT. | `nft: &PizzoNFT` - The NFT to query. | `&string::String` |
| `description(nft: &PizzoNFT): &string::String` | Returns the description of the NFT. | `nft: &PizzoNFT` - The NFT to query. | `&string::String` |
| `url(nft: &PizzoNFT): &Url` | Returns the URL of the NFT. | `nft: &PizzoNFT` - The NFT to query. | `&Url` |
| `mint_to_sender(name: vector<u8>, description: vector<u8>, url: vector<u8>, ctx: &mut TxContext)` | Mints a new NFT and transfers it to the sender. | `name: vector<u8>` - The name of the NFT. `description: vector<u8>` - The description of the NFT. `url: vector<u8>` - The URL of the NFT. `ctx: &mut TxContext` - Transaction context. | - |
| `transfer(nft: PizzoNFT, recipient: address, ctx: &mut TxContext)` | Transfers the NFT to a recipient. | `nft: PizzoNFT` - The NFT to transfer. `recipient: address` - The address of the recipient. `ctx: &mut TxContext` - Transaction context. | - |
| `update_description(nft: &mut PizzoNFT, new_description: vector<u8>, ctx: &mut TxContext)` | Updates the description of the NFT. | `nft: &mut PizzoNFT` - The NFT to update. `new_description: vector<u8>` - The new description. `ctx: &mut TxContext` - Transaction context. | - |
| `burn(nft: PizzoNFT, ctx: &mut TxContext)` | Burns the NFT. | `nft: PizzoNFT` - The NFT to burn. `ctx: &mut TxContext` - Transaction context. | - |

### 3. PizzoToken

**Contract Address:** `0x98604b50a89c6bdfa7f6bc9d632df7da2e322c4738586b9cc417f4fe8051c2be`  
**Purpose:** Manages fungible tokens (PIZZOTOKEN) with minting, burning, and transfer functionalities.

| Method | Description | Parameters | Returns |
| ------ | ----------- | ---------- | ------- |
| `init(witness: PIZZOTOKEN, ctx: &mut TxContext)` | Initializes the token contract and sets up the treasury cap. | `witness: PIZZOTOKEN` - The witness for initialization. `ctx: &mut TxContext` - Transaction context. | - |
| `mint(treasury_cap: &mut TreasuryCap<PIZZOTOKEN>, amount: u64, recipient: address, ctx: &mut TxContext)` | Mints new tokens and transfers them to a recipient. | `treasury_cap: &mut TreasuryCap<PIZZOTOKEN>` - The treasury cap. `amount: u64` - The amount to mint. `recipient: address` - The recipient address. `ctx: &mut TxContext` - Transaction context. | - |
| `burn(treasury_cap: &mut TreasuryCap<PIZZOTOKEN>, coin: Coin<PIZZOTOKEN>)` | Burns tokens. | `treasury_cap: &mut TreasuryCap<PIZZOTOKEN>` - The treasury cap. `coin: Coin<PIZZOTOKEN>` - The coin to burn. | - |
| `balance_of(owner: address): u64` | Returns the balance of tokens for a specific owner. | `owner: address` - The owner address. | `u64` |
| `test_init(ctx: &mut TxContext)` | Test function for initializing the token contract. | `ctx: &mut TxContext` - Transaction context. | - |

### 4. Total

**Contract Address:** `0x98604b50a89c6bdfa7f6bc9d632df7da2e322c4738586b9cc417f4fe8051c2be`  
**Purpose:** Integrates user, mission, and token reward management.

| Method | Description | Parameters | Returns |
| ------ | ----------- | ---------- | ------- |
| `create_total(ctx: &mut TxContext): Total` | Creates a new Total object. | `ctx: &mut TxContext` - Transaction context. | `Total` |
| `mint_tokens(treasury_cap: &mut TreasuryCap<PIZZOTOKEN>, amount: u64, recipient: address, ctx: &mut TxContext)` | Mints tokens and transfers them to a recipient. | `treasury_cap: &mut TreasuryCap<PIZZOTOKEN>` - The treasury cap. `amount: u64` - The amount to mint. `recipient: address` - The recipient address. `ctx: &mut TxContext` - Transaction context. | - |
| `get_token_balance(owner: address): u64` | Returns the token balance of a specific owner. | `owner: address` - The owner address. | `u64` |
| `awards_mint(treasury_cap: &mut TreasuryCap<PIZZOTOKEN>, recipients: vector<address>, amounts: vector<u64>, ctx: &mut TxContext)` | Mints and awards tokens to multiple recipients. | `treasury_cap: &mut TreasuryCap<PIZZOTOKEN>` - The treasury cap. `recipients: vector<address>` - The recipient addresses. `amounts: vector<u64>` - The amounts to mint. `ctx: &mut TxContext` - Transaction context. | - |
| `user_game_end(total: &mut Total, user_addr: address, points: u64, ctx: &mut TxContext)` | Ends a user's game session and updates their points. | `total: &mut Total` - The total object. `user_addr: address` - The user address. `points: u64` - The points to add. `ctx: &mut TxContext` - Transaction context. | - |
| `check_mission(total: &mut Total, mission_addr: address, mission_type: vector<u8>, today: u64, ctx: &mut TxContext)` | Checks and updates the status of a mission. | `total: &mut Total` - The total object. `mission_addr: address` - The mission address. `mission_type: vector<u8>` - The mission type. `today: u64` - The current day timestamp. `ctx: &mut TxContext` - Transaction context. | - |

### 5. User

**Contract Address:** `0x98604b50a89c6bdfa7f6bc9d632df7da2e322c4738586b9cc417f4fe8051c2be`  
**Purpose:** Tracks user points and scores.

| Method | Description | Parameters | Returns |
| ------ | ----------- | ---------- | ------- |
| `create_user(ctx: &mut TxContext): User` | Creates a new user. | `ctx: &mut TxContext` - Transaction context. | `User` |
| `user_point_solstice(point: &Point, cur_point: u64): u64` | Returns the highest single point score. | `point: &Point` - The current point object. `cur_point: u64` - The current point value. | `u64` |
| `update_point(user: &mut User, cur_point: u64, ctx: &mut TxContext)` | Updates a user's points. | `user: &mut User` - The user object. `cur_point: u64` - The current point value. `ctx: &mut TxContext` - Transaction context. | - |
| `get_user_point(user: &User, addr: address): UserPoints` | Returns a user's points. | `user: &User` - The user object. `addr: address` - The user address. | `UserPoints` |
| `test_user_module()` | Test function for the user module. | `ctx: &mut TxContext` - Transaction context. | - |
