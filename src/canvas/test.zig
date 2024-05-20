const Canvas = @import("canvas.zig").Canvas;
const Color = @import("../color/color.zig").Color;
const expect = @import("std").testing.expect;

test "create canvas" {
    var buffer: [10 * 20]Color = undefined;
    const canvas = Canvas.New(10, 20, &buffer);
    for (canvas.buffer) |pixel| {
        try expect(pixel.red() == 0);
        try expect(pixel.green() == 0);
        try expect(pixel.blue() == 0);
    }
}

test "write pixel" {
    var buffer: [10 * 20]Color = undefined;
    const canvas = Canvas.New(10, 20, &buffer);
    canvas.set(2, 3, Color.New(255, 0, 0));
    const result = canvas.get(2, 3);
    const expected_result = Color.New(255, 0, 0);
    try expect(result.equals(expected_result));
}

test "write set canvas color" {
    var buffer: [5 * 3]Color = undefined;
    const canvas = Canvas.New(5, 3, &buffer);
    canvas.set(0, 0, Color.New(1.5, 0, 0));
    canvas.set(2, 1, Color.New(0, 0.5, 0));
    canvas.set(4, 2, Color.New(-0.5, 0, 1));
    try canvas.render("./output/canvas.ppm");
}

test "create flying ball" {
    const width = 300;
    const height = 200;
    var buffer: [width * height]Color = undefined;
    const canvas = Canvas.New(width, height, &buffer);

    var x: i64 = 0;
    var y: i64 = 0;
    const velocity_x = 9;
    var velocity_y: i64 = 17;

    while (x < width) {
        canvas.set(@intCast(@max(x, 0)), @intCast(@max(y, 0)), Color.New(255, 0, 0));
        x += velocity_x;
        y += velocity_y;
        velocity_y -= 1;
    }
    try canvas.render("./output/flying_ball.ppm");
}
