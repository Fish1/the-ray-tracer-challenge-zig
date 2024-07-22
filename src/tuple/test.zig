const Tuple = @import("tuple.zig").Tuple;

const std = @import("std");
const expect = std.testing.expect;
const sqrt = std.math.sqrt;

test "create tuples" {
    const a = Tuple.init(4.3, -4.2, 3.1, 0.0);
    try expect(a.getX() == 4.3);
    try expect(a.getY() == -4.2);
    try expect(a.getZ() == 3.1);
    try expect(a.getW() == 0.0);

    const b = Tuple.init(4.3, -4.2, 3.1, 1.0);
    try expect(b.getX() == 4.3);
    try expect(b.getY() == -4.2);
    try expect(b.getZ() == 3.1);
    try expect(b.getW() == 1.0);
}

test "create point" {
    const a = Tuple.Point(4, -4, 3);
    const b = Tuple.init(4, -4, 3, 1);
    try expect(a.equals(b));
}

test "create vector" {
    const a = Tuple.Vector(4, -4, 3);
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
    const a = Tuple.Point(3, 2, 1);
    const b = Tuple.Point(5, 6, 7);
    const result = a.subtract(b);
    const expected_result = Tuple.Vector(-2, -4, -6);
    try expect(result.equals(expected_result));
}

test "subtract vectors" {
    const a = Tuple.Vector(3, 2, 1);
    const b = Tuple.Vector(5, 6, 7);
    const result = a.subtract(b);
    const expected_result = Tuple.Vector(-2, -4, -6);
    try expect(result.equals(expected_result));
}

test "negative tuple" {
    const a = Tuple.init(1, -2, 3, -4);
    const result = a.negate();
    const expected_result = Tuple.init(-1, 2, -3, 4);
    try expect(result.equals(expected_result));
}

test "multiply tuple by scaler" {
    const a = Tuple.init(1, -2, 3, -4);
    const result = a.multiplyScaler(3.5);
    const expected_result = Tuple.init(3.5, -7, 10.5, -14);
    try expect(result.equals(expected_result));
}

test "multiply tuple by fractional scaler" {
    const a = Tuple.init(1, -2, 3, -4);
    const result = a.multiplyScaler(0.5);
    const expected_result = Tuple.init(0.5, -1, 1.5, -2);
    try expect(result.equals(expected_result));
}

test "divide tuple by scaler" {
    const a = Tuple.init(1, -2, 3, -4);
    const result = a.divideScaler(2);
    const expected_result = Tuple.init(0.5, -1, 1.5, -2);
    try expect(result.equals(expected_result));
}

test "magnitude vector 1" {
    const a = Tuple.Vector(1, 0, 0);
    const result = a.magnitude();
    const expected_result = 1;
    try expect(result == expected_result);
}

test "magnitude vector 2" {
    const a = Tuple.Vector(0, 1, 0);
    const result = a.magnitude();
    const expected_result = 1;
    try expect(result == expected_result);
}

test "magnitude vector 3" {
    const a = Tuple.Vector(0, 0, 1);
    const result = a.magnitude();
    const expected_result = 1;
    try expect(result == expected_result);
}

test "magnitude vector 4" {
    const a = Tuple.Vector(1, 2, 3);
    const result = a.magnitude();
    const expected_result = std.math.sqrt(14.0);
    try expect(result == expected_result);
}

test "magnitude vector 5" {
    const a = Tuple.Vector(-1, -2, -3);
    const result = a.magnitude();
    const expected_result = std.math.sqrt(14.0);
    try expect(result == expected_result);
}

test "normalize vector 1" {
    const a = Tuple.Vector(4, 0, 0);
    const result = a.normalize();
    const expected_result = Tuple.Vector(1, 0, 0);
    try expect(result.equals(expected_result));
}

test "normalize vector 2" {
    const a = Tuple.Vector(1, 2, 3);
    const result = a.normalize();
    const expected_result = Tuple.Vector(0.26726, 0.53452, 0.80178);
    try expect(result.equals(expected_result));
}

test "normalized vector magnitude" {
    const a = Tuple.Vector(1, 2, 3);
    const result = a.normalize().magnitude();
    const expected_result = 1;
    try expect(result == expected_result);
}

test "dot product" {
    const a = Tuple.Vector(1, 2, 3);
    const b = Tuple.Vector(2, 3, 4);
    const result = a.dot(b);
    const expected_result = 20;
    try expect(result == expected_result);
}

test "cross product" {
    const a = Tuple.Vector(1, 2, 3);
    const b = Tuple.Vector(2, 3, 4);
    const result_axb = a.cross(b);
    const expected_result_axb = Tuple.Vector(-1, 2, -1);
    try expect(result_axb.equals(expected_result_axb));

    const result_bxa = a.cross(b);
    const expected_result_bxa = Tuple.Vector(-1, 2, -1);
    try expect(result_bxa.equals(expected_result_bxa));
}

test "reflect vector" {
    const vector = Tuple.Vector(1, -1, 0);
    const normal = Tuple.Vector(0, 1, 0);
    const reflection = vector.reflect(normal);
    const expected_result = Tuple.Vector(1, 1, 0);
    try expect(reflection.equals(expected_result));
}

test "reflect vector of slant" {
    const vector = Tuple.Vector(0, -1, 0);
    const normal = Tuple.Vector(sqrt(2.0) / 2.0, sqrt(2.0) / 2.0, 0.0);
    const reflection = vector.reflect(normal);
    const expected_result = Tuple.Vector(1, 0, 0);
    try expect(reflection.equals(expected_result));
}
