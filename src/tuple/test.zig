const Tuple = @import("tuple.zig").Tuple;

const std = @import("std");
const expect = std.testing.expect;

test "create tuples" {
    const a = Tuple.init(4.3, -4.2, 3.1, 1.0);
    try expect(a.x == 4.3);
    try expect(a.y == -4.2);
    try expect(a.z == 3.1);
    try expect(a.w == 1.0);

    const b = Tuple.init(4.3, -4.2, 3.1, 0.0);
    try expect(b.x == 4.3);
    try expect(b.y == -4.2);
    try expect(b.z == 3.1);
    try expect(b.w == 0.0);
}

test "create point" {
    const a = Tuple.initPoint(4, -4, 3);
    const b = Tuple.init(4, -4, 3, 1);
    try expect(a.equals(b));
}

test "create vector" {
    const a = Tuple.initVector(4, -4, 3);
    const b = Tuple.init(4, -4, 3, 0);
    try expect(a.equals(b));
}

test "add tuples" {
    const a = Tuple.init(3, -2, 5, 1);
    const b = Tuple.init(-2, 3, 1, 0);
    const result = a.add(b);
    const expected_result = Tuple.init(1, 1, 6, 1);
    try expect(result.equals(expected_result));
}

test "subtract points" {
    const a = Tuple.initPoint(3, 2, 1);
    const b = Tuple.initPoint(5, 6, 7);
    const result = a.subtract(b);
    const expected_result = Tuple.initVector(-2, -4, -6);
    try expect(result.equals(expected_result));
}

test "subtract vectors" {
    const a = Tuple.initVector(3, 2, 1);
    const b = Tuple.initVector(5, 6, 7);
    const result = a.subtract(b);
    const expected_result = Tuple.initVector(-2, -4, -6);
    try expect(result.equals(expected_result));
}

test "negative tuple" {
    const a = Tuple.init(1, -2, 3, -4);
    const result = a.negative();
    const expected_result = Tuple.init(-1, 2, -3, 4);
    try expect(result.equals(expected_result));
}

test "multiply tuple by scaler" {
    const a = Tuple.init(1, -2, 3, -4);
    const result = a.multiply_scale(3.5);
    const expected_result = Tuple.init(3.5, -7, 10.5, -14);
    try expect(result.equals(expected_result));
}

test "multiply tuple by fractional scaler" {
    const a = Tuple.init(1, -2, 3, -4);
    const result = a.multiply_scale(0.5);
    const expected_result = Tuple.init(0.5, -1, 1.5, -2);
    try expect(result.equals(expected_result));
}

test "divide tuple by scaler" {
    const a = Tuple.init(1, -2, 3, -4);
    const result = a.divide_scale(2);
    const expected_result = Tuple.init(0.5, -1, 1.5, -2);
    try expect(result.equals(expected_result));
}

test "magnitude vector 1" {
    const a = Tuple.initVector(1, 0, 0);
    const result = a.magnitude();
    const expected_result = 1;
    try expect(result == expected_result);
}

test "magnitude vector 2" {
    const a = Tuple.initVector(0, 1, 0);
    const result = a.magnitude();
    const expected_result = 1;
    try expect(result == expected_result);
}

test "magnitude vector 3" {
    const a = Tuple.initVector(0, 0, 1);
    const result = a.magnitude();
    const expected_result = 1;
    try expect(result == expected_result);
}

test "magnitude vector 4" {
    const a = Tuple.initVector(1, 2, 3);
    const result = a.magnitude();
    const expected_result = std.math.sqrt(14.0);
    try expect(result == expected_result);
}

test "magnitude vector 5" {
    const a = Tuple.initVector(-1, -2, -3);
    const result = a.magnitude();
    const expected_result = std.math.sqrt(14.0);
    try expect(result == expected_result);
}

test "normalize vector 1" {
    const a = Tuple.initVector(4, 0, 0);
    const result = a.normalized();
    const expected_result = Tuple.initVector(1, 0, 0);
    try expect(result.equals(expected_result));
}

test "normalize vector 2" {
    const a = Tuple.initVector(1, 2, 3);
    const result = a.normalized();
    const expected_result = Tuple.initVector(0.26726, 0.53452, 0.80178);
    try expect(result.equals(expected_result));
}

test "normalized vector magnitude" {
    const a = Tuple.initVector(1, 2, 3);
    const result = a.normalized().magnitude();
    const expected_result = 1;
    try expect(result == expected_result);
}

test "dot product" {
    const a = Tuple.initVector(1, 2, 3);
    const b = Tuple.initVector(2, 3, 4);
    const result = a.dot(b);
    const expected_result = 20;
    try expect(result == expected_result);
}

test "cross product" {
    const a = Tuple.initVector(1, 2, 3);
    const b = Tuple.initVector(2, 3, 4);
    const result_axb = a.cross(b);
    const expected_result_axb = Tuple.initVector(-1, 2, -1);
    try expect(result_axb.equals(expected_result_axb));

    const result_bxa = a.cross(b);
    const expected_result_bxa = Tuple.initVector(-1, 2, -1);
    try expect(result_bxa.equals(expected_result_bxa));
}
