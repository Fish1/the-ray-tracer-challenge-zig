const expect = @import("std").testing.expect;
const sqrt = @import("std").math.sqrt;
const pi = @import("std").math.pi;

const Object = @import("./object.zig").Object;
const Objects = @import("../objects/objects.zig").Objects;
const Transforms = @import("../transforms/transforms.zig").Transforms;
const Tuple = @import("../tuple/tuple.zig").Tuple;
const Material = @import("../material/material.zig").Material;

test "sphere identity transform" {
    const sphere = Objects.Sphere();
    try expect(sphere.transform.equals(Transforms.Identity()));
}

test "sphere transform" {
    var sphere = Objects.Sphere();
    sphere.transform = Transforms.Translate(2, 3, 4);
    try expect(sphere.transform.equals(Transforms.Translate(2, 3, 4)));
}

test "sphere normal x" {
    const sphere = Objects.Sphere();
    const normal = sphere.normalAt(Tuple.Point(1, 0, 0));
    try expect(normal.equals(Tuple.Vector(1, 0, 0)));
}

test "sphere normal y" {
    const sphere = Objects.Sphere();
    const normal = sphere.normalAt(Tuple.Point(0, 1, 0));
    try expect(normal.equals(Tuple.Vector(0, 1, 0)));
}

test "sphere normal z" {
    const sphere = Objects.Sphere();
    const normal = sphere.normalAt(Tuple.Point(0, 0, 1));
    try expect(normal.equals(Tuple.Vector(0, 0, 1)));
}

test "sphere normal non-axial" {
    const sphere = Objects.Sphere();
    const normal = sphere.normalAt(Tuple.Point(sqrt(3.0) / 3.0, sqrt(3.0) / 3.0, sqrt(3.0) / 3.0));
    try expect(normal.equals(Tuple.Vector(sqrt(3.0) / 3.0, sqrt(3.0) / 3.0, sqrt(3.0) / 3.0)));
}

test "normal is normalized" {
    const sphere = Objects.Sphere();
    const normal = sphere.normalAt(Tuple.Point(sqrt(3.0) / 3.0, sqrt(3.0) / 3.0, sqrt(3.0) / 3.0));
    try expect(normal.equals(normal.normalize()));
}

test "normal on translated sphere" {
    var sphere = Objects.Sphere();
    sphere.transform = Transforms.Translate(0, 1, 0);
    const normal = sphere.normalAt(Tuple.Point(0, 1.70711, -0.70711));
    try expect(normal.equals(Tuple.Vector(0, 0.70711, -0.70711)));
}

test "normal on rotate & scale sphere" {
    var sphere = Objects.Sphere();
    sphere.transform = Transforms.Scale(1, 0.5, 1).multiply(Transforms.RotateZ(pi / 5.0));
    const normal = sphere.normalAt(Tuple.Point(0, sqrt(2.0) / 2.0, -sqrt(2.0) / 2.0));
    try expect(normal.equals(Tuple.Vector(0, 0.97014, -0.24254)));
}

test "sphere has material" {
    const sphere = Objects.Sphere();
    try expect(sphere.material.equals(Material().init()));
}

test "sphere can change material" {
    var sphere = Objects.Sphere();
    var material = Material().init();
    material.ambient = 1;
    sphere.material = material;
    try expect(sphere.material.equals(material));
}
