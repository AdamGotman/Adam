fx_version "adamant"
game "gta5"
lua54 "yes"
description "admDMV"
contributor {
    "Made by Adam"
}
client_scripts{ 
  "@vrp/client/Tunnel.lua",
	"@vrp/client/Proxy.lua",
  "client.lua"
}
server_scripts {
	"@vrp/lib/utils.lua",
    'server.lua'
}
ui_page {"html/index.html"}
files {"html/index.html",'html/font/DigitalNumbers-Regular.ttf','html/style.css','html/script.js','html/img/*.png'}
