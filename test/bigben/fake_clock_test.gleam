import bigben/fake_clock
import gleam/time/calendar
import gleam/time/duration
import gleam/time/timestamp
import gleeunit/should

pub fn fake_clock_set_now_test() {
  let assert Ok(now) = timestamp.parse_rfc3339("2024-04-13T01:33:46.382Z")
  let clock = fake_clock.new_at(now)

  fake_clock.now(clock)
  |> timestamp.to_rfc3339(calendar.utc_offset)
  |> should.equal(timestamp.to_rfc3339(now, calendar.utc_offset))

  let assert Ok(new_now) = timestamp.parse_rfc3339("2025-04-13T01:33:46.382Z")
  fake_clock.set_now(clock, new_now)

  fake_clock.now(clock)
  |> timestamp.to_rfc3339(calendar.utc_offset)
  |> should.equal(timestamp.to_rfc3339(new_now, calendar.utc_offset))
}

pub fn fake_clock_advance_test() {
  let assert Ok(now) = timestamp.parse_rfc3339("2024-04-13T01:33:46.382Z")
  let clock = fake_clock.new_at(now)

  fake_clock.advance(clock, duration.hours(3 * 24))
  fake_clock.now(clock)
  |> timestamp.to_rfc3339(calendar.utc_offset)
  |> should.equal("2024-04-16T01:33:46.382Z")

  fake_clock.advance(clock, duration.hours(6 * 7 * 24))
  fake_clock.now(clock)
  |> timestamp.to_rfc3339(calendar.utc_offset)
  |> should.equal("2024-05-28T01:33:46.382Z")

  fake_clock.advance(clock, duration.hours(9 * 30 * 24))
  fake_clock.now(clock)
  |> timestamp.to_rfc3339(calendar.utc_offset)
  |> should.equal("2025-02-22T01:33:46.382Z")
}
