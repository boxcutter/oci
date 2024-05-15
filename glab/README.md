# glab

GLab is an open source GitLab CLI tool bringing GitLab to your terminal next to
where you are already working with `git` and your code without switching
between windows and browser tabs. Work with issues, merge requests, watch
running pipelines directly from your CLI among other features.
Inspired by [gh], the official GitHub CLI tool.

This image packages releases from https://gitlab.com/gitlab-org/cli/-/releases

Image source: https://github.com/boxcutter/oci/tree/main/glab

## Using glab

You'll need to pass in a `GITLAB_TOKEN` for glab to use and mount your source
into the container:

```bash
docker run -it --rm \
  --env GITLAB_TOKEN \
  --mount type=bind,source="$(pwd)",target=/code \
  docker.io/boxcutter/glab <command>
```

You may also want to create an alias to the `glab` command in your
environment:

```
alias glab="docker run -it --rm --env GITLAB_TOKEN --mount type=bind,source="$(pwd)",target=/code docker.io/boxcutter/glab"
```

This will allow you to run glab comands using this image as if it were a local
install:
```
glab repo clone boxcutter/oci
```

## Authentication

You'll need to have a personal access token with at least the `api` and
`write_repository` scopes. You can run `glab auth login` to walk you through
the steps. glab will read the token via the `GITLAB_TOKEN` environment
variable. If you would prefer topass the token in via a file, you can use
`glab auth login --stdin < token.txt`.

## Command examples

### Listing all projects in a group, including all sub-projects

```
$ glab api "https://gitlab.com/api/v4/groups/boxcutter/projects?include_subgroups=true" \
    --paginate | jq -r '.[] | .path_with_namespace'
```

### Listing all projects in a group for mirroring, including all sub-projects

```
$ glab api "https://gitlab.com/api/v4/groups/boxcutter/projects?include_subgroups=true" \
--paginate | jq -r '.[] | .ssh_url_to_repo'
```

### Cloning a repo

```
$ glab repo clone profclems/glab

$ glab repo clone https://gitlab.com/profclems/glab

$ glab repo clone profclems/glab mydirectory  # Clones repo into mydirectory

$ glab repo clone glab   # clones repo glab for current user

$ glab repo clone 4356677   # finds the project by the ID provided and clones it

# Clone all repos in a group
$ glab repo clone -g everyonecancontribute
```

# CLI

```
% docker run -it --rm \
    --env GITLAB_TOKEN \
    --mount type=bind,source="$(pwd)",target=/code \
    docker.io/boxcutter/glab
GLab is an open source GitLab CLI tool that brings GitLab to your command line.

USAGE
  glab <command> <subcommand> [flags]

CORE COMMANDS
  alias:       Create, list and delete aliases
  api:         Make an authenticated request to GitLab API
  ask:         Generate terminal commands from natural language. (Experimental.)
  auth:        Manage glab's authentication state
  changelog:   Interact with the changelog API
  check-update: Check for latest glab releases
  ci:          Work with GitLab CI/CD pipelines and jobs
  completion:  Generate shell completion scripts
  config:      Set and get glab settings
  help:        Help about any command
  incident:    Work with GitLab incidents
  issue:       Work with GitLab issues
  label:       Manage labels on remote
  mr:          Create, view and manage merge requests
  release:     Manage GitLab releases
  repo:        Work with GitLab repositories and projects
  schedule:    Work with GitLab CI schedules
  snippet:     Create, view and manage snippets
  ssh-key:     Manage SSH keys registered with your GitLab account.
  user:        Interact with user
  variable:    Manage GitLab Project and Group Variables
  version:     Show glab version information

FLAGS
      --help      Show help for command
  -v, --version   show glab version information

ENVIRONMENT VARIABLES
  GITLAB_TOKEN: An authentication token for API requests. Set this variable to
  avoid prompts to authenticate. Overrides any previously-stored credentials.
  Can be set in the config with 'glab config set token xxxxxx'.

  GITLAB_HOST or GL_HOST: Specify the URL of the GitLab server if self-managed.
  (Example: https://gitlab.example.com) Defaults to https://gitlab.com.

  REMOTE_ALIAS or GIT_REMOTE_URL_VAR: A 'git remote' variable or alias that contains
  the GitLab URL. Can be set in the config with 'glab config set remote_alias origin'.

  VISUAL, EDITOR (in order of precedence): The editor tool to use for authoring text.
  Can be set in the config with 'glab config set editor vim'.

  BROWSER: The web browser to use for opening links.
  Can be set in the config with 'glab config set browser mybrowser'.

  GLAMOUR_STYLE: The environment variable to set your desired Markdown renderer style.
  Available options: dark, light, notty. To set a custom style, read
  https://github.com/charmbracelet/glamour#styles

  NO_PROMPT: Set to 1 (true) or 0 (false) to disable or enable prompts.

  NO_COLOR: Set to any value to avoid printing ANSI escape sequences for color output.

  FORCE_HYPERLINKS: Set to 1 to force hyperlinks in output, even when not outputting to a TTY.

  GLAB_CONFIG_DIR: Set to a directory path to override the global configuration location.

LEARN MORE
  Use 'glab <command> <subcommand> --help' for more information about a command.

FEEDBACK
  Encountered a bug or want to suggest a feature?
  Open an issue using 'glab issue create -R gitlab-org/cli'
```
