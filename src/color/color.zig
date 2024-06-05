const Tuple = @import("../tuple/tuple.zig").Tuple;
const print = @import("std").debug.print;

pub const Color = struct {
    tuple: Tuple,

    pub fn init(r: f64, g: f64, b: f64) Color {
        return Color{ .tuple = Tuple.init(r, g, b, 1) };
    }

    pub fn red(self: Color) f64 {
        return self.tuple.x;
    }

    pub fn green(self: Color) f64 {
        return self.tuple.y;
    }

    pub fn blue(self: Color) f64 {
        return self.tuple.z;
    }

    pub fn equals(self: Color, other: Color) bool {
        return self.tuple.equals(other.tuple);
    }

    pub fn add(self: Color, other: Color) Color {
        const result = self.tuple.add(other.tuple);
        return Color.init(result.x, result.y, result.z);
    }

    pub fn subtract(self: Color, other: Color) Color {
        const result = self.tuple.subtract(other.tuple);
        return Color.init(result.x, result.y, result.z);
    }

    pub fn multiply_scale(self: Color, scaler: f64) Color {
        const result = self.tuple.multiply_scale(scaler);
        return Color.init(result.x, result.y, result.z);
    }

    pub fn multiply(self: Color, other: Color) Color {
        return Color.init(
            self.red() * other.red(),
            self.green() * other.green(),
            self.blue() * other.blue(),
        );
    }
};
