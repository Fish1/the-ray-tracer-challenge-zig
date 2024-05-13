const std = @import("std");
const Tuple = @import("tuple/tuple.zig").Tuple;

pub fn main() !void {
    const a = Tuple{
        .x = 5.0,
        .y = 1.0,
        .z = 1.0,
        .w = 1.0,
    };
    std.debug.print("x = {}\n", .{a.x});

    const b = Tuple.NewTuple(1.0, 1.0, 1.0, 1.0);

    std.debug.print("x = {}\n", .{b.x});
}
