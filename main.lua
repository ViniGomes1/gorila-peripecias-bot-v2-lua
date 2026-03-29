local api = require('telegram-bot-lua').configure('8009230244:AAHcHJL3L65eQDg22BnESWjrfl_7uvtdPXg')

function api.on_message(message)
    local cmd = api.extract_command(message)
    if cmd and cmd.command == 'start' then
        api.send_reply(message, 'Olá, como começaremos?')
    end
end

api.run({ timeout = 60 })