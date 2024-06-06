const std = @import("std");
const expect = std.testing.expect;
const ArrayList = std.ArrayList;
const PageAllocator = std.heap.page_allocator;

const Tuple = @import("../tuple/tuple.zig").Tuple;

pub fn Matrixx(comptime _width: usize, comptime _height: usize) type {
    return struct {
        pub const width = _width;
        pub const height = _height;

        comptime width: usize = _width,
        comptime height: usize = _height,

        buffer: [_width * _height]f64,

        pub fn init(data: []const f64) @This() {
            var self: @This() = .{ .buffer = undefined };
            @memcpy(&self.buffer, data);
            return self;
        }

        pub fn init_identity() @This() {
            comptime expect(_width == _height) catch @compileError("matrix is not square");
            var self: @This() = .{ .buffer = undefined };
            for (0.._width * _height) |index| {
                self.buffer[index] = if (index % (_width + 1) == 0) 1 else 0;
            }
            return self;
        }

        pub fn equals(self: @This(), other: @This()) bool {
            const eq = std.math.approxEqAbs;
            for (0.._width * _height) |index| {
                const a = self.buffer[index];
                const b = other.buffer[index];
                if (eq(f64, a, b, 0.00001) == false) {
                    return false;
                }
            }
            return true;
        }

        pub fn get(self: @This(), row: usize, col: usize) !f64 {
            try expect(col < _width);
            try expect(row < _height);
            return self.buffer[row * self.width + col];
        }

        pub fn multiply(self: @This(), other: anytype) MultiplyType(@TypeOf(self), @TypeOf(other)) {
            comptime expect(self.width == other.height) catch @compileError("invalid matrix multiplication");
            var buffer = [_]f64{0} ** (other.width * self.height);
            for (0..self.width) |col| {
                for (0..other.height) |row| {
                    const a = self.buffer[row * self.width + 0];
                    const b = self.buffer[row * self.width + 1];
                    const c = self.buffer[row * self.width + 2];
                    const d = self.buffer[row * self.width + 3];

                    const e = other.buffer[0 * other.width + col];
                    const f = other.buffer[1 * other.width + col];
                    const g = other.buffer[2 * other.width + col];
                    const h = other.buffer[3 * other.width + col];

                    const result =
                        (a * e) +
                        (b * f) +
                        (c * g) +
                        (d * h);
                    buffer[row * other.width + col] = result;
                }
            }
            return Matrixx(other.width, self.height).init(&buffer);
        }

        fn MultiplyType(comptime self: type, comptime other: type) type {
            if (self.height != other.height) {
                @compileError("matrices with different heights provided");
            }
            return Matrixx(other.width, self.height);
        }
    };
}

pub const Matrix = struct {
    width: usize,
    height: usize,

    buffer: []f64,

    pub fn create(width: usize, height: usize, data: []const f64) !Matrix {
        const buffer = try PageAllocator.alloc(f64, width * height);
        @memcpy(buffer, data);
        return Matrix{
            .width = width,
            .height = height,
            .buffer = buffer,
        };
    }

    pub fn create_identity(size: usize) !Matrix {
        const buffer = try PageAllocator.alloc(f64, size * size);
        for (0..size * size) |index| {
            buffer[index] = if (index % 5 == 0) 1 else 0;
        }
        return Matrix{
            .width = size,
            .height = size,
            .buffer = buffer,
        };
    }

    pub fn destroy(self: Matrix) void {
        PageAllocator.free(self.buffer);
    }

    pub fn get(self: Matrix, row: usize, col: usize) !f64 {
        try expect(row < self.height);
        try expect(col < self.width);
        return self.buffer[row * self.width + col];
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
                const a = try self.get(row, 0);
                const b = try self.get(row, 1);
                const c = try self.get(row, 2);
                const d = try self.get(row, 3);

                const e = try other.get(0, col);
                const f = try other.get(1, col);
                const g = try other.get(2, col);
                const h = try other.get(3, col);

                const result =
                    (a * e) +
                    (b * f) +
                    (c * g) +
                    (d * h);
                try list.append(result);
            }
        }
        const buffer = try list.toOwnedSlice();
        return Matrix.create(width, height, buffer);
    }

    pub fn multiplyTuple(self: Matrix, other: Tuple) !Tuple {
        try expect(self.width == 4);
        try expect(self.height == 4);

        var tuple = Tuple.init(0, 0, 0, 0);
        for (0..4) |row| {
            const a = try self.get(row, 0);
            const b = try self.get(row, 1);
            const c = try self.get(row, 2);
            const d = try self.get(row, 3);
            const result =
                (a * other.x) +
                (b * other.y) +
                (c * other.z) +
                (d * other.w);
            switch (row) {
                0 => {
                    tuple.x = result;
                },
                1 => {
                    tuple.y = result;
                },
                2 => {
                    tuple.z = result;
                },
                3 => {
                    tuple.w = result;
                },
                else => {
                    unreachable;
                },
            }
        }
        return tuple;
    }

    pub fn transpose(self: Matrix) !Matrix {
        const buffer = try PageAllocator.alloc(f64, self.width * self.height);
        defer PageAllocator.free(buffer);

        for (0..self.width) |col| {
            for (0..self.height) |row| {
                buffer[row * self.height + col] = try self.get(col, row);
            }
        }

        return Matrix.create(self.width, self.height, buffer);
    }

    pub fn determinant(self: Matrix) f64 {
        if (self.width == 2 and self.height == 2) {
            return self.determinant_2x2();
        } else {
            return 0.0;
        }
    }

    fn determinant_2x2(self: Matrix) f64 {
        return self.buffer[0] * self.buffer[3] - self.buffer[1] * self.buffer[2];
    }

    pub fn submatrix(self: Matrix, row: usize, col: usize) !Matrix {
        const width = self.width - 1;
        const height = self.height - 1;
        const buffer = try PageAllocator.alloc(f64, width * height);
        defer PageAllocator.free(buffer);

        // TODO: optimize this please
        for (0..self.width) |current_col| {
            if (current_col == col) {
                continue;
            }
            for (0..self.height) |current_row| {
                if (current_row == row) {
                    continue;
                }
                const new_col = if (current_col > col) current_col - 1 else current_col;
                const new_row = if (current_row > row) current_row - 1 else current_row;
                const current_value = self.buffer[current_row * self.height + current_col];
                buffer[new_row * height + new_col] = current_value;
            }
        }

        return Matrix.create(width, height, buffer);
    }

    pub fn minor(self: Matrix, row: usize, col: usize) f64 {
        const sub = self.submatrix(row, col) catch @panic("failed");
        return sub.determinant();
    }
};
