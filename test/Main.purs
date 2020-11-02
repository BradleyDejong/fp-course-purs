module Test.Main where

import Prelude
import Effect (Effect)
import Effect.Class.Console (log)
import Test.OptionalSpec (optionalSpec)
import Test.ListSpec (listSpec)

main :: Effect Unit
main = do
  optionalSpec
  listSpec
  log "🍝"
