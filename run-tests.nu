def main [
  --filter: string (-f) # Filters tests to only those which start with this prefix.
]: nothing -> nothing {
  # Collect tests
  let without_tests = scope commands | where type == custom | get name
  let with_tests = nu -c 'use tests; scope commands | where type == custom | get name | to nuon' | from nuon
  let tests = $with_tests
  | default []
  | where ($it starts-with "tests ") and ($it not-in $without_tests)
  | each {|test| $test | str substring 6..}
  let filtered_tests = if ($filter | is-not-empty) {
    $tests | where $it starts-with $filter
  } else {
    $tests
  }

  # Execute tests
  let results = $filtered_tests | par-each {|test|
    let output = do -i { nu -n -c $"use tests; tests ($test)" } | complete
    let success = $output.exit_code == 0
    {
      name: $test
      status: (if $success { "pass" } else { "fail" })
      stdout: $output.stdout
      stderr: $output.stderr
    }
  } | append (
    $tests
    | where $it not-in $filtered_tests
    | each {|test|
      {
        name: $test
        status: "skip"
        stdout: ""
        stderr: ""
      }
    }
  )

  # Print the results
  print-results $results
}

def print-results [
  results: table
]: nothing -> nothing {
  let passed = $results | where status == "pass" | sort-by name
  let failed = $results | where status == "fail" | sort-by name
  let skipped = $results | where status == "skip" | sort-by name

  # Print passed tests
  for result in $passed {
    print $"(ansi-fmt green)PASS(ansi-fmt reset) ($result.name)"
  }

  # Print failed tests
  for result in $failed {
    print $"(ansi-fmt red_reverse)FAIL(ansi-fmt reset) ($result.name)"
  }

  # Collect output from failed tests
  let outputs = $failed | each {|result|
    mut output = []
    if ($result.stdout | is-not-empty) {
      $output ++= [
        $"==== (ansi-fmt red)STDOUT(ansi-fmt reset): ($result.name) ===="
        ""
        $result.stdout
      ]
    }
    if ($result.stderr | is-not-empty) {
      $output ++= [
        $"==== (ansi-fmt red)STDERR(ansi-fmt reset): ($result.name) ===="
        ""
        $result.stderr
      ]
    }
    $output
  } | flatten

  if ($outputs | is-not-empty) {
    print "" ...$outputs
  }

  # Print summary
  let ran = ($passed | length) + ($failed | length)
  let total = $results | length
  print $"($passed | length)/($ran) tests passed \(($skipped | length) skipped\)"
}

def ansi-fmt [code: string]: nothing -> string {
  if ("NO_COLOR" in $env) and ($env.NO_COLOR | is-not-empty) {
    ""
  } else {
    ansi $code
  }
}
