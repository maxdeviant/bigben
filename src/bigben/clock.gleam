//// A clock.

import bigben/fake_clock.{type FakeClock}
import birl.{type Time}

/// A clock.
pub opaque type Clock {
  Clock(utc_now: fn() -> Time)
}

/// Returns a new `Clock`.
pub fn new() -> Clock {
  Clock(birl.utc_now)
}

/// Returns the current time on the given `Clock`, in UTC.
pub fn now(clock: Clock) -> Time {
  clock.utc_now()
}

/// Returns a new `Clock` constructed from the given `FakeClock`.
pub fn from_fake(clock: FakeClock) -> Clock {
  Clock(fn() { fake_clock.now(clock) })
}
