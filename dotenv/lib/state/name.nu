use ./fail.nu
use ./ident.nu
use ./state.nu
use ./value

export def init []: record<defs: table> -> record<defs: table> {
  merge {
    type: "name"
    name: ""
    exported: false
    step: {|position: record<line: int, col: int>, c: string|
      let state = $in
      
      match $c {
        # Separator
        "=" if ($state.name | is-not-empty) => ($state | value init $state.name)
        "=" => (
          fail expected $position "valid name"
        )
        # Whitespace after 'export'
        _ if not $state.exported and $state.name == "export" and ($c | str trim | is-empty) => (
          $state | merge {exported: true, name: ""}
        )
        # Leading whitespace (or after 'export')
        _ if ($state.name | is-empty) and ($c | str trim | is-empty) => $state
        # Name character
        _ => (
          $state
          | ident init {|name| $state | merge {name: $name}}
          | state step $position $c
        )
      }
    }
  }
}
