class vec2 {
    constructor(x, y) {
        this.x = x;
        this.y = y;
    }

    lenght() {
        return Math.sqrt(this.x * this.x + this.y * this.y);
    }

    normalize() {
        let l = this.lenght();
        return new vec2(this.x / l, this.y / l);
    }

    toString() {
        return (
            "vec2(" +
            Math.round(this.x * 100) / 100 +
            ", " +
            Math.round(this.y * 100) / 100 +
            ")"
        );
    }
}

class vec3 {
    constructor(x, y, z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    add(other) {
        return new vec3(this.x + other.x, this.y + other.y, this.z + other.z);
    }

    sub(other) {
        return new vec3(this.x - other.x, this.y - other.y, this.z - other.z);
    }

    mul(scalar) {
        return new vec3(this.x * scalar, this.y * scalar, this.z * scalar);
    }

    rotateY(angle) {
        let s = Math.sin(angle);
        let c = Math.cos(angle);

        return new vec3(
            c * this.x + s * this.z,
            this.y,
            c * this.z - s * this.x
        );
    }

    rotate(axis, angle) {
        let s = Math.sin(angle);
        let c = Math.cos(angle);
        let omc = 1 - c;

        let a11 = axis.x * axis.x * omc + c;
        let a12 = axis.x * axis.y * omc - axis.z * s;
        let a13 = axis.x * axis.z * omc + axis.y * s;

        let a21 = axis.x * axis.y * omc + axis.z * s;
        let a22 = axis.y * axis.y * omc + c;
        let a23 = axis.y * axis.z * omc - axis.x * s;

        let a31 = axis.x * axis.z * omc - axis.y * s;
        let a32 = axis.y * axis.z * omc + axis.x * s;
        let a33 = axis.z * axis.z * omc + c;

        return new vec3(
            a11 * this.x + a12 * this.y + a13 * this.z,
            a21 * this.x + a22 * this.y + a23 * this.z,
            a31 * this.x + a32 * this.y + a33 * this.z
        );
    }

    toString() {
        return (
            "vec3(" +
            this.x.toPrecision(2) +
            ", " +
            this.y.toPrecision(2) +
            ", " +
            this.z.toPrecision(2) +
            ")"
        );
    }
}

function clamp(value, min, max) {
    return Math.max(Math.min(value, max), min);
}

function mouseWheel(event) {
    event.preventDefault();

    camera.inc = Math.max(camera.inc - event.deltaY * 0.001, 0);
}

function keyDownEventHandler(event) {
    if (event.keyCode === KEYCODE.c) {
        toggleCamera();
    }

    if (event.keyCode === KEYCODE.h) {
        toggleMenu();
    }

    if (event.keyCode === KEYCODE.p) {
        timer.PlayPause();
    }

    if (event.keyCode === KEYCODE.r) {
        timer.Reset();
    }

    if (event.keyCode === KEYCODE.f) {
        timer.Step();
    }

    camera.KeyDown(event.keyCode);
}

function keyUpEventHandler(event) {
    camera.KeyUp(event.keyCode);
}

function mouseMoveEventHandler(event) {
    camera.MouseMove(event);
}

function mouseWheel(event) {
    event.preventDefault();

    camera.inc = Math.max(camera.inc - event.deltaY * 0.001, 0);
}
