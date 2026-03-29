local http = require("socket.http")
--local gumbo = require("gumbo")
local htmlparser = require("htmlparser")

-- local ggram
-- https://meli.la/2B5iCCJ -> desconto com pix - polyPrice = algo
-- https://meli.la/1A4F2pe -> desconto sem pix - polyPrice = nil
-- https://amzn.to/4k6dVlz
local body = http.request('https://meli.la/1A4F2pe')

local documento = htmlparser.parse(body)

local content = documento:select("div.poly-card__content")
local algo = content[1]:getcontent()

print(algo)

local polyContent = algo:getElementsByClassName("poly-content")[1]

local MoneyAmount = polyContent:getElementsByClassName("andes-money-amount__fraction")
local polyPrice = polyContent:getElementsByClassName("poly-price__disc_label")[1]

-- Verifica se o desconto é no pix 
if polyPrice ~= nil then
    print(polyPrice)
end

-- retorna os valores do desconto [1 = valor anterior, 2 = valor atual, 3 = valor no cartão] - o 3 so aparece as vezes
for i, valor in ipairs(MoneyAmount) do
    print(i, valor.textContent)
end
