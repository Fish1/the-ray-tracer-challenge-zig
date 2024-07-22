comptime {
    if (@import("builtin").is_test) {
        _ = @import("./_render_tests/render_sphere.zig");
    }
}
