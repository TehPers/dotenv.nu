use std/assert

use ./util.nu
use ../../../dotenv/lib/state/start.nu
use ../../../dotenv/lib/state/state.nu

export def done-on-name-start []: nothing -> nothing {
  let state = state init | start init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos "e"
  assert not equal $state.type "start"
}

export def ignores-whitespace []: nothing -> nothing {
  let state = state init | start init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos "   \t \r\n  "
  assert equal $state.type "start"
}

export def ignores-comments []: nothing -> nothing {
  let state = state init | start init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos " # abcde\n#abcde"
  assert equal $state.type "start"
}
