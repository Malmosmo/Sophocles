depthColorPair rayMarcher(vec3 rayOrigin, vec3 rayDirection) {
    float depth = 0.0;
    
    for (int i = 0; i < MAX_STEPS; i++) {
        depthColorPair scene = sceneSDF(rayOrigin + depth * rayDirection);
        if (scene.depth < EPSILON) {
            return depthColorPair(depth, scene.color);
        }
        
        depth += scene.depth;
        
        if (depth >= FAR) {
            break;
        }
    }
    return depthColorPair(FAR, vec3(0.2));
}

float depthMarcher(vec3 rayOrigin, vec3 rayDirection) {
    float totalDistance = 0.0;
    int steps;

    for(int i = 0; i < MAX_STEPS; i++) {
        steps = i;
        vec3 point = rayOrigin + totalDistance * rayDirection;
        float dist = sceneSDF(point).depth;
        totalDistance += dist;

        if(dist < EPSILON) {
            break;
        }

        if(dist > FAR) {
            steps = MAX_STEPS;
            break;
        }
    }

    return 1.0 - (float(steps) / float(MAX_STEPS));
}
