import bigben/clock.{type Clock}
import bigben/fake_clock
import gleam/int
import gleam/time/calendar
import gleam/time/duration
import gleam/time/timestamp
import gleeunit/should

pub fn clock_can_be_faked_test() {
  let assert Ok(now) = timestamp.parse_rfc3339("2024-04-12T01:33:46.382Z")
  let fake_clock = fake_clock.new_at(now)
  let clock = clock.from_fake(fake_clock)

  what_day_is_it(clock)
  |> should.equal("Today is April 12, 2024")

  fake_clock.advance(fake_clock, duration.hours(5 * 24))

  what_day_is_it(clock)
  |> should.equal("Today is April 17, 2024")
}

fn what_day_is_it(clock: Clock) -> String {
  let now = clock.now(clock)
  let #(date, _time) = now |> timestamp.to_calendar(calendar.utc_offset)

  let month = date.month |> calendar.month_to_string
  let day = int.to_string(date.day)
  let year = int.to_string(date.year)

  "Today is " <> month <> " " <> day <> ", " <> year
}
