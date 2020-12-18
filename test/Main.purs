module Test.Main where

import Prelude
import Course.FunctorSpec (functorSpec)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class.Console (log)
import Test.ListSpec (listSpec)
import Course.ApplicativeSpec (spec) as A
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner (runSpec)

main :: Effect Unit
main = do
  launchAff_
    $ runSpec [ consoleReporter ] do
        A.spec
