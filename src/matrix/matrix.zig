const std = @import("std");
const expect = std.testing.expect;
const ArrayList = std.ArrayList;

pub const Matrix = struct {
    width: usize,
    height: usize,

    buffer: []f64,
    allocator: std.mem.Allocator,

    pub fn alloc(width: usize, height: usize, data: []const f64) !Matrix {
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

    pub fn get(self: Matrix, x: usize, y: usize) !f64 {
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
        try expect(self.width == other.height);
        const width = other.width;
        const height = other.height;
        const allocator = std.heap.page_allocator;
        var list = ArrayList(f64).init(allocator);
        for (0..other.height) |row| {
            for (0..self.width) |col| {
                const a = try self.get(0, row);
                const b = try self.get(1, row);
                const c = try self.get(2, row);
                const d = try self.get(3, row);

                const e = try self.get(col, 0);
                const f = try self.get(col, 1);
                const g = try self.get(col, 2);
                const h = try self.get(col, 3);

                try list.append(a * e +
                    b * f +
                    c * g +
                    d * h);
            }
        }
        const buffer = try list.toOwnedSlice();
        return Matrix.alloc(width, height, buffer);
    }
};
