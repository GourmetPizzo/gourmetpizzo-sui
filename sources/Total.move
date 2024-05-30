module gourmetpizzo::Total {
    use gourmetpizzo::PizzoToken::{Self, PIZZOTOKEN};
    use gourmetpizzo::User::{Self, User};
    use sui::coin::{TreasuryCap};
    use gourmetpizzo::Mission::{Self, Mission};
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer::{Self, public_transfer};
    use sui::table::{Self, Table};
    use sui::clock::{Self, Clock};
    use sui::event;
    use std::option::{Self, Option};
    use std::vector;
    

    struct Total has key, store {
        id: UID,
        user_store: Table<address, User>,
        mission_store: Table<address, Mission>,
    }

    struct AwardsMinted has copy, drop {
        recipient: address,
        amount: u64,
    }

    struct UserGameEnded has copy, drop {
        user: address,
        points: u64,
    }

    struct TwitterChecked has copy, drop {
        mission: address,
    }

    struct InviteChecked has copy, drop {
        mission: address,
    }

    struct TodayChecked has copy, drop {
        mission: address,
        today: u64,
    }

    struct TodayMissionChecked has copy, drop {
        mission: address,
        today: u64,
    }

    public fun create_total(ctx: &mut TxContext): Total {
        let id = object::new(ctx);
        let user_store = table::new<address, User>(ctx);
        let mission_store = table::new<address, Mission>(ctx);
        Total { id, user_store, mission_store }
    }

    public entry fun mint_tokens(treasury_cap: &mut TreasuryCap<PIZZOTOKEN>, amount: u64, recipient: address, ctx: &mut TxContext) {
        PizzoToken::mint(treasury_cap, amount, recipient, ctx);
    }

    public fun get_token_balance(owner: address): u64 {
        // Implement the balance check
        // Placeholder return value
        0
    }

    public entry fun awards_mint(treasury_cap: &mut TreasuryCap<PIZZOTOKEN>, recipients: vector<address>, amounts: vector<u64>, ctx: &mut TxContext) {
        assert!(vector::length(&recipients) == 3, 1); // totalAward = 3
        assert!(vector::length(&amounts) == 3, 2);

        let i = 0;
        while (i < 3) {
            let recipient = *vector::borrow(&recipients, i);
            let amount = *vector::borrow(&amounts, i);
            mint_tokens(treasury_cap, amount, recipient, ctx);
            i = i + 1;
            event::emit(AwardsMinted { recipient, amount });
        }
    }

    public entry fun user_game_end(total: &mut Total, user_addr: address, points: u64, ctx: &mut TxContext) {
        let user = if (table::contains(&total.user_store, user_addr)) {
            table::borrow_mut(&mut total.user_store, user_addr)
        } else {
            let new_user = User::create_user(ctx);
            table::add(&mut total.user_store, user_addr, new_user);
            table::borrow_mut(&mut total.user_store, user_addr)
        };

        User::update_point(user, points, ctx);
        event::emit(UserGameEnded { user: user_addr, points });
    }

    public entry fun check_mission(total: &mut Total, mission_addr: address, mission_type: vector<u8>, today: u64, ctx: &mut TxContext) {
        let mission = if (table::contains(&total.mission_store, mission_addr)) {
            table::borrow_mut(&mut total.mission_store, mission_addr)
        } else {
            let new_mission = Mission::create_user_mission(ctx);
            table::add(&mut total.mission_store, mission_addr, new_mission);
            table::borrow_mut(&mut total.mission_store, mission_addr)
        };

        if (vector::is_empty(&mission_type)) {
            abort(3); // "Unknown mission type"
        } else {
            let first_byte = *vector::borrow(&mission_type, 0);
            if (first_byte == 84) { // 'T' for Twitter
                Mission::twitter_check(mission);
                event::emit(TwitterChecked { mission: mission_addr });
            } else if (first_byte == 73) { // 'I' for Invite
                Mission::invite_check(mission);
                event::emit(InviteChecked { mission: mission_addr });
            } else if (first_byte == 67) { // 'C' for CheckIn
                Mission::check_in(mission, today);
                event::emit(TodayChecked { mission: mission_addr, today });
            } else if (first_byte == 77) { // 'M' for Mission
                let _ = Mission::get_attendance_status(mission, today); // Assuming a function that gets mission status
                event::emit(TodayMissionChecked { mission: mission_addr, today });
            } else {
                abort(3); // "Unknown mission type"
            }
        }
    }
}
