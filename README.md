# bigben

[![Package Version](https://img.shields.io/hexpm/v/bigben)](https://hex.pm/packages/bigben)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/bigben/)
![Erlang-compatible](https://img.shields.io/badge/target-erlang-b83998)
![JavaScript-compatible](https://img.shields.io/badge/target-javascript-f1e05a)

🕰️ A clock abstraction, with time travel.

## Installation

```sh
gleam add bigben
```

## Usage

```gleam
import bigben/clock.{type Clock}
import bigben/fake_clock
import gleam/int
import gleam/io
import gleam/time/calendar
import gleam/time/duration
import gleam/time/timestamp

pub fn main() {
  // In your production code, you'll use the real `Clock` to get the time
  // from the system:
  let clock = clock.new()
  what_day_is_it(clock)
  // Today is July 26, 2025.

  // In test code you can construct a `FakeClock`:
  let assert Ok(now) = timestamp.parse_rfc3339("2024-04-08T02:26:31.464Z")
  let fake_clock = fake_clock.new_at(now)
  // and pass it off as a real `Clock`:
  let clock = clock.from_fake(fake_clock)

  what_day_is_it(clock)
  // Today is April 8, 2024.

  // We can then manipulate the clock to help us in our tests:
  fake_clock.advance(fake_clock, duration.hours(4 * 24))

  what_day_is_it(clock)
  // Today is April 12, 2024.
}

fn what_day_is_it(clock: Clock) {
  let #(date, _time) =
    clock |> clock.now |> timestamp.to_calendar(calendar.utc_offset)

  let month = date.month |> calendar.month_to_string
  let day = date.day |> int.to_string
  let year = date.year |> int.to_string

  io.println("Today is " <> month <> " " <> day <> ", " <> year <> ".")
}
```
