export def main [
  position: record<line: int, col: int>
  help: string
]: nothing -> error {
  error make {
    msg: "Error parsing dotenv"
    help: $"At ($position.line):($position.col): ($help)"
  }
}

# Fails with an error message indicating an expected value.
export def expected [
  position: record<line: int, col: int> # The position of the failure.
  expected: string # What was expected (for example 'a valid name').
]: nothing -> error {
  main $position $"expected ($expected)"
}
