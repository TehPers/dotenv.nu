use std/assert

use ./util.nu
use ../../../dotenv/lib/state/name.nu
use ../../../dotenv/lib/state/state.nu

export def steps-on-valid-input []: nothing -> nothing {
  let state = state init | name init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos "ab1="
  assert equal $state.type "value"
  assert equal $state.name "ab1"
}

export def ignores-export []: nothing -> nothing {
  let state = state init | name init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos "export foo="
  assert equal $state.type "value"
  assert equal $state.name "foo"
}

export def ignores-leading-ws []: nothing -> nothing {
  let state = state init | name init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos "  \t\r\n foo="
  assert equal $state.type "value"
  assert equal $state.name "foo"
}

export def ignores-ws-after-export []: nothing -> nothing {
  let state = state init | name init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos " export  \t\r\n foo="
  assert equal $state.type "value"
  assert equal $state.name "foo"
}

export def fails-on-start-with-number []: nothing -> nothing {
  let state = state init | name init
  let pos = {line: 1, col: 0}

  let state = assert error {
    $state | util step $pos "1"
  }
}

export def fails-on-start-with-number-after-export []: nothing -> nothing {
  let state = state init | name init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos "export "
  let state = assert error {
    $state | util step $pos "1"
  }
}

export def fails-on-space-after-name []: nothing -> nothing {
  let state = state init | name init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos "foo"
  let state = assert error {
    $state | util step $pos " "
  }
}

export def fails-on-missing-name []: nothing -> nothing {
  let state = state init | name init
  let pos = {line: 1, col: 0}

  let state = assert error {
    $state | util step $pos "="
  }
}

export def fails-on-missing-name-after-export []: nothing -> nothing {
  let state = state init | name init
  let pos = {line: 1, col: 0}

  let state = $state | util step $pos "export "
  let state = assert error {
    $state | util step $pos "="
  }
}
