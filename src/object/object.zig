const Matrix = @import("../matrix/matrix.zig").Matrix;
const Transforms = @import("../transforms/transforms.zig").Transforms;
const Tuple = @import("../tuple/tuple.zig").Tuple;
const Tuples = @import("../tuples/tuples.zig").Tuples;
const Material = @import("../material/material.zig").Material;

pub fn Object() type {
    return struct {
        transform: Matrix(4, 4),
        material: Material(),

        pub fn init() @This() {
            return .{
                .transform = Transforms.Identity(),
                .material = Material().init(),
            };
        }

        //pub fn Sphere() @This() {
        //   return .{
        //      .transform = Transforms.Identity(),
        //     .material = Material().init(),
        //};
        //}

        pub fn normalAt(self: @This(), worldSpacePoint: Tuple()) Tuple() {
            const objectOrigin = Tuples.Point(0, 0, 0);
            const objectSpacePoint = self.transform.inverse().multiplyTuple(worldSpacePoint);
            const objectSpaceNormal = objectSpacePoint.subtract(objectOrigin);
            var worldSpaceNormal = self.transform.inverse().transpose().multiplyTuple(objectSpaceNormal);
            worldSpaceNormal.setW(0);
            return worldSpaceNormal.normalize();
        }

        pub fn equals(self: @This(), other: *const @This()) bool {
            const transformsEqual = self.transform.equals(other.transform);
            const materialsEqual = self.material.equals(other.material);
            return transformsEqual and materialsEqual;
        }
    };
}
