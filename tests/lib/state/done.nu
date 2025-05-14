use std/assert

use ./util.nu
use ../../../dotenv/lib/state/done.nu
use ../../../dotenv/lib/state/state.nu

export def fails-on-step []: nothing -> nothing {
  let state = state init
  | merge {name: "test", value: "value"}
  | done init
  let pos = {line: 1, col: 0}

  assert error {
    $state | util step $pos " "
  }
}
