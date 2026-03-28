# Pride Sys Test (Flutter)

A Flutter client for the [Rick and Morty API](https://rickandmortyapi.com): browse characters with pagination, favourites, detail screens, local edits, and offline-friendly caching.

## Setup

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) SDK **3.11.1** or compatible (see `environment.sdk` in `pubspec.yaml`).
- A device or emulator (Android, iOS, or desktop/web if your toolchain supports it).

### Steps

1. Clone the repository and open the project root (where `pubspec.yaml` lives).

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:

   ```bash
   flutter run
   ```

4. (Optional) Static analysis:

   ```bash
   flutter analyze
   ```

The app initializes **SQLite** on startup (`AppDatabase().initDB()` in `lib/main.dart`) before dependency injection and `runApp`, so no extra database setup is required.

## State management

This project uses **GetX** (`get` package) for:

- **Reactive UI** — `Obx` / `.obs` so lists and flags rebuild when data changes (e.g. home grid, loading states).
- **Dependency injection** — `Get.lazyPut` in `lib/common/utils/di/dependency_injection.dart` wires repositories and view models; `fenix: true` recreates dependencies when needed after disposal.
- **Navigation** — `GetMaterialApp` with named routes (`lib/common/utils/routing/`).

**Why GetX here:** It keeps routing, DI, and lightweight reactivity in one place without extra boilerplate, which fits a medium-sized app with a few screens and shared repositories. Domain/data layers stay separate; GetX is mostly at the presentation and composition root.

## Storage approach

Persistence uses **sqflite** on device (`app_db.db` under the platform database path).

| Concern | Role |
|--------|------|
| **`characters`** | Cache of API character rows (by page). Populated when fetches succeed; used when offline or the network fails. |
| **`character_page_meta`** | Per-page `has_more` from the API so pagination can continue offline when cache exists. |
| **`favorites`** | Favourite character IDs. |
| **`edited_characters`** | User overrides (name, status, species, etc.). Merged on read in `CharacterUseCase` so the UI sees edited values without replacing the base cache row. |

The **repository/use case** layer (`CharacterUseCase`) coordinates HTTP (Dio) with the database: write-through cache on success, merge edits when loading by ID or page, and cache-backed fallbacks when the API is unavailable.

## Known limitations

- **Home search** filters only **characters already loaded in memory** (pages fetched so far). It does not query the full Rick and Morty catalogue unless those characters are in the current list.
- **Offline behaviour** depends on what was previously cached; empty cache with no network means list load can fail or show no rows until online.
- **Single API** — data source is Rick and Morty only; no auth or multi-tenant backend in this repo.
- **Platform paths** — database and network behaviour follow the host OS; web support, if enabled, may need extra sqflite/web configuration beyond the default mobile/desktop setup.

## Project layout (high level)

- `lib/domain/` — entities, repository contracts, use cases.
- `lib/data/` — API (Dio), models, SQLite (`AppDatabase`, queries).
- `lib/presentation/` — screens, widgets, GetX view models.
- `lib/common/` — theme, routing, DI, shared utilities.
