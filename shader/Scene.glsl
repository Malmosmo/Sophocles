/*

// Combinations
opUnion(float d1, float d2) -> float                                                || "adds" d1 to d2
opSubtraction(float d1, float d2) -> float                                          || "subtracts" d2 from d1
opIntersection(float d1, float d2) -> float                                         || displays the intersection of d1 and d2

opSmoothUnion(float d1, float d2, float k) -> float                                 || same as opUnion with smoothness-factor k
opSmoothSubtraction(float d1, float d2, float k) -> float                           || same as opSubtraction with smoothness-factor k
opSmoothIntersection(float d1, float d2, float k) -> float                          || same as opIntersection with smoothness-factor k


// Transformations
opRotateX(vec3 point, float angle) -> vec3                                          || rotates around X-axis
opRotateY(vec3 point, float angle) -> vec3                                          || rotates around Y-axis
opRotateZ(vec3 point, float angle) -> vec3                                          || rotates around Z-axis

opTranslate(vec3 point, vec3 translation) -> vec3                                   || translates an sdf

opElongate(vec3 point, vec3 h) -> vec3                                              || elongates sdf
opRound(float dist, float radius) -> float                                          || rounds sdf
opOnion(float dist, float thickness) -> float                                       || iterate to make "onion rings"

opSymX(vec3 point) -> vec3                                                          || symmetry on X-axis
opSymY(vec3 point) -> vec3                                                          || symmetry on Y-axis
opSymZ(vec3 point) -> vec3                                                          || symmetry on Z-axis

opRep(vec3 point, vec3 c) -> vec3                                                   || repeats sdf infinitly many times
opRepLim(vec3 point, float c, vec3 l) -> vec3                                       || l = bounding cube

opDisplacement(vec3 point) -> float                                                 || added to sdf makes the sdf "displaced"
opTwist(vec3 p, float scale) -> vec3                                                || Twist around the Y-axis
opCheapBend(vec3 p, float scale) -> vec3                                            || bend around the X-axis


// SDFs
sdSphere(vec3 point, float radius) -> float                                         ||
sdBox(vec3 point, vec3 scale) -> float                                              || scale = length of each edge of the cube
sdBoundingBox(vec3 point, vec3 scale, float thickness) -> float                     ||

sdTorus(vec3 point, float radius, float thickness) -> float                         ||
sdCappedTorus(vec3 point, vec2 scale, float radius, float thickness) -> float       || scale = (sin(angle), cos(angle))

sdLink(vec3 point, float size, float radius, float thickness) -> float              || size = length of link
sdCylinder(vec3 point, vec3 scale) -> float                                         ||
sdCone(vec3 point, vec2 c, float height) -> float                                   || scale = (sin(angle), cos(angle))

sdPlane(vec3 point, vec3 normal, float height) -> float                             ||

sdHexPrism(vec3 point, vec2 scale) -> float                                         || scale = (radius, height)
sdTriPrism( vec3 point, vec2 scale) -> float                                        || scale = (radius, height)

sdCapsule(vec3 point, vec3 a, vec3 b, float radius) -> float                        || a and b are the start/end points of the capsule
sdCappedCylinder(vec3 point, float radius, float height) -> float                   ||
sdCappedCone(vec3 point, float height, float lower, float upper) -> float           || lower = lower radius, upper = upper radius
sdSolidAngle(vec3 point, vec2 scale, float radius) -> float                         || scale = (sin(angle), cos(angle))

sdEllipsoid(vec3 point, vec3 radius) -> float                                       || radius = (X-axis, Y-axis, Z-axis)
sdRhombus(vec3 point, float rx, float rz, float height, float roundness) -> float   || rx = radius X-axis, rz = radius Z-axis
sdOctahedron(vec3 point, float scale) -> float                                      ||
sdPyramid(vec3 point, float height) -> float                                        ||

sdTriangle(vec3 point, vec3 a, vec3 b, vec3 c) -> float                             || a, b, c = corners of the triangle
sdRect(vec3 point, vec3 a, vec3 b, vec3 c, vec3 d) -> float                         || a, b, c, d = corners of the Rectangle

*/


depthColorPair sceneSDF(vec3 point) {

    point = opTwist(point, 0.2);

   float d2 = sdBoundingBox(point, vec3(1.0, 1.0, 1.0), 0.2);

    return depthColorPair(d2, vec3(0.2, 0.4, 0.1));
}