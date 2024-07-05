const expect = @import("std").testing.expect;

const Object = @import("../object/object.zig").Object;

const Intersection = @import("intersection.zig").Intersection;
const IntersectionList = @import("intersection_list.zig").IntersectionList;

test "intersection 1" {
    const shape = Object().Sphere();

    const intersection = Intersection().init(3.5, &shape);
    try expect(intersection.time == 3.5);
    try expect(intersection.object == &shape);
}

test "intersections aggregate" {
    const shape = Object().Sphere();

    const intersection1 = Intersection().init(1, &shape);
    const intersection2 = Intersection().init(2, &shape);

    var intersections = IntersectionList().create();
    defer intersections.destroy();
    intersections.append(intersection1);
    intersections.append(intersection2);

    try expect(intersections.get(0).time == 1.0);
    try expect(intersections.get(1).time == 2.0);
}
