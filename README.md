# bigben

[![Package Version](https://img.shields.io/hexpm/v/bigben)](https://hex.pm/packages/bigben)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/bigben/)

🕰️ A clock abstraction, with time travel.

## Installation

```sh
gleam add bigben
```

## Usage

```gleam
import bigben/clock.{type Clock}
import bigben/fake_clock
import birl
import birl/duration
import gleam/io

pub fn main() {
  // In your production code, you'll use the real `Clock` to get the time
  // from the system:
  let clock = clock.new()
  what_day_is_it(clock) // Today is Monday.

  // In test code you can construct a `FakeClock`:
  let assert Ok(now) = birl.parse("2024-04-08T02:26:31.464Z")
  let fake_clock = fake_clock.new_at(now)
  // and pass it off as a real `Clock`:
  let clock = clock.from_fake(fake_clock)

  what_day_is_it(clock) // Today is Monday.

  // We can then manipulate the clock to help us in our tests:
  fake_clock.advance(fake_clock, duration.days(4))

  what_day_is_it(clock) // Today is Friday.
}

fn what_day_is_it(clock: Clock) {
  let day_of_the_week =
    clock
    |> clock.now
    |> birl.string_weekday

  io.println("Today is " <> day_of_the_week <> ".")
}
```

## Targets

`bigben` supports the Erlang target.
