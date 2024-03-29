module examples::item {
    use sui::transfer;
    use sui::object::{Self, UID};
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};

    /// Type that marks Capability to create new `Item`s.
    struct Admin has key {
        id: UID,
    }

    /// Custom NFT-like type.
    struct Item has key, store {
        id: UID,
        name: String,    
    }

    /// Module initializer is called once on module publish.
    /// Here we create only one instance of `AdminCap` and send it to the publisher.
    fun init(ctx: &mut TxContext) {
        transfer::transfer(Admin { id: object::new(ctx) }, tx_context::sender(ctx));
    }

    /// The entry function can not be called if `Admin` is not passed as
    /// the first argument. Hence only owner of the `Admin` can perform
    /// this action.
    public fun create_and_send(_: &Admin, name: vector<u8>, to: address, ctx: &mut TxContext) {
        let item = Item {
            id: object::new(ctx),
            name: string::utf8(name),
        };
        transfer::transfer(item, to);
    }
}