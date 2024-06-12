const std = @import("std");
const expect = std.testing.expect;
const ArrayList = std.ArrayList;
const PageAllocator = std.heap.page_allocator;

const Tuple = @import("../tuple/tuple.zig").Tuple;

pub fn Matrix(comptime _rows: usize, comptime _cols: usize) type {
    return struct {
        pub const rows = _rows;
        pub const cols = _cols;

        comptime rows: usize = _rows,
        comptime cols: usize = _cols,

        buffer: [_rows * _cols]f64,

        pub fn init(data: []const f64) @This() {
            var self: @This() = .{ .buffer = undefined };
            @memcpy(&self.buffer, data);
            return self;
        }

        pub fn init_identity() @This() {
            comptime expect(_rows == _cols) catch @compileError("matrix is not square");
            var self: @This() = .{ .buffer = undefined };
            for (0.._rows * _cols) |index| {
                self.buffer[index] = if (index % (_cols + 1) == 0) 1 else 0;
            }
            return self;
        }

        pub fn equals(self: @This(), other: @This()) bool {
            const eq = std.math.approxEqAbs;
            for (0.._rows * _cols) |index| {
                const a = self.buffer[index];
                const b = other.buffer[index];
                if (eq(f64, a, b, 0.00001) == false) {
                    return false;
                }
            }
            return true;
        }

        pub fn get(self: @This(), row: usize, col: usize) !f64 {
            try expect(col < _cols);
            try expect(row < _rows);
            return self.buffer[row * self.cols + col];
        }

        pub fn multiply(self: @This(), other: anytype) MultiplyType(@TypeOf(self), @TypeOf(other)) {
            comptime expect(self.cols == other.rows) catch @compileError("invalid matrix multiplication");
            var buffer = [_]f64{0} ** (other.cols * self.rows);
            for (0..self.cols) |col| {
                for (0..other.rows) |row| {
                    const a = self.buffer[row * self.cols + 0];
                    const b = self.buffer[row * self.cols + 1];
                    const c = self.buffer[row * self.cols + 2];
                    const d = self.buffer[row * self.cols + 3];

                    const e = other.buffer[0 * other.cols + col];
                    const f = other.buffer[1 * other.cols + col];
                    const g = other.buffer[2 * other.cols + col];
                    const h = other.buffer[3 * other.cols + col];

                    const result =
                        (a * e) +
                        (b * f) +
                        (c * g) +
                        (d * h);
                    buffer[row * other.cols + col] = result;
                }
            }
            return Matrix(other.cols, self.rows).init(&buffer);
        }

        fn MultiplyType(comptime self: type, comptime other: type) type {
            if (self.rows != other.rows) {
                @compileError("matrices with different rows provided");
            }
            return Matrix(other.cols, self.rows);
        }

        pub fn multiplyTuple(self: @This(), other: Tuple) Tuple {
            comptime expect(self.cols == 4) catch @compileError("matrix must have 4 columns");
            var r = [4]f64{ 0, 0, 0, 0 };
            for (0..self.rows) |row| {
                const a = self.buffer[row * self.cols + 0];
                const b = self.buffer[row * self.cols + 1];
                const c = self.buffer[row * self.cols + 2];
                const d = self.buffer[row * self.cols + 3];
                r[row] =
                    (a * other.x) +
                    (b * other.y) +
                    (c * other.z) +
                    (d * other.w);
            }
            return Tuple.init(r[0], r[1], r[2], r[3]);
        }

        pub fn transpose(self: @This()) @This() {
            var buffer = std.mem.zeroes([self.cols * self.rows]f64);
            for (0..self.rows) |row| {
                for (0..self.cols) |col| {
                    const current = self.buffer[row * self.cols + col];
                    buffer[col * self.cols + row] = current;
                }
            }
            return Matrix(self.rows, self.rows).init(&buffer);
        }

        pub fn determinant(self: @This()) f64 {
            comptime expect(self.cols == self.rows) catch @compileError("matrix must be square");
            if (self.cols == 2) {
                return self.determinant_2x2();
            }
            var result: f64 = 0;
            for (0..self.cols) |col| {
                const c = self.cofactor(0, col);
                const v = self.buffer[col];
                result += c * v;
            }
            return result;
        }

        fn determinant_2x2(self: @This()) f64 {
            return self.buffer[0] * self.buffer[3] - self.buffer[1] * self.buffer[2];
        }

        pub fn submatrix(self: @This(), skip_row: usize, skip_col: usize) Matrix(_rows - 1, _cols - 1) {
            const new_rows = (_rows - 1);
            const new_cols = (_cols - 1);
            var buffer = std.mem.zeroes([new_cols * new_rows]f64);

            for (0..new_rows) |row| {
                for (0..new_cols) |col| {
                    const old_row = if (row >= skip_row) row + 1 else row;
                    const old_col = if (col >= skip_col) col + 1 else col;
                    buffer[row * new_cols + col] = self.buffer[old_row * _rows + old_col];
                }
            }

            const result = Matrix(new_cols, new_rows).init(&buffer);
            return result;
        }

        pub fn minor(self: @This(), row: usize, col: usize) f64 {
            return self.submatrix(row, col).determinant();
        }

        pub fn cofactor(self: @This(), row: usize, col: usize) f64 {
            const m = self.minor(row, col);
            if (row + col % 2 == 0) {
                return m;
            } else {
                return m * -1;
            }
        }

        pub fn isInvertable(self: @This()) bool {
            return self.determinant() != 0;
        }

        pub fn inverse(self: @This()) @This() {
            var result = std.mem.zeroes([self.cols * self.rows]f64);
            const d = self.determinant();
            for (0..self.rows) |row| {
                for (0..self.cols) |col| {
                    const c = self.cofactor(row, col);
                    result[row * self.cols + col] = c / d;
                }
            }
            return Matrix(self.rows, self.cols).init(&result);
        }
    };
}
