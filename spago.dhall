{ name = "now"
, dependencies =
  [ "assert"
  , "console"
  , "datetime"
  , "effect"
  , "node-process"
  , "psci-support"
  , "transformers"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
