const matrix = @import("matrix.zig").Matrix;
const matrixx = @import("matrix.zig").Matrixx;
const std = @import("std");
const expect = std.testing.expect;
const Tuple = @import("../tuple/tuple.zig").Tuple;

test "create matrix 4x4" {
    const buffer = [_]f64{ 1, 2, 3, 4, 5.5, 6.5, 7.5, 8.5, 9, 10, 11, 12, 13.5, 14.5, 15.5, 16.5 };
    const m = matrixx(4, 4).init(&buffer);
    var x = try m.get(0, 0);
    try expect(x == 1);
    x = try m.get(0, 3);
    try expect(x == 4);
    x = try m.get(1, 0);
    try expect(x == 5.5);
    x = try m.get(1, 2);
    try expect(x == 7.5);
    x = try m.get(2, 2);
    try expect(x == 11);
    x = try m.get(3, 0);
    try expect(x == 13.5);
    x = try m.get(3, 2);
    try expect(x == 15.5);
}

test "create matrix 2x2" {
    const buffer = [_]f64{ -3, 5, 1, -2 };
    const m = matrixx(2, 2).init(&buffer);
    var x = try m.get(0, 0);
    try expect(x == -3);
    x = try m.get(0, 1);
    try expect(x == 5);
    x = try m.get(1, 0);
    try expect(x == 1);
    x = try m.get(1, 1);
    try expect(x == -2);
}

test "create matrix 3x3" {
    const buffer = [_]f64{ -3, 5, 0, 1, -2, -7, 0, 1, 1 };
    const m = matrixx(3, 3).init(&buffer);
    var x = try m.get(0, 0);
    try expect(x == -3);
    x = try m.get(0, 1);
    try expect(x == 5);
    x = try m.get(0, 2);
    try expect(x == 0);
    x = try m.get(1, 0);
    try expect(x == 1);
    x = try m.get(1, 1);
    try expect(x == -2);
    x = try m.get(1, 2);
    try expect(x == -7);
    x = try m.get(2, 0);
    try expect(x == 0);
    x = try m.get(2, 1);
    try expect(x == 1);
    x = try m.get(2, 2);
    try expect(x == 1);
}

test "true equality test" {
    const buffer1 = [_]f64{ -3, 5, 0, 1, -2, -7, 0, 1, 1 };
    const m1 = matrixx(3, 3).init(&buffer1);
    const buffer2 = [_]f64{ -3, 5, 0, 1, -2, -7, 0, 1, 1 };
    const m2 = matrixx(3, 3).init(&buffer2);
    try expect(m1.equals(m2) == true);
}

test "false equality test" {
    const buffer1 = [_]f64{ -3, 5, 0, 1, -2, -7, 0, 1, 1 };
    const m1 = matrixx(3, 3).init(&buffer1);
    const buffer2 = [_]f64{ -3, 5, 0, 1, -2, -7, 0, 1, 2 };
    const m2 = matrixx(3, 3).init(&buffer2);
    try expect(m1.equals(m2) == false);
}

test "multiply" {
    const buffer1 = [_]f64{
        1, 2, 3, 4,
        5, 6, 7, 8,
        9, 8, 7, 6,
        5, 4, 3, 2,
    };
    const m1 = matrixx(4, 4).init(&buffer1);
    const buffer2 = [_]f64{
        -2, 1, 2, 3,
        3,  2, 1, -1,
        4,  3, 6, 5,
        1,  2, 7, 8,
    };
    const m2 = matrixx(4, 4).init(&buffer2);
    const result = m1.multiply(m2);
    const expectedResult = matrixx(4, 4).init(&[_]f64{
        20, 22, 50,  48,
        44, 54, 114, 108,
        40, 58, 110, 102,
        16, 26, 46,  42,
    });
    try expect(result.equals(expectedResult));
}

test "multiply tuple" {
    const buffer1 = [_]f64{ 1, 2, 3, 4, 2, 4, 4, 2, 8, 6, 4, 1, 0, 0, 0, 1 };
    const m1 = try matrix.create(4, 4, &buffer1);
    const t1 = Tuple.init(1, 2, 3, 1);
    const result = try m1.multiplyTuple(t1);
    const expectedResult = Tuple.init(18, 24, 33, 1);
    try expect(result.equals(expectedResult));
}

test "multiply identity" {
    const buffer1 = [_]f64{
        0, 1, 2,  4,
        1, 2, 4,  8,
        2, 4, 8,  16,
        4, 8, 16, 32,
    };
    const m1 = matrixx(4, 4).init(&buffer1);
    const m2 = matrixx(4, 4).init_identity();
    const result = m1.multiply(m2);
    const expectedResult = matrixx(4, 4).init(&[_]f64{
        0, 1, 2,  4,
        1, 2, 4,  8,
        2, 4, 8,  16,
        4, 8, 16, 32,
    });
    try expect(result.equals(expectedResult) == true);
}

test "transpose" {
    const buffer1 = [_]f64{ 0, 9, 3, 0, 9, 8, 0, 8, 1, 8, 5, 3, 0, 0, 5, 8 };
    const m1 = try matrix.create(4, 4, &buffer1);
    const result = try m1.transpose();
    const expectedResult = try matrix.create(4, 4, &[_]f64{ 0, 9, 1, 0, 9, 8, 8, 0, 3, 0, 5, 5, 0, 8, 3, 8 });
    try expect(result.equals(expectedResult) == true);
}

test "transpose identity" {
    const m1 = try matrix.create_identity(4);
    const result = try m1.transpose();
    const expectedResult = try matrix.create_identity(4);
    try expect(result.equals(expectedResult));
}

test "determinant 2x2" {
    const buffer1 = [_]f64{
        1,  5,
        -3, 2,
    };
    const m1 = try matrix.create(2, 2, &buffer1);
    const result = m1.determinant();
    const expectedResult: f64 = 17.0;
    try expect(result == expectedResult);
}

test "submatrix 3x3 -> 2x2" {
    const buffer1 = [_]f64{
        1,  5, 0,
        -3, 2, 7,
        0,  6, -3,
    };
    const m1 = try matrix.create(3, 3, &buffer1);

    const result = try m1.submatrix(0, 2);

    const buffer2 = [_]f64{
        -3, 2,
        0,  6,
    };
    const expectedResult = try matrix.create(2, 2, &buffer2);
    try expect(result.equals(expectedResult));
}

test "submatrix 4x4 -> 3x3" {
    const buffer1 = [_]f64{
        -6, 1, 1,  6,
        -8, 5, 8,  6,
        -1, 0, 8,  2,
        -7, 1, -1, 1,
    };
    const m1 = try matrix.create(4, 4, &buffer1);

    const result = try m1.submatrix(2, 1);

    const buffer2 = [_]f64{
        -6, 1,  6,
        -8, 8,  6,
        -7, -1, 1,
    };
    const expectedResult = try matrix.create(3, 3, &buffer2);

    try expect(result.equals(expectedResult));
}

test "minor 3x3" {
    const buffer1 = [_]f64{
        3, 5,  0,
        2, -1, -7,
        6, -1, 5,
    };
    const m1 = try matrix.create(3, 3, &buffer1);
    const m2 = try m1.submatrix(1, 0);

    const minor = m1.minor(1, 0);
    const det = m2.determinant();

    try expect(minor == det);
}
