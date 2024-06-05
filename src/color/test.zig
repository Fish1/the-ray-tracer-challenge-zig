const Color = @import("color.zig").Color;

const std = @import("std");
const expect = std.testing.expect;

test "create color" {
    const a = Color.init(1, 2, 3);
    try expect(a.red() == 1);
    try expect(a.green() == 2);
    try expect(a.blue() == 3);
}

test "add colors" {
    const a = Color.init(0.9, 0.6, 0.75);
    const b = Color.init(0.7, 0.1, 0.25);
    const result = a.add(b);
    const expected_result = Color.init(1.6, 0.7, 1.0);
    try expect(result.equals(expected_result));
}

test "subtract colors" {
    const a = Color.init(0.9, 0.6, 0.75);
    const b = Color.init(0.7, 0.1, 0.25);
    const result = a.subtract(b);
    const expected_result = Color.init(0.2, 0.5, 0.5);
    try expect(result.equals(expected_result));
}

test "scale color" {
    const a = Color.init(0.2, 0.3, 0.4);
    const result = a.multiply_scale(2);
    const expected_result = Color.init(0.4, 0.6, 0.8);
    try expect(result.equals(expected_result));
}

test "multiply colors" {
    const a = Color.init(1, 0.2, 0.4);
    const b = Color.init(0.9, 1, 0.1);
    const result = a.multiply(b);
    const expected_result = Color.init(0.9, 0.2, 0.04);
    try expect(result.equals(expected_result));
}
