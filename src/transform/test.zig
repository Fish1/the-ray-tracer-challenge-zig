const math = @import("std").math;
const expect = @import("std").testing.expect;

const Tuple = @import("../tuple/tuple.zig").Tuple;
const Transform = @import("transform.zig").Transform;

test "Translate" {
    const translate = Transform.Translate(5, -3, 2);
    const point = Tuple.Point(-3, 4, 5);
    const result = translate.multiplyTuple(point);
    const expectedResult = Tuple.Point(2, 1, 7);
    try expect(result.equals(expectedResult));
}

test "Translate inverse" {
    const translate = Transform.Translate(5, -3, 2);
    const point = Tuple.Point(-3, 4, 5);
    const result = translate.inverse().multiplyTuple(point);
    const expectedResult = Tuple.Point(-8, 7, 3);
    try expect(result.equals(expectedResult));
}

test "Translate vector" {
    const translate = Transform.Translate(5, -3, 2);
    const vector = Tuple.Vector(-3, 4, 5);
    const result = translate.inverse().multiplyTuple(vector);
    const expectedResult = Tuple.Vector(-3, 4, 5);
    try expect(result.equals(expectedResult));
}

test "scale" {
    const scale = Transform.Scale(2, 3, 4);
    const point = Tuple.Point(-4, 6, 8);
    const result = scale.multiplyTuple(point);
    const expectedResult = Tuple.Point(-8, 18, 32);
    try expect(result.equals(expectedResult));
}

test "scale vector" {
    const scale = Transform.Scale(2, 3, 4);
    const vector = Tuple.Vector(-4, 6, 8);
    const result = scale.multiplyTuple(vector);
    const expectedResult = Tuple.Vector(-8, 18, 32);
    try expect(result.equals(expectedResult));
}

test "scale inverse" {
    const scale = Transform.Scale(2, 3, 4).inverse();
    const vector = Tuple.Vector(-4, 6, 8);
    const result = scale.multiplyTuple(vector);
    const expectedResult = Tuple.Vector(-2, 2, 2);
    try expect(result.equals(expectedResult));
}

test "rotate x" {
    const point = Tuple.Point(0, 1, 0);
    const halfQuarter = Transform.RotateX(math.pi / 4.0);
    const fullQuarter = Transform.RotateX(math.pi / 2.0);

    const p1 = halfQuarter.multiplyTuple(point);
    const p1r = Tuple.Point(0, math.sqrt(2.0) / 2.0, math.sqrt(2.0) / 2.0);
    const p2 = fullQuarter.multiplyTuple(point);
    const p2r = Tuple.Point(0, 0, 1);

    try expect(p1.equals(p1r));
    try expect(p2.equals(p2r));
}

test "inverse rotate x" {
    const point = Tuple.Point(0, 1, 0);
    const halfQuarter = Transform.RotateX(math.pi / 4.0).inverse();

    const p1 = halfQuarter.multiplyTuple(point);
    const p1r = Tuple.Point(0, math.sqrt(2.0) / 2.0, -math.sqrt(2.0) / 2.0);

    try expect(p1.equals(p1r));
}

test "rotate y" {
    const point = Tuple.Point(0, 0, 1);

    const halfQuarter = Transform.RotateY(math.pi / 4.0);
    const fullQuarter = Transform.RotateY(math.pi / 2.0);

    const p1 = halfQuarter.multiplyTuple(point);
    const p1r = Tuple.Point(math.sqrt(2.0) / 2.0, 0, math.sqrt(2.0) / 2.0);
    const p2 = fullQuarter.multiplyTuple(point);
    const p2r = Tuple.Point(1, 0, 0);

    try expect(p1.equals(p1r));
    try expect(p2.equals(p2r));
}

test "rotate z" {
    const point = Tuple.Point(0, 1, 0);

    const halfQuarter = Transform.RotateZ(math.pi / 4.0);
    const fullQuarter = Transform.RotateZ(math.pi / 2.0);

    const p1 = halfQuarter.multiplyTuple(point);
    const p1r = Tuple.Point(-math.sqrt(2.0) / 2.0, math.sqrt(2.0) / 2.0, 0);
    const p2 = fullQuarter.multiplyTuple(point);
    const p2r = Tuple.Point(-1, 0, 0);

    try expect(p1.equals(p1r));
    try expect(p2.equals(p2r));
}
