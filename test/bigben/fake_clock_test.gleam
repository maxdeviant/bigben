import bigben/fake_clock
import birl
import birl/duration
import gleeunit/should

pub fn fake_clock_set_now_test() {
  let assert Ok(now) = birl.parse("2024-04-13T01:33:46.382Z")
  let clock = fake_clock.new_at(now)

  fake_clock.now(clock)
  |> birl.to_iso8601
  |> should.equal(birl.to_iso8601(now))

  let assert Ok(new_now) = birl.parse("2025-04-13T01:33:46.382Z")
  fake_clock.set_now(clock, new_now)

  fake_clock.now(clock)
  |> birl.to_iso8601
  |> should.equal(birl.to_iso8601(new_now))
}

pub fn fake_clock_advance_test() {
  let assert Ok(now) = birl.parse("2024-04-13T01:33:46.382Z")
  let clock = fake_clock.new_at(now)

  fake_clock.advance(clock, duration.days(3))
  fake_clock.now(clock)
  |> birl.to_iso8601
  |> should.equal("2024-04-16T01:33:46.382Z")

  fake_clock.advance(clock, duration.weeks(6))
  fake_clock.now(clock)
  |> birl.to_iso8601
  |> should.equal("2024-05-28T01:33:46.382Z")

  fake_clock.advance(clock, duration.months(9))
  fake_clock.now(clock)
  |> birl.to_iso8601
  |> should.equal("2025-02-22T01:33:46.382Z")
}
