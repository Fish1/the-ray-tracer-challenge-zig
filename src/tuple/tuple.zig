const std = @import("std");

const Matrix = @import("../matrix/matrix.zig").Matrix;

pub const Tuple = struct {
    m: Matrix(4, 1),

    pub fn init(x: f64, y: f64, z: f64, w: f64) Tuple {
        return Tuple{ .m = Matrix(4, 1).init(&[_]f64{
            x, y, z, w,
        }) };
    }

    pub fn initPoint(x: f64, y: f64, z: f64) Tuple {
        return Tuple.init(x, y, z, 1);
    }

    pub fn initVector(x: f64, y: f64, z: f64) Tuple {
        return Tuple.init(x, y, z, 0);
    }

    pub fn getX(self: Tuple) f64 {
        return self.m.buffer[0];
    }

    pub fn getY(self: Tuple) f64 {
        return self.m.buffer[1];
    }

    pub fn getZ(self: Tuple) f64 {
        return self.m.buffer[2];
    }

    pub fn getW(self: Tuple) f64 {
        return self.m.buffer[3];
    }

    pub fn equals(self: Tuple, other: Tuple) bool {
        return self.m.equals(other.m);
    }

    pub fn add(self: Tuple, other: Tuple) Tuple {
        return Tuple{ .m = self.m.add(other.m) };
    }

    pub fn subtract(self: Tuple, other: Tuple) Tuple {
        return Tuple{ .m = self.m.subtract(other.m) };
    }

    pub fn negate(self: Tuple) Tuple {
        return Tuple{ .m = self.m.negate() };
    }

    pub fn multiplyScaler(self: Tuple, scaler: f64) Tuple {
        return Tuple{ .m = self.m.multiplyScaler(scaler) };
    }

    pub fn divideScaler(self: Tuple, scaler: f64) Tuple {
        return Tuple{ .m = self.m.divideScaler(scaler) };
    }

    pub fn magnitude(self: Tuple) f64 {
        return std.math.sqrt((self.getX() * self.getX()) +
            (self.getY() * self.getY()) +
            (self.getZ() * self.getZ()) +
            (self.getW() * self.getW()));
    }

    pub fn normalize(self: Tuple) Tuple {
        return Tuple.init(
            self.getX() / self.magnitude(),
            self.getY() / self.magnitude(),
            self.getZ() / self.magnitude(),
            self.getW() / self.magnitude(),
        );
    }

    pub fn dot(self: Tuple, other: Tuple) f64 {
        return self.getX() * other.getX() +
            self.getY() * other.getY() +
            self.getZ() * other.getZ() +
            self.getW() * other.getW();
    }

    pub fn cross(self: Tuple, other: Tuple) Tuple {
        return Tuple.initVector(
            self.getY() * other.getZ() - self.getZ() * other.getY(),
            self.getZ() * other.getX() - self.getX() * other.getZ(),
            self.getX() * other.getY() - self.getY() * other.getX(),
        );
    }
};
