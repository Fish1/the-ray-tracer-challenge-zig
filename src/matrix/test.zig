const std = @import("std");
const expect = @import("std").testing.expect;

const Matrix = @import("matrix.zig").Matrix;
const Transform = @import("matrix.zig").Transform;
const Tuple = @import("../tuple/tuple.zig").Tuple;

test "create matrix 4x4" {
    const buffer = [_]f64{ 1, 2, 3, 4, 5.5, 6.5, 7.5, 8.5, 9, 10, 11, 12, 13.5, 14.5, 15.5, 16.5 };
    const m = Matrix(4, 4).init(&buffer);
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
    const m = Matrix(2, 2).init(&buffer);
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
    const m = Matrix(3, 3).init(&buffer);
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
    const m1 = Matrix(3, 3).init(&buffer1);
    const buffer2 = [_]f64{ -3, 5, 0, 1, -2, -7, 0, 1, 1 };
    const m2 = Matrix(3, 3).init(&buffer2);
    try expect(m1.equals(m2) == true);
}

test "false equality test" {
    const buffer1 = [_]f64{ -3, 5, 0, 1, -2, -7, 0, 1, 1 };
    const m1 = Matrix(3, 3).init(&buffer1);
    const buffer2 = [_]f64{ -3, 5, 0, 1, -2, -7, 0, 1, 2 };
    const m2 = Matrix(3, 3).init(&buffer2);
    try expect(m1.equals(m2) == false);
}

test "multiply" {
    const buffer1 = [_]f64{
        1, 2, 3, 4,
        5, 6, 7, 8,
        9, 8, 7, 6,
        5, 4, 3, 2,
    };
    const m1 = Matrix(4, 4).init(&buffer1);
    const buffer2 = [_]f64{
        -2, 1, 2, 3,
        3,  2, 1, -1,
        4,  3, 6, 5,
        1,  2, 7, 8,
    };
    const m2 = Matrix(4, 4).init(&buffer2);
    const result = m1.multiply(m2);
    const expectedResult = Matrix(4, 4).init(&[_]f64{
        20, 22, 50,  48,
        44, 54, 114, 108,
        40, 58, 110, 102,
        16, 26, 46,  42,
    });
    try expect(result.equals(expectedResult));
}

test "multiply tuple" {
    const m1 = Matrix(4, 4).init(&[_]f64{
        1, 2, 3, 4,
        2, 4, 4, 2,
        8, 6, 4, 1,
        0, 0, 0, 1,
    });
    const t1 = Tuple().init(1, 2, 3, 1);
    const result = m1.multiplyTuple(t1);
    const expectedResult = Tuple().init(18, 24, 33, 1);
    try expect(result.equals(expectedResult));
}

test "multiply identity" {
    const buffer1 = [_]f64{
        0, 1, 2,  4,
        1, 2, 4,  8,
        2, 4, 8,  16,
        4, 8, 16, 32,
    };
    const m1 = Matrix(4, 4).init(&buffer1);
    const m2 = Matrix(4, 4).Identity();
    const result = m1.multiply(m2);
    const expectedResult = Matrix(4, 4).init(&[_]f64{
        0, 1, 2,  4,
        1, 2, 4,  8,
        2, 4, 8,  16,
        4, 8, 16, 32,
    });
    try expect(result.equals(expectedResult) == true);
}

test "transpose" {
    const m1 = Matrix(4, 4).init(&[_]f64{
        0, 9, 3, 0,
        9, 8, 0, 8,
        1, 8, 5, 3,
        0, 0, 5, 8,
    });
    const result = m1.transpose();
    const expectedResult = Matrix(4, 4).init(&[_]f64{
        0, 9, 1, 0,
        9, 8, 8, 0,
        3, 0, 5, 5,
        0, 8, 3, 8,
    });
    try expect(result.equals(expectedResult) == true);
}

test "transpose identity" {
    const m1 = Matrix(4, 4).Identity();
    const result = m1.transpose();
    const expectedResult = Matrix(4, 4).Identity();
    try expect(result.equals(expectedResult));
}

test "determinant 2x2" {
    const m = Matrix(2, 2).init(&[_]f64{
        1,  5,
        -3, 2,
    });
    const result = m.determinant();
    const expectedResult: f64 = 17.0;
    try expect(result == expectedResult);
}

test "submatrix 3x3 -> 2x2" {
    const m1 = Matrix(3, 3).init(&[_]f64{
        1,  5, 0,
        -3, 2, 7,
        0,  6, -3,
    });

    const result = m1.submatrix(0, 2);

    const expectedResult = Matrix(2, 2).init(&[_]f64{
        -3, 2,
        0,  6,
    });

    try expect(result.equals(expectedResult));
}

test "submatrix 4x4 -> 3x3" {
    const m1 = Matrix(4, 4).init(&[_]f64{
        -6, 1, 1,  6,
        -8, 5, 8,  6,
        -1, 0, 8,  2,
        -7, 1, -1, 1,
    });

    const result = m1.submatrix(2, 1);

    const expectedResult = Matrix(3, 3).init(&[_]f64{
        -6, 1,  6,
        -8, 8,  6,
        -7, -1, 1,
    });

    try expect(result.equals(expectedResult));
}

test "minor 3x3" {
    const m1 = Matrix(3, 3).init(&[_]f64{
        3, 5,  0,
        2, -1, -7,
        6, -1, 5,
    });
    const result = m1.minor(1, 0);
    const expectedResult = 25;
    try expect(result == expectedResult);
}

