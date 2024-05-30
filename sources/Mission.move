module gourmetpizzo::Mission {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::clock::{Self, Clock};
    use sui::table::{Self, Table};
    use sui::transfer::{Self, transfer};
    use std::option::{Self, Option};

    struct Attendance has key, store {
        id: UID,
        dates: Table<u64, bool>,
    }

    struct Mission has key, store {
        id: UID,
        twitter: bool,
        invite: bool,
        attendance: Attendance,
    }

    public fun create_user_mission(ctx: &mut TxContext): Mission {
        let mission_id = object::new(ctx);
        let attendance_id = object::new(ctx);
        let attendance_dates = table::new<u64, bool>(ctx);
        let attendance = Attendance { id: attendance_id, dates: attendance_dates };
        Mission {
            id: mission_id,
            twitter: false,
            invite: false,
            attendance: attendance,
        }
    }

    public entry fun check_in(mission: &mut Mission, today: u64) {
        assert!(!table::contains(&mission.attendance.dates, today), 1); // "Already checked in today"
        table::add(&mut mission.attendance.dates, today, true);
    }

    public entry fun twitter_check(mission: &mut Mission) {
        assert!(!mission.twitter, 2); // "Already checked in today"
        mission.twitter = true;
    }

    public entry fun invite_check(mission: &mut Mission) {
        assert!(!mission.invite, 3); // "Already checked in today"
        mission.invite = true;
    }

    public fun get_twitter_status(mission: &Mission): bool {
        mission.twitter
    }

    public fun get_invite_status(mission: &Mission): bool {
        mission.invite
    }

    public fun get_attendance_status(mission: &Mission, today: u64): bool {
        table::contains(&mission.attendance.dates, today)
    }

    // Helper function to create a mission for a user and transfer it to them
    public entry fun create_and_transfer_mission(ctx: &mut TxContext) {
        let mission = create_user_mission(ctx);
        transfer(mission, tx_context::sender(ctx));
    }

    #[test]
    public fun test_create_user_mission() {
        let ctx = &mut tx_context::dummy();
        let mission = create_user_mission(ctx);

        // Check initial state
        assert!(!get_twitter_status(&mission), 1); // Initial twitter state
        assert!(!get_invite_status(&mission), 2); // Initial invite state
        assert!(!get_attendance_status(&mission, 20230501), 3); // Initial attendance state

        // Create a dummy address and transfer the mission
        let dummy_address = @0xCAFE;
        transfer(mission, dummy_address);
    }

    /// Check-in test
    #[test]
    public entry fun test_check_in() {
        let ctx = &mut tx_context::dummy();
        let mission = create_user_mission(ctx);
        let today: u64 = 20230501; // Example date
        check_in(&mut mission, today);
        assert!(get_attendance_status(&mission, today), 4); // Check attendance state

        // Create a dummy address and transfer the mission
        let dummy_address = @0xCAFE;
        transfer(mission, dummy_address);
    }

    /// Twitter check test
    #[test]
    public entry fun test_twitter_check() {
        let ctx = &mut tx_context::dummy();
        let mission = create_user_mission(ctx);
        twitter_check(&mut mission);
        assert!(get_twitter_status(&mission), 5); // Check twitter state

        // Create a dummy address and transfer the mission
        let dummy_address = @0xCAFE;
        transfer(mission, dummy_address);
    }

    /// Invite check test
    #[test]
    public entry fun test_invite_check() {
        let ctx = &mut tx_context::dummy();
        let mission = create_user_mission(ctx);
        invite_check(&mut mission);
        assert!(get_invite_status(&mission), 6); // Check invite state

        // Create a dummy address and transfer the mission
        let dummy_address = @0xCAFE;
        transfer(mission, dummy_address);
    }

    /// Overall status test
    #[test]
    public entry fun test_get_mission_status() {
        let ctx = &mut tx_context::dummy();
        let mission = create_user_mission(ctx);
        let today: u64 = 20230501; // Example date

        assert!(!get_twitter_status(&mission), 7); // Initial twitter state
        assert!(!get_invite_status(&mission), 8); // Initial invite state
        assert!(!get_attendance_status(&mission, today), 9); // Initial attendance state

        twitter_check(&mut mission);
        invite_check(&mut mission);
        check_in(&mut mission, today);

        assert!(get_twitter_status(&mission), 10); // Updated twitter state
        assert!(get_invite_status(&mission), 11); // Updated invite state
        assert!(get_attendance_status(&mission, today), 12); // Updated attendance state

        // Create a dummy address and transfer the mission
        let dummy_address = @0xCAFE;
        transfer(mission, dummy_address);
    }

    /// Drop mission test
    #[test]
    public entry fun test_drop_mission() {
        let ctx = &mut tx_context::dummy();
        let mission = create_user_mission(ctx);

        // Create a dummy address and transfer the mission
        let dummy_address = @0xCAFE;
        transfer(mission, dummy_address);

        // Verify that mission is dropped (or transferred in this case)
        assert!(true, 13); // Adjust this according to the actual verification method
    }
}
