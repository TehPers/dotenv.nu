use ./fail.nu
use ./state.nu

const ASCII_ALPHA = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
const IDENT_FIRST_CHARS = $"($ASCII_ALPHA)_"
const IDENT_CHARS = $"($IDENT_FIRST_CHARS)0123456789"

export def init [
  done: closure # Closure to call once done parsing a name. It should take the name and produce a state (string -> record).
  --alpha-only # Only allow alphabetic characters in the name.
  --empty: closure # Closure to call if ident is empty. Default is to fail.
]: record<defs: table> -> record<defs: table, type: string, step: closure> {
  let prev_state = $in
  $prev_state | merge {
    type: "ident"
    ident: ""
    alpha-only: $alpha_only
    step: {|position: record<line: int, col: int>, c: string|
      let state = $in
      let first = $state.ident | is-empty

      # Check if $c is a valid name character
      match [$state.alpha-only, $first] {
        [true, _] if $c in $ASCII_ALPHA => (
          $state | merge {ident: $"($state.ident)($c)"}
        )
        [false, false] if $c in $IDENT_CHARS => (
          $state | merge {ident: $"($state.ident)($c)"}
        )
        [false, true] if $c in $IDENT_FIRST_CHARS => (
          $state | merge {ident: $"($state.ident)($c)"}
        )
        [_, true] if $empty != null => (do $empty | state step $position $c)
        [true, true] => (
          fail expected $position "variable name consisting only of letters"
        )
        [false, true] => (
          fail expected $position "variable name"
        )
        _ => (do $done $state.ident | state step $position $c)
      }
    }
  }
}
