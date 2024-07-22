const expect = @import("std").testing.expect;
const print = @import("std").debug.print;

const Ray = @import("../ray/ray.zig").Ray;
const Tuple = @import("../tuple/tuple.zig").Tuple;
const Object = @import("../object/object.zig").Object;
const Material = @import("../material/material.zig").Material;
const Light = @import("../light/light.zig").Light;

const Transform = @import("../transform/transform.zig").Transform;

const Canvas = @import("../canvas/canvas.zig").Canvas;
const Color = @import("../color/color.zig").Color;

test "render sphere 1" {
    const size = 300;

    var buffer: [size * size]Color = undefined;
    var canvas = Canvas.init(size, size, &buffer);

    var ray = Ray().init(
        Tuple.Point(0, 0, -6),
        Tuple.Vector(0, 0, 0),
    );

    var sphere = Object().Sphere();
    var material = Material().init();
    material.color = Color.init(1, 1, 1);
    material.shininess = 100;
    material.diffuse = 1.3;
    sphere.material = material;

    const lightPosition = Tuple.Point(10, -10, -10);
    const lightColor = Color.init(0.6, 0.3, 0.5);
    const light = Light().Point(lightPosition, lightColor);

    const wallSize: f64 = 7.0;
    const halfWallSize: f64 = wallSize / 2.0;

    const pixelSize: f64 = wallSize / size;

    var y: usize = 0;
    while (y < size) : (y += 1) {
        const floatY: f64 = @floatFromInt(y);
        const worldY: f64 = halfWallSize - pixelSize * floatY;

        var x: usize = 0;
        while (x < size) : (x += 1) {
            const floatX: f64 = @floatFromInt(x);
            const worldX: f64 = -halfWallSize + pixelSize * floatX;
            const wallpoint = Tuple.Point(
                worldX,
                worldY,
                10,
            );

            ray.direction = wallpoint.subtract(ray.origin).normalize();

            const intersection = ray.intersect(&sphere);
            if (intersection.length() >= 1) {
                const hit = intersection.get(0);
                const worldPoint = ray.position(hit.time);
                const surfaceNormal = sphere.normalAt(worldPoint);
                const surfaceColor = light.lighting(material, worldPoint, ray.direction.negate(), surfaceNormal);
                canvas.set(x, y, surfaceColor);
            }
        }
    }

    try canvas.render("./output/draw_sphere_2.ppm");
}
