use ../fail.nu
use ../state.nu
use ./double-quoted.nu
use ./unquoted.nu
use ./single-quoted.nu

export def init [name: string]: record<defs: table> -> record<defs: table> {
  merge {
    type: "value"
    name: $name
    value: ""
    step: {|position: record<line: int, col: int>, c: string|
      # Decide which sub-state to go to
      match $c {
        '"' => (double-quoted init)
        "'" => {
          single-quoted init
        }
        _ => {
          unquoted init | state step $position $c
        }
      }
    }
  }
}
