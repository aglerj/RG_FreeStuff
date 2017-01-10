local public = {}
-- SSK 
local isInBounds		= ssk.easyIFC.isInBounds
local newCircle 		= ssk.display.circle
local newRect 			= ssk.display.rect
local newImageRect 		= ssk.display.imageRect
local easyIFC			= ssk.easyIFC
local ternary			= _G.ternary
local quickLayers  		= ssk.display.quickLayers

local angle2Vector 		= ssk.math2d.angle2Vector
local vector2Angle 		= ssk.math2d.vector2Angle
local scaleVec 			= ssk.math2d.scale
local addVec 			= ssk.math2d.add
local subVec 			= ssk.math2d.sub
local getNormals 		= ssk.math2d.normals

-- Lua and Corona
local mAbs 				= math.abs
local mPow 				= math.pow
local mRand 			= math.random
local getInfo			= system.getInfo
local getTimer 			= system.getTimer
local strMatch 			= string.match
local strFormat 		= string.format


local values = {}

local function exists( name, shouldExist )
	if( values[name] ) then
		if( shouldExist ) then
			print("ERROR!  Value with that name does not exist")
			
		else
			print("ERROR!  Created flag or value with existing name.")			
		end		
		return true
	end
	return false 
end

function public.addFlag( name, isTrue )
	name = string.lower(name)
	if(exists(name)) then return end
	if (isTrue == nil) then
		isTrue = false
	end	
	values[name] = { value = isTrue, type = "flag" }
end

function public.getType( name )
	name = string.lower(name)
	if( not exists( name, true ) ) then return "none" end	
	return values[name].type
end

function public.getValue( name )
	name = string.lower(name)	
	if( not exists( name, true ) ) then return false end	
	return values[name].value
end

function public.setValue( name, value )
	name = string.lower(name)	
	if( not exists( name, true ) ) then return false end	
	values[name].value = value
	return values[name].value
end


local ops = {}
function public.equal( name, to )
	if( values[name] == nil ) then return false end
	if( to == nil ) then return false end

	if(values[name].type == "flag") then
		return (to == values[name].value)
	end

	return false
end
function public.notequal( name, to )
	return not public.equal( name, to )
end

ops.eq = public.equal
ops.neq = public.notequal


function public.evaluate( expression )
	local isTrue = false
	for i = 1, #expression do
		isTrue = isTrue or  public.subevaluate( expression[i] )
	end
	return isTrue
end

function public.subevaluate( subexpression )
	local isTrue = true
	for i = 1, #subexpression do		
		local curExp = subexpression[i]		
		local op = ops[curExp[2]]
		isTrue = isTrue and op( curExp[1], curExp[3] )
		--print( curExp[1], curExp[2], curExp[3],  op( curExp[1], curExp[3] ) )
	end
	return isTrue	
end

-- Convert a string to a expression table
-- Single Expression: a,b,c
-- AND ==> ;
-- OR ==> :
function public.genExpression( str )
	str = str:gsub("% ", "")
	local expression = string.split( str, ":" )
	for i = 1, #expression do
		local subexp = string.split( expression[i], ";" )
		for j = 1, #subexp do
			subexp[j] = string.split(subexp[j],",")
			if( subexp[j][3] == "true" )  then
				subexp[j][3] = true
			elseif( subexp[j][3] == "false" )  then
				subexp[j][3] = false
			elseif( tonumber(subexp[j][3]) ~= nil )  then
				subexp[j][3] = tonumber(subexp[j][3])
			end
		end
		expression[i] = subexp
	end
	return expression
end

return public