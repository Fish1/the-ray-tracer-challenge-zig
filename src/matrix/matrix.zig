const std = @import("std");

pub const Matrix = struct {
    width: usize,
    height: usize,

    buffer: []f64,
    allocator: std.mem.Allocator,

    fn alloc(comptime width: usize, comptime height: usize) !Matrix {
        const allocator = std.heap.page_allocator;
        const buffer = try allocator.alloc(f64, width * height);
        return Matrix{
            .width = width,
            .height = height,
            .buffer = buffer,
            .allocator = allocator,
        };
    }

    pub fn free(self: Matrix) void {
        self.allocator.free(self.buffer);
    }
};
