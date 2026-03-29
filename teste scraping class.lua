local AmazonScraping = require("AmazonScrapinClass")

local urlSemPromo = "https://amzn.to/41cCZPD"
local urlComPromo = "https://amzn.to/3PGoWz1" -- com promocao

local amazonClass = AmazonScraping:new(urlSemPromo)
local centerCol = amazonClass:parseHtmlCenter()
local title = amazonClass:productTitle(centerCol)
local price = amazonClass:price(centerCol)
local fromPrice = amazonClass:fromPrice(centerCol)

print(title)
print(price)
print(fromPrice)
