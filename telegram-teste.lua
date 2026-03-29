local api = require('telegram-bot-lua').configure(os.getenv("TELEGRAM_KEY"), true)

local AmazonScraping = require("AmazonScrapinClass")
local pegasus = require("pegasus")
local json = require("cjson")

--&#8986; por onde comecamos &#8986; <- emoji

-- function api.on_message(message)
--     local cmd = api.extract_command(message)
--     if cmd or cmd.command == 'amazon' then
--         local amazonClass = AmazonScraping:new(cmd.args_str)

--         local centerCol = amazonClass:parseHtmlCenter(true)
--         local root = amazonClass:parseHtmlCenter(false)
--         local image = amazonClass:productImage(root)
--         local title = amazonClass:productTitle(centerCol)
--         local price = amazonClass:price(centerCol)
--         local fromPrice = amazonClass:fromPrice(centerCol)

--         local saidaMensagem = "<b> &#8986;" .. title .. "</b>" .. "\n" .. "DE: " .. fromPrice .. "\n" .. "PARA: " .. price

--         api.send_photo(message.chat.id, image, {
--             caption = saidaMensagem,
--             parse_mode = 'HTML'
--         })
--     end
-- end

local function handle_updates(update)
    if update.message then
        local msg = update.message
        local chat_id = msg.chat.id
        local text = msg.text

        if text == "/start" then
            api.sendMessage(chat_id, "Olá! O bot está rodando via Webhook no Render! 🚀")
        else
            api.sendMessage(chat_id, "Você disse: " .. (text or "algo que não é texto"))
        end
    end
end

local server = pegasus:new({
    port = os.getenv("PORT") or 5000,
    location = '0.0.0.0'
})

server:start(function (request, response)
    local path = request:path()

    if path == "/set_webhook" then
        local url = os.getenv("LINK_WEBHOOK")
        local sucess = api.set_webhook(url)
        response:status(200):add_headers('Content-Type', 'text/plain'):write("Webhook configurado: " .. tostring(sucess))

    elseif path == "/Webhook" then
        local body = request:receive_body()
        if body then
            local decoded = json.decode(body)
            if decoded then
                handle_updates(body)
            end
        end

    end

end)

api.delete_webhook()
api.run({ timeout = 60 })