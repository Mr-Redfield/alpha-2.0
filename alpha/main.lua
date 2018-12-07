local anim = require 'anim8' 
local imagem, animation --cria variáveis imagem e animation
local bump = require "bump"--Chama bump.
local sti = require "sti"--chama "sti"

local world = bump.newWorld(32)--chama a bump, criando um mundo(World).

function love.load()
	mapa = sti("mapa.lua", {})--procura a imagem criada no Tiled

	mapa:addCustomLayer("PlayerLayer", 2)--adiciona uma layer
	playerLayer = mapa.layers["PlayerLayer"]--Está chamando a layer criada anteriormente

	playerLayer.sprites = {--adiciona "sprite" na camada
		player = {--adioca o vetor "palyer" dentro de playerLayer.sprites
			image = love.graphics.newImage("imagem/sprite.png"),
			x = 400,
			y = 150,
			w = 180,
			h = 247,
			direcao = true
		}
	}
	
	playerLayer.sprites.player.grid--[[adiciona "grid" no vetor "player"(recem criado)]] = anim.newGrid(180, 247, playerLayer.sprites.player.image:getWidth(), playerLayer.sprites.player.image:getHeight())
	playerLayer.sprites.player.animation--[[adiciona "animation em "player"]] = anim.newAnimation(playerLayer.sprites.player.grid('1-5', 1, '1-5', 2), 0.1)

	world:add(playerLayer.sprites.player, playerLayer.sprites.player.x, playerLayer.sprites.player.y, playerLayer.sprites.player.w, playerLayer.sprites.player.h)--adiciona todos os elementos criados ao mundo

	function playerLayer:update(dt)--novo update criado para as camadas
		for _, sprites in pairs(playerLayer.sprites) do
			if love.keyboard.isDown('left') then
				sprites.direcao = false --direção da imagem, no caso, virada para frente.
				sprites.animation:update( dt )-- trás as animações definidas em love.load
				sprites.x = world:move(sprites, sprites.x - 800 * dt, sprites.y )--adiciona o movimento do objeto no mundo criado
			elseif love.keyboard.isDown('right') then
				sprites.direcao = true --direção da imagem, no caso, virada para trás.
				sprites.animation:update( dt )---- trás as animações definidas em love.load
				sprites.x = world:move(sprites, sprites.x + 800 * dt, sprites.y )
			end
		end
	end

	function playerLayer:draw()
		for _, sprites in pairs(playerLayer.sprites) do
			if sprites.direcao then
				sprites.animation:draw(sprites.image, sprites.x,sprites.y,0,0.5,0.5,123.5,0)
			elseif not sprites.direcao then
				sprites.animation:draw(sprites.image, sprites.x,sprites.y,0,-0.5,0.5,123.5,0)
			end
		end
	end
end

function love.update( dt )
	mapa:update(dt)
end

function love.draw()
	mapa:draw()
end