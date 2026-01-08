# State Management Providers

This directory contains Riverpod state management providers with local persistence.

## Providers

### 1. SavedStylesProvider
Manages bookmarked/saved styles with persistent storage.

**Features:**
- Automatically loads saved styles on app start
- Persists changes to local storage using SharedPreferences
- Survives app restarts

**Storage Key:** `saved_styles`

**Usage:**
```dart
// Toggle save state
ref.read(savedStylesProvider.notifier).toggleSave(imageId);

// Check if saved
final savedStyles = ref.watch(savedStylesProvider);
final isSaved = savedStyles.contains(imageId);
```

### 2. BlockedUsersProvider
Manages blocked users with persistent storage.

**Features:**
- Automatically loads blocked users on app start
- Persists changes to local storage using SharedPreferences
- Survives app restarts
- Blocked content is filtered from the feed

**Storage Key:** `blocked_users`

**Usage:**
```dart
// Block a user
await ref.read(blockedUsersProvider.notifier).blockUser(imageId);

// Unblock a user (if needed)
await ref.read(blockedUsersProvider.notifier).unblockUser(imageId);

// Check if blocked
final blockedUsers = ref.watch(blockedUsersProvider);
final isBlocked = blockedUsers.contains(imageId);
```

## Implementation Details

Both providers use:
- **StateNotifier** for state management
- **SharedPreferences** for local persistence
- **Set<String>** for efficient lookups
- Automatic loading on initialization
- Automatic saving on state changes

## Data Persistence

Data is stored locally on the device using SharedPreferences:
- iOS: NSUserDefaults
- Android: SharedPreferences
- Web: LocalStorage
- Desktop: Platform-specific storage

The data persists across:
- App restarts
- Device reboots
- App updates (unless app data is cleared)

## Error Handling

Both providers handle errors gracefully:
- If loading fails, starts with empty state
- If saving fails, continues silently (state is still updated in memory)
- No user-facing errors for storage operations
