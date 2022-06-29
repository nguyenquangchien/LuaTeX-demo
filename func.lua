-- Lua functions used in the LuaTeX document
-- These functions contains TeX directives 
-- and hence cannot be used stand-alone.
-- Prepared for RSE's SeptembRSE event, UK 2021


function readfile(filename, n, m)
    -- Print the first n rows and m columns of a CSV data file
    count = 0
    for line in io.lines(filename) do
	    items = {}
	    string.gsub(line, '([^,]+)', function(item)
            table.insert(items, item)
        end)
	    for j = 1, m do
            tex.sprint(items[j] .. ' & ')
        end
        tex.sprint('\\\\')
        count = count + 1
        if count == n then break end
    end
    tex.sprint('Total: ' .. count .. ' lines.')
end 


function trigtable()
	-- Generates a trigonometry table for a range of angles
    for t = 0, 45, 3 do
        x = math.rad(t)
        tex.sprint(string.format('%2dÅã & %1.9f & %1.9f & %1.9f & %1.9f \\\\', 
                    t, x, math.sin(x), math.cos(x), math.tan(x)))
    end
end



function f(t,y)
	-- Helper function for solving ODE
    return y * math.cos(t+math.sqrt(1+y))
end


function print_RKfour(tMax,npoints,option)
	-- Differential equation y'(t) = f(t,y)
	--
	-- Solving the ODE equation y'(t) = f(t,y) 
	-- with f(t,y) = y * cos(t+sqrt(1+y)) (defined above)
	-- and initial condition: y(0) = 1
	--
	-- then write PGFplots data as coordinates
	local t0 = 0.0
    local y0 = 1.0
    local h = (tMax-t0)/(npoints-1)
    local t = t0
    local y = y0
    if option~=[[]] then
        tex.sprint("\\addplot["..option.."] coordinates{")
    else
        tex.sprint("\\addplot coordinates{")
    end
    tex.sprint("("..t0..","..y0..")")
    for i=1, npoints do
        k1 = h * f(t,y)
        k2 = h * f(t+h/2,y+k1/2)
        k3 = h * f(t+h/2,y+k2/2)
        k4 = h * f(t+h,y+k3)
        y = y + (k1+2*k2+2*k3+k4)/6
        t = t + h
        tex.sprint("("..t..","..y..")")
    end
    tex.sprint("}")
end


function coth (i) 
	-- hyperbolic cotangent function to be used in Brillouin function
	return math.cosh(i) / math.sinh(i)
end


function brillouin (J, x) 
	-- Function Brilouin
	-- the output coordinates are used for plotting
	if x == 0 then
		return 0
	else
		return (2*J+1)/(2*J)*coth((2*J+1)/(2*J)*x) - 
			1/(2*J)*coth(1/(2*J)*x)
	end
end
