----------------------------------------------------------
--Grafitti
--uses api for registering various painted images
--various symbols and patterns, enough to make it possible to form a symbolic vocabulary.

--colours:
--lime white
--glow paint (a light)
--carbon black --!!
--red ochre --!!

--frequently used symbols could be repeated in each colour
-- plus some unique ones per color for variety
-- few enough that menu is small

----------------------------------------------------------

-- Internationalization
local S = tech.S

grafitti = grafitti

--lime White


--abstract
grafitti.register_grafitti("tech:lw_x", {image = "tech_paint_lw_x.png"})
grafitti.register_grafitti("tech:lw_hourglass1", {image = "tech_paint_lw_hourglass1.png"})
grafitti.register_grafitti("tech:lw_hourglass2", {image = "tech_paint_lw_hourglass2.png"})
grafitti.register_grafitti("tech:lw_hourglass3", {image = "tech_paint_lw_hourglass3.png"})
grafitti.register_grafitti("tech:lw_xox", {image = "tech_paint_lw_xox.png"})

grafitti.register_grafitti("tech:lw_o", {image = "tech_paint_lw_o.png"})
grafitti.register_grafitti("tech:lw_odot", {image = "tech_paint_lw_odot.png"})

grafitti.register_grafitti("tech:lw_quad", {image = "tech_paint_lw_quad.png"})
grafitti.register_grafitti("tech:lw_quaddot", {image = "tech_paint_lw_quaddot.png"})

grafitti.register_grafitti("tech:lw_oval", {image = "tech_paint_lw_oval.png"})
grafitti.register_grafitti("tech:lw_ovalfull", {image = "tech_paint_lw_ovalfull.png"})

grafitti.register_grafitti("tech:lw_square", {image = "tech_paint_lw_square.png"})
grafitti.register_grafitti("tech:lw_squarefull", {image = "tech_paint_lw_squarefull.png"})

grafitti.register_grafitti("tech:lw_lineh", {image = "tech_paint_lw_lineh.png"})
grafitti.register_grafitti("tech:lw_linev", {image = "tech_paint_lw_linev.png"})
grafitti.register_grafitti("tech:lw_flute", {image = "tech_paint_lw_flute.png"})

grafitti.register_grafitti("tech:lw_arrowd", {image = "tech_paint_lw_arrowd.png"})
grafitti.register_grafitti("tech:lw_arrowu", {image = "tech_paint_lw_arrowu.png"})
grafitti.register_grafitti("tech:lw_arrowl", {image = "tech_paint_lw_arrowl.png"})
grafitti.register_grafitti("tech:lw_arrowr", {image = "tech_paint_lw_arrowr.png"})

grafitti.register_grafitti("tech:lw_penni1", {image = "tech_paint_lw_penni1.png"})
grafitti.register_grafitti("tech:lw_penni2", {image = "tech_paint_lw_penni2.png"})
grafitti.register_grafitti("tech:lw_pecti1", {image = "tech_paint_lw_pecti1.png"})
grafitti.register_grafitti("tech:lw_pecti2", {image = "tech_paint_lw_pecti2.png"})
grafitti.register_grafitti("tech:lw_tecti", {image = "tech_paint_lw_tecti.png"})
grafitti.register_grafitti("tech:lw_4pole", {image = "tech_paint_lw_4pole.png"})
grafitti.register_grafitti("tech:lw_avi", {image = "tech_paint_lw_avi.png"})
grafitti.register_grafitti("tech:lw_scali", {image = "tech_paint_lw_scali.png"})
grafitti.register_grafitti("tech:lw_bridge", {image = "tech_paint_lw_bridge.png"})

grafitti.register_grafitti("tech:lw_spiral", {image = "tech_paint_lw_spiral.png"})
grafitti.register_grafitti("tech:lw_spiral2", {image = "tech_paint_lw_spiral2.png"})
grafitti.register_grafitti("tech:lw_spirald", {image = "tech_paint_lw_spirald.png"})
grafitti.register_grafitti("tech:lw_spirald2", {image = "tech_paint_lw_spirald2.png"})
grafitti.register_grafitti("tech:lw_antiq", {image = "tech_paint_lw_antiq.png"})

grafitti.register_grafitti("tech:lw_burst1", {image = "tech_paint_lw_burst1.png"})
grafitti.register_grafitti("tech:lw_burst2", {image = "tech_paint_lw_burst2.png"})
grafitti.register_grafitti("tech:lw_bolt", {image = "tech_paint_lw_bolt.png"})

--less abstract
grafitti.register_grafitti("tech:lw_tree", {image = "tech_paint_lw_tree.png"})
grafitti.register_grafitti("tech:lw_hand", {image = "tech_paint_lw_hand.png"})
grafitti.register_grafitti("tech:lw_hand2", {image = "tech_paint_lw_hand2.png"})
grafitti.register_grafitti("tech:lw_foot", {image = "tech_paint_lw_foot.png"})
grafitti.register_grafitti("tech:lw_fig1", {image = "tech_paint_lw_fig1.png"})
grafitti.register_grafitti("tech:lw_fig2", {image = "tech_paint_lw_fig2.png"})
grafitti.register_grafitti("tech:lw_fig3", {image = "tech_paint_lw_fig3.png"})
grafitti.register_grafitti("tech:lw_chrysalis", {image = "tech_paint_lw_chrysalis.png"})

grafitti.palette_build("tech:lime_white")

grafitti.register_brush("tech:paint_lime_white", {
    description = S("Painting Kit (lime white)"),
    inventory_image = "tech_paint_brush_white.png",
    wield_image = "tech_paint_brush_white.png^[transformR270",
    palette = "tech:lime_white"
})


crafting.register_recipe({
	type = "mortar_and_pestle",
	output = "tech:paint_lime_white",
	items = {'tech:crushed_lime', 'tech:stick', 'group:fibrous_plant 4', 'tech:vegetable_oil 4'},
	level = 1,
	always_known = true,
})



----------------------------------------------------------
--glow paint (glowing blue)

grafitti.register_grafitti("tech:gp_dot", {image = "tech_paint_gp_dot.png", light = 2})
grafitti.register_grafitti("tech:gp_x", {image = "tech_paint_gp_x.png", light = 2})
grafitti.register_grafitti("tech:gp_arrowl", {image = "tech_paint_gp_arrowl.png", light = 2})
grafitti.register_grafitti("tech:gp_arrowr", {image = "tech_paint_gp_arrowr.png", light = 2})
grafitti.register_grafitti("tech:gp_arrowd", {image = "tech_paint_gp_arrowd.png", light = 2})
grafitti.register_grafitti("tech:gp_arrowu", {image = "tech_paint_gp_arrowu.png", light = 2})
grafitti.register_grafitti("tech:gp_spsq", {image = "tech_paint_gp_spsq.png", light = 2})
grafitti.register_grafitti("tech:gp_sq", {image = "tech_paint_gp_sq.png", light = 2})

grafitti.palette_build("tech:glow_paint")

grafitti.register_brush("tech:paint_glow_paint", {
    description = S("Painting Kit (glow paint)"),
    inventory_image = "tech_paint_brush_glow.png",
    wield_image = "tech_paint_brush_glow.png^[transformR270",
    palette = "tech:glow_paint"
})


crafting.register_recipe({
	type = "mortar_and_pestle",
	output = "tech:paint_glow_paint",
	items = {'group:bioluminescent 16', 'tech:stick', 'group:fibrous_plant 4', 'tech:vegetable_oil 4'},
	level = 1,
	always_known = true,
})

----------------------------------------------------------
--carbon black



----------------------------------------------------------
--red ochre
