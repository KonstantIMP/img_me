project('img_me', ['d', 'c'], version : '0.0.1')

source_dir = include_directories('source/')
source_root = meson.source_root()

img_me_sorce = [
    'source/app.d',
]

gtkd_dep = dependency('gtkd-3')

uncompressed_image_source = [
    'source/uncompressed_image/image.d',
    'source/uncompressed_image/defines.d',
    'source/uncompressed_image/color_translater.d'
]
uncompressed_image_lib = static_library('uncompressed_image',
    uncompressed_image_source, include_directories : [source_dir])

pnm_source = [
    'source/pnm/pnm_me.d',
    'source/pnm/pnm_defines.d',
    'source/pnm/pnm_parser.d'
]
pnm_lib = static_library('pnm', pnm_source, include_directories : [source_dir], link_with : [uncompressed_image_lib])

img_me_bin = executable('img_me', [img_me_sorce],
    include_directories : [source_dir],
    link_with : [pnm_lib, uncompressed_image_lib],
    dependencies : [gtkd_dep])