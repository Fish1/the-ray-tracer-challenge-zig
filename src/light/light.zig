const pow = @import("std").math.pow;

const Matrix = @import("../matrix/matrix.zig").Matrix;
const Transforms = @import("../transforms/transforms.zig").Transforms;

const Tuple = @import("../tuple/tuple.zig").Tuple;
const Color = @import("../color/color.zig").Color;
const Material = @import("../material/material.zig").Material;

pub fn Light() type {
    return struct {
        transform: Matrix(4, 4),
        position: Tuple(),
        intensity: Color(),

        pub fn Point(position: Tuple(), intensity: Color()) @This() {
            return .{
                .transform = Transforms.Identity(),
                .position = position,
                .intensity = intensity,
            };
        }

        pub fn equals(self: @This(), other: *const @This()) bool {
            const transformsEqual = self.transform.equals(other.transform);
            const positionsEqual = self.position.equals(other.position);
            const intensityEqual = self.intensity.equals(other.intensity);
            return transformsEqual and positionsEqual and intensityEqual;
        }

        pub fn lighting(self: @This(), material: Material(), surfacePoint: Tuple(), toEye: Tuple(), surfaceNormal: Tuple()) Color() {
            const effectiveColor = material.color.multiply(self.intensity);
            const lightVector = self.position.subtract(surfacePoint).normalize();
            const ambient = effectiveColor.multiplyScaler(material.ambient);

            var diffuse = Color().init(0, 0, 0);
            var specular = Color().init(0, 0, 0);

            const lightDotNormal = lightVector.dot(surfaceNormal);
            if (lightDotNormal >= 0) {
                diffuse = effectiveColor.multiplyScaler(material.diffuse).multiplyScaler(lightDotNormal);
                const reflection = lightVector.multiplyScaler(-1).reflect(surfaceNormal);
                const reflectDotEye = reflection.dot(toEye);
                if (reflectDotEye > 0) {
                    const factor = pow(f64, reflectDotEye, material.shininess);
                    specular = self.intensity.multiplyScaler(material.specular).multiplyScaler(factor);
                }
            }

            return ambient.add(diffuse).add(specular);
        }
    };
}
