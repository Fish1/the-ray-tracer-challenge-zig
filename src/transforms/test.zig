const math = @import("std").math;
const expect = @import("std").testing.expect;
const log = @import("std").log;

const Tuple = @import("../tuple/tuple.zig").Tuple;
const Transforms = @import("transforms.zig").Transforms;
const Color = @import("../color/color.zig").Color;
const Canvas = @import("../canvas/canvas.zig").Canvas;

test "Translate" {
    const translate = Transforms.Translate(5, -3, 2);
    const point = Tuple.Point(-3, 4, 5);
    const result = translate.multiplyTuple(point);
    const expectedResult = Tuple.Point(2, 1, 7);
    try expect(result.equals(expectedResult));
}

test "Translate inverse" {
    const translate = Transforms.Translate(5, -3, 2);
    const point = Tuple.Point(-3, 4, 5);
    const result = translate.inverse().multiplyTuple(point);
    const expectedResult = Tuple.Point(-8, 7, 3);
    try expect(result.equals(expectedResult));
}

test "Translate vector" {
    const translate = Transforms.Translate(5, -3, 2);
    const vector = Tuple.Vector(-3, 4, 5);
    const result = translate.inverse().multiplyTuple(vector);
    const expectedResult = Tuple.Vector(-3, 4, 5);
    try expect(result.equals(expectedResult));
}

test "scale" {
    const scale = Transforms.Scale(2, 3, 4);
    const point = Tuple.Point(-4, 6, 8);
    const result = scale.multiplyTuple(point);
    const expectedResult = Tuple.Point(-8, 18, 32);
    try expect(result.equals(expectedResult));
}

test "scale vector" {
    const scale = Transforms.Scale(2, 3, 4);
    const vector = Tuple.Vector(-4, 6, 8);
    const result = scale.multiplyTuple(vector);
    const expectedResult = Tuple.Vector(-8, 18, 32);
    try expect(result.equals(expectedResult));
}

test "scale inverse" {
    const scale = Transforms.Scale(2, 3, 4).inverse();
    const vector = Tuple.Vector(-4, 6, 8);
    const result = scale.multiplyTuple(vector);
    const expectedResult = Tuple.Vector(-2, 2, 2);
    try expect(result.equals(expectedResult));
}

test "rotate x" {
    const point = Tuple.Point(0, 1, 0);
    const halfQuarter = Transforms.RotateX(math.pi / 4.0);
    const fullQuarter = Transforms.RotateX(math.pi / 2.0);

    const p1 = halfQuarter.multiplyTuple(point);
    const p1r = Tuple.Point(0, math.sqrt(2.0) / 2.0, math.sqrt(2.0) / 2.0);
    const p2 = fullQuarter.multiplyTuple(point);
    const p2r = Tuple.Point(0, 0, 1);

    try expect(p1.equals(p1r));
    try expect(p2.equals(p2r));
}

test "inverse rotate x" {
    const point = Tuple.Point(0, 1, 0);
    const halfQuarter = Transforms.RotateX(math.pi / 4.0).inverse();

    const p1 = halfQuarter.multiplyTuple(point);
    const p1r = Tuple.Point(0, math.sqrt(2.0) / 2.0, -math.sqrt(2.0) / 2.0);

    try expect(p1.equals(p1r));
}

test "rotate y" {
    const point = Tuple.Point(0, 0, 1);

    const halfQuarter = Transforms.RotateY(math.pi / 4.0);
    const fullQuarter = Transforms.RotateY(math.pi / 2.0);

    const p1 = halfQuarter.multiplyTuple(point);
    const p1r = Tuple.Point(math.sqrt(2.0) / 2.0, 0, math.sqrt(2.0) / 2.0);
    const p2 = fullQuarter.multiplyTuple(point);
    const p2r = Tuple.Point(1, 0, 0);

    try expect(p1.equals(p1r));
    try expect(p2.equals(p2r));
}

test "rotate z" {
    const point = Tuple.Point(0, 1, 0);

    const halfQuarter = Transforms.RotateZ(math.pi / 4.0);
    const fullQuarter = Transforms.RotateZ(math.pi / 2.0);

    const p1 = halfQuarter.multiplyTuple(point);
    const p1r = Tuple.Point(-math.sqrt(2.0) / 2.0, math.sqrt(2.0) / 2.0, 0);
    const p2 = fullQuarter.multiplyTuple(point);
    const p2r = Tuple.Point(-1, 0, 0);

    try expect(p1.equals(p1r));
    try expect(p2.equals(p2r));
}

