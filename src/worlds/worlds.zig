const World = @import("../world/world.zig").World;
const Material = @import("../material/material.zig").Material;
const Color = @import("../color/color.zig").Color;
const Light = @import("../light/light.zig").Light;
const Transforms = @import("../transforms/transforms.zig").Transforms;
const Objects = @import("../objects/objects.zig").Objects;
const Tuples = @import("../tuples/tuples.zig").Tuples;

pub const Worlds = struct {
    pub fn DefaultWorld() World() {
        var world = World().create();
        var sphere = Objects.Sphere();
        var material = Material().init();
        material.color = Color().init(0.8, 1.0, 0.6);
        material.diffuse = 0.7;
        material.specular = 0.2;
        sphere.material = material;
        sphere.transform = Transforms.Scale(0.5, 0.5, 0.5);
        world.addObject(sphere);
        const light = Light().Point(Tuples.Point(-10, 10, -10), Color().init(1, 1, 1));
        world.addLight(light);
        return world;
    }
};
