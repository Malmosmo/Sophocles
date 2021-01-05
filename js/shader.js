class Shader {
    /**
     * Constructor for Shader class
     * @param {Object} shaders Dictionary with fragment and vertex shader
     */
    constructor(shaders) {
        this.shaderProgram = gl.createProgram();

        let vertexShader = this.getShader(
            shaders["vertexShader"],
            gl.VERTEX_SHADER
        );

        let fragmentShader = this.getShader(
            shaders["fragmentShader"],
            gl.FRAGMENT_SHADER
        );

        if (fragmentShader === null || vertexShader === null) {
            this.shaderProgram = null;
            return;
        }

        gl.attachShader(this.shaderProgram, vertexShader);
        gl.attachShader(this.shaderProgram, fragmentShader);
        gl.linkProgram(this.shaderProgram);

        if (!gl.getProgramParameter(this.shaderProgram, gl.LINK_STATUS)) {
            alert("Could not initialise shaders");
        }
    }

    /**
     * Read the shader file, compile it, and create a WebGL shader
     * @param {HTML Class ID} id Class ID of the shader in the active DOM
     */
    getShader(shaderFiles, shaderType) {
        let shaderText = "";

        shaderFiles.forEach((shaderFile) => {
            shaderText += this.readTextFile(shaderFile);
        });

        let shader = gl.createShader(shaderType);

        gl.shaderSource(shader, shaderText);
        gl.compileShader(shader);

        // TODO: Change this to appropriate html
        if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
            console.log("ERROR!");
            console.log(gl.getShaderInfoLog(shader));

            /*

            let element = document.getElementById("error");
            element.style.display = "block";
            element.innerHTML =
                `<div class="section" id="sec1">
                 <div id="title">GLSL COMPILE ERROR</div>
                 <pre class="code"><code class="GLSL">` +
                gl.getShaderInfoLog(shader) +
                `</code></pre>
                 </div>
                 <div class="section" id="sec2">
                 <div id="title">GLSL SOURCE CODE</div>
                 <pre class="code"><code class="GLSL">` +
                gl.getShaderSource(shader) +
                `</code></pre>
                 </div>
                 </figure>`;
            */

            return null;
        }

        return shader;
    }

    /**
     * Reads a shader file
     * @param {string} path Path to the File of the shader
     */
    readTextFile(path) {
        let result = null;
        let xmlhttp = new XMLHttpRequest();
        xmlhttp.open("GET", path, false);
        // xmlhttp.setRequestHeader("Content-Type", "text/plain");
        xmlhttp.send();
        if (xmlhttp.status == 200) {
            result = xmlhttp.responseText;
        }
        return result;
    }

    /**
     * Return the WebGL shader program
     */
    GetProgram() {
        return this.shaderProgram;
    }

    /**
     * Set the WebGL shader program to be the active renderer
     */
    UseProgram() {
        gl.useProgram(this.shaderProgram);
    }

    /**
     * Set a vec2 uniform in the shader program
     * @param {string} uniformName Name of the uniform in the shader program
     * @param {flat array} vector 2D vector to pass to the shader
     */
    SetUniformVec2(uniformName, vector) {
        gl.uniform2fv(
            gl.getUniformLocation(this.shaderProgram, uniformName),
            vector
        );
    }

    /**
     * Set a vec3 uniform in the shader program
     * @param {string} uniformName Name of the uniform in the shader program
     * @param {flat array} vector 3D vector to pass to the shader
     */
    SetUniformVec3(uniformName, vector) {
        gl.uniform3fv(
            gl.getUniformLocation(this.shaderProgram, uniformName),
            vector
        );
    }

    /**
     * Set a float uniform in the shader program
     * @param {string} uniformName Name of the uniform in the shader program
     * @param {float} value Float to pass to the shader
     */
    SetUniform1f(uniformName, value) {
        gl.uniform1f(
            gl.getUniformLocation(this.shaderProgram, uniformName),
            value
        );
    }
}
