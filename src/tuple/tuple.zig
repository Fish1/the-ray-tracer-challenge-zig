const std = @import("std");

const Matrix = @import("../matrix/matrix.zig").Matrix;
const Tuples = @import("../tuples/tuples.zig").Tuples;

pub fn Tuple() type {
    return struct {
        m: Matrix(4, 1),

        pub fn init(x: f64, y: f64, z: f64, w: f64) @This() {
            return .{ .m = Matrix(4, 1).init(&[_]f64{
                x, y, z, w,
            }) };
        }

        pub fn getX(self: @This()) f64 {
            return self.m.buffer[0];
        }

        pub fn getY(self: @This()) f64 {
            return self.m.buffer[1];
        }

        pub fn getZ(self: @This()) f64 {
            return self.m.buffer[2];
        }

        pub fn getW(self: @This()) f64 {
            return self.m.buffer[3];
        }

        pub fn setX(self: *@This(), value: f64) void {
            self.m.buffer[0] = value;
        }

        pub fn setY(self: *@This(), value: f64) void {
            self.m.buffer[1] = value;
        }

        pub fn setZ(self: *@This(), value: f64) void {
            self.m.buffer[2] = value;
        }

        pub fn setW(self: *@This(), value: f64) void {
            self.m.buffer[3] = value;
        }

        pub fn equals(self: @This(), other: @This()) bool {
            return self.m.equals(other.m);
        }

        pub fn add(self: @This(), other: @This()) @This() {
            return .{ .m = self.m.add(other.m) };
        }

        pub fn subtract(self: @This(), other: @This()) @This() {
            return .{ .m = self.m.subtract(other.m) };
        }

        pub fn negate(self: @This()) @This() {
            return .{ .m = self.m.negate() };
        }

        pub fn multiplyScaler(self: @This(), scaler: f64) @This() {
            return .{ .m = self.m.multiplyScaler(scaler) };
        }

        pub fn multiplyMatrix(self: @This(), matrix: Matrix(4, 4)) @This() {
            return matrix.multiplyTuple(self);
        }

        pub fn divideScaler(self: @This(), scaler: f64) @This() {
            return .{ .m = self.m.divideScaler(scaler) };
        }

        pub fn magnitude(self: @This()) f64 {
            return std.math.sqrt((self.getX() * self.getX()) +
                (self.getY() * self.getY()) +
                (self.getZ() * self.getZ()) +
                (self.getW() * self.getW()));
        }

        pub fn normalize(self: @This()) @This() {
            return @This().init(
                self.getX() / self.magnitude(),
                self.getY() / self.magnitude(),
                self.getZ() / self.magnitude(),
                self.getW() / self.magnitude(),
            );
        }

        pub fn dot(self: @This(), other: @This()) f64 {
            return self.getX() * other.getX() +
                self.getY() * other.getY() +
                self.getZ() * other.getZ() +
                self.getW() * other.getW();
        }

        pub fn cross(self: @This(), other: @This()) @This() {
            return Tuples.Vector(
                self.getY() * other.getZ() - self.getZ() * other.getY(),
                self.getZ() * other.getX() - self.getX() * other.getZ(),
                self.getX() * other.getY() - self.getY() * other.getX(),
            );
        }

        pub fn reflect(self: @This(), other: @This()) @This() {
            return @This().subtract(
                self,
                other
                    .multiplyScaler(2.0)
                    .multiplyScaler(Tuple().dot(self, other)),
            );
        }
    };
}
