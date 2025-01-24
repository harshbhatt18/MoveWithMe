module car::car {
    public struct Car has key {
        id: UID,
        speed: u8,
        acceleration: u8,
        handling: u8
    }

    fun new(ctx: &mut TxContext, speed: u8, acceleration: u8, handling: u8): Car {
        Car{
            id:object::new(ctx),
            speed,
            acceleration,
            handling
        }
    }

    public entry fun create(speed: u8, acceleration: u8, handling: u8, ctx: &mut TxContext) {
        let car = new(ctx, speed, acceleration, handling);
        transfer::transfer(car, tx_context::sender(ctx));
    }

    public entry fun transfer(car: Car, recipient: address) {
        transfer::transfer(car, recipient);
    }

    public fun getStats(self: &Car): (u8, u8, u8) {
        (self.speed, self.acceleration, self.handling)
    }

    public fun update_speed(self:&mut Car, amount:u8){
        self.speed = self.speed + amount;
    }

    public fun update_acceleration(self:&mut Car, amount:u8){
        self.acceleration = self.acceleration + amount;
    }

    public fun update_handling(self:&mut Car, amount:u8){
        self.handling = self.handling + amount;
    }

}
    