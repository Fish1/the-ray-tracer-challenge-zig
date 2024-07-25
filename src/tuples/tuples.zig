const Tuple = @import("../tuple/tuple.zig").Tuple;

pub const Tuples = struct {
    pub fn Point(x: f64, y: f64, z: f64) Tuple() {
        return Tuple().init(x, y, z, 1);
    }

    pub fn Vector(x: f64, y: f64, z: f64) Tuple() {
        return Tuple().init(x, y, z, 0);
    }
};
