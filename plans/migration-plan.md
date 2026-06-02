# Migration Plan

Replace local `composite-setup` and `composite-build` actions + inline release/docs steps with the shared `alanscodelog/actions` repo.

## What changes for every package

- Delete `.github/actions/composite-setup/` and `.github/actions/composite-build/`
- Replace `docs.yml` and `release.yml` with the standardized workflows
- Migrate `secrets.USE_LOCKFILE` / `secrets.ENABLE_DOCS` / `secrets.ENABLE_RELEASE` to repo **variables** (not secrets)
- Remove `NPM_TOKEN` secret usage (OIDC handles publishing)

## Packages

### Standard (no customizations)

- **@alanscodelog/commitlint-config** — `/home/alan/code/nuxtapps/packages/@alanscodelog/commitlint-config`
- **@alanscodelog/eslint-config** — `/home/alan/code/nuxtapps/packages/@alanscodelog/eslint-config`
- **@alanscodelog/semantic-release-config** — `/home/alan/code/nuxtapps/packages/@alanscodelog/semantic-release-config`
- **@alanscodelog/tsconfigs** — `/home/alan/code/nuxtapps/packages/@alanscodelog/tsconfigs`
- **@alanscodelog/vite-config** — `/home/alan/code/nuxtapps/packages/@alanscodelog/vite-config`
- **@alanscodelog/utils** — `/home/alan/code/nuxtapps/packages/@alanscodelog/utils`
- **metamorphosis** — `/home/alan/code/nuxtapps/packages/metamorphosis`
- **@witchcraft/nuxt-android** — `/home/alan/code/nuxtapps/packages/@witchcraft/nuxt-android`
- **@witchcraft/nuxt-auth** — `/home/alan/code/nuxtapps/packages/@witchcraft/nuxt-auth`
- **@witchcraft/nuxt-electron** — `/home/alan/code/nuxtapps/packages/@witchcraft/nuxt-electron`
- [x] **@witchcraft/nuxt-logger** — `/home/alan/code/nuxtapps/packages/@witchcraft/nuxt-logger` ✅ `805f131`
- **@witchcraft/nuxt-utils** — `/home/alan/code/nuxtapps/packages/@witchcraft/nuxt-utils`

### Custom docs

- **@witchcraft/editor** — `/home/alan/code/nuxtapps/packages/@witchcraft/editor`
  - [x] Hardcoded `node-version: ['24.15.0']`
  - [x] `INSTALL_PLAYWRIGHT: true`
  - [x] `build_playground: true`
  - [x] `build_demo: true`

- **@witchcraft/layout** — `/home/alan/code/nuxtapps/packages/@witchcraft/layout`
  - [x] `build_playground: true`

- **@witchcraft/expressit** — `/home/alan/code/nuxtapps/packages/@witchcraft/expressit`
  - [x] `build_playground: true`
  - [x] `build_demo: true`

- **@witchcraft/spellcraft** — `/home/alan/code/nuxtapps/packages/@witchcraft/spellcraft`
  - [x] `build_playground: true`
  - [x] `build_demo: true`

- **template-lib/template** — `/home/alan/code/nuxtapps/template-lib/template`
- This should just get replaced with copies of standard workflows, its the main template repo

- **@witchcraft/ui** — `/home/alan/code/nuxtapps/packages/@witchcraft/ui`
  - [x] Hardcoded `node-version: ['24.15.0']`
  - [x] `INSTALL_PLAYWRIGHT: true`
  - [x] `test_script: "echo 'skipping tests'"` (skip tests in docs)
  - [ ] `timeout-minutes: 20` on job
  - [ ] Hold runner on failure step (Blacksmith SSH debugging)

### Custom release

- **@witchcraft/editor** — `/home/alan/code/nuxtapps/packages/@witchcraft/editor`
  - [ ] Hardcoded `node-version: ['24.15.0']`
  - [ ] `INSTALL_PLAYWRIGHT: true`

- **@witchcraft/nuxt-postgres** — `/home/alan/code/nuxtapps/packages/@witchcraft/nuxt-postgres`
  - [ ] `pnpm i --frozen-lockfile` in playground before build — **not needed**, playground uses `workspace:*` and root `pnpm install` handles it

- **@witchcraft/ui** — `/home/alan/code/nuxtapps/packages/@witchcraft/ui`
  - [x] Hardcoded `node-version: ['24.15.0']`
  - [x] `INSTALL_PLAYWRIGHT: true`
  - [x] `pnpm i --frozen-lockfile` in playground before build
  - [ ] `timeout-minutes: 30` on job
  - [ ] Hold runner on failure step (Blacksmith SSH debugging)
