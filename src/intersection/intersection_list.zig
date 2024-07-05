const ArrayList = @import("std").ArrayList;
const heap = @import("std").heap;
const mem = @import("std").mem;

const Intersection = @import("intersection.zig").Intersection;

pub fn IntersectionList() type {
    return struct {
        array_list: ArrayList(Intersection()),

        pub fn create() @This() {
            const self: @This() = .{
                .array_list = ArrayList(Intersection()).init(heap.page_allocator),
            };
            return self;
        }

        pub fn destroy(self: *@This()) void {
            self.array_list.deinit();
        }

        pub fn append(self: *@This(), intersection: Intersection()) void {
            self.array_list.append(intersection) catch unreachable;
        }

        pub fn get(self: @This(), index: usize) *const Intersection() {
            return &self.array_list.items[index];
        }

        pub fn length(self: @This()) usize {
            return self.array_list.items.len;
        }
    };
}
