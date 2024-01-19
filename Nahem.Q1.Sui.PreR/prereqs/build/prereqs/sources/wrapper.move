/// A freely transfererrable Wrapper for custom data.
module examples::wrapper {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    /// An object with `store` can be transferred in any
    /// module without a custom transfer implementation.
    struct Wrapper<T: store> has key, store {
        id: UID,
        contents: T,
    }

    /// View function to read contents of a `Container`.
    public fun read_content<T: store>(c: &Wrapper<T>): &T {
         &c.contents
    }

    /// Anyone can create a new object
    public fun wrap<T: store>(contents: T, ctx: &mut TxContext): Wrapper<T> {
        Wrapper {
            id: object::new(ctx),
            contents,
        }
    }

    /// Unwrap and get its contents
    public fun unwrap<T: store>(w: Wrapper<T>): T {
        let Wrapper { id, contents } = w;
        object::delete(id);
        contents
    }

}