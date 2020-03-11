Exile mod: Grafitti
=============================
Grafitti API.

Allows applying images to walls etc




Usage:

grafitti.register_grafitti(node_name, def)
-- node_name (eg. "default:stone")
-- def : {
--   image,
--   size = {x, y}, (optional, default: {1, 1})
--   center = {row, col}, (optional, default: {0, 0})
--   pointable (optional, default: false)
-- }

grafitti.set_palette_width(width)
-- Set GUI width for palette. If not set, default width is 8.
-- Use before palette build.

grafitti.palette_build(palette_name)
-- Place all previously registered grafitti into palette.
-- palette_name (eg. "mymod:nyancat_images")

grafitti.register_brush(brush_name, def)
-- Use after palette_build.
-- brush_name (eg. "mymod:nyancat_brush")
-- def : {
--   palette (eg. "mymod:nyancat_images"),
--   description (optional),
--   inventory_image (optional),
--   wield_image (optional),
--   recipe (optional)
-- }


Authors of original source code
-------------------------------
Adapted for Exile from Grafitti by  AspireMint. GPLv3
