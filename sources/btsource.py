class CustomBot:
    def __init__(self, token):
        self.token = token
        self.running = False
        self.commands = {}   # only user-created commands

    # ----- Events -----
    def onstart(self):
        print(f"BotStartingPrompt {self.token}")
        self.running = True

    def oncommand(self, command, *args):
        print(f"Command received: {command} {args}")

    def onping(self, at_tag):
        print(f"Ping event for {at_tag}")

    def onstopresponding(self):
        print("Bot stopped responding.")
        self.running = False

    def onerror(self, error_message):
        print(f"Error: {error_message}")

    # ----- Custom Commands -----
    def register_command(self, name, func):
        self.commands[name] = func
        print(f"Custom command '{name}' registered.")

    def run_command(self, name, *args):
        if name in self.commands:
            try:
                self.commands[name](*args)
            except Exception as e:
                self.onerror(str(e))
        else:
            print(f"Unknown command: {name}")

    # ----- Runtime Loop -----
    def run(self):
        self.onstart()

        while self.running:
            try:
                line = input("> ").strip()
                if not line:
                    continue

                parts = line.split(" ")
                cmd = parts[0]
                args = parts[1:]

                # event hook
                self.oncommand(cmd, *args)

                # custom command
                self.run_command(cmd, *args)

            except Exception as e:
                self.onerror(str(e))


def onstart(bottoken):
    bot = CustomBot(bottoken)

    
    
    return bot

