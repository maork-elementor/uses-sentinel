# Uses Sentinel

Uses Sentinel is a GitHub action that scans all `.yml` files in the `.github/workflows` directory of a GitHub repository and performs two checks on the `uses` fields in the YAML files:

1. Checks if any `uses` field contains the version `main`, `master`, or `latest`, which are considered unsafe versions to use. If a `uses` field contains any of these versions, a warning message is printed to the console.

2. Checks if the `uses` field references the latest version of the action by checking the GitHub repository's tags. If the `uses` field does not reference the latest version, a warning message is printed to the console.

Uses Sentinel is written in Bash only and has no dependencies.

## Usage

To use Uses Sentinel in your GitHub repository, create a new workflow file (e.g., `.github/workflows/uses-sentinel.yml`) with the following content:

```yaml
name: Uses Sentinel
on: [pull_request]

jobs:
  uses-sentinel:
    runs-on: ubuntu-latest
    steps:
      - name: Uses Sentinel
        uses: maork-elementor/uses-sentinel@v1
```

* This will run Uses Sentinel on every pull request in your repository.

## Inputs
Uses Sentinel does not have any inputs.

## Output Example
Here's an example output from Uses Sentinel:

```
Some actions are not safe to use or not updated

Bad versions:
yml: ./.github/workflows/ci.yml, use: actions/checkout@main version: main, It not safe to use main, master or latest

Not updated actions:
yml: ./.github/workflows/ci.yml, use: actions/setup-node@v1 current version: v1.0.0, latest version: v2.1.4
```

This output indicates that the .github/workflows/ci.yml file contains an unsafe version (main) of the actions/checkout action and an outdated version (v1.0.0) of the actions/setup-node action.

License
Uses Sentinel is released under the MIT License.
