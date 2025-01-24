module car::car_shop {
    

    use sui::sui::SUI;
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};

    const EInsufficientBalance: u64 = 0;

    public struct Car has key {
        id: UID,
        speed: u8,
        acceleration: u8,
        handling: u8
    }

    public struct CarShop has key {
        id: UID,
        price: u64,
        balance: Balance<SUI>
    }

    public struct ShopOwnerCap has key { id: UID }

    // This function, `init`, is responsible for setting up the initial state of the CarShop module.
    // 
    // Step 1: Create a new ShopOwnerCap object.
    // - `object::new(ctx)` generates a unique identifier (UID) for the new ShopOwnerCap.
    // - `ShopOwnerCap { id: object::new(ctx) }` creates a new ShopOwnerCap with this UID.
    // - `transfer::transfer(..., tx_context::sender(ctx))` sends this new ShopOwnerCap to the account that initiated the transaction (the sender).
    //
    // Step 2: Create and share a new CarShop object.
    // - `object::new(ctx)` generates a unique identifier (UID) for the new CarShop.
    // - `CarShop { id: object::new(ctx), price: 100, balance: balance::zero() }` creates a new CarShop with:
    //   - a unique ID,
    //   - a set price of 100 (this could represent the cost of a car),
    //   - an initial balance of zero (using `balance::zero()` to represent no funds initially).
    // - `transfer::share_object(...)` makes this CarShop object available for others to interact with.

    fun init(ctx: &mut TxContext) {
        transfer::transfer(ShopOwnerCap {
            id: object::new(ctx)
        }, tx_context::sender(ctx));

        transfer::share_object(CarShop {
            id: object::new(ctx),
            price: 100,
            balance: balance::zero()
        })
    }


    // This function, `buy_car`, allows a user to purchase a car from the CarShop.
    //
    // Step 1: Ensure the user has enough funds to buy the car.
    // - `assert!(coin::value(payment) >= shop.price, EInsufficientBalance)` checks if the value of the payment coin is at least the price of the car.
    // - If the payment is insufficient, the transaction will fail with the error code `EInsufficientBalance`.
    //
    // Step 2: Deduct the car price from the user's payment.
    // - `let coin_balance = coin::balance_mut(payment)` gets a mutable reference to the balance of the payment coin.
    // - `let paid = balance::split(coin_balance, shop.price)` splits the payment coin, deducting the car price from the user's balance and creating a new coin with the deducted amount.
    //
    // Step 3: Add the deducted amount to the shop's balance.
    // - `balance::join(&mut shop.balance, paid)` adds the paid amount to the shop's balance.
    //
    // Step 4: Transfer the newly created car to the user.
    // - `transfer::transfer(Car { id: object::new(ctx), speed: 50, acceleration: 50, handling: 50 }, tx_context::sender(ctx))` creates a new Car object with specified attributes and transfers it to the user who initiated the transaction.
    public entry fun buy_car(shop: &mut CarShop, payment: &mut Coin<SUI>, ctx: &mut TxContext) {
        assert!(coin::value(payment) >= shop.price, EInsufficientBalance);

        let coin_balance = coin::balance_mut(payment);
        let paid = balance::split(coin_balance, shop.price);

        balance::join(&mut shop.balance, paid);

        transfer::transfer(Car {
            id: object::new(ctx),
            speed: 50,
            acceleration: 50,
            handling: 50
        }, tx_context::sender(ctx))
    }

    // This function, `collect_profits`, allows the shop owner to collect all the profits from the CarShop.
    //
    // Step 1: Determine the total amount of profits in the shop's balance.
    // - `let amount = balance::value(&shop.balance)` retrieves the current value of the shop's balance.
    //
    // Step 2: Take the total amount from the shop's balance.
    // - `let profits = coin::take(&mut shop.balance, amount, ctx)` deducts the total amount from the shop's balance and creates a new coin with the deducted amount.
    //
    // Step 3: Transfer the collected profits to the shop owner.
    // - `transfer::public_transfer(profits, tx_context::sender(ctx))` transfers the newly created coin (representing the collected profits) to the shop owner who initiated the transaction.
    public entry fun collect_profits(_: &ShopOwnerCap, shop: &mut CarShop, ctx: &mut TxContext) {
        let amount = balance::value(&shop.balance);
        let profits = coin::take(&mut shop.balance, amount, ctx);
        transfer::public_transfer(profits, tx_context::sender(ctx))
    }

}