const expect = @import("std").testing.expect;
const print = @import("std").debug.print;

const Ray = @import("../ray/ray.zig").Ray;
const Tuple = @import("../tuple/tuple.zig").Tuple;

const Object = @import("../object/object.zig").Object;

const Transform = @import("../transform/transform.zig").Transform;

const Canvas = @import("../canvas/canvas.zig").Canvas;
const Color = @import("../color/color.zig").Color;

test "render sphere 1" {
    const size = 200;

    var buffer: [size * size]Color = undefined;
    var canvas = Canvas.init(size, size, &buffer);

    var ray = Ray().init(
        Tuple.Point(0, 0, -6),
        Tuple.Vector(0, 0, 0),
    );

    const sphere = Object().Sphere();

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
                canvas.set(x, y, Color.init(1, 0, 0));
            }
        }
    }

    try canvas.render("./output/draw_sphere_2.ppm");
}
