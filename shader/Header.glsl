precision mediump float;

//uniform float iFrame;

uniform vec3 iPlayerPos;
uniform vec3 iPlayerDir;

uniform vec2 resolution;

// Constants
#define INF 1000000000.0
#define NEAR 0.0
#define FAR 100.0
#define EPSILON 0.0001
#define MAX_STEPS 1024
#define POWER 1.0
#define M_PI 3.1415926535
#define M_SQRT_3_DIV_2 0.8660254037
#define M_1_DIV_SQRT_3 0.5773502691


// Data structures
struct light {
    vec3 origin;
    vec3 color;
};

struct depthColorPair {
    float depth;
    vec3 color;
};

// MATH/Utility functions
float dot2(vec3 a) {
    return dot(a, a);
}

float dot2(vec2 a) {
    return dot(a, a);
}

float ndot(vec2 a, vec2 b) {
    return a.x * b.x - a.y * b.y;
}

vec3 round(vec3 a) {
    return floor(a + 0.5);
}
