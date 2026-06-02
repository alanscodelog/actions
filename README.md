# @alanscodelog/actions

Reusable GitHub Actions composite actions for the Alan's Code Log monorepo packages.

## Actions

### setup-node-pnpm

Installs Node.js, pnpm, and project dependencies.

**Inputs:**

| Input              | Required | Default   | Description                                                    |
|--------------------|----------|-----------|----------------------------------------------------------------|
| `USE_LOCKFILE`     | Yes      | —         | `"true"` for `--frozen-lockfile`, otherwise `--no-lockfile`    |
| `INSTALL_PLAYWRIGHT` | No     | `"false"` | `"true"` to install Playwright browsers with caching           |

### build-lint-test

Runs build, lint, and test steps with optional coverage reporting.

**Inputs:**

| Input              | Required | Default           | Description                                  |
|--------------------|----------|--------------------|----------------------------------------------|
| `build_script`     | No       | `"pnpm build"`     | Command to run for building                  |
| `lint_script`      | No       | `"pnpm lint"`      | Command to run for linting                   |
| `test_script`      | No       | `"pnpm test"`      | Command to run for testing                   |
| `report_coverage`  | No       | `"true"`           | `"false"` to skip coverage report on PRs     |

### deploy-docs

Generates documentation and deploys to GitHub Pages.

**Inputs:**

| Input              | Required | Default           | Description                                  |
|--------------------|----------|--------------------|----------------------------------------------|
| `doc_script`       | No       | `"pnpm doc"`       | Command to generate docs                     |
| `build_dir`        | No       | `"docs"`           | Directory containing built docs              |
| `target_branch`    | No       | `"gh-pages"`       | Branch to deploy to                          |
| `build_playground` | No       | `"false"`          | `"true"` to copy playground output as demo   |
| `build_demo`       | No       | `"false"`          | `"true"` to install and copy demo directory  |

### npm-release

Publishes to npm via semantic-release with OIDC authentication, or runs a dry run.

**Inputs:**

| Input              | Required | Default                              | Description                                  |
|--------------------|----------|---------------------------------------|----------------------------------------------|
| `ENABLE_RELEASE`   | Yes      | —                                     | `"true"` to publish; otherwise dry run       |
| `release_script`   | No       | `"pnpm semantic-release"`            | Command for real release                     |
| `dry_run_script`   | No       | `"pnpm semantic-release --dry-run"`  | Command for dry run                          |

## Repository Variables and Secrets

Set these in your repo's **Settings > Variables and secrets > Actions**:

### Variables (non-sensitive config)

| Variable         | Description                                        |
|------------------|----------------------------------------------------|
| `USE_LOCKFILE`   | `"true"` to use `--frozen-lockfile`, else omit     |
| `ENABLE_DOCS`    | `"true"` to enable docs deployment                 |
| `ENABLE_RELEASE` | `"true"` to enable npm publishing                  |

### Secrets (sensitive)

| Secret           | Description                        |
|------------------|------------------------------------|
| `GITHUB_TOKEN`   | Auto-provided by GitHub Actions    |

## Usage

Reference from a workflow in the same monorepo:

```yaml
- name: Setup
  uses: ../../@alanscodelog/actions/.github/actions/setup-node-pnpm
  with:
    USE_LOCKFILE: ${{ vars.USE_LOCKFILE }}
    INSTALL_PLAYWRIGHT: true
```

Or from a separate repo (once published):

```yaml
- name: Setup
  uses: alanscodelog/actions/.github/actions/setup-node-pnpm@main
  with:
    USE_LOCKFILE: ${{ vars.USE_LOCKFILE }}
```
