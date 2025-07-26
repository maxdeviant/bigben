//// A fake clock for manipulating the flow of time.

import gleam/time/duration.{type Duration}
import gleam/time/timestamp.{type Timestamp}
import interior/cell.{type Cell}

/// A fake clock.
pub opaque type FakeClock {
  FakeClock(now: Cell(Timestamp))
}

/// Returns a new `FakeClock`.
///
/// The current time will be the instant the clock was created.
pub fn new() -> FakeClock {
  new_at(timestamp.system_time())
}

/// Returns a new `FakeClock` at the given time.
pub fn new_at(now: Timestamp) -> FakeClock {
  FakeClock(cell.new(now))
}

/// Returns the current time on the given `FakeClock`.
pub fn now(clock: FakeClock) -> Timestamp {
  cell.get(clock.now)
}

/// Sets the current time on the given `FakeClock` to the specified value.
pub fn set_now(clock: FakeClock, now: Timestamp) -> Nil {
  cell.set(clock.now, now)
}

/// Advances the given `FakeClock` by the specified duration.
pub fn advance(clock: FakeClock, duration: Duration) -> Nil {
  cell.update(clock.now, timestamp.add(_, duration))
}
