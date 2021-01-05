class Camera {
    /**
     * Constructor for Camera class
     * @param {float} x x-position of camera
     * @param {float} y y-position of camera
     * @param {float} z z-position of camera
     */
    constructor(x = 0, y = 0, z = 0) {
        this.position = new vec3(x, y, z);
        this.direction = new vec3(0, 0, -1);

        this.rotation = new vec2(0, 0);
        this.Xaxis = new vec3(1, 0, 0);

        this.requestPointerLock();

        this.inc = 0.01;

        this.left = false;
        this.right = false;
        this.forwards = false;
        this.backwards = false;
        this.up = false;
        this.down = false;
    }

    /**
     * requests to lock the cursor, so you can look around
     */
    requestPointerLock() {
        canvas.requestPointerLock =
            canvas.requestPointerLock || canvas.mozRequestPointerLock;
        document.exitPointerLock =
            document.exitPointerLock || document.mozExitPointerLock;

        canvas.requestPointerLock();
    }

    /**
     * Changes the direction the camera is
     * looking if your mouse moves
     * @param {IDK} event Mouse event
     */
    MouseMove(event) {
        if (
            document.pointerLockElement === canvas ||
            document.mozPointerLockElement === canvas
        ) {
            let movementX =
                -(event.movementX || event.mozMovementX || 0) / 1000;
            let movementY =
                -(event.movementY || event.mozMovementY || 0) / 1000;

            this.direction = this.direction.rotateY(movementX);

            this.Xaxis = this.Xaxis.rotateY(movementX);

            if (Math.abs(this.rotation.y) < 1.5) {
                this.direction = this.direction.rotate(this.Xaxis, movementY);
            }

            this.rotation.x = (this.rotation.x - movementX) % (Math.PI * 2);
            this.rotation.y = clamp(this.rotation.y + movementY, -1.5, 1.5);
        }
    }

    /**
     * Key Handler for keyboard input
     * @param {number} keyCode number of the key you pressed
     */
    KeyDown(keyCode) {
        if (keyCode === KEYCODE.l) {
            this.requestPointerLock();
        }

        if (keyCode === KEYCODE.a) {
            this.left = true;
        }

        if (keyCode === KEYCODE.d) {
            this.right = true;
        }

        if (keyCode === KEYCODE.s) {
            this.backwards = true;
        }

        if (keyCode === KEYCODE.w) {
            this.forwards = true;
        }

        if (keyCode === KEYCODE.SHIFT) {
            this.down = true;
        }

        if (keyCode === KEYCODE.SPACE) {
            this.up = true;
        }
    }

    /**
     * Key Handler for keyboard input
     * @param {number} keyCode number of the key you released
     */
    KeyUp(keyCode) {
        if (keyCode === KEYCODE.a) {
            this.left = false;
        }

        if (keyCode === KEYCODE.d) {
            this.right = false;
        }

        if (keyCode === KEYCODE.s) {
            this.backwards = false;
        }

        if (keyCode === KEYCODE.w) {
            this.forwards = false;
        }

        if (keyCode === KEYCODE.SHIFT) {
            this.down = false;
        }

        if (keyCode === KEYCODE.SPACE) {
            this.up = false;
        }
    }

    /**
     * Update function called once in 'drawScene'
     */
    Update() {
        if (config["canMove"]) {
            let direction = new vec2(
                this.direction.x,
                this.direction.z
            ).normalize();

            if (this.forwards && !this.backwards) {
                this.position.x += direction.x * this.inc;
                this.position.z += direction.y * this.inc;
            }

            if (this.backwards && !this.forwards) {
                this.position.x -= direction.x * this.inc;
                this.position.z -= direction.y * this.inc;
            }

            if (this.left && !this.right) {
                this.position.x += direction.y * this.inc;
                this.position.z -= direction.x * this.inc;
            }

            if (this.right && !this.left) {
                this.position.x -= direction.y * this.inc;
                this.position.z += direction.x * this.inc;
            }

            if (this.up && !this.down) {
                this.position.y += this.inc;
            }

            if (this.down && !this.up) {
                this.position.y -= this.inc;
            }
        }

        if (config["showStats"]) {
            document.getElementById("pos").innerHTML = this.position;
            document.getElementById("dir").innerHTML = this.direction;
            document.getElementById("speed").innerHTML = this.inc;
        }
    }

    /**
     * Returns the camera position as an array
     */
    GetPos() {
        return [this.position.x, this.position.y, this.position.z];
    }

    /**
     * Returns the camera position as an array
     */
    GetDir() {
        return [this.direction.x, this.direction.y, this.direction.z];
    }
}
