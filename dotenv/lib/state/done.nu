use ./fail.nu

export def init []: [
  record<defs: table, name: string, value: string> -> record<defs: table, name: string, value: string>
] {
  merge {
    type: "done"
    step: {|position: record<line: int, col: int>, c: string|
      fail $position "attempted to step when done (this is a bug)"
    }
  }
}
