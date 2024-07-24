const expect = @import("std").testing.expect;

const Light = @import("../light/light.zig").Light;
const Tuple = @import("../tuple/tuple.zig").Tuple;
const Color = @import("../color/color.zig").Color;
const Object = @import("../object/object.zig").Object;
const Material = @import("../material/material.zig").Material;
const Transform = @import("../transform/transform.zig").Transform;

const World = @import("./world.zig").World;
const Worlds = @import("../worlds/worlds.zig").Worlds;

test "empty world" {
    const world = World().create();
    try expect(world.objects.items.len == 0);
    try expect(world.lights.items.len == 0);
}

test "default world" {
    const world = Worlds.DefaultWorld();
    const light = Light().Point(Tuple.Point(-10, 10, -10), Color.init(1, 1, 1));
    var sphere = Object().Sphere();
    var material = Material().init();
    material.color = Color.init(0.8, 1.0, 0.6);
    material.diffuse = 0.7;
    material.specular = 0.2;
    sphere.material = material;
    sphere.transform = Transform.Scale(0.5, 0.5, 0.5);

    try expect(world.containsObject(&sphere) == true);
    try expect(world.containsLight(&light) == true);
}
