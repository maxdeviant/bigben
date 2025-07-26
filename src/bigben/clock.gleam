//// A clock.

import bigben/fake_clock.{type FakeClock}
import gleam/time/timestamp.{type Timestamp}

/// A clock.
pub opaque type Clock {
  Clock(utc_now: fn() -> Timestamp)
}

/// Returns a new `Clock`.
pub fn new() -> Clock {
  Clock(timestamp.system_time)
}

/// Returns the current time on the given `Clock`.
pub fn now(clock: Clock) -> Timestamp {
  clock.utc_now()
}

/// Returns a new `Clock` constructed from the given `FakeClock`.
pub fn from_fake(clock: FakeClock) -> Clock {
  Clock(fn() { fake_clock.now(clock) })
}
