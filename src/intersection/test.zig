const expect = @import("std").testing.expect;
const print = @import("std").debug.print;

const Objects = @import("../objects/objects.zig").Objects;

const Intersection = @import("intersection.zig").Intersection;
const IntersectionList = @import("intersection_list.zig").IntersectionList;

test "intersection 1" {
    const shape = Objects.Sphere();

    const intersection = Intersection().init(3.5, &shape);
    try expect(intersection.time == 3.5);
    try expect(intersection.object == &shape);
}

test "intersections aggregate" {
    const shape = Objects.Sphere();

    const intersection1 = Intersection().init(1, &shape);
    const intersection2 = Intersection().init(2, &shape);

    var intersections = IntersectionList().create();
    defer intersections.destroy();
    intersections.append(intersection1);
    intersections.append(intersection2);

    try expect(intersections.get(0).time == 1.0);
    try expect(intersections.get(1).time == 2.0);
}

test "hit 1" {
    const shape = Objects.Sphere();
    const intersection1 = Intersection().init(1, &shape);
    const intersection2 = Intersection().init(2, &shape);

    var intersections = IntersectionList().create();
    defer intersections.destroy();

    intersections.append(intersection1);
    intersections.append(intersection2);

    const hit = intersections.hit();
    try expect(hit == intersections.get(0));
}

test "hit 2" {
    const shape = Objects.Sphere();
    const intersection1 = Intersection().init(-1, &shape);
    const intersection2 = Intersection().init(1, &shape);

    var intersections = IntersectionList().create();
    defer intersections.destroy();

    intersections.append(intersection1);
    intersections.append(intersection2);

    const hit = intersections.hit();
    try expect(hit == intersections.get(1));
}

test "hit 3" {
    const shape = Objects.Sphere();
    const intersection1 = Intersection().init(-2, &shape);
    const intersection2 = Intersection().init(-1, &shape);

    var intersections = IntersectionList().create();
    defer intersections.destroy();

    intersections.append(intersection1);
    intersections.append(intersection2);

    const hit = intersections.hit();
    try expect(hit == null);
}

test "hit 4" {
    const shape = Objects.Sphere();
    const intersection1 = Intersection().init(5, &shape);
    const intersection2 = Intersection().init(7, &shape);
    const intersection3 = Intersection().init(-3, &shape);
    const intersection4 = Intersection().init(2, &shape);

    var intersections = IntersectionList().create();
    defer intersections.destroy();

    intersections.append(intersection1);
    intersections.append(intersection2);
    intersections.append(intersection3);
    intersections.append(intersection4);

    const hit = intersections.hit();
    try expect(hit == intersections.get(3));
}
