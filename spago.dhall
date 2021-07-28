{ name = "now"
, dependencies =
  [ "assert"
  , "console"
  , "datetime"
  , "effect"
  , "either"
  , "exceptions"
  , "node-process"
  , "prelude"
  , "psci-support"
  , "transformers"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
