use ./escape.nu
use ./post-quote.nu
use ./substitute.nu

export def init []: [
  record<defs: table, name: string> -> record<defs: table, name: string>
] {
  merge {
    type: "value"
    value-type: "double-quoted"
    value: ""
    step: {|position: record<line: int, col: int>, c: string|
      let state = $in
      match $c {
        '"' => ($state | post-quote init)
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
