-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
--
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local screenGroup
local layers 

-- Callbacks/Functions
local onBack

-- Forward Declarations
local imageRect 		= ssk.display.imageRect
local easyIFC			= ssk.easyIFC
local tern 				= _G.ternary
local mRand 			= math.random

local getTimer 			= system.getTimer
local sysGetInfo		= system.getInfo
local strMatch 			= string.match
local strFormat 		= string.format

----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------
local maxW = w - 30
local curY = 0
local ySep = 5
local text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry.  Lorem Ipsum is simply dummy text of the printing and typesetting industry."

local rooms = {}

rooms['start'] = { title = 'Beach', description = "You are standing on a beach.\n\nA rocky trail leads north towards some cliffs.  To the west you see a shack.", exits = { { 'north', 'room1' }, { 'west', 'room2'} } }
rooms['room1'] = { title = 'Cliffs', description = "A small clearing rests at the base of impassible cliffs.\n\nA rocky trail leads south towards the ocean.  A grassy path leads uphill to the west.", exits = { { 'south', 'start' }, { 'west', 'room3'} } }
rooms['room2'] = { title = 'Shack', description = "A small shack with a single door and a window sits all alone on the edge of the island. The door is closed.\n\nTrails lead north and east.", exits = { { 'east', 'start' }, { 'north', 'room3'}, { 'door', 'shackdoor' }, { 'window', 'shackwindow' } } }
rooms['room3'] = { title = 'Hilltop', description = "You stand atop a low hill.\n\nTo the east you see a grassy clearing.  To the south is a shack.  A loose and rutted trail leads south east.", exits = { { 'east', 'room1' }, { 'south', 'room2'}, {"south east", 'start'} } }
rooms['shackdoor'] = { title = 'Door', description = "You open the door, and see a crossbow resting on a table and facing the door.\n\nYou also see a string, attaching the the crossbow's trigger to the doorknob . . .  Twang!  Oomph!\n\nYou died.", exits = {} }
rooms['shackwindow'] = { title = 'Dirty Window', description = "The window is too dirty to see through.\n\nIf you could break the window, you would be able to look inside.\n\nOh well, there is always the door.", exits = { { 'east', 'start' }, { 'north', 'room3'}, { 'door', 'shackdoor' }, { 'window', 'shackwindow' } } }


----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	screenGroup = self.view
	
	-- Create some rendering layers
	layers = ssk.display.quickLayers( screenGroup, "underlay", "background", "content", "buttons", "overlay" )
	local content = layers.content

	local backImage = imageRect( layers.underlay, centerX, centerY, 
	           "images/interface/protoBack.png", 
	           { w = 380, h = 570, rotation = tern( isLandscape, 90, 0 ) } )


	local text = string.gsub( text, "  ", " " )
	text = string.trim( text )
	text = text .. " " .. text
	text = text .. " " .. text
	text = string.gsub( text, "  ", " " )
	local words = text:split( " " )

	local startX = 10
	local startY = 20

	local nextX
	local curX = startX
	local curY = startY

	local xSep = 7
	local ySep = 24

	local function addTouch( obj )
		obj:setFillColor( 1, 1, 0 )
		obj.touch = function( self, event )
			table.dump(event)
		end
		obj:addEventListener( "touch", obj )
	end

	for i = 1, #words do
	--for i = 1, 2 do

		local word = words[i]

		local tmp = display.newText( layers.content, word, 0, 0, gameFont, ySep - 2 )	
		tmp.anchorX = 0
		
		nextX = curX + tmp.contentWidth + xSep
		if(nextX > w) then
			curX = startX
			nextX = curX + tmp.contentWidth + xSep
			curY = curY + ySep
		end

		tmp.x = curX
		curX = nextX
		tmp.y = curY


		if( word == "Lorem" ) then
			addTouch( tmp )
		end
	end

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:show( event )
	screenGroup 	= self.view
	local willDid 	= event.phase
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:hide( event )
	screenGroup 	= self.view
	local willDid 	= event.phase
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	screenGroup = self.view

	display.remove(layers)
	layers = nil

	screenGroup = nil
end


----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
onBack = function ( event ) 
	local options =
	{
		effect = "fade",
		time = 200,
		params =
		{
			logicSource = nil
		}
	}
	composer.gotoScene( "ifc.mainMenu", options  )	

	return true
end


---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------

return scene
