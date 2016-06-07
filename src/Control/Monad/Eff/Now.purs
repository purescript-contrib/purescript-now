module Control.Monad.Eff.Now where

import Control.Monad.Eff (Eff)
import Data.DateTime.Instant (Instant)

-- | Effect type for when accessing the current date/time.
foreign import data NOW :: !

-- | Gets an `Instant` value corresponding to the current date/time according to
-- | the current machine’s clock.
foreign import now :: forall e. Eff (now :: NOW | e) Instant
