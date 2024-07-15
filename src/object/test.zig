const expect = @import("std").testing.expect;

const Object = @import("./object.zig").Object;
const Transform = @import("../transform/transform.zig").Transform;

test "sphere identity transform" {
    const sphere = Object().Sphere();
    try expect(sphere.transform.equals(Transform.Identity()));
}

test "sphere transform" {
    var sphere = Object().Sphere();
    sphere.transform = Transform.Translate(2, 3, 4);
    try expect(sphere.transform.equals(Transform.Translate(2, 3, 4)));
}
