use ./state/start.nu
use ./state/state.nu

export def parse []: string -> table {
  let input = $in
  mut state = state init | start init
  mut pos = {line: 1, col: 0}
  mut results = []
  for c in ($in | split chars -g) {
    # Update position
    $pos = match $c {
      "\n" | "\r\n" => {line: ($pos.line + 1), col: 0}
      _ => {line: $pos.line, col: ($pos.col + 1)}
    }

    # Step state
    $state = $state | state step $pos $c | $in

    # Check if done parsing a variable
    if $state.type == "done" {
      $results ++= [{
        name: $state.name
        value: $state.value
      }]
      $state = state init
      | start init
      | merge {defs: $state.defs}
      | state push-def $state.name $state.value
    }
  }

  $results
}
