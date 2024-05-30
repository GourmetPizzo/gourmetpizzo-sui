module gourmetpizzo::PizzoToken {
    use std::option;
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    /// The type identifier of PizzoToken.
    struct PIZZOTOKEN has drop {}

    /// Module initializer is called once on module publish.
    /// A treasury cap is sent to the publisher, who then controls minting and burning.
    fun init(witness: PIZZOTOKEN, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency<PIZZOTOKEN>(witness, 6, b"PIZZOTOKEN", b"PIZZO Token", b"PIZ", option::none(), ctx);
        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx));
    }

    /// Manager can mint new coins
    public entry fun mint(
        treasury_cap: &mut TreasuryCap<PIZZOTOKEN>, 
        amount: u64, 
        recipient: address, 
        ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury_cap, amount, recipient, ctx)
    }

    public fun burn(treasury_cap: &mut TreasuryCap<PIZZOTOKEN>, coin: Coin<PIZZOTOKEN>) {
        coin::burn(treasury_cap, coin);
    }

    public fun balance_of(owner: address): u64 {
        // This is a placeholder for the actual implementation
        0 // Placeholder
    }

    #[test_only]
    /// Wrapper of module initializer for testing
    public fun test_init(ctx: &mut TxContext) {
        init(PIZZOTOKEN {}, ctx)
    }
}
