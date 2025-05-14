export def step [position: record, input: string]: record -> record {
  let state = $in
  $input | split chars -g | reduce -f $state {|c, state|
    $state | do $state.step $position $c
  }
}
