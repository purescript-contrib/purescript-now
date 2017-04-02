module Control.Monad.Eff.Now
  ( NOW
  , now
  , nowDateTime
  , nowDate
  , nowTime
  , locale
  ) where

import Prelude

import Control.Monad.Eff (kind Effect, Eff)

import Data.DateTime (time, date)
import Data.DateTime.Instant (Instant, toDateTime)
import Data.DateTime.Locale (LocalTime, LocalDate, LocalDateTime, LocalValue(..), Locale(..))
import Data.Maybe (Maybe(..))
import Data.Time.Duration (Minutes)

-- | Effect type for when accessing the current date/time.
foreign import data NOW :: Effect

-- | Gets an `Instant` value for the date and time according to the current
-- | machine’s clock.
foreign import now :: forall e. Eff (now :: NOW | e) Instant

-- | Gets a `DateTime` value for the date and time according to the current
-- | machine’s clock.
nowDateTime :: forall e. Eff (now :: NOW | e) LocalDateTime
nowDateTime = LocalValue <$> locale <*> (toDateTime <$> now)

-- | Gets the date according to the current machine’s clock.
nowDate :: forall e. Eff (now :: NOW | e) LocalDate
nowDate = LocalValue <$> locale <*> (date <<< toDateTime <$> now)

-- | Gets the time according to the current machine’s clock.
nowTime :: forall e. Eff (now :: NOW | e) LocalTime
nowTime = LocalValue <$> locale <*> (time <<< toDateTime <$> now)

-- | Gets the locale according to the current machine’s clock.
-- |
-- | **Note**: The `LocaleName` will always be empty for the `Locale` value
-- | returned here until there is a reliable way to detect a name for the
-- | locale.
locale :: forall e. Eff (now :: NOW | e) Locale
locale = Locale Nothing <$> nowOffset

foreign import nowOffset :: forall e. Eff (now :: NOW | e) Minutes
