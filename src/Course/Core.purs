module Course.Core where

import Prelude
import Effect.Console (log)
import Effect.Unsafe (unsafePerformEffect)
import Unsafe.Coerce (unsafeCoerce)

error :: forall a. String -> a
error msg =
  unsafePerformEffect
    $ do
        log msg
        pure $ unsafeCoerce unit
