(module dotfiles.plugin.colorizer
  {autoload {colorizer colorizer}})

(colorizer.setup {"*" {}}
                 {:RGB      true ; #RGB hex codes, like #F00
                  :RRGGBB   true ; #RRGGBB hex codes, like #00FF00
                  :names    true ; "Name" codes like Blue
                  :RRGGBBAA true ; #RRGGBBAA hex codes
                  :rgb_fn   true ; CSS rgb() and rgba() functions
                  :hsl_fn   true ; CSS hsl() and hsla() functions
                  :css      true ; Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                  :css_fn   true ; Enable all CSS *functions*: rgb_fn, hsl_fn
                  })
