comptime {
    if (@import("builtin").is_test) {
        _ = @import("./color/test.zig");
        _ = @import("./tuple/test.zig");
        _ = @import("./canvas/test.zig");
        _ = @import("./matrix/test.zig");
    }
}
