const Matrix = @import("../matrix/matrix.zig").Matrix;
const Transform = @import("../transform/transform.zig").Transform;

pub fn Object() type {
    return struct {
        transform: Matrix(4, 4),

        pub fn Sphere() @This() {
            return .{
                .transform = Transform.Identity(),
            };
        }
    };
}
