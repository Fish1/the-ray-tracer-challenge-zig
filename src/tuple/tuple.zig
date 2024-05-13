const std = @import("std");

pub const Tuple = struct {
    x: f64,
    y: f64,
    z: f64,
    w: f64,

    pub fn New(x: f64, y: f64, z: f64, w: f64) Tuple {
        return Tuple{
            .x = x,
            .y = y,
            .z = z,
            .w = w,
        };
    }

    pub fn NewPoint(x: f64, y: f64, z: f64) Tuple {
        return Tuple{
            .x = x,
            .y = y,
            .z = z,
            .w = 1,
        };
    }

    pub fn NewVector(x: f64, y: f64, z: f64) Tuple {
        return Tuple{
            .x = x,
            .y = y,
            .z = z,
            .w = 0,
        };
    }

    pub fn equals(self: Tuple, other: Tuple) bool {
        const eq = std.math.approxEqAbs;
        return eq(f64, self.x, other.x, 0.00001) and
            eq(f64, self.y, other.y, 0.00001) and
            eq(f64, self.z, other.z, 0.00001) and
            eq(f64, self.w, other.w, 0.00001);
    }

    pub fn add(self: Tuple, other: Tuple) Tuple {
        return Tuple{
            .x = self.x + other.x,
            .y = self.y + other.y,
            .z = self.z + other.z,
            .w = self.w + other.w,
        };
    }

    pub fn subtract(self: Tuple, other: Tuple) Tuple {
        return Tuple{
            .x = self.x - other.x,
            .y = self.y - other.y,
            .z = self.z - other.z,
            .w = self.w - other.w,
        };
    }

    pub fn negative(self: Tuple) Tuple {
        return Tuple{
            .x = -self.x,
            .y = -self.y,
            .z = -self.z,
            .w = -self.w,
        };
    }

    pub fn multiply_scale(self: Tuple, scaler: f64) Tuple {
        return Tuple{
            .x = self.x * scaler,
            .y = self.y * scaler,
            .z = self.z * scaler,
            .w = self.w * scaler,
        };
    }

    pub fn divide_scale(self: Tuple, scaler: f64) Tuple {
        return Tuple{
            .x = self.x / scaler,
            .y = self.y / scaler,
            .z = self.z / scaler,
            .w = self.w / scaler,
        };
    }

    pub fn magnitude(self: Tuple) f64 {
        return std.math.sqrt((self.x * self.x) +
            (self.y * self.y) +
            (self.z * self.z) +
            (self.w * self.w));
    }

    pub fn normalized(self: Tuple) Tuple {
        return Tuple.New(
            self.x / self.magnitude(),
            self.y / self.magnitude(),
            self.z / self.magnitude(),
            self.w / self.magnitude(),
        );
    }

    pub fn dot(self: Tuple, other: Tuple) f64 {
        return self.x * other.x + self.y * other.y + self.z * other.z + self.w * other.w;
    }

    pub fn cross(self: Tuple, other: Tuple) Tuple {
        return Tuple.NewVector(self.y * other.z - self.z * other.y, self.z * other.x - self.x * other.z, self.x * other.y - self.y * other.x);
    }
};