test "sheer x in proportion to y" {
    const point = Tuple.Point(2, 3, 4);
    const transform = Transforms.Sheer(1, 0, 0, 0, 0, 0);
    const result = transform.multiplyTuple(point);
    const expectedResult = Tuple.Point(5, 3, 4);
    try expect(result.equals(expectedResult));
}

test "sheer x in proportion to z" {
    const point = Tuple.Point(2, 3, 4);
    const transform = Transforms.Sheer(0, 1, 0, 0, 0, 0);
    const result = transform.multiplyTuple(point);
    const expectedResult = Tuple.Point(6, 3, 4);
    try expect(result.equals(expectedResult));
}

test "sheer y in proportion to x" {
    const point = Tuple.Point(2, 3, 4);
    const transform = Transforms.Sheer(0, 0, 1, 0, 0, 0);
    const result = transform.multiplyTuple(point);
    const expectedResult = Tuple.Point(2, 5, 4);
    try expect(result.equals(expectedResult));
}

test "sheer y in proportion to z" {
    const point = Tuple.Point(2, 3, 4);
    const transform = Transforms.Sheer(0, 0, 0, 1, 0, 0);
    const result = transform.multiplyTuple(point);
    const expectedResult = Tuple.Point(2, 7, 4);
    try expect(result.equals(expectedResult));
}

test "sheer z in proportion to x" {
    const point = Tuple.Point(2, 3, 4);
    const transform = Transforms.Sheer(0, 0, 0, 0, 1, 0);
    const result = transform.multiplyTuple(point);
    const expectedResult = Tuple.Point(2, 3, 6);
    try expect(result.equals(expectedResult));
}

test "sheer z in proportion to y" {
    const point = Tuple.Point(2, 3, 4);
    const transform = Transforms.Sheer(0, 0, 0, 0, 0, 1);
    const result = transform.multiplyTuple(point);
    const expectedResult = Tuple.Point(2, 3, 7);
    try expect(result.equals(expectedResult));
}

test "tranformations in sequence" {
    const point = Tuple.Point(1, 0, 1);
    const rotate = Transforms.RotateX(math.pi / 2.0);
    const scale = Transforms.Scale(5, 5, 5);
    const translate = Transforms.Translate(10, 5, 7);

    const p2 = rotate.multiplyTuple(point);
    try expect(p2.equals(Tuple.Point(1, -1, 0)));

    const p3 = scale.multiplyTuple(p2);
    try expect(p3.equals(Tuple.Point(5, -5, 0)));

    const p4 = translate.multiplyTuple(p3);
    try expect(p4.equals(Tuple.Point(15, 0, 7)));
}

test "transformations in seqence (chained)" {
    const point = Tuple.Point(1, 0, 1);
    const rotate = Transforms.RotateX(math.pi / 2.0);
    const scale = Transforms.Scale(5, 5, 5);
    const translate = Transforms.Translate(10, 5, 7);

    const result = translate.multiplyTuple(scale.multiplyTuple(rotate.multiplyTuple(point)));
    try expect(result.equals(Tuple.Point(15, 0, 7)));

    const result2 = point.multiplyMatrix(rotate).multiplyMatrix(scale).multiplyMatrix(translate);
    try expect(result2.equals(Tuple.Point(15, 0, 7)));
}

test "create clock" {
    var buffer: [300 * 300]Color = undefined;
    const canvas = Canvas.init(300, 300, &buffer);

    const position = Transforms.Translate(150, 150, 0);

    var point = Tuple.Point(0, 0, 0);
    point = point.multiplyMatrix(Transforms.Translate(100, 0, 0));

    const rotate = Transforms.RotateZ(math.pi / 32.0);
    for (0..64) |_| {
        point = point.multiplyMatrix(rotate);
        const p2 = point.multiplyMatrix(position);
        const x = @as(usize, @intFromFloat(p2.getX()));
        const y = @as(usize, @intFromFloat(p2.getY()));
        canvas.safeSet(x, y, Color.init(1.5, 0, 0));
    }
    try canvas.render("./output/clock.ppm");
}
