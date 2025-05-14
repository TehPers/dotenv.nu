use ./name.nu
use ./state.nu

export def init []: [
  record<defs: table> -> record<defs: table>
] {
  merge {
    type: "start"
    comment: false
    step: {|position: record<line: int, col: int>, c: string|
      let state = $in
      match $c {
        "\n" | "\r\n" => ($state | merge {comment: false})
        '#' if not $state.comment => ($state | merge {comment: true})
        _ if $state.comment or ($c | str trim | is-empty) => $state
        _ => ($state | name init | state step $position $c)
      }
    }
  }
}
