export def init [
  done: closure
]: record -> record {
  let prev_state = $in
  $prev_state | merge {
    substate: "escape"
    step: {|position: record<line: int, col: int>, c: string|
      let inserted = match $c {
        'b' => "\b"
        'f' => "\f"
        'n' => "\n"
        'r' => "\r"
        't' => "\t"
        '0' => (char nul)
        _ => $c
      }
      do $done $inserted
    }
  }
}
