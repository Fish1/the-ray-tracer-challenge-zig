const Object = @import("../object/object.zig").Object;

pub fn Intersection() type {
    return struct {
        time: f64,
        object: *const Object(),

        pub fn init(time: f64, object: *const Object()) @This() {
            return .{
                .time = time,
                .object = object,
            };
        }
    };
}
