use ../done.nu
use ../state.nu
use ./escape.nu
use ./post-quote.nu
use ./substitute.nu

export def init []: [
  record<defs: table, name: string> -> record<defs: table, name: string>
] {
  merge {
    type: "value"
    value-type: "unquoted"
    value: ""
    step: {|position: record<line: int, col: int>, c: string|
      let state = $in
      match $c {
        '#' if ($state.value != ($state.value | str trim --right)) => (
          $state
          | merge {value: ($state.value | str trim --right)}
          | post-quote init
          | state step $position $c
        )
        "\n" | "\r\n" => ($state | done init)
        '\' => (
          $state
          | escape init {|c| $state | merge {value: $"($state.value)($c)"}}
        )
        '$' => (
          $state | substitute init {|value|
            $state | merge {
              value: $"($state.value)($value)"
            }
          }
        )
        _ => ($state | merge {value: $"($state.value)($c)"})
      }
    }
  }
}
