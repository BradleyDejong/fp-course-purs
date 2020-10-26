module Course.Optional where

import Prelude
import Control.Monad (class Monad)
import Utils.Error (error)

-- | The `Optional` data type contains 0 or 1 value.
--
-- It might be thought of as a list, with a maximum length of one.
data Optional a
  = Full a
  | Empty

derive instance optionalExactlyOne :: Eq a => Eq (Optional a)

instance showExactlyOne :: Show a => Show (Optional a) where
  show :: forall a. Show a => Optional a -> String
  show (Full a) = show a
  show Empty = ""

-- -- | Map the given function on the possible value.
-- --
-- -- >>> mapOptional (+1) Empty
-- -- Empty
-- --
-- -- >>> mapOptional (+1) (Full 8)
-- -- Full 9
mapOptional :: forall a b. (a -> b) -> Optional a -> Optional b
mapOptional _ Empty = Empty

mapOptional f (Full a) = Full (f a)

-- -- | Bind the given function on the possible value.
-- --
-- -- >>> bindOptional Full Empty
-- -- Empty
-- --
-- -- >>> bindOptional (\n -> if even n then Full (n - 1) else Full (n + 1)) (Full 8)
-- -- Full 7
-- --
-- -- >>> bindOptional (\n -> if even n then Full (n - 1) else Full (n + 1)) (Full 9)
-- -- Full 10
bindOptional :: forall a b. (a -> Optional b) -> Optional a -> Optional b
bindOptional _ Empty = Empty

bindOptional f (Full a) = f a

-- -- | Return the possible value if it exists; otherwise, the second argument.
-- --
-- -- >>> Full 8 ?? 99
-- -- 8
-- --
-- -- >>> Empty ?? 99
-- -- 99
optional :: forall a. Optional a -> a -> a
optional Empty a = a

optional (Full a) _ = a

infixl 12 optional as ??

-- -- | Try the first optional for a value. If it has a value, use it; otherwise,
-- -- use the second value.
-- --
-- -- >>> Full 8 <+> Empty
-- -- Full 8
-- --
-- -- >>> Full 8 <+> Full 9
-- -- Full 8
-- --
-- -- >>> Empty <+> Full 9
-- -- Full 9
-- --
-- -- >>> Empty <+> Empty
-- -- Empty
eitherOptional :: forall a. Optional a -> Optional a -> Optional a
eitherOptional Empty x = x

eitherOptional (Full a) _ = Full a

infixl 12 eitherOptional as <+>

applyOptional :: forall a b. Optional (a -> b) -> Optional a -> Optional b
applyOptional f a = bindOptional (\f' -> mapOptional f' a) f

twiceOptional :: forall a b c. (a -> b -> c) -> Optional a -> Optional b -> Optional c
twiceOptional f = applyOptional <<< mapOptional f

contains :: forall a. Eq a => a -> Optional a -> Boolean
contains _ Empty = false

contains a (Full z) = a == z

instance optionalFunctor :: Functor Optional where
  map = mapOptional

instance applyOptionalForReal :: Apply Optional where
  apply (Full f) (Full a) = Full (f a)
  apply _ _ = Empty

instance optionalApplicative :: Applicative Optional where
  pure = Full

instance bindOptionalForReal :: Bind Optional where
  bind = flip bindOptional

instance optionalMonad :: Monad Optional
