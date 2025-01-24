module car::car_Admin {
    public struct AdminCapability has key {
        id: UID
    }

   public struct Car has key {
        id: UID,
        speed: u8,
        acceleration: u8,
        handling: u8
    }

    fun init(ctx: &mut TxContext) {
        transfer::transfer(
            AdminCapability {
                id: object::new(ctx)
            }, 
            tx_context::sender(ctx)
        );
    }

    fun new_car(
        ctx: &mut TxContext, 
        speed: u8, 
        acceleration: u8, 
        handling: u8
    ): Car {   
        Car {
            id: object::new(ctx),
            speed,
            acceleration,
            handling
        }
    }

    public entry fun create(_: &AdminCapability, speed: u8, acceleration: u8, handling: u8, ctx: &mut TxContext) {
        let car = new_car(ctx, speed, acceleration, handling);
        transfer::transfer(car, tx_context::sender(ctx));
    }
}   
    