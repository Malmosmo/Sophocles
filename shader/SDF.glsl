float sdSphere(vec3 point, float radius) {
    return length(point) - radius;
}

float sdBox(vec3 point, vec3 scale) {
    vec3 q = abs(point) - scale;
    return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}

float sdBoundingBox(vec3 point, vec3 scale, float thickness) {
    point = abs(point) - scale;
    vec3 q = abs(point + thickness) - thickness;
    return min(
        min(
            length(max(vec3(point.x, q.y, q.z), 0.0)) +
                min(max(point.x, max(q.y, q.z)), 0.0),
            length(max(vec3(q.x, point.y, q.z), 0.0)) +
                min(max(q.x, max(point.y, q.z)), 0.0)
        ),
        length(max(vec3(q.x, q.y, point.z), 0.0)) +
            min(max(q.x, max(q.y, point.z)), 0.0)
    );
}

float sdTorus(vec3 point, float radius, float thickness) {
    vec2 q = vec2(length(point.xz) - radius, point.y);
    return length(q) - thickness;
}

float sdCappedTorus(vec3 point, vec2 scale, float radius, float thickness) {
    point.x = abs(point.x);
    float k = scale.y * point.x > scale.x * point.y
        ? dot(point.xy, scale)
        : length(point.xy);
    return sqrt(dot(point, point) + radius * radius - 2.0 * radius * k) - thickness;
}

float sdLink(vec3 point, float size, float radius, float thickness) {
    vec3 q = vec3(point.x, max(abs(point.y) - size, 0.0), point.z);
    return length(vec2(length(q.xy) - radius, q.z)) - thickness;
}

float sdCylinder(vec3 point, vec3 scale) {
    return length(point.xz - scale.xy) - scale.z;
}

float sdCone(vec3 point, vec2 c, float height) {
    // c is the sin/cos of the angle, h is height
    // Alternatively pass q instead of (c,h),
    // which is the point at the base in 2D
    vec2 q = height * vec2(c.x / c.y, -1.0);
    vec2 w = vec2(length(point.xz), point.y);
    vec2 a = w - q * clamp(dot(w, q) / dot(q, q), 0.0, 1.0);
    vec2 b = w - q * vec2(clamp(w.x / q.x, 0.0, 1.0), 1.0);
    float k = sign(q.y);
    float d = min(dot(a, a), dot(b, b));
    float s = max(k * (w.x * q.y - w.y * q.x), k * (w.y - q.y));
    return sqrt(d) * sign(s);
}

float sdPlane(vec3 point, vec3 normal, float height) {
    return dot(point, normal) + height;
}

float sdHexPrism(vec3 point, vec2 scale) {
    const vec3 k = vec3(-M_SQRT_3_DIV_2, 0.5, M_1_DIV_SQRT_3);
    point = abs(point);
    point.xy -= 2.0 * min(dot(k.xy, point.xy), 0.0) * k.xy;
    vec2 d = vec2(
        length(
            point.xy -
                vec2(clamp(point.x, -k.z * scale.x, k.z * scale.x), scale.x)
        ) * sign(point.y - scale.x),
        point.z - scale.y
    );
    return min(max(d.x, d.y), 0.0) + length(max(d, 0.0));
}

float sdTriPrism( vec3 point, vec2 scale) {
    vec3 q = abs(point);
    return max(
        q.z - scale.y,
        max(q.x * M_SQRT_3_DIV_2 + point.y * 0.5, -point.y) - scale.x * 0.5
    );
}

float sdCapsule(vec3 point, vec3 a, vec3 b, float radius) {
    vec3 pa = point - a, ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h) - radius;
}

float sdCappedCylinder(vec3 point, float radius, float height) {
    vec2 d = abs(vec2(length(point.xz), point.y)) - vec2(radius, height);
    return min(max(d.x, d.y), 0.0) + length(max(d, 0.0));
}

float sdCappedCone(vec3 point, float height, float lower, float upper) {
    vec2 q = vec2(length(point.xz), point.y);
    vec2 k1 = vec2(upper, height);
    vec2 k2 = vec2(upper - lower, 2.0 * height);
    vec2 ca = vec2(q.x - min(q.x, (q.y < 0.0) ? lower : upper), abs(q.y) - height);
    vec2 cb = q - k1 + k2 * clamp(dot(k1 - q, k2) / dot2(k2), 0.0, 1.0);
    float s = (cb.x < 0.0 && ca.y < 0.0) ? -1.0 : 1.0;
    return s * sqrt(min(dot2(ca), dot2(cb)));
}

float sdSolidAngle(vec3 point, vec2 scale, float radius) {
    vec2 q = vec2(length(point.xz), point.y);
    float l = length(q) - radius;
    float m = length(q - scale * clamp(dot(q, scale), 0.0, radius));
    return max(l, m * sign(scale.y * q.x - scale.x * q.y));
}

