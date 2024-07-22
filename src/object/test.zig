const expect = @import("std").testing.expect;
const sqrt = @import("std").math.sqrt;
const pi = @import("std").math.pi;

const Object = @import("./object.zig").Object;
const Transform = @import("../transform/transform.zig").Transform;
const Tuple = @import("../tuple/tuple.zig").Tuple;
const Material = @import("../material/material.zig").Material;

test "sphere identity transform" {
    const sphere = Object().Sphere();
    try expect(sphere.transform.equals(Transform.Identity()));
}

test "sphere transform" {
    var sphere = Object().Sphere();
    sphere.transform = Transform.Translate(2, 3, 4);
    try expect(sphere.transform.equals(Transform.Translate(2, 3, 4)));
}

test "sphere normal x" {
    const sphere = Object().Sphere();
    const normal = sphere.normalAt(Tuple.Point(1, 0, 0));
    try expect(normal.equals(Tuple.Vector(1, 0, 0)));
}

test "sphere normal y" {
    const sphere = Object().Sphere();
    const normal = sphere.normalAt(Tuple.Point(0, 1, 0));
    try expect(normal.equals(Tuple.Vector(0, 1, 0)));
}

test "sphere normal z" {
    const sphere = Object().Sphere();
    const normal = sphere.normalAt(Tuple.Point(0, 0, 1));
    try expect(normal.equals(Tuple.Vector(0, 0, 1)));
}

test "sphere normal non-axial" {
    const sphere = Object().Sphere();
    const normal = sphere.normalAt(Tuple.Point(sqrt(3.0) / 3.0, sqrt(3.0) / 3.0, sqrt(3.0) / 3.0));
    try expect(normal.equals(Tuple.Vector(sqrt(3.0) / 3.0, sqrt(3.0) / 3.0, sqrt(3.0) / 3.0)));
}

test "normal is normalized" {
    const sphere = Object().Sphere();
    const normal = sphere.normalAt(Tuple.Point(sqrt(3.0) / 3.0, sqrt(3.0) / 3.0, sqrt(3.0) / 3.0));
    try expect(normal.equals(normal.normalize()));
}

test "normal on translated sphere" {
    var sphere = Object().Sphere();
    sphere.transform = Transform.Translate(0, 1, 0);
    const normal = sphere.normalAt(Tuple.Point(0, 1.70711, -0.70711));
    try expect(normal.equals(Tuple.Vector(0, 0.70711, -0.70711)));
}

test "normal on rotate & scale sphere" {
    var sphere = Object().Sphere();
    sphere.transform = Transform.Scale(1, 0.5, 1).multiply(Transform.RotateZ(pi / 5.0));
    const normal = sphere.normalAt(Tuple.Point(0, sqrt(2.0) / 2.0, -sqrt(2.0) / 2.0));
    try expect(normal.equals(Tuple.Vector(0, 0.97014, -0.24254)));
}

test "sphere has material" {
    const sphere = Object().Sphere();
    try expect(sphere.material.equals(Material().init()));
}

test "sphere can change material" {
    var sphere = Object().Sphere();
    var material = Material().init();
    material.ambient = 1;
    sphere.material = material;
    try expect(sphere.material.equals(material));
}
