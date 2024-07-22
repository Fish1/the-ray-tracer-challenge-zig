const expect = @import("std").testing.expect;

const Material = @import("./material.zig").Material;
const Color = @import("../color/color.zig").Color;

test "create material" {
    const material = Material().init();
    try expect(material.color.equals(Color.init(1, 1, 1)));
    try expect(material.ambient == 0.1);
    try expect(material.diffuse == 0.9);
    try expect(material.specular == 0.9);
    try expect(material.shininess == 200.0);
}
