const std = @import("std");
const expect = std.testing.expect;

pub const Matrix = struct {
    width: usize,
    height: usize,

    buffer: []f64,
    allocator: std.mem.Allocator,

    pub fn alloc(comptime width: usize, comptime height: usize, data: [width * height]f64) !Matrix {
        const allocator = std.heap.page_allocator;
        const buffer = try allocator.alloc(f64, width * height);
        for (data, 0..) |number, index| {
            buffer[index] = number;
        }
        return Matrix{
            .width = width,
            .height = height,
            .buffer = buffer,
            .allocator = allocator,
        };
    }

    pub fn free(self: Matrix) void {
        self.allocator.free(self.buffer);
    }

    pub fn get(self: Matrix, comptime x: usize, comptime y: usize) !f64 {
        try expect(x < self.width);
        try expect(y < self.height);
        return self.buffer[self.width * y + x];
    }

    pub fn equals(self: Matrix, other: Matrix) bool {
        if (self.width != other.width or self.height != other.height) {
            return false;
        }
        const eq = std.math.approxEqAbs;
        for (0..self.width * self.height) |index| {
            const a = self.buffer[index];
            const b = other.buffer[index];
            if (eq(f64, a, b, 0.00001) == false) {
                return false;
            }
        }
        return true;
    }

    pub fn multiply(self: Matrix, other: Matrix) !Matrix {
        try expect(self.width != other.height);
    }
};
