const matrix = @import("matrix.zig").Matrix;

test "create matrix" {
    const m = try matrix.alloc(4, 4);
    defer m.free();
}
