const World = @import("../world/world.zig").World;
const Object = @import("../object/object.zig").Object;
const Material = @import("../material/material.zig").Material;
const Color = @import("../color/color.zig").Color;
const Light = @import("../light/light.zig").Light;
const Transform = @import("../transform/transform.zig").Transform;
const Tuple = @import("../tuple/tuple.zig").Tuple;

pub const Worlds = struct {
    pub fn DefaultWorld() World() {
        var world = World().create();
        var sphere = Object().Sphere();
        var material = Material().init();
        material.color = Color.init(0.8, 1.0, 0.6);
        material.diffuse = 0.7;
        material.specular = 0.2;
        sphere.material = material;
        sphere.transform = Transform.Scale(0.5, 0.5, 0.5);
        world.addObject(sphere);
        const light = Light().Point(Tuple.Point(-10, 10, -10), Color.init(1, 1, 1));
        world.addLight(light);
        return world;
    }
};
