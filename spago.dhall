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
, license = "BSD-3-Clause"
, repository = "https://github.com/xc-jp/purescript-web-file-directory-entries"
}
