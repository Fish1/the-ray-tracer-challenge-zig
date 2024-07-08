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

        pub fn hit(self: @This()) ?*const Intersection() {
            if (self.array_list.items.len == 0) {
                return null;
            }
            var result: *const Intersection() = &self.array_list.items[0];
            for (self.array_list.items) |*item| {
                if (item.time < result.time or result.time < 0) {
                    result = item;
                }
            }
            if (result.time <= 0) {
                return null;
            }
            return result;
        }
    };
}
