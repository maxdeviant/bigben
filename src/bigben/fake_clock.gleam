//// A fake clock for manipulating the flow of time.

import gleam/erlang/process.{type Subject}
import gleam/otp/actor
import gleam/time/duration.{type Duration}
import gleam/time/timestamp.{type Timestamp}

/// A fake clock.
pub opaque type FakeClock {
  FakeClock(subject: Subject(Message))
}

/// Returns a new `FakeClock`.
///
/// The current time will be the instant the clock was created.
pub fn new() -> FakeClock {
  new_at(timestamp.system_time())
}

/// Returns a new `FakeClock` at the given time.
pub fn new_at(now: Timestamp) -> FakeClock {
  let assert Ok(actor) =
    actor.new(now) |> actor.on_message(handle_message) |> actor.start
  FakeClock(actor.data)
}

/// Returns the current time on the given `FakeClock`.
pub fn now(clock: FakeClock) -> Timestamp {
  process.call(clock.subject, 10, Get)
}

/// Sets the current time on the given `FakeClock` to the specified value.
pub fn set_now(clock: FakeClock, now: Timestamp) -> Nil {
  process.send(clock.subject, Set(now))
}

/// Advances the given `FakeClock` by the specified duration.
pub fn advance(clock: FakeClock, duration: Duration) -> Nil {
  process.send(clock.subject, Advance(duration))
}

type Message {
  Get(reply_with: Subject(Timestamp))
  Set(Timestamp)
  Advance(Duration)
}

fn handle_message(state: Timestamp, message: Message) {
  case message {
    Get(client) -> {
      process.send(client, state)
      actor.continue(state)
    }
    Set(now) -> actor.continue(now)
    Advance(duration) -> actor.continue(timestamp.add(state, duration))
  }
}
