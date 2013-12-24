--[[
Clock Rings by Linux Mint (2011) reEdited by despot77

This script draws percentage meters as rings, and also draws clock hands if you want! It is fully customisable; all options are described in the script. This script is based off a combination of my clock.lua script and my rings.lua script.

IMPORTANT: if you are using the 'cpu' function, it will cause a segmentation fault if it tries to draw a ring straight away. The if statement on line 145 uses a delay to make sure that this doesn't happen. It calculates the length of the delay by the number of updates since Conky started. Generally, a value of 5s is long enough, so if you update Conky every 1s, use update_num>5 in that if statement (the default). If you only update Conky every 2s, you should change it to update_num>3; conversely if you update Conky every 0.5s, you should use update_num>10. ALSO, if you change your Conky, is it best to use "killall conky; conky" to update it, otherwise the update_num will not be reset and you will get an error.

To call this script in Conky, use the following (assuming that you save this script to ~/scripts/rings.lua):
    lua_load ~/scripts/clock_rings.lua
    lua_draw_hook_pre clock_rings
    
Changelog:
+ v1.0 -- Original release (30.09.2009)
   v1.1p -- Jpope edit londonali1010 (05.10.2009)
*v 2011mint -- reEdit despot77 (18.02.2011)
]]

settings_table = {
     {
        -- Edit this table to customise your rings.
        -- You can create more rings simply by adding more elements to settings_table.
        -- "name" is the type of stat to display; you can choose from 'cpu', 'memperc', 'fs_used_perc', 'battery_used_perc'.
        name='time',
        -- "arg" is the argument to the stat type, e.g. if in Conky you would write ${cpu cpu0}, 'cpu0' would be the argument. If you would not use an argument in the Conky variable, use ''.
        arg='%I.%M',
        -- "max" is the maximum value of the ring. If the Conky variable outputs a percentage, use 100.
        max=12,
        -- "bg_colour" is the colour of the base ring.
        bg_colour=0xffffff,
        -- "bg_alpha" is the alpha value of the base ring.
        bg_alpha=0.1,
        -- "fg_colour" is the colour of the indicator part of the ring.
        fg_colour=0x0066FF,
        -- "fg_alpha" is the alpha value of the indicator part of the ring.
        fg_alpha=0.3,
        -- "x" and "y" are the x and y coordinates of the centre of the ring, relative to the top left corner of the Conky window.
        x=360, y=160,
        -- "radius" is the radius of the ring.
        radius=70,
        -- "thickness" is the thickness of the ring, centred around the radius.
        thickness=10,
        -- "start_angle" is the starting angle of the ring, in degrees, clockwise from top. Value can be either positive or negative.
        start_angle=0,
        -- "end_angle" is the ending angle of the ring, in degrees, clockwise from top. Value can be either positive or negative, but must be larger than start_angle.
        end_angle=360
    },
    {
        name='time',
        arg='%M.%S',
        max=60,
        bg_colour=0xdddddd,
        bg_alpha=0.1,
        fg_colour=0x0066FF,
        fg_alpha=0.4,
        x=360, y=160,
        radius=83,
        thickness=10,
        start_angle=0,
        end_angle=360
    },
    {
        name='time',
        arg='%S',
        max=60,
        bg_colour=0xdddddd,
        bg_alpha=0.1,
        fg_colour=0x0066FF,
        fg_alpha=0.6,
        x=360, y=160,
        radius=97,
        thickness=12,
        start_angle=0,
        end_angle=360
    },
    {
        name='time',
        arg='%d',
        max=31,
        bg_colour=0xdddddd,
        bg_alpha=0.1,
        fg_colour=0x0066FF,
        fg_alpha=0.8,
        x=360, y=160,
        radius=110,
        thickness=6,
        start_angle=-90,
        end_angle=90
    },
    {
        name='time',
        arg='%m',
        max=12,
        bg_colour=0xdddddd,
        bg_alpha=0.1,
        fg_colour=0x0066FF,
        fg_alpha=1,
        x=360, y=160,
        radius=120,
        thickness=6,
        start_angle=-90,
        end_angle=90
    },
    {
        name='acpitemp',
        arg='',
        max=110,
        bg_colour=0xdddddd,
        bg_alpha=0.8,
        fg_colour=0x0066FF,
        fg_alpha=0.8,
        x=200, y=300,
        radius=97,
        thickness=4,
        start_angle=0,
        end_angle=240
    },
    {
        name='cpu',
        arg='cpu0',
        max=100,
        bg_colour=0xdddddd,
        bg_alpha=0.8,
        fg_colour=0x0066FF,
        fg_alpha=0.8,
        x=200, y=300,
        radius=86,
        thickness=13,
        start_angle=0,
        end_angle=240
    },
    {
        name='cpu',
        arg='cpu1',
        max=100,
        bg_colour=0xdddddd,
        bg_alpha=0.7,
        fg_colour=0x0066FF,
        fg_alpha=0.8,
        x=200, y=300,
        radius=71,
        thickness=12,
        start_angle=0,
        end_angle=240
    },
    {
        name='cpu',
        arg='cpu2',
        max=100,
        bg_colour=0xdddddd,
        bg_alpha=0.6,
        fg_colour=0x0066FF,
        fg_alpha=0.8,
        x=200, y=300,
        radius=57,
        thickness=11,
        start_angle=0,
        end_angle=240
    },
    {
        name='cpu',
        arg='cpu3',
        max=100,
        bg_colour=0xdddddd,
        bg_alpha=0.5,
        fg_colour=0x0066FF,
        fg_alpha=0.8,
        x=200, y=300,
        radius=44,
        thickness=10,
        start_angle=0,
        end_angle=240
    },
    {
        name='memperc',
        arg='',
        max=100,
        bg_colour=0xdddddd,
        bg_alpha=0.8,
        fg_colour=0x0066FF,
        fg_alpha=0.8,
        x=340, y=414,
        radius=60,
        thickness=15,
        start_angle=180,
        end_angle=420
    },
    {
        name='swapperc',
        arg='',
        max=100,
        bg_colour=0xdddddd,
        bg_alpha=0.4,
        fg_colour=0x0066FF,
        fg_alpha=0.8,
        x=340, y=414,
        radius=45,
        thickness=10,
        start_angle=180,
        end_angle=420
    },
    {
        name='fs_used_perc',
        arg='/',
        max=100,
        bg_colour=0xdddddd,
        bg_alpha=0.4,
        fg_colour=0x0066FF,
        fg_alpha=0.8,
        x=220, y=460,
        radius=25,
        thickness=10,
        start_angle=0,
        end_angle=240
    },
    {
        name='fs_used_perc',
        arg='/home',
        max=100,
        bg_colour=0xdddddd,
        bg_alpha=0.8,
        fg_colour=0x0066FF,
        fg_alpha=0.8,
        x=220, y=460,
        radius=40,
        thickness=14,
        start_angle=0,
        end_angle=240
    },
    {
        name='downspeedf',
        arg='',
        max=2000,
        bg_colour=0xdddddd,
        bg_alpha=0.8,
        fg_colour=0x0066FF,
        fg_alpha=0.8,
        x=290, y=526,
        radius=30,
        thickness=12,
        start_angle=180,
        end_angle=420
    },
    {
        name='upspeedf',
        arg='',
        max=200,
        bg_colour=0xdddddd,
        bg_alpha=0.6,
        fg_colour=0x0066FF,
        fg_alpha=0.8,
        x=290, y=526,
        radius=18,
        thickness=8,
        start_angle=180,
        end_angle=420
    },
    {
        name='battery_percent',
        arg='BAT1',
        max=100,
        bg_colour=0xdddddd,
        bg_alpha=0.6,
        fg_colour=0x0066FF,
        fg_alpha=0.8,
        x=274, y=644,
        radius=18,
        thickness=10,
        start_angle=180,
        end_angle=420
    }
}

