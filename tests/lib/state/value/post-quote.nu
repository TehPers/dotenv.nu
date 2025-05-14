use std/assert

use ../util.nu
use ../../../../dotenv/lib/state/state.nu
use ../../../../dotenv/lib/state/value/post-quote.nu

export def done-on-lf []: nothing -> nothing {
  let state = state init
  | merge {name: "test", value: "value"}
  | post-quote init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos "\n"
  $state | assert done "test" "value"
}

export def done-on-crlf []: nothing -> nothing {
  let state = state init
  | merge {name: "test", value: "value"}
  | post-quote init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos "\r\n"
  $state | assert done "test" "value"
}

export def ignores-whitespace []: nothing -> nothing {
  let state = state init
  | merge {name: "test", value: "value"}
  | post-quote init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos "   \t \r\n"
  $state | assert done "test" "value"
}

export def ignores-comments []: nothing -> nothing {
  let state = state init
  | merge {name: "test", value: "value"}
  | post-quote init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos " # abcde\n"
  $state | assert done "test" "value"
}

export def ignores-comments-without-space []: nothing -> nothing {
  let state = state init
  | merge {name: "test", value: "value"}
  | post-quote init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos "#abcde\n"
  $state | assert done "test" "value"
}

def "assert done" [name: string, value: string]: record -> nothing {
  let state = $in
  assert equal $state.type "done"
  assert equal $state.name $name
  assert equal $state.value value
}
