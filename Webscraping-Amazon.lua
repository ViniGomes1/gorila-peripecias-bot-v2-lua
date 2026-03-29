--require(luarocks.loader)
-- rodar isso antes no wsl{docker run -p 8050:8050 scrapinghub/splash}
local ltn12 = require("ltn12")
local http = require("socket.http")
local json = require("cjson")
local htmlparser = require("htmlparser")

--local arquivo = io.open("salvar.txt", "w")

local lua_script = [[
function main(splash, args)
    splash:go(args.url)
    splash:wait(2)  -- Wait for JS to execute
    return splash:html()
end
]]

local urlSemPromo = "https://amzn.to/4k6dVlz"
local urlNoPix = "https://amzn.to/41cCZPD"
local urlComPromo = "https://amzn.to/3PGoWz1" -- com promocao

local request_data = json.encode({
    lua_source = lua_script,
    url = urlSemPromo
})

local response = {}

http.request({
    url = "http://localhost:8050/execute",
    method = "POST",
    headers = {
        ["Content-Type"] = "application/json",
        ["Content-Length"] = tostring(#request_data)
    },
    source = ltn12.source.string(request_data),
    sink = ltn12.sink.table(response)
})

local rendered_html = table.concat(response)

local root = htmlparser.parse(rendered_html, 5000)

local image = root:select("img#landingImage")[1]
print(image.attributes.src)

-- local centerCol = root:select("div#centerCol")[1]
-- local productTitle = centerCol:select("div#title_feature_div")[1]:select("span#productTitle")

-- local priceHole = centerCol:select("span.apex-pricetopay-value")[1]
-- local preco = priceHole.nodes[2].nodes[1]:getcontent() .. priceHole.nodes[2].nodes[2]:getcontent():gsub("<[^>]+>", "") .. priceHole.nodes[2].nodes[3]:getcontent()

-- local fromPrice = centerCol:select("span.apex-basisprice-value")[1]
-- print(productTitle)

-- print(preco)
-- if fromPrice ~= nil then
--     local precoInicial = string.gsub(fromPrice:select("span.a-offscreen")[1]:getcontent(), "R$", "")
--     print(precoInicial)
-- end

