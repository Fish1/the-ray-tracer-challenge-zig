const Color = @import("../color/color.zig").Color;

pub const Canvas = struct {
    width: u64,
    height: u64,
    pixels: []Color,

    pub fn New(comptime width: u64, comptime height: u64) Canvas {
        var pixels: [width * height]Color = undefined;

        for (&pixels) |*pixel| {
            pixel.* = Color.New(0, 0, 0);
        }

        return Canvas{
            .width = width,
            .height = height,
            .pixels = &pixels,
        };
    }

    pub fn get(self: Canvas, x: usize, y: usize) Color {
        return self.pixels[y * self.width + x];
    }

    pub fn set(self: Canvas, x: usize, y: usize, color: Color) void {
        self.pixels[y * self.width + x] = color;
    }
};
