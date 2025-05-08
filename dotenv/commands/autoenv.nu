use ./load.nu

# Enables automatic loading of dotenv files when changing directories.
@category env
@search-terms dotenv .env environment
export def --env enable [
  file: path = ".env" # The path to the dotenv file.
  --tree (-r) # Recursively load dotenv files from parent directories too.
]: nothing -> nothing {
  # If already enabled, disable first
  disable

  # Create the hook
  let hook = if $tree {
    { try { load tree --exists } }
  } else {
    { try { load } }
  }

  # Update the config
  $env.config.hooks = $env.config.hooks
  | merge deep --strategy append {
    env_change: {
      PWD: [
        {
          __dotenv: true
          code: $hook
        }
      ]
    }
  }

  # Run the hook to immediately update the environment
  do $hook
}

# Disables automatic loading of dotenv files when changing directories.
#
# This is a no-op if autoenv isn't enabled.
@category env
@search-terms dotenv .env environment
export def --env disable []: nothing -> nothing {
  # Check if enabled first
  if "PWD" not-in $env.config.hooks.env_change {
    return
  }

  # Remove all dotenv hooks
  $env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD
  | filter {|hook| "__dotenv" not-in $hook }
}
