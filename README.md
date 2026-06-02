# actions

Shared composite actions for my repos.

## Actions

### setup

Sets up Node.js, pnpm, and installs dependencies. Caches the pnpm store when `USE_LOCKFILE` is `"true"`.

**Inputs:**

| Input              | Required | Default   | Description                                                    |
|--------------------|----------|-----------|----------------------------------------------------------------|
| `USE_LOCKFILE`     | Yes      | —         | `"true"` for `--frozen-lockfile`, otherwise `--no-lockfile`    |
| `INSTALL_PLAYWRIGHT` | No     | `"false"` | `"true"` to install Playwright browsers with caching           |

### build

Runs `pnpm build`, `pnpm lint`, `pnpm test` with optional coverage reporting on PRs.

**Inputs:**

| Input              | Required | Default           | Description                                  |
|--------------------|----------|--------------------|----------------------------------------------|
| `build_script`     | No       | `"pnpm build"`     | Command to run for building                  |
| `lint_script`      | No       | `"pnpm lint"`      | Command to run for linting                   |
| `test_script`      | No       | `"pnpm test"`      | Command to run for testing                   |
| `report_coverage`  | No       | `"true"`           | `"false"` to skip coverage report on PRs     |

### docs

Runs `pnpm doc` and deploys to `gh-pages` via GitHub Pages.

**Inputs:**

| Input              | Required | Default   | Description                                            |
|--------------------|----------|-----------|--------------------------------------------------------|
| `build_playground` | No       | `"false"` | `"true"` to copy the Nuxt playground output as a demo  |
| `build_demo`       | No       | `"false"` | `"true"` to install deps and copy a `demo/` directory  |

### release

Publishes to npm via `pnpm semantic-release` with OIDC, or runs a dry run.

**Inputs:**

| Input              | Required | Default | Description                                      |
|--------------------|----------|---------|--------------------------------------------------|
| `ENABLE_RELEASE`   | Yes      | —       | `"true"` to publish; otherwise dry run           |

## Repo Variables

Set these in **Settings > Variables and secrets > Actions > Variables**:

| Variable         | Description                                        |
|------------------|----------------------------------------------------|
| `USE_LOCKFILE`   | `"true"` to use `--frozen-lockfile`, else omit     |
| `ENABLE_DOCS`    | `"true"` to enable docs deployment                 |
| `ENABLE_RELEASE` | `"true"` to enable npm publishing                  |

## Usage

From a separate repo:

```yaml
- name: Setup
  uses: alanscodelog/actions/.github/actions/setup@main
  with:
    USE_LOCKFILE: ${{ vars.USE_LOCKFILE }}
```

From the same monorepo (testing locally):

```yaml
- name: Setup
  uses: ../../@alanscodelog/actions/.github/actions/setup
  with:
    USE_LOCKFILE: ${{ vars.USE_LOCKFILE }}
```
