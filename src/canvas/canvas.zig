const std = @import("std");
const Color = @import("../color/color.zig").Color;

pub const Canvas = struct {
    width: usize,
    height: usize,
    buffer: []Color,

    pub fn init(comptime width: usize, comptime height: usize, buffer: []Color) Canvas {
        for (buffer) |*pixel| {
            pixel.* = Color.init(0, 0, 0);
        }

        return Canvas{
            .width = width,
            .height = height,
            .buffer = buffer,
        };
    }

    pub fn get(self: Canvas, x: usize, y: usize) Color {
        return self.buffer[y * self.width + x];
    }

    pub fn set(self: Canvas, x: usize, y: usize, color: Color) void {
        self.buffer[y * self.width + x] = color;
    }

    pub fn safeSet(self: Canvas, x: usize, y: usize, color: Color) void {
        if (x >= 0 and x < self.width and y >= 0 and y < self.height) {
            self.buffer[y * self.width + x] = color;
        }
    }

    pub fn render(self: Canvas, destination: []const u8) !void {
        const file = try std.fs.cwd().createFile(
            destination,
            .{ .read = true },
        );
        defer file.close();

        try file.writer().print("P3\n{d} {d}\n255\n", .{ self.width, self.height });

        var index: usize = 0;
        while (index < self.width * self.height) : (index += 1) {
            const ending = if ((index + 1) % self.width == 0) "\n" else " ";

            var red: i64 = @intFromFloat(@round(255 * self.buffer[index].red()));
            red = std.math.clamp(red, 0, 255);
            var green: i64 = @intFromFloat(@round(255 * self.buffer[index].green()));
            green = std.math.clamp(green, 0, 255);
            var blue: i64 = @intFromFloat(@round(255 * self.buffer[index].blue()));
            blue = std.math.clamp(blue, 0, 255);

            try file.writer().print("{d} {d} {d}{s}", .{ red, green, blue, ending });
        }
    }
};
