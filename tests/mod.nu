use std/assert

export use ./lib
use ../dotenv

export def parse-env [] {
  let environment = dotenv parse tests/envs/syntax.env
  let expected = open tests/envs/syntax.env.nuon
  assert equal ($environment | length) ($expected | length)

  let incorrect = $environment
  | zip $expected
  | where {|it|
    $it.0.name != $it.1.name or ($it.0.value | str replace "\r\n" "\n") != ($it.1.value | str replace "\r\n" "\n")
  }

  if ($incorrect | is-not-empty) {
    for row in $incorrect {
      let name = $row.0.name
      print -e {
        name: $name
        actual: ($row.0.value | debug --raw-value)
        expected: ($row.1.value | debug --raw-value)
      }
    }

    error make {msg: $"($incorrect | length) incorrect values"}
  }
}

export def parse-simple []: nothing -> nothing {
  let environment = dotenv parse tests/envs/simple.env
  assert equal $environment [
    {name: "ABC", value: "123"}
    {name: "ABC", value: "456"}
    {name: "DEF", value: "123"}
    {name: "GHI", value: "456"}
  ]
}
