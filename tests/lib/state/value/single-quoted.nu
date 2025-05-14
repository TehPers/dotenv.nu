use std/assert

use ../util.nu
use ../../../../dotenv/lib/state/state.nu
use ../../../../dotenv/lib/state/value/single-quoted.nu

export def steps-on-valid-input []: nothing -> nothing {
  let state = state init
  | merge {name: "test"}
  | single-quoted init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos 'value'
  assert equal $state.value "value"
}

export def done-on-single-quote []: nothing -> nothing {
  let state = state init
  | merge {name: "test"}
  | single-quoted init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos "value\"abc$def\"'"
  $state | assert done "test" "value\"abc$def\""
}

export def accepts-newlines []: nothing -> nothing {
  let state = state init
  | merge {name: "test"}
  | single-quoted init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos "a\nb'"
  $state | assert done "test" "a\nb"
}

def "assert done" [name: string, value: string]: record -> nothing {
  let state = $in
  assert equal $state.type "value"
  assert equal $state.value-type "post-quote"
  assert equal $state.name $name
  assert equal $state.value $value
}
