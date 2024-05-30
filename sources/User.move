module gourmetpizzo::User {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::table::{Self, Table};
    use sui::transfer::{Self};

    struct Point has store {
         user_point: u64, // High_Point 한판최고점수
        total_point: u64, // 누적포인트
    }

    struct User has key, store {
        id: UID,
        users: Table<address, Point>,
    }

    struct UserPoints has copy, drop {
        user_point: u64,
        total_point: u64,
    }


    public fun create_user(ctx: &mut TxContext): User {
        let id = object::new(ctx);
        let users = table::new<address, Point>(ctx);
        User { id, users }
    }

    public fun user_point_solstice(point: &Point, cur_point: u64): u64 {
        if (point.user_point < cur_point) {
            cur_point
        } else {
            point.user_point
        }
    }

    public entry fun update_point(user: &mut User, cur_point: u64, ctx: &mut TxContext) {
        assert!(cur_point > 0, 1); // "point zero impossible"

        let user_address = tx_context::sender(ctx);
        let point = if (table::contains(&user.users, user_address)) {
            table::borrow_mut(&mut user.users, user_address)
        } else {
            let new_point = Point { user_point: 0, total_point: 0 };
            table::add(&mut user.users, user_address, new_point);
            table::borrow_mut(&mut user.users, user_address)
        };

        point.user_point = user_point_solstice(point, cur_point);
        point.total_point = point.total_point + cur_point;
    }

    public fun get_user_point(user: &User, addr: address): UserPoints {
        if (table::contains(&user.users, addr)) {
            let test = table::borrow(&user.users, addr);
            UserPoints {
                user_point: test.user_point,
                total_point: test.total_point,
            }
        } else {
            UserPoints {
                user_point: 0,
                total_point: 0,
            }
        }
    }

    #[test]
    public entry fun test_user_module() {
        let ctx = &mut tx_context::dummy();
        let user = create_user(ctx);

        // Update points
        update_point(&mut user, 100, ctx);
        update_point(&mut user, 200, ctx);


        // Get user points
        let sender = tx_context::sender(ctx);
        let points = get_user_point(&user, sender);

        assert!(points.user_point == 200, 2); // Highest single point
        assert!(points.total_point == 300, 3); // Total points

        // Create a dummy address and transfer the user
        sui::transfer::public_transfer(user, @0xADD);
    }
}
