const Tuple = @import("../tuple/tuple.zig").Tuple;
const print = @import("std").debug.print;

pub const Color = struct {
    tuple: Tuple,

    pub fn init(r: f64, g: f64, b: f64) Color {
        return Color{ .tuple = Tuple.init(r, g, b, 1) };
    }

    pub fn red(self: Color) f64 {
        return self.tuple.getX();
    }

    pub fn green(self: Color) f64 {
        return self.tuple.getY();
    }

    pub fn blue(self: Color) f64 {
        return self.tuple.getZ();
    }

    pub fn equals(self: Color, other: Color) bool {
        return self.tuple.equals(other.tuple);
    }

    pub fn add(self: Color, other: Color) Color {
        const result = self.tuple.add(other.tuple);
        return Color.init(result.getX(), result.getY(), result.getZ());
    }

    pub fn subtract(self: Color, other: Color) Color {
        const result = self.tuple.subtract(other.tuple);
        return Color.init(result.getX(), result.getY(), result.getZ());
    }

    pub fn multiply_scale(self: Color, scaler: f64) Color {
        const result = self.tuple.multiplyScaler(scaler);
        return Color.init(result.getX(), result.getY(), result.getZ());
    }

    pub fn multiply(self: Color, other: Color) Color {
        return Color.init(
            self.red() * other.red(),
            self.green() * other.green(),
            self.blue() * other.blue(),
        );
    }
};
