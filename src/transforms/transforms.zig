const math = @import("std").math;

const Matrix = @import("../matrix/matrix.zig").Matrix;

pub const Transforms = struct {
    pub fn Translate(x: f64, y: f64, z: f64) Matrix(4, 4) {
        return Matrix(4, 4).init(&[_]f64{
            1, 0, 0, x,
            0, 1, 0, y,
            0, 0, 1, z,
            0, 0, 0, 1,
        });
    }

    pub fn Scale(x: f64, y: f64, z: f64) Matrix(4, 4) {
        return Matrix(4, 4).init(&[_]f64{
            x, 0, 0, 0,
            0, y, 0, 0,
            0, 0, z, 0,
            0, 0, 0, 1,
        });
    }

    pub fn RotateX(radians: f64) Matrix(4, 4) {
        return Matrix(4, 4).init(&[_]f64{
            1, 0,                 0,                  0,
            0, math.cos(radians), -math.sin(radians), 0,
            0, math.sin(radians), math.cos(radians),  0,
            0, 0,                 0,                  1,
        });
    }

    pub fn RotateY(radians: f64) Matrix(4, 4) {
        return Matrix(4, 4).init(&[_]f64{
            math.cos(radians),  0, math.sin(radians), 0,
            0,                  1, 0,                 0,
            -math.sin(radians), 0, math.cos(radians), 0,
            0,                  0, 0,                 1,
        });
    }

    pub fn RotateZ(radians: f64) Matrix(4, 4) {
        return Matrix(4, 4).init(&[_]f64{
            math.cos(radians), -math.sin(radians), 0, 0,
            math.sin(radians), math.cos(radians),  0, 0,
            0,                 0,                  1, 0,
            0,                 0,                  0, 1,
        });
    }

    pub fn Sheer(xy: f64, xz: f64, yx: f64, yz: f64, zx: f64, zy: f64) Matrix(4, 4) {
        return Matrix(4, 4).init(&[_]f64{
            1,  xy, xz, 0,
            yx, 1,  yz, 0,
            zx, zy, 1,  0,
            0,  0,  0,  1,
        });
    }

    pub fn Identity() Matrix(4, 4) {
        return Matrix(4, 4).Identity();
    }
};
