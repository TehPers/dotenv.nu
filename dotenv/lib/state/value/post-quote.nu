use ../done.nu

export def init []: [
  record<defs: table, name: string, value: string> -> record<defs: table, name: string, value: string>
] {
  merge {
    type: "value"
    value-type: "post-quote"
    comment: false
    step: {|position: record<line: int, col: int>, c: string|
      let state = $in
      match $c {
        '#' if not $state.comment => ($state | merge {comment: true})
        "\n" | "\r\n" => ($state | done init)
        _ if $state.comment or ($c | str trim | is-empty) => $state
        _ => (fail expected $position "whitespace, newline, or comment")
      }
    }
  }
}
