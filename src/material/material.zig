const Color = @import("../color/color.zig").Color;

pub fn Material() type {
    return struct {
        color: Color,
        ambient: f64,
        diffuse: f64,
        specular: f64,
        shininess: f64,

        pub fn init() @This() {
            return .{
                .color = Color.init(1, 1, 1),
                .ambient = 0.1,
                .diffuse = 0.9,
                .specular = 0.9,
                .shininess = 200.0,
            };
        }

        pub fn equals(self: Material(), other: Material()) bool {
            return self.color.equals(other.color) and
                self.ambient == other.ambient and
                self.diffuse == other.diffuse and
                self.specular == other.specular and
                self.shininess == other.shininess;
        }
    };
}
