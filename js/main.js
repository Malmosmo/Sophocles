// RayMarcher with WebGL

// global vars
let gl, mesh, canvas, shaderProgram;

let config = {
    showStats: true,
    loop: true,
    animation: false,
    canMove: true,
    shader: {
        vertexShader: ["../shader/vertexShader.glsl"],
        fragmentShader: [
            "../shader/Header.glsl",
            "../shader/Combinations.glsl",
            "../shader/Transformations.glsl",
            "../shader/SDF.glsl",
            "../shader/Scene.glsl",
            "../shader/RayMarcher.glsl",
            "../shader/Shader.glsl",
            "../shader/Main.glsl",
        ],
    },
};

KEYCODE = {
    SHIFT: 16,
    CTRL: 17,
    ALT: 18,
    ESC: 27,
    SPACE: 32,
    a: 65,
    c: 67,
    d: 68,
    f: 70,
    h: 72,
    l: 76,
    p: 80,
    r: 82,
    s: 83,
    v: 86,
    w: 87,
};

function initGL() {
    // get canvas
    canvas = document.getElementById("canvas");

    // WebGL stuff
    gl = canvas.getContext("webgl2", {
        antialias: false,
        depth: false,
        preserveDrawingBuffer: true,
    });

    gl.enable(gl.DEPTH_TEST);
    gl.enable(gl.BLEND);
    gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
}

// resize canvas on browser resize
function resize(canvas) {
    let displayWidth = canvas.clientWidth;
    let displayHeight = canvas.clientHeight;

    if (canvas.width !== displayWidth || canvas.height !== displayHeight) {
        canvas.width = displayWidth;
        canvas.height = displayHeight;
        aspectRatio = displayWidth / displayHeight;
    }
}

function drawScene() {
    // calls drawScene again
    if (config["loop"]) {
        normalSceneFrame = window.requestAnimationFrame(drawScene);
    }

    // resizes the image if the browser size changes
    resize(gl.canvas);

    // WebGL stuff
    gl.viewport(0, 0, gl.canvas.width, gl.canvas.height);

    gl.clearColor(0.53, 0.81, 0.92, 1.0);
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

    // gives the shader some input parameters
    shaderProgram.SetUniformVec2("resolution", [
        gl.canvas.width,
        gl.canvas.height,
    ]);
    shaderProgram.SetUniform1f("iFrame", timer.tick);
    shaderProgram.SetUniformVec3("iPlayerPos", camera.GetPos());
    shaderProgram.SetUniformVec3("iPlayerDir", camera.GetDir());

    // draw the mesh.... what else
    mesh.Draw();

    timer.Update();
    camera.Update();
}

function main() {
    // add event listeners for movement
    document.addEventListener("mousemove", mouseMoveEventHandler, false);
    document.addEventListener("keydown", keyDownEventHandler, false);
    document.addEventListener("keyup", keyUpEventHandler, false);

    // init
    initGL();

    // more init
    shaderProgram = new Shader(config["shader"]);
    camera = new Camera();
    timer = new Timer();

    // increase/decrease camera speed on scroll
    canvas.onwheel = mouseWheel;

    // does that really happen?
    if (shaderProgram == null) {
        console.log("Error: Could not create Shader");
        throw "Error: Could not create Shader";
    }

    // gl stuff
    shaderProgram.UseProgram();

    let vertices = [-1.0, -1.0, 1.0, 1.0, -1.0, 1.0, 1.0, -1.0];
    let indices = [2, 0, 1, 1, 0, 3];

    // create Mesh
    mesh = new Mesh(vertices, indices);

    // drawScene
    drawScene();
}
