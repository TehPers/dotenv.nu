# Merge parsed dotenv values into a single record.
#
# This record can be used with `load-env` directly to load the parsed values
# into `$env`.
@category env
@search-terms dotenv .env environment
@example "collect a .env" { dotenv parse | dotenv collect } --result { A: "3", B: "true" }
@example "load .env into $env" { dotenv parse | dotenv collect | load-env }
export def main []: table<name: string, value: string> -> record {
  reduce --fold {} {|it, acc| $acc | upsert $it.name $it.value}
}
