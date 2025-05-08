# Parse a dotenv file.
#
# The resulting table contains all the key-value pairs in the dotenv file in the
# order they are declared. If a variable is defined multiple times in the file,
# then it will appear multiple times in the resulting table.
#
# In general, later rows should override earlier rows.
@category env
@search-terms dotenv .env environment
@example "parse .env file" { dotenv parse } --result [{ name: "A", value: "3" }, { name: "B", value: "true" }]
export def main [
  file: path = ".env" # The path to the file.
]: nothing -> table<name: string, value: string> {
  open -r $file
  | lines
  | filter {|line| not ($line | str trim --left | str starts-with '#')}
  | parse -r '(?P<name>.+?)=(?P<value>.+)'
}

# Parse a dotenv file and all similarly named dotenv files in its parent directories.
#
# The resulting table contains all the key-value pairs in each dotenv file in
# the order they are declared. Additionally, each parent directory's dotenv file
# will contain its entries earlier in the table, with the most distant
# ancestor's entries appearing first. The provided file's entries will appear
# last in the table.
#
# In general, later rows should override earlier rows.
@category env
@search-terms dotenv .env environment
@example "parse .env files" { dotenv parse tree } --result [{ name: "A", value: "3", source: "/a/.env" }, { name: "B", value: "true", source: "/a/b/c/.env" }]
@example "parse .env files until a directory is reached" { dotenv parse tree --until /a/b } --result [{ name: "B", value: "true", source: "/a/b/c/.env" }]
export def tree [
  file: path = ".env" # The path to the file.
  --exists (-e) # Load only if the dotenv file exists. Parent directories are always loaded with this flag.
  --until: path # Load until this directory is reached.
]: nothing -> table<name: string, value: string, source: path> {
  let expanded = $file | path expand

  # Check if the final directory has been reached
  if ($until | is-empty) and ($expanded | path dirname) == ($until | path expand) {
    return []
  }

  # Parse dotenv file
  let contents = if ($expanded | path exists) and ($expanded | path type) == "file" {
    main $expanded
    | insert source $expanded
  } else if $exists {
    []
  } else {
    error make {
      msg: "File not found"
      label: {
        text: "File not found"
        span: (metadata $file).span
      }
      help: $"'($expanded)' does not exist"
    }
  }

  # Parse parent directory's dotenv (if possible)
  let filename = $expanded | path basename
  let parent = $expanded | path dirname -n 2
  let parentfile = $parent | path join $filename
  if $parentfile != $expanded {
    tree --exists --until=$until $parentfile
    | append $contents
  } else {
    $contents
  }
}
