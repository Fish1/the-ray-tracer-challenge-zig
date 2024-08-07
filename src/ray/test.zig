const expect = @import("std").testing.expect;
const log = @import("std").log;
const heap = @import("std").heap;
const mem = @import("std").mem;
const debug = @import("std").debug;

const Tuples = @import("../tuples/tuples.zig").Tuples;
const Transforms = @import("../transforms/transforms.zig").Transforms;
const Ray = @import("ray.zig").Ray;
const Object = @import("../object/object.zig").Object;
const Objects = @import("../objects/objects.zig").Objects;

test "create a ray" {
    const origin = Tuples.Point(1, 2, 3);
    const direction = Tuples.Vector(4, 5, 6);

    const ray = Ray().init(origin, direction);

    try expect(ray.origin.equals(origin));
    try expect(ray.direction.equals(direction));
}

test "position ray at time" {
    const origin = Tuples.Point(2, 3, 4);
    const direction = Tuples.Vector(1, 0, 0);

    const ray = Ray().init(origin, direction);

    const p1 = ray.position(0);
    const p2 = ray.position(1);
    const p3 = ray.position(-1);
    const p4 = ray.position(2.5);

    try expect(p1.equals(Tuples.Point(2, 3, 4)));
    try expect(p2.equals(Tuples.Point(3, 3, 4)));
    try expect(p3.equals(Tuples.Point(1, 3, 4)));
    try expect(p4.equals(Tuples.Point(4.5, 3, 4)));
}

test "intersect 1" {
    const origin = Tuples.Point(0, 0, -5);
    const direction = Tuples.Vector(0, 0, 1);

    const ray = Ray().init(origin, direction);
    const sphere = Objects.Sphere();

    const result = ray.intersect(&sphere);

    try expect(result.length() == 2);
    try expect(result.get(0).time == 4.0);
    try expect(result.get(1).time == 6.0);
}

test "intersect 2" {
    const origin = Tuples.Point(0, 1, -5);
    const direction = Tuples.Vector(0, 0, 1);

    const ray = Ray().init(origin, direction);
    const sphere = Objects.Sphere();

    const result = ray.intersect(&sphere);

    try expect(result.length() == 2);
    try expect(result.get(0).time == 5.0);
    try expect(result.get(1).time == 5.0);
}

test "intersect 3" {
    const origin = Tuples.Point(0, 2, -5);
    const direction = Tuples.Vector(0, 0, 1);

    const ray = Ray().init(origin, direction);
    const sphere = Objects.Sphere();

    const result = ray.intersect(&sphere);
    try expect(result.length() == 0);
}

test "intersect 4" {
    const origin = Tuples.Point(0, 0, 0);
    const direction = Tuples.Vector(0, 0, 1);

    const ray = Ray().init(origin, direction);
    const sphere = Objects.Sphere();

    const result = ray.intersect(&sphere);
    try expect(result.length() == 2);
    try expect(result.get(0).time == -1.0);
    try expect(result.get(1).time == 1.0);
}

test "intersect 5" {
    const origin = Tuples.Point(0, 0, 5);
    const direction = Tuples.Vector(0, 0, 1);

    const ray = Ray().init(origin, direction);
    const sphere = Objects.Sphere();

    const result = ray.intersect(&sphere);

    try expect(result.length() == 2);
    try expect(result.get(0).time == -6.0);
    try expect(result.get(1).time == -4.0);
}

test "translate ray" {
    const origin = Tuples.Point(1, 2, 3);
    const direction = Tuples.Vector(0, 1, 0);
    const ray = Ray().init(origin, direction);

    const transform = Transforms.Translate(3, 4, 5);
    const result = ray.transform(transform);

    try expect(result.origin.equals(Tuples.Point(4, 6, 8)));
    try expect(result.direction.equals(Tuples.Vector(0, 1, 0)));
}

test "scale ray" {
    const origin = Tuples.Point(1, 2, 3);
    const direction = Tuples.Vector(0, 1, 0);
    const ray = Ray().init(origin, direction);

    const transform = Transforms.Scale(2, 3, 4);
    const result = ray.transform(transform);

    try expect(result.origin.equals(Tuples.Point(2, 6, 12)));
    try expect(result.direction.equals(Tuples.Vector(0, 3, 0)));
}

test "intersects scaled sphere" {
    const origin = Tuples.Point(0, 0, -5);
    const direction = Tuples.Vector(0, 0, 1);
    const ray = Ray().init(origin, direction);

    var sphere = Objects.Sphere();
    sphere.transform = Transforms.Scale(2, 2, 2);

    const result = ray.intersect(&sphere);

    try expect(result.length() == 2);
    try expect(result.get(0).time == 3);
    try expect(result.get(1).time == 7);
}

test "intersects translated sphere" {
    const origin = Tuples.Point(0, 0, -5);
    const direction = Tuples.Vector(0, 0, 1);
    const ray = Ray().init(origin, direction);

    var sphere = Objects.Sphere();
    sphere.transform = Transforms.Translate(5, 0, 0);

    const result = ray.intersect(&sphere);

    try expect(result.length() == 0);
}
