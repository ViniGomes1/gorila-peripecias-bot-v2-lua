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
    if type(update) == "string" then update = json.decode(update) end

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
    port = os.getenv("PORT") or 10000,
    location = '0.0.0.0'
})

print("Iniciando servidor na porta " .. (os.getenv("PORT") or "10000"))
print("webhook: " .. os.getenv("LINK_WEBHOOK"))

server:start(function (request, response)
    local path = request:path()
    print("Requisição recebida em: " .. tostring(path))

    if path == "/" then
        local url = os.getenv("LINK_WEBHOOK") .. "/webhook"
        local sucess = api.set_webhook(url)
        response:statusCode(200):addHeader('Content-Type', 'text/plain'):write("deu")

    elseif path == "/webhook" then
        local body = request.querystring()
        print(body)
--        if body and body ~= "" then
--            print("Recebido corpo: " .. body)
--            local status, err = pcall(function()
--                local decoded = json.decode(body)
--                handle_updates(decoded)
--            end)
--
--            if not status then
--                print("Erro ao processar update: " .. tostring(err))
--            end
--
--        end
        response:statusCode(200):addHeader('Content-Type', 'text/plain'):write("!")
    else
        response:statusCode(404):addHeader('Content-Type', 'text/plain'):write("Not Found")
            
    end

end)

