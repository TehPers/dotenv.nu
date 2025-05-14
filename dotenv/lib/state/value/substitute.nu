use ../fail.nu
use ../ident.nu
use ../state.nu

export def init [
  done: closure
]: [
  record<defs: table> -> record<defs: table>
] {
  merge {
    substate: "substitute"
    name: null
    step: {|position: record<line: int, col: int>, c: string|
      let state = $in
      match [$c, ($state.name != null)] {
        ['}', true] => (do $done ($state | state get-def $state.name))
        [_, true] => (fail expected $position "'}'")
        ['{', _] => ($state | ident init {|name| $state | merge {name: $name}})
        _ => (
          $state
          | ident init
            --alpha-only {|name| do $done ($state | state get-def $name)}
            --empty {do $done '$'}
          | state step $position $c
        )
      }
    }
  }
}
