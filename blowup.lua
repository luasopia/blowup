-------------------------------------------------------------------------------
-- 2021/05/16: refactored. usage:
-- local function blowup = import 'blowup'
-- local e = blowup():xy(nx,ny)
-- blowup() returns Group object in which blow-up effect in contained.
-- The group object is self-removed after 500ms.
-------------------------------------------------------------------------------

-- Receives a function u() that reflects the path information
-- of the current folder. 
local u = getdir(...)

-- make global functiones/classes to local ones.
-- This slightly speeds up execution.
local rand = rand
local Image = Image
local Sprite = Sprite

-- creates resource objects using the funcitn u()
-- for example, u'expl.png' designates expl.png file of the current folder
local sht2 = getsheet(u'expl.png', 64, 64, 16)
local sht3 = getsheet(u'expl2.png', 64,64,8)
local seqflame = {time=500,loops=1}
local explsnd = Sound(u'expl.wav')
local shthit = getsheet(u'hit.png', 256, 256, 9)
local seqhit = {time=200, loops=1}

local function updflash(self)
    local ys = self:getyscale() - 0.3 -- 0.3
    if ys<0.1 then ys = 0.1 end
    self:yscale(ys)
end

local function blowup()

    local grp = Group():removeafter(500)

    -- explosion smoke effect 
    for k=1,8 do
        local s1, dx1, dy1 = rand(10,20)/10, rand(-60,60)/10, rand(-60,60)/10
        Sprite(sht2,seqflame):addto(grp):scale(s1):dxdy(dx1,dy1):play()
        local dx2, dy2 = rand(-15,15)/10, rand(-15,15)/10
        Sprite(sht3,seqflame):addto(grp):dxdy(dx2,dy2):play()
    end
   
    -- flash effect
    local flash = Image(u'flash.png'):addto(grp)
    flash:rot(rand(-30,30)):dxscale(0.4):removeafter(100)
    flash.update = updflash

    -- background light effect
    local hit = Sprite(shthit,seqhit):addto(grp)
    hit:rot(rand(360)):scale(2.2)
    hit:play():removeafter(250)

    explsnd:play()

    return grp

end

return blowup