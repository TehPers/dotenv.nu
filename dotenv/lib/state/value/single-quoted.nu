use ../done.nu
use ../fail.nu
use ./post-quote.nu

export def init []: [
  record<defs: table, name: string> -> record<defs: table, name: string>
] {
  merge {
    type: "value"
    value-type: "single-quoted"
    value: ""
    escaped: false
    step: {|position: record<line: int, col: int>, c: string|
      mut state = $in
      match $c {
        "'" => {
          $state | post-quote init
        }
        _ => {
          $state.value += $c
          $state
        }
      }
    }
  }
}