test "cofactor 3x3" {
    const m1 = Matrix(3, 3).init(&[_]f64{
        3, 5,  0,
        2, -1, -7,
        6, -1, 5,
    });
    var result = m1.cofactor(0, 0);
    try expect(result == -12);
    result = m1.cofactor(1, 0);
    try expect(result == -25);
}

test "determinant of 3x3" {
    const m1 = Matrix(3, 3).init(&[_]f64{
        1,  2, 6,
        -5, 8, -4,
        2,  6, 4,
    });
    const cofactor1 = m1.cofactor(0, 0);
    try expect(cofactor1 == 56);
    const cofactor2 = m1.cofactor(0, 1);
    try expect(cofactor2 == 12);
    const cofactor3 = m1.cofactor(0, 2);
    try expect(cofactor3 == -46);

    const determinant = m1.determinant();
    try expect(determinant == -196);
}

test "determinant of 4x4" {
    const m1 = Matrix(4, 4).init(&[_]f64{
        -2, -8, 3,  5,
        -3, 1,  7,  3,
        1,  2,  -9, 6,
        -6, 7,  7,  -9,
    });
    const cofactor1 = m1.cofactor(0, 0);
    try expect(cofactor1 == 690);
    const cofactor2 = m1.cofactor(0, 1);
    try expect(cofactor2 == 447);
    const cofactor3 = m1.cofactor(0, 2);
    try expect(cofactor3 == 210);
    const cofactor4 = m1.cofactor(0, 3);
    try expect(cofactor4 == 51);

    const determinant = m1.determinant();
    try expect(determinant == -4071);
}

test "is invertable 1" {
    const m1 = Matrix(4, 4).init(&[_]f64{
        6, 4,  4, 4,
        5, 5,  7, 6,
        4, -9, 3, -7,
        9, 1,  7, -6,
    });
    const result = m1.isInvertable();
    try expect(result == true);
}

test "is invertable 2" {
    const m1 = Matrix(4, 4).init(&[_]f64{
        -4, 2,  -2, -3,
        9,  6,  2,  6,
        0,  -5, 1,  -5,
        0,  0,  0,  0,
    });
    const result = m1.isInvertable();
    try expect(result == false);
}

test "inverse" {
    const m1 = Matrix(4, 4).init(&[_]f64{
        -5, 2,  6,  -8,
        1,  -5, 1,  8,
        7,  7,  -6, -7,
        1,  -3, 7,  4,
    });
    const m2 = m1.inverse();

    const determinant_m1 = m1.determinant();
    try expect(determinant_m1 == 532);

    var cofactor_m1 = m1.cofactor(2, 3);
    try expect(cofactor_m1 == -160);
    const b32 = try m2.get(3, 2);
    try expect(b32 == -160.0 / 532.0);

    cofactor_m1 = m1.cofactor(3, 2);
    try expect(cofactor_m1 == 105);
    const b23 = try m2.get(2, 3);
    try expect(b23 == 105.0 / 532.0);

    cofactor_m1 = m1.cofactor(2, 0);
    try expect(cofactor_m1 == 128);
    const b20 = try m2.get(0, 2);
    try expect(b20 == 128.0 / 532.0);

    const expectedInverse = Matrix(4, 4).init(&[_]f64{
        0.21805,  0.45113,  0.24060,  -0.04511,
        -0.80827, -1.45677, -0.44361, 0.52068,
        -0.07895, -0.22368, -0.05263, 0.19737,
        -0.52256, -0.81391, -0.30075, 0.30639,
    });
    try expect(m2.equals(expectedInverse));
}

test "inverse 2" {
    const m1 = Matrix(4, 4).init(&[_]f64{
        8,  -5, 9,  2,
        7,  5,  6,  1,
        -6, 0,  9,  6,
        -3, 0,  -9, -4,
    });

    const result = m1.inverse();

    const expectedResult = Matrix(4, 4).init(&[_]f64{
        -0.15385, -0.15385, -0.28205, -0.53846,
        -0.07692, 0.12308,  0.02564,  0.03077,
        0.35897,  0.35897,  0.43590,  0.92308,
        -0.69231, -0.69231, -0.76923, -1.92308,
    });

    try expect(result.equals(expectedResult));
}

test "inverse 3" {
    const m1 = Matrix(4, 4).init(&[_]f64{
        9,  3,  0,  9,
        -5, -2, -6, -3,
        -4, 9,  6,  4,
        -7, 6,  6,  2,
    });

    const result = m1.inverse();

    const expectedResult = Matrix(4, 4).init(&[_]f64{
        -0.04074, -0.07778, 0.14444,  -0.22222,
        -0.07778, 0.03333,  0.36667,  -0.33333,
        -0.02901, -0.14630, -0.10926, 0.12963,
        0.17778,  0.06667,  -0.26667, 0.33333,
    });

    try expect(result.equals(expectedResult));
}

test "inverse 4" {
    const a = Matrix(4, 4).init(&[_]f64{
        3,  -9, 7,  3,
        3,  -8, 2,  -9,
        -4, 4,  4,  1,
        -6, 5,  -1, 1,
    });

    const b = Matrix(4, 4).init(&[_]f64{
        8, 2,  2, 2,
        3, -1, 7, 0,
        7, 0,  5, 4,
        6, -2, 0, 5,
    });

    const result = a.multiply(b).multiply(b.inverse());

    try expect(result.equals(a));
}
