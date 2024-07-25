const print = @import("std").debug.print;
const expect = @import("std").testing.expect;
const sqrt = @import("std").math.sqrt;

const Light = @import("./light.zig").Light;
const Tuples = @import("../tuples/tuples.zig").Tuples;
const Color = @import("../color/color.zig").Color;
const Material = @import("../material/material.zig").Material;

test "create light" {
    const position = Tuples.Point(0, 0, 0);
    const intensity = Color.init(1, 1, 1);
    const light = Light().Point(position, intensity);
    try expect(light.position.equals(position));
    try expect(light.intensity.equals(intensity));
}

test "direct light" {
    const surfaceMaterial = Material().init();
    const surfacePosition = Tuples.Point(0, 0, 0);

    const position = Tuples.Point(0, 0, -10);
    const intensity = Color.init(1, 1, 1);
    const light = Light().Point(position, intensity);

    const toEye = Tuples.Vector(0, 0, -1);
    const surfaceNormal = Tuples.Vector(0, 0, -1);

    const result = light.lighting(surfaceMaterial, surfacePosition, toEye, surfaceNormal);
    try expect(result.equals(Color.init(1.9, 1.9, 1.9)));
}

test "45 degree eye" {
    const surfaceMaterial = Material().init();
    const surfacePosition = Tuples.Point(0, 0, 0);

    const position = Tuples.Point(0, 0, -10);
    const intensity = Color.init(1, 1, 1);
    const light = Light().Point(position, intensity);

    const toEye = Tuples.Vector(0, sqrt(2.0) / 2.0, sqrt(2.0) / 2.0);
    const surfaceNormal = Tuples.Vector(0, 0, -1);

    const result = light.lighting(surfaceMaterial, surfacePosition, toEye, surfaceNormal);
    try expect(result.equals(Color.init(1, 1, 1)));
}

test "45 degree light" {
    const surfaceMaterial = Material().init();
    const surfacePosition = Tuples.Point(0, 0, 0);

    const position = Tuples.Point(0, 10, -10);
    const intensity = Color.init(1, 1, 1);
    const light = Light().Point(position, intensity);

    const toEye = Tuples.Vector(0, 0, -1);
    const surfaceNormal = Tuples.Vector(0, 0, -1);

    const result = light.lighting(surfaceMaterial, surfacePosition, toEye, surfaceNormal);
    try expect(result.equals(Color.init(0.7364, 0.7364, 0.7364)));
}

test "45 degree light & eye" {
    const surfaceMaterial = Material().init();
    const surfacePosition = Tuples.Point(0, 0, 0);

    const position = Tuples.Point(0, 10, -10);
    const intensity = Color.init(1, 1, 1);
    const light = Light().Point(position, intensity);

    const toEye = Tuples.Vector(0, -sqrt(2.0) / 2.0, -sqrt(2.0) / 2.0);
    const surfaceNormal = Tuples.Vector(0, 0, -1);

    const result = light.lighting(surfaceMaterial, surfacePosition, toEye, surfaceNormal);
    try expect(result.equals(Color.init(1.6364, 1.6364, 1.6364)));
}

test "behind surface light" {
    const surfaceMaterial = Material().init();
    const surfacePosition = Tuples.Point(0, 0, 0);

    const position = Tuples.Point(0, 0, 10);
    const intensity = Color.init(1, 1, 1);
    const light = Light().Point(position, intensity);

    const toEye = Tuples.Vector(0, 0, -1);
    const surfaceNormal = Tuples.Vector(0, 0, -1);

    const result = light.lighting(surfaceMaterial, surfacePosition, toEye, surfaceNormal);
    try expect(result.equals(Color.init(0.1, 0.1, 0.1)));
}
