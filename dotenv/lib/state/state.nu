# Initializes a new state.
export def init []: [
  nothing -> record<defs: table>
] {
  {defs: []}
}

# Gets the value of the last definition with the given name, if any.
export def get-def [name: string]: record<defs: table> -> any {
  get defs
  | where name == $name
  | if ($in | length) > 0 {
    last | get value
  } else {
    null
  }
}

# Pushes a new definition onto the state, returning the modified state.
export def push-def [name: string, value: string]: record<defs: table> -> record<defs: table> {
  merge deep -s append {
    defs: [{
      name: $name
      value: $value
    }]
  }
}

# Transitions the state.
export def step [
  position: record<line: int, col: int>
  c: string
]: record -> record {
  do $in.step $position $c
}