float sdEllipsoid(vec3 point, vec3 radius) {
    float k0 = length(point / radius);
    float k1 = length(point / (radius * radius));
    return k0 * (k0 - 1.0) / k1;
}

float sdRhombus(vec3 point, float rx, float rz, float height, float roundness) {
    point = abs(point);
    vec2 b = vec2(rx, rz);
    float f = clamp((ndot(b, b - 2.0 * point.xz)) / dot(b, b), -1.0, 1.0);
    vec2 q = vec2(
        length(point.xz - 0.5 * b * vec2(1.0 - f, 1.0 + f)) *
            sign(point.x * b.y + point.z * b.x - b.x * b.y) -
            roundness,
        point.y - height
    );
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0));
}

float sdOctahedron(vec3 point, float scale) {
    point = abs(point);
    float m = point.x + point.y + point.z - scale;
    vec3 q;
    if (3.0 * point.x < m) q = point.xyz;
    else if (3.0 * point.y < m) q = point.yzx;
    else if (3.0 * point.z < m ) q = point.zxy;
    else return m * M_1_DIV_SQRT_3;
    
    float k = clamp(0.5 * (q.z - q.y + scale), 0.0, scale); 
    return length(vec3(q.x, q.y - scale + k, q.z - k)); 
}

float sdPyramid(vec3 point, float height) {
    float m2 = height * height + 0.25;
        
    point.xz = abs(point.xz);
    point.xz = (point.z > point.x) ? point.zx : point.xz;
    point.xz -= 0.5;

    vec3 q = vec3(
        point.z,
        height * point.y - 0.5 * point.x,
        height * point.x + 0.5 * point.y
    );
    
    float s = max(-q.x, 0.0);
    float t = clamp((q.y - 0.5 * point.z) / (m2 + 0.25), 0.0, 1.0);
        
    float a = m2 * (q.x + s) * (q.x + s) + q.y * q.y;
    float b = m2 * (q.x + 0.5 * t) * (q.x + 0.5 * t) +
        (q.y - m2 * t) * (q.y - m2 * t);
        
    float d2 = min(q.y, -q.x * m2 - q.y * 0.5) > 0.0 ? 0.0 : min(a, b);
        
    return sqrt((d2 + q.z * q.z) / m2) * sign(max(q.z, -point.y));
}

float sdTriangle(vec3 point, vec3 a, vec3 b, vec3 c) {
    vec3 ba = b - a; vec3 pa = point - a;
    vec3 cb = c - b; vec3 pb = point - b;
    vec3 ac = a - c; vec3 pc = point - c;
    vec3 nor = cross(ba, ac);

    return sqrt(
        sign(dot(cross(ba, nor), pa)) +
            sign(dot(cross(cb, nor), pb)) +
            sign(dot(cross(ac, nor), pc)) <
            2.0
            ? min(
                  min(
                      dot2(ba * clamp(dot(ba, pa) / dot2(ba), 0.0, 1.0) - pa),
                      dot2(cb * clamp(dot(cb, pb) / dot2(cb), 0.0, 1.0) - pb)
                  ),
                  dot2(ac * clamp(dot(ac, pc) / dot2(ac), 0.0, 1.0) - pc)
              )
            : (dot(nor, pa) * dot(nor, pa)) / dot2(nor)
    );
}

float sdRect(vec3 point, vec3 a, vec3 b, vec3 c, vec3 d) {
    vec3 ba = b - a; vec3 pa = point - a;
    vec3 cb = c - b; vec3 pb = point - b;
    vec3 dc = d - c; vec3 pc = point - c;
    vec3 ad = a - d; vec3 pd = point - d;
    vec3 nor = cross(ba, ad);

    return sqrt(
        sign(dot(cross(ba, nor), pa)) +
            sign(dot(cross(cb, nor), pb)) +
            sign(dot(cross(dc, nor), pc)) +
            sign(dot(cross(ad, nor), pd)) <
            3.0
            ? min(
                  min(
                      min(
                          dot2(
                              ba * clamp(dot(ba, pa) / dot2(ba), 0.0, 1.0) - pa
                          ),
                          dot2(
                              cb * clamp(dot(cb, pb) / dot2(cb), 0.0, 1.0) - pb
                          )
                      ),
                      dot2(dc * clamp(dot(dc, pc) / dot2(dc), 0.0, 1.0) - pc)
                  ),
                  dot2(ad * clamp(dot(ad, pd) / dot2(ad), 0.0, 1.0) - pd)
              )
            : (dot(nor, pa) * dot(nor, pa)) / dot2(nor)
    );
}
