--[[
Ring Meters by londonali1010 (2009)

This script draws percentage meters as rings. It is fully customisable; all options are described in the script.

IMPORTANT: if you are using the 'cpu' function, it will cause a segmentation fault if it tries to draw a ring straight away. The if statement near the end of the script uses a delay to make sure that this doesn't happen. It calculates the length of the delay by the number of updates since Conky started. Generally, a value of 5s is long enough, so if you update Conky every 1s, use update_num > 5 in that if statement (the default). If you only update Conky every 2s, you should change it to update_num > 3; conversely if you update Conky every 0.5s, you should use update_num > 10. ALSO, if you change your Conky, is it best to use "killall conky; conky" to update it, otherwise the update_num will not be reset and you will get an error.

To call this script in Conky, use the following (assuming that you save this script to ~/scripts/rings.lua):
	lua_load ~/scripts/rings-v1.2.1.lua
	lua_draw_hook_pre ring_stats
	
Changelog:
+ v1.2.1 -- Fixed minor bug that caused script to crash if conky_parse() returns a nil value (20.10.2009)
+ v1.2 -- Added option for the ending angle of the rings (07.10.2009)
+ v1.1 -- Added options for the starting angle of the rings, and added the "max" variable, to allow for variables that output a numerical value rather than a percentage (29.09.2009)
+ v1.0 -- Original release (28.09.2009)

        arg=conky_parse("${if_up wlan0}wlan0${else}wlp6s0${endif}"),
        fg_colour=0xf0651f,
        fg_colour=conky_parse("${if_up wlan0}wlan0${else}wlp6s0${endif}"),
        conky_parse("${cpu}")
        name=conky_parse("${acpitemp}"),
]]

-- A TESTER
--set alarm value, this is the value at which bar color will change
--alarm_value=80
----set alarm bar color, 1,0,0,1 = red fully opaque
--ar,ag,ab,aa=1,0,0,1

-- couleurs 1
-- 0066FF
-- f0651f
-- f01f42
-- couleurs 2 + flashy
-- 008cff
-- ff7200
-- ff000d

--normal_temp="0x0066FF"
--warn_temp="0xf0651f"
--crit_temp="0xf01f42"
-- Un mélange des deux
normal="0x0066FF"
warn="0xff7200"
crit="0xff000d"

-- seulement quand fond nécessaire
corner_r=35
bg_colour=0x333333
bg_alpha=0.2


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
    },
    {
        name='',
        arg='',
        max=100,
        bg_colour=0xdddddd,
        bg_alpha=0.6,
        fg_colour=0x0066FF,
        fg_alpha=0.6,
        x=274, y=644,
        radius=3,
        thickness=13,
        start_angle=0,
        end_angle=360
    },
}



require 'cairo'

function rgb_to_r_g_b(colour,alpha)
	return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

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