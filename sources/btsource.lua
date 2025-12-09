-- custombot.lua

local CustomBot = {}
CustomBot.__index = CustomBot

function CustomBot.new(token)
    local self = setmetatable({}, CustomBot)

    self.token = token
    self.running = false
    self.commands = {}  -- user-created commands only

    return self
end

-- ===== Events =====

function CustomBot:onstart()
    print("BotStartingPrompt " .. tostring(self.token))
    self.running = true
end

function CustomBot:oncommand(cmd, ...)
    print("Command event:", cmd, ...)
end

function CustomBot:onping(at_tag)
    print("Ping event for " .. tostring(at_tag))
end

function CustomBot:onstopresponding()
    print("Bot stopped responding.")
    self.running = false
end

function CustomBot:onerror(msg)
    print("Error:", msg)
end

-- ===== Command System =====

function CustomBot:register_command(name, func)
    self.commands[name] = func
end

function CustomBot:run_command(name, ...)
    local fn = self.commands[name]
    if not fn then
        print("Unknown command:", name)
        return
    end

    local ok, err = pcall(fn, ...)
    if not ok then
        self:onerror(err)
    end
end

-- ===== Main Runtime Loop =====

function CustomBot:run()
    self:onstart()

    while self.running do
        io.write("> ")
        local line = io.read("*l")

        if line and line ~= "" then
            local parts = {}
            for word in line:gmatch("%S+") do
                table.insert(parts, word)
            end

            local cmd = parts[1]
            table.remove(parts, 1) -- remaining are args

            self:oncommand(cmd, table.unpack(parts))
            self:run_command(cmd, table.unpack(parts))
        end
    end
end

-- top-level entry (like Python's onstart function)
local function createBot(token)
    return CustomBot.new(token)
end

return {
    createBot = createBot,
    CustomBot = CustomBot
}
