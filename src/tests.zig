comptime {
    if (@import("builtin").is_test) {
        _ = @import("./color/test.zig");
        _ = @import("./tuple/test.zig");
        _ = @import("./canvas/test.zig");
        _ = @import("./matrix/test.zig");
        _ = @import("./transform/test.zig");
        _ = @import("./ray/test.zig");
        _ = @import("./intersection/test.zig");
        _ = @import("./object/test.zig");
        _ = @import("./light/test.zig");
        _ = @import("./material/test.zig");
    }
}
