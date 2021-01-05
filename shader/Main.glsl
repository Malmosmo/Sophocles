mat3 lookAtViewMatrix(vec3 eye, vec3 center, vec3 up) {
	vec3 f = normalize(center - eye);
	vec3 s = normalize(cross(f, up));
	vec3 u = cross(s, f);
	return mat3(s, u, -f);
}

vec3 rayDirection(float fieldOfView, vec2 size, vec2 fragCoord) {
    vec2 coordinate = fragCoord - (size / 2.0);
    float zCoordComponent = -1.0 * (size.y / tan(radians(fieldOfView) / 2.0));
    return normalize(vec3(coordinate, zCoordComponent));
}

void main()
{
    vec3 eyePosition = iPlayerPos;

    vec3 center = eyePosition + iPlayerDir;

    vec3 directionOfRay = rayDirection(90.0, resolution.xy, gl_FragCoord.xy);
    mat3 rayTransform = lookAtViewMatrix(
        eyePosition,
        center,
        vec3(0.0, 1.0, 0.0)
    );

    vec3 worldDirection = rayTransform * directionOfRay;

    // COLOR
    vec3 color = shMain(eyePosition, worldDirection);
    gl_FragColor = vec4(color, 1.0);
    
    
    // GREYSCALE
    // float greyScale = depthMarcher(eyePosition, worldDirection);

    // dim greyscale
    // greyScale = pow(greyScale, 4.0);

    // gl_FragColor = vec4(greyScale, greyScale, greyScale, 1.0);    
}
