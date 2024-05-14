const Canvas = @import("canvas.zig").Canvas;
const Color = @import("../color/color.zig").Color;
const expect = @import("std").testing.expect;

test "create canvas" {
    const a = Canvas.New(10, 20);
    for (a.pixels) |pixel| {
        try expect(pixel.red() == 0);
        try expect(pixel.green() == 0);
        try expect(pixel.blue() == 0);
    }
}

test "write pixel" {
    const a = Canvas.New(10, 20);
    a.set(2, 3, Color.New(255, 0, 0));
    const result = a.get(2, 3);
    const expected_result = Color.New(255, 0, 0);
    try expect(result.equals(expected_result));
}
