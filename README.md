# Actions

Shared composite actions for my package repos.

## Badge Example

Add this to your `README.md` (replace `ORG/REPO` and `npm-package`):

```markdown
[![Docs][docs-src]][docs-href]
[![Release][release-src]][release-href]
[![npm version][npm-version-src]][npm-version-href]
[![License][license-src]][license-href]
	// for nuxt project
 	[![Nuxt][nuxt-src]][nuxt-href]
```
Footer:
```markdown
<!-- Badges -->
[docs-src]: https://github.com/ORG/REPO/actions/workflows/docs.yml/badge.svg
[docs-href]: https://github.com/ORG/REPO/actions/workflows/docs.yml
[release-src]: https://github.com/ORG/REPO/actions/workflows/release.yml/badge.svg
[release-href]: https://github.com/ORG/REPO/actions/workflows/release.yml
[npm-version-src]: https://img.shields.io/npm/v/npm-package/latest
[npm-version-href]: https://www.npmjs.com/package/npm-package/v/latest
[license-src]: https://img.shields.io/badge/license-MIT-blue.svg
[license-href]: https://opensource.org/licenses/MIT
// for nuxt projects
[nuxt-src]: https://img.shields.io/badge/nuxt-3-32a852?style=flat&logo=nuxt.js
[nuxt-href]: https://nuxt.com/
```

## setup

Sets up Node.js, pnpm, and installs dependencies. Caches the pnpm store when `USE_LOCKFILE` is `"true"`.

**Inputs:**

| Input              | Required | Default   | Description                                                    |
|--------------------|----------|-----------|----------------------------------------------------------------|
| `USE_LOCKFILE`     | Yes      | —         | `"true"` for `--frozen-lockfile`, otherwise `--no-lockfile`    |
| `INSTALL_PLAYWRIGHT` | No     | `"false"` | `"true"` to install Playwright browsers with caching           |

## build

Runs `pnpm build`, `pnpm lint`, `pnpm test` with optional coverage reporting on PRs.

**Inputs:**

| Input              | Required | Default           | Description                                  |
|--------------------|----------|--------------------|----------------------------------------------|
| `build_script`     | No       | `"pnpm build"`     | Command to run for building                  |
| `lint_script`      | No       | `"pnpm lint"`      | Command to run for linting                   |
| `test_script`      | No       | `"pnpm test"`      | Command to run for testing                   |
| `report_coverage`  | No       | `"true"`           | `"false"` to skip coverage report on PRs     |

## docs

Runs `pnpm doc` and deploys to `gh-pages` via GitHub Pages.

**Inputs:**

| Input              | Required | Default   | Description                                            |
|--------------------|----------|-----------|--------------------------------------------------------|
| `build_playground` | No       | `"false"` | `"true"` to copy the Nuxt playground output as a demo  |
| `build_demo`       | No       | `"false"` | `"true"` to install deps and copy a `demo/` directory  |

## release

Publishes to npm via `pnpm semantic-release` with OIDC, or runs a dry run.

**Inputs:**

| Input              | Required | Default | Description                                      |
|--------------------|----------|---------|--------------------------------------------------|
| `ENABLE_RELEASE`   | No       | `"true"`  | `"false"` to run dry run instead                   |

# Repo Variables

Set these in **Settings > Variables and secrets > Actions > Variables**:

| Variable         | Description                                        |
|------------------|----------------------------------------------------|
| `USE_LOCKFILE`   | `"true"` to use `--frozen-lockfile`, else omit     |
| `ENABLE_DOCS`    | `"true"` to enable docs deployment                 |
| `ENABLE_RELEASE` | `"true"` to enable npm publishing                  |

# Example Workflows

### Docs (`.github/workflows/docs.yml`)

```yaml
name: Docs

on:
  push:
    branches: [ master ]
  repository_dispatch:
    types: [ docs ]

jobs:
  docs:
    if: "vars.ENABLE_DOCS == 'true'"
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: ["lts/*"]
    steps:
      - uses: actions/checkout@v6

      - name: Setup
        uses: alanscodelog/actions/.github/actions/setup@main
        with:
          USE_LOCKFILE: ${{ vars.USE_LOCKFILE }}
          # INSTALL_PLAYWRIGHT: true

      - name: Build
        uses: alanscodelog/actions/.github/actions/build@main

      - name: Docs
        uses: alanscodelog/actions/.github/actions/docs@main
        with:
          build_playground: "false"
          build_demo: "false"
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Release (`.github/workflows/release.yml`)

```yaml
name: Release

on:
  push:
    branches: [ master, alpha, beta, build ]
  repository_dispatch:
    types: [ release ]

permissions:
  id-token: write

jobs:
  release:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: ["lts/*"]
    permissions:
      contents: write # to be able to publish a GitHub release
      issues: write # to be able to comment on released issues
      pull-requests: write # to be able to comment on released pull requests
      id-token: write # to enable use of OIDC for trusted publishing and npm provenance
    steps:
      - uses: actions/checkout@v6

      - name: Setup
        uses: alanscodelog/actions/.github/actions/setup@main
        with:
          USE_LOCKFILE: ${{ vars.USE_LOCKFILE }}
          # INSTALL_PLAYWRIGHT: true

      - name: Build
        uses: alanscodelog/actions/.github/actions/build@main

      - name: Release
        uses: alanscodelog/actions/.github/actions/release@main
        with:
          ENABLE_RELEASE: ${{ vars.ENABLE_RELEASE == 'true' && github.ref != 'refs/heads/build' }}
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
