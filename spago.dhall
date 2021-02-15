{ name = "web-file-directory-entries"
, dependencies =
  [ "prelude"
  , "aff"
  , "aff-promise"
  , "either"
  , "functions"
  , "effect"
  , "web-file"
  , "web-html"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
