import bigben/clock.{type Clock}
import bigben/fake_clock
import birl.{Day}
import birl/duration
import gleam/int
import gleeunit/should

pub fn clock_can_be_faked_test() {
  let assert Ok(now) = birl.parse("2024-04-12T01:33:46.382Z")
  let fake_clock = fake_clock.new_at(now)
  let clock = clock.from_fake(fake_clock)

  what_day_is_it(clock)
  |> should.equal("Today is Friday, April 12, 2024")

  fake_clock.advance(fake_clock, duration.days(5))

  what_day_is_it(clock)
  |> should.equal("Today is Wednesday, April 17, 2024")
}

fn what_day_is_it(clock: Clock) -> String {
  let now = clock.now(clock)

  let weekday = birl.string_weekday(now)
  let month = birl.string_month(now)
  let Day(year, _, day) = birl.get_day(now)
  let day = int.to_string(day)
  let year = int.to_string(year)

  "Today is " <> weekday <> ", " <> month <> " " <> day <> ", " <> year
}
