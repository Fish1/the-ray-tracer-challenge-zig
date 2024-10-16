const Tuple = @import("../tuple/tuple.zig").Tuple;
const print = @import("std").debug.print;

pub fn Color() type {
    return struct {
        tuple: Tuple(),

        pub fn init(r: f64, g: f64, b: f64) @This() {
            return @This(){ .tuple = Tuple().init(r, g, b, 1) };
        }

        pub fn red(self: @This()) f64 {
            return self.tuple.getX();
        }

        pub fn green(self: @This()) f64 {
            return self.tuple.getY();
        }

        pub fn blue(self: @This()) f64 {
            return self.tuple.getZ();
        }

        pub fn equals(self: @This(), other: @This()) bool {
            return self.tuple.equals(other.tuple);
        }

        pub fn add(self: @This(), other: @This()) @This() {
            const result = self.tuple.add(other.tuple);
            return @This().init(result.getX(), result.getY(), result.getZ());
        }

        pub fn subtract(self: @This(), other: @This()) @This() {
            const result = self.tuple.subtract(other.tuple);
            return @This().init(result.getX(), result.getY(), result.getZ());
        }

        pub fn multiplyScaler(self: @This(), scaler: f64) @This() {
            const result = self.tuple.multiplyScaler(scaler);
            return @This().init(result.getX(), result.getY(), result.getZ());
        }

        pub fn multiply(self: @This(), other: @This()) @This() {
            return @This().init(
                self.red() * other.red(),
                self.green() * other.green(),
                self.blue() * other.blue(),
            );
        }
    };
}
