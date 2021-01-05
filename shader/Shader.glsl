vec3 getNormal(vec3 p) {
    return normalize(
        vec3(
            sceneSDF(vec3(p.x + EPSILON, p.y, p.z)).depth -
                sceneSDF(vec3(p.x - EPSILON, p.y, p.z)).depth,
            sceneSDF(vec3(p.x, p.y + EPSILON, p.z)).depth -
                sceneSDF(vec3(p.x, p.y - EPSILON, p.z)).depth,
            sceneSDF(vec3(p.x, p.y, p.z + EPSILON)).depth -
                sceneSDF(vec3(p.x, p.y, p.z - EPSILON)).depth
        )
    );
}

float shadow(vec3 point, vec3 direction) {
    point = point + getNormal(point) * 0.002;
    float t = NEAR;
    for (int i = 0; i < 100; i++) {
        float h = sceneSDF(point + direction * t).depth;
        if(h < 0.001) {
            return 0.0;
        }
        if (t > FAR) {
            break;
        }
        t += h;
    }
    return 1.0;
}

float softshadow(vec3 point, vec3 direction, float k) {
    point = point + getNormal(point) * 0.002;
    float res = 1.0;
    float t = NEAR;
    for (int i = 0; i < 100; i++) {
        float h = sceneSDF(point + direction * t).depth;
        if(h < 0.001)
            return 0.0;
        if (t > FAR) {
            break;
        }
        res = min(res, k * h / t);
        t += h;
    }
    return res;
}

vec3 applyFog(vec3  rgb, float distance) {
    float fogAmount = 1.0 - exp(-distance * 0.05);
    vec3 fogColor  = vec3(0.5, 0.6, 0.7);
    return mix(rgb, fogColor, fogAmount);
}

vec3 lambertianShader(vec3 point, light L, vec3 color) {
    vec3 N = getNormal(point);

    vec3 Ldirection = normalize(L.origin - point);

    vec3 lambertColor = color * L.color * max(dot(N, Ldirection), 0.0);

    // shadow
    float s = softshadow(point, Ldirection, 16.0) * 0.75 + 0.25;

    return lambertColor * s;

}

vec3 phongShader(vec3 point, light L, vec3 V, vec3 color) {
    vec3 N = getNormal(point);
    vec3 Ldirection = normalize(L.origin - point);

    vec3 R = 2.0 * dot(Ldirection, N) * N - Ldirection;

    V = normalize(V * (-1.0));


    // Ka = 0.7
    vec3 Ambient = color;

    // Kd = 1.0
    vec3 Diffuse = L.color * max(dot(Ldirection, N), 0.0) * 0.5;

    // Ks = 1.0
    // alpha = 16
    vec3 Specular = L.color * pow(max(dot(R, V), 0.0), 32.0) * 0.5;

    return (Ambient + Diffuse + Specular);
}

vec3 shMain(vec3 eye, vec3 dir) {

    light source = light(vec3(10.0, 10.0, 5.0), vec3(1.0));
    depthColorPair dist = rayMarcher(eye, dir);
    vec3 point = eye + dist.depth * dir;

    vec3 Ldirection = normalize(source.origin - point);

    if (dist.depth >= FAR) {
        return vec3(0.5, 0.6, 0.7);
    }

    vec3 color = phongShader(point, source, dir, dist.color);
    // vec3 color = lambertianShader(point, source, vec3(1.0, 0.5, 0.2));


    // shadow
    float s = 1.0;// softshadow(point, Ldirection, 16.0) * 0.75 + 0.25;

    return applyFog(color * s, dist.depth);

}
