const ArrayList = @import("std").ArrayList;
const heap = @import("std").heap;

const Object = @import("../object/object.zig").Object;
const Light = @import("../light/light.zig").Light;

pub fn World() type {
    return struct {
        objects: ArrayList(Object()),
        lights: ArrayList(Light()),

        pub fn create() @This() {
            const self: @This() = .{
                .objects = ArrayList(Object()).init(heap.page_allocator),
                .lights = ArrayList(Light()).init(heap.page_allocator),
            };
            return self;
        }

        pub fn destroy(self: @This()) @This() {
            self.objects.deinit();
            self.lights.deinit();
        }

        pub fn addObject(self: *@This(), object: Object()) void {
            self.objects.append(object) catch unreachable;
        }

        pub fn addLight(self: *@This(), light: Light()) void {
            self.lights.append(light) catch unreachable;
        }

        pub fn containsObject(self: @This(), otherObject: *const Object()) bool {
            for (self.objects.items) |object| {
                if (object.equals(otherObject)) {
                    return true;
                }
            }
            return false;
        }

        pub fn containsLight(self: @This(), otherLight: *const Light()) bool {
            for (self.lights.items) |light| {
                if (light.equals(otherLight)) {
                    return true;
                }
            }
            return false;
        }
    };
}
