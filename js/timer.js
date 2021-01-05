class Timer {
    /**
     * Constructor for Timer class
     */
    constructor() {
        this.frameCounter = 0;
        this.tick = 0;

        this.time = new Date();
    }

    /**
     * Called once in 'drawScene'
     */
    Update() {
        this.frameCounter++;

        if (this.frameCounter % 10 == 0) {
            let now = new Date();
            let elapsedTime = now - this.time;

            let fps = Math.round(10e3 / elapsedTime);

            if (config["showStats"]) {
                document.getElementById("fps").innerHTML = fps;
            }

            this.time = now;
        }

        if (config["animation"]) {
            this.tick++;
        }
    }
}
