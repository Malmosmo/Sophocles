// Transformations to transform objects
vec3 opRotateX(vec3 point, float angle) {
    float s = sin(angle), c = cos(angle);
    mat3 rot = mat3(
        1.0, 0.0, 0.0,
        0.0, c, s,
        0.0, -s, c
        );
    return rot * point;
}

vec3 opRotateY(vec3 point, float angle) {
    float s = sin(angle), c = cos(angle);
    mat3 rot = mat3(
        c, 0.0, -s,
        0.0, 1.0, 0.0,
        s, 0.0, c
        );
    return rot * point;
}

vec3 opRotateZ(vec3 point, float angle) {
    float s = sin(angle), c = cos(angle);
    mat3 rot = mat3(
        c, s, 0.0,
        -s, c, 0.0,
        0.0, 0.0, 1.0
        );
    return rot * point;
}

vec3 opTranslate(vec3 point, vec3 translation) {
    return point - translation;
}

////////////////////////////////////////////////////////////////
// SPECIAL TRANSFORMATIONS
////////////////////////////////////////////////////////////////

// use directly before sdf
vec3 opElongate(vec3 point, vec3 h) {
    return point - clamp(point, -h, h);
}

// use after sdf
float opRound(float dist, float radius) {
    return dist - radius;
}

// use after sdf
float opOnion(float dist, float thickness) {
    return abs(dist) - thickness;
}

// symmetrie on x-axis
vec3 opSymX(vec3 point) {
    point.x = abs(point.x);
    return point;
}

// symmetrie on y-axis
vec3 opSymY(vec3 point) {
    point.y = abs(point.y);
    return point;
}

// symmetrie on z-axis
vec3 opSymZ(vec3 point) {
    point.z = abs(point.z);
    return point;
}

// repetition
vec3 opRep(vec3 point, vec3 c) {
    return mod(point + 0.5 * c, c) - 0.5 * c;
}

// finite repetition
vec3 opRepLim(vec3 point, float c, vec3 l) {
    return point - c * clamp(round(point / c), -l, l);
}

// Distortions
float opDisplacement(vec3 point) {
    return 0.05 * sin(20.0 * point.x) * sin(20.0 * point.y) * sin(20.0 * point.z);
}

// Twist around y-axis
vec3 opTwist(vec3 p, float scale) {
    float c = cos(scale * p.y);
    float s = sin(scale * p.y);
    mat2  m = mat2(
        c, -s,
        s, c
    );
    return vec3(m * p.xz, p.y);
}

// bend on x-axis
vec3 opCheapBend(vec3 p, float scale) {
    float c = cos(scale * p.x);
    float s = sin(scale * p.x);
    mat2  m = mat2(
        c, -s, 
        s, c
    );
    return vec3(m * p.xy, p.z);
}
