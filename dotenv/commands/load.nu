use ./collect.nu
use ./parse.nu

# Load a dotenv file into your environment.
@category env
@search-terms dotenv .env environment
export def --env main [
  file: path = ".env" # The path to the dotenv file.
]: nothing -> nothing {
  parse $file | collect | load-env
}

# Recursively load a dotenv file and all dotenv files in its parent directories.
@category env
@search-terms dotenv .env environment
export def --env tree [
  file: path = ".env" # The path to the dotenv file in each directory.
  --exists (-e) # Load only if the dotenv file exists. Parent directories are always loaded with this flag.
  --until: path # Load until (and excluding when) this path is reached.
]: nothing -> nothing {
  parse tree $file --exists=$exists --until=$until | collect | load-env
}
