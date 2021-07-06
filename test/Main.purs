module Test.Main where

import Prelude

import Control.Monad.Error.Class (try)
import Control.Monad.State (StateT, execStateT, lift, modify)
import Data.Either (Either(..))
import Data.Time.Duration (Minutes(..))
import Effect (Effect)
import Effect.Class.Console (log, logShow)
import Effect.Exception (throw)
import Effect.Now (getTimezoneOffset, now, nowDate, nowTime)
import Node.Process (exit)
import Test.Assert (assert, assert')

type FailedTestCount = Int
type Test = StateT FailedTestCount Effect Unit

test :: String -> Effect Unit -> Test
test name body = 
  try (lift body) >>= case _ of
    Right _ -> log ("✔️  " <> name)
    Left err -> do 
      log ("❌  " <> name)
      logShow err
      void $ modify (_ + 1)

assertDoesNotThrow :: ∀ a. Effect a -> Effect Unit
assertDoesNotThrow action = try action >>= case _ of
  Right _ -> pure unit
  Left err -> do throw ("Expected to not throw an exception, but one was thrown.\n" <> show err)


timeAdvances :: ∀ time. Show time => Ord time => Effect time -> String -> Test
timeAdvances getTime name = test ("time advances with " <> name) do
  startTime <- getTime
  endTime <- getTime
  assert' (show endTime <> " should be greater than than " <> show startTime) $ endTime >= startTime 

canGetTheCurrentTime :: Test
canGetTheCurrentTime = test "can get the current time" do 
  assertDoesNotThrow nowTime

offsetSeemsSensible :: Test
offsetSeemsSensible = test "UTC offset between -13:00 and +15:00" do
  minutes <- getTimezoneOffset
  assert $ between lbound ubound minutes

  where
    lbound = Minutes $ (-13.0) * minPerHour
    ubound = Minutes $ 15.0 * minPerHour
    minPerHour = 60.0
    

main :: Effect Unit
main = do
  failedTests <- flip execStateT 0 do 
    timeAdvances now "now"
    timeAdvances nowDate "nowDate"
    canGetTheCurrentTime
    offsetSeemsSensible

  exit failedTests

