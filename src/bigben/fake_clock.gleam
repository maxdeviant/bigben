//// A fake clock for manipulating the flow of time.

import birl.{type Time}
import birl/duration.{type Duration}
import gleam/erlang/process.{type Subject}
import gleam/otp/actor

/// A fake clock.
pub opaque type FakeClock {
  FakeClock(subject: Subject(Message))
}

/// Returns a new `FakeClock`.
///
/// The current time will be now in UTC.
pub fn new() -> FakeClock {
  new_at(birl.utc_now())
}

/// Returns a new `FakeClock` at the given time.
pub fn new_at(now: Time) -> FakeClock {
  let assert Ok(subject) = actor.start(now, handle_message)
  FakeClock(subject)
}

/// Returns the current time on the given `FakeClock`.
pub fn now(clock: FakeClock) -> Time {
  process.call(clock.subject, Get, 10)
}

/// Sets the current time on the given `FakeClock` to the specified value.
pub fn set_now(clock: FakeClock, now: Time) -> Nil {
  process.send(clock.subject, Set(now))
}

/// Advances the given `FakeClock` by the specified duration.
pub fn advance(clock: FakeClock, duration: Duration) -> Nil {
  process.send(clock.subject, Advance(duration))
}

type Message {
  Get(reply_with: Subject(Time))
  Set(Time)
  Advance(Duration)
}

fn handle_message(message: Message, state: Time) {
  case message {
    Get(client) -> {
      process.send(client, state)
      actor.continue(state)
    }
    Set(now) -> actor.continue(now)
    Advance(duration) -> actor.continue(birl.add(state, duration))
  }
}
