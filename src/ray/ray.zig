const math = @import("std").math;
const log = @import("std").log;
const mem = @import("std").mem;

const Tuple = @import("../tuple/tuple.zig").Tuple;
const Object = @import("../object/object.zig").Object;

const IntersectionList = @import("../intersection/intersection_list.zig").IntersectionList;
const Intersection = @import("../intersection/intersection.zig").Intersection;

pub fn Ray() type {
    return struct {
        origin: Tuple,
        direction: Tuple,

        pub fn init(origin: Tuple, direction: Tuple) @This() {
            const self: @This() = .{
                .origin = origin,
                .direction = direction,
            };

            return self;
        }

        pub fn position(self: @This(), time: f64) Tuple {
            return self.origin.add(
                self.direction.multiplyScaler(time),
            );
        }

        pub fn intersect(self: @This(), object: *const Object()) IntersectionList() {
            const shapeToRay = Tuple.subtract(self.origin, Tuple.Point(0, 0, 0));
            const a = Tuple.dot(self.direction, self.direction);
            const b = Tuple.dot(self.direction, shapeToRay) * 2;
            const c = Tuple.dot(shapeToRay, shapeToRay) - 1.0;

            const discriminant = (b * b) - 4 * a * c;
            if (discriminant < 0) {
                return IntersectionList().create();
            }

            var intersectionList = IntersectionList().create();
            const intersection_a = Intersection().init(
                (-b - math.sqrt(discriminant)) / (2 * a),
                object,
            );
            const intersection_b = Intersection().init(
                (-b + math.sqrt(discriminant)) / (2 * a),
                object,
            );
            intersectionList.append(intersection_a);
            intersectionList.append(intersection_b);
            return intersectionList;
        }
    };
}
