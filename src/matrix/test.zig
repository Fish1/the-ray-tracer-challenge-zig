const matrix = @import("matrix.zig").Matrix;
const std = @import("std");
const expect = std.testing.expect;

test "create matrix 4x4" {
    const m = try matrix.alloc(4, 4, [16]f64{ 1, 2, 3, 4, 5.5, 6.5, 7.5, 8.5, 9, 10, 11, 12, 13.5, 14.5, 15.5, 16.5 });
    defer m.free();

    var x = m.get(0, 0) catch 0;
    try expect(x == 1);
    x = m.get(3, 0) catch 0;
    try expect(x == 4);
    x = m.get(0, 1) catch 0;
    try expect(x == 5.5);
    x = m.get(2, 1) catch 0;
    try expect(x == 7.5);
    x = m.get(2, 2) catch 0;
    try expect(x == 11);
    x = m.get(0, 3) catch 0;
    try expect(x == 13.5);
    x = m.get(2, 3) catch 0;
    try expect(x == 15.5);
}

test "create matrix 2x2" {
    const m = try matrix.alloc(2, 2, [4]f64{ -3, 5, 1, -2 });
    defer m.free();

    var x = m.get(0, 0) catch 0;
    try expect(x == -3);
    x = m.get(1, 0) catch 0;
    try expect(x == 5);
    x = m.get(0, 1) catch 0;
    try expect(x == 1);
    x = m.get(1, 1) catch 0;
    try expect(x == -2);
}

test "create matrix 3x3" {
    const m = try matrix.alloc(3, 3, [9]f64{ -3, 5, 0, 1, -2, -7, 0, 1, 1 });
    defer m.free();

    var x = m.get(0, 0) catch 0;
    try expect(x == -3);
    x = m.get(1, 0) catch 0;
    try expect(x == 5);
    x = m.get(2, 0) catch 0;
    try expect(x == 0);
    x = m.get(0, 1) catch 0;
    try expect(x == 1);
    x = m.get(1, 1) catch 0;
    try expect(x == -2);
    x = m.get(2, 1) catch 0;
    try expect(x == -7);
    x = m.get(0, 2) catch 0;
    try expect(x == 0);
    x = m.get(1, 2) catch 0;
    try expect(x == 1);
    x = m.get(2, 2) catch 0;
    try expect(x == 1);
}

test "true equality test" {
    const m1 = try matrix.alloc(3, 3, [9]f64{ -3, 5, 0, 1, -2, -7, 0, 1, 1 });
    defer m1.free();
    const m2 = try matrix.alloc(3, 3, [9]f64{ -3, 5, 0, 1, -2, -7, 0, 1, 1 });
    defer m2.free();
    try expect(m1.equals(m2) == true);
}

test "false equality test" {
    const m1 = try matrix.alloc(3, 3, [9]f64{ -3, 5, 0, 1, -2, -7, 0, 1, 1 });
    defer m1.free();
    const m2 = try matrix.alloc(3, 3, [9]f64{ -3, 5, 0, 1, -2, -7, 0, 1, 2 });
    defer m2.free();
    try expect(m1.equals(m2) == false);
}