-- Use these settings to define the origin and extent of your clock.

clock_r=102

-- "clock_x" and "clock_y" are the coordinates of the centre of the clock, in pixels, from the top left of the Conky window.

clock_x=360
clock_y=160

show_seconds=true

require 'cairo'

function rgb_to_r_g_b(colour,alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function draw_ring(cr,t,pt)
    local w,h=conky_window.width,conky_window.height
    
    local xc,yc,ring_r,ring_w,sa,ea=pt['x'],pt['y'],pt['radius'],pt['thickness'],pt['start_angle'],pt['end_angle']
    local bgc, bga, fgc, fga=pt['bg_colour'], pt['bg_alpha'], pt['fg_colour'], pt['fg_alpha']

    local angle_0=sa*(2*math.pi/360)-math.pi/2
    local angle_f=ea*(2*math.pi/360)-math.pi/2
    local t_arc=t*(angle_f-angle_0)

    -- Draw background ring

    cairo_arc(cr,xc,yc,ring_r,angle_0,angle_f)
    cairo_set_source_rgba(cr,rgb_to_r_g_b(bgc,bga))
    cairo_set_line_width(cr,ring_w)
    cairo_stroke(cr)
    
    -- Draw indicator ring

    cairo_arc(cr,xc,yc,ring_r,angle_0,angle_0+t_arc)
    cairo_set_source_rgba(cr,rgb_to_r_g_b(fgc,fga))
    cairo_stroke(cr)        
end

function draw_clock_hands(cr,xc,yc)
    local secs,mins,hours,secs_arc,mins_arc,hours_arc
    local xh,yh,xm,ym,xs,ys
    
    secs=os.date("%S")    
    mins=os.date("%M")
    hours=os.date("%I")
        
    secs_arc=(2*math.pi/60)*secs
    mins_arc=(2*math.pi/60)*mins+secs_arc/60
    hours_arc=(2*math.pi/12)*hours+mins_arc/12
        
    -- Draw hour hand
    
    xh=xc+0.7*clock_r*math.sin(hours_arc)
    yh=yc-0.7*clock_r*math.cos(hours_arc)
    cairo_move_to(cr,xc,yc)
    cairo_line_to(cr,xh,yh)
    
    cairo_set_line_cap(cr,CAIRO_LINE_CAP_ROUND)
    cairo_set_line_width(cr,5)
    cairo_set_source_rgba(cr,1.0,1.0,1.0,1.0)
    cairo_stroke(cr)
    
    -- Draw minute hand
    
    xm=xc+0.85*clock_r*math.sin(mins_arc)
    ym=yc-0.85*clock_r*math.cos(mins_arc)
    cairo_move_to(cr,xc,yc)
    cairo_line_to(cr,xm,ym)
    
    cairo_set_line_width(cr,3)
    cairo_stroke(cr)
    
    -- Draw seconds hand
    
    if show_seconds then
        xs=xc+clock_r*math.sin(secs_arc)
        ys=yc-clock_r*math.cos(secs_arc)
        cairo_move_to(cr,xc,yc)
        cairo_line_to(cr,xs,ys)
    
        cairo_set_line_width(cr,2)
        cairo_stroke(cr)
    end

end

function conky_clock_rings()
    local function setup_rings(cr,pt)
        local str=''
        local value=0
        
        str=string.format('${%s %s}',pt['name'],pt['arg'])
        str=conky_parse(str)
        
        value=tonumber(str)
        pct=value/pt['max']
        
        draw_ring(cr,pct,pt)
    end
    
    -- Check that Conky has been running for at least 5s

    if conky_window==nil then return end
    local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
    
    local cr=cairo_create(cs)    
    
    local updates=conky_parse('${updates}')
    update_num=tonumber(updates)
    
    if update_num>5 then
        for i in pairs(settings_table) do
            setup_rings(cr,settings_table[i])
        end
    end
    
    draw_clock_hands(cr,clock_x,clock_y)
end

---------------------------------


function conky_ring_stats()
    local function setup_rings(cr,pt)
        local str=''
        local value=0
        
        str=string.format('${%s %s}',pt['name'],pt['arg'])
        str=conky_parse(str)
        
        value=tonumber(str)
        if value == nil then value = 0 end
        pct=value/pt['max']
        
        draw_ring(cr,pct,pt)
    end

    if conky_window==nil then return end
    local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
    
    local cr=cairo_create(cs)   
    
    local updates=conky_parse('${updates}')
    update_num=tonumber(updates)

    if update_num>5 then
        for i in pairs(settings_table) do
                display_temp=temp_watch()
        setup_rings(cr,settings_table[i])
        end
    end
   cairo_surface_destroy(cs)
   cairo_destroy(cr)
end

-- Contrôle de l'espace disque
function disk_watch()

    warn_disk=93
    crit_disk=98

    -- poser une boucle plus tard... pas simple

    disk=tonumber(conky_parse("${fs_used_perc /}"))

    if disk<warn_disk then
        settings_table[8]['fg_colour']=normal
    elseif disk<crit_disk then
        settings_table[8]['fg_colour']=warn
    else
        settings_table[8]['fg_colour']=crit
    end

    disk=tonumber(conky_parse("${fs_used_perc /home}"))

    if disk<warn_disk then
        settings_table[9]['fg_colour']=normal
    elseif disk<crit_disk then
        settings_table[9]['fg_colour']=warn
    else
        settings_table[9]['fg_colour']=crit
    end

    disk=tonumber(conky_parse("${fs_used_perc /usr}"))

    if disk<warn_disk then
        settings_table[10]['fg_colour']=normal
    elseif disk<crit_disk then
        settings_table[10]['fg_colour']=warn
    else
        settings_table[10]['fg_colour']=crit
    end
end

-- Contrôle de la température
function temp_watch()

    warn_value=70
    crit_value=80

    temperature=tonumber(conky_parse("${acpitemp}"))

    if temperature<warn_value then
        settings_table[1]['fg_colour']=normal
    elseif temperature<crit_value then
        settings_table[1]['fg_colour']=warn
    else
        settings_table[1]['fg_colour']=crit
    end
end

-- Contrôle de l'interface active
function iface_watch()

    iface=conky_parse("${if_existing /proc/net/route wlp6s0}wlp6s0${else}wlan0${endif}")

    settings_table[11]['arg']=iface
    settings_table[12]['arg']=iface
end

function conky_draw_bg()
    if conky_window==nil then return end
    local w=conky_window.width
    local h=conky_window.height
    local cs=cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, w, h)
    cr=cairo_create(cs)
    
    cairo_move_to(cr,corner_r,0)
    cairo_line_to(cr,w-corner_r,0)
    cairo_curve_to(cr,w,0,w,0,w,corner_r)
    cairo_line_to(cr,w,h-corner_r)
    cairo_curve_to(cr,w,h,w,h,w-corner_r,h)
    cairo_line_to(cr,corner_r,h)
    cairo_curve_to(cr,0,h,0,h,0,h-corner_r)
    cairo_line_to(cr,0,corner_r)
    cairo_curve_to(cr,0,0,0,0,corner_r,0)
    cairo_close_path(cr)
    
    cairo_set_source_rgba(cr,rgb_to_r_g_b(bg_colour,bg_alpha))
    cairo_fill(cr)
end

function conky_main()
    temp_watch()
    disk_watch()
    iface_watch()
    conky_ring_stats()

-- quand fond nécessaire
--    conky_draw_bg()
end
