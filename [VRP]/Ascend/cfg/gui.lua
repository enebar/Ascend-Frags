
-- gui config file

local cfg = {}

-- additional css loaded to customize the gui display (see gui/design.css to know the available css elements)
-- it is not recommended to modify the CLIMB core files outside the cfg/ directory, create a new resource instead
-- you can load external images/fonts/etc using the NUI absolute path: nui://my_resource/myfont.ttf
-- example, changing the gui font (suppose a CLIMB_mod resource containing a custom font)
cfg.css = [[
@font-face {
  font-family: "Custom Font";
  src: url(nui://CLIMB_mod/customfont.ttf) format("truetype");
}

body{
  font-family: "Custom Font";
}
]]

-- list of static menu types (map of name => {.title,.blipid,.blipcolor,.permissions (optional)})
-- static menus are menu with choices defined by CLIMB.addStaticMenuChoices(name, choices)
cfg.static_menu_types = {
  ["missions"] = { -- example of a mission menu that can be filled by other resources
    title = "Missions",
    blipid = 205, 
    blipcolor = 5
  }
}

-- list of static menu points
cfg.static_menus = {

}

return cfg
