// custombot.js

class CustomBot {
    constructor(token) {
        this.token = token;
        this.running = false;
        this.commands = {}; // only user-created commands
    }

    // ===== Events =====

    onstart() {
        console.log("BotStartingPrompt " + this.token);
        this.running = true;
    }

    oncommand(cmd, ...args) {
        console.log("Command event:", cmd, ...args);
    }

    onping(atTag) {
        console.log("Ping event for " + atTag);
    }

    onstopresponding() {
        console.log("Bot stopped responding.");
        this.running = false;
    }

    onerror(msg) {
        console.log("Error:", msg);
    }

    // ===== Command System =====

    register_command(name, func) {
        this.commands[name] = func;
    }

    run_command(name, ...args) {
        const fn = this.commands[name];
        if (!fn) {
            console.log("Unknown command:", name);
            return;
        }

        try {
            fn(...args);
        } catch (err) {
            this.onerror(err);
        }
    }

    // ===== Main Runtime Loop =====

    run() {
        this.onstart();

        const readline = require("readline").createInterface({
            input: process.stdin,
            output: process.stdout
        });

        const ask = () => {
            if (!this.running) return readline.close();

            readline.question("> ", line => {
                if (line && line.trim() !== "") {
                    const parts = line.trim().split(/\s+/);
                    const cmd = parts.shift();
                    const args = parts;

                    this.oncommand(cmd, ...args);
                    this.run_command(cmd, ...args);
                }

                ask();
            });
        };

        ask();
    }
}

// entry point
function createBot(token) {
    return new CustomBot(token);
}

module.exports = {
    createBot,
    CustomBot
};
