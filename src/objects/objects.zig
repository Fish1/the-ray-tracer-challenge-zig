const Object = @import("../object/object.zig").Object;

pub const Objects = struct {
    pub fn Sphere() Object() {
        return Object().init();
    }
};
