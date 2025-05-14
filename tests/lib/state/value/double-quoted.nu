use std/assert

use ../util.nu
use ../../../../dotenv/lib/state/state.nu
use ../../../../dotenv/lib/state/value/double-quoted.nu

export def steps-on-valid-input []: nothing -> nothing {
  let state = state init
  | merge {name: "test"}
  | double-quoted init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos 'value'
  assert equal $state.value "value"
}

export def done-on-double-quote []: nothing -> nothing {
  let state = state init
  | merge {name: "test"}
  | double-quoted init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos 'value\"abc\$def\""'
  $state | assert done "test" 'value"abc$def"'
}

export def expands-unbraced-var []: nothing -> nothing {
  let state = state init
  | merge {defs: [{name: "ABC", value: "foo"}]}
  | merge {name: "test"}
  | double-quoted init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos '$ABC_$DEF_$ABC123$DEF_$_g"'
  $state | assert done "test" 'foo__foo123_$_g'
}

export def expands-braced-var []: nothing -> nothing {
  let state = state init
  | merge {
    defs: [
      {name: "ABC", value: "foo"},
      {name: "ABC123", value: "bar"}
    ]
  }
  | merge {name: "test"}
  | double-quoted init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos '${ABC}_${DEF}_${ABC123}${DEF}_g"'
  $state | assert done "test" 'foo__bar_g'
}

export def accepts-newlines []: nothing -> nothing {
  let state = state init
  | merge {name: "test"}
  | double-quoted init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos "a\nb\""
  $state | assert done "test" "a\nb"
}

def "assert done" [name: string, value: string]: record -> nothing {
  let state = $in
  assert equal $state.type "value"
  assert equal $state.value-type "post-quote"
  assert equal $state.name $name
  assert equal $state.value $value
}
