import 'package:hive/hive.dart';
import '../models/manga_model.dart';

/// Stores "Saved for later" Discover picks - series the user wants but can't yet
/// read because no installed source carries them. Reuses [LibraryManga] (its
/// adapter is already registered in main) in a box kept separate from the
/// library, keyed by [LibraryManga.uniqueKey].
///
/// A metadata-only entry (nothing to read yet) uses a synthetic key: sourceId =
/// the recommendation's origin ('anilist' / 'myanimelist'), url = the origin's
/// media id. Once matched to a real source it graduates to the library and is
/// removed from here.
class WishlistService {
  static const _boxName = 'wishlist';
  Box<LibraryManga>? _box;

  bool get _ready => _box?.isOpen ?? false;

  Future<void> init() async {
    _box = await Hive.openBox<LibraryManga>(_boxName);
  }

  List<LibraryManga> getAll() {
    final list = _box?.values.toList() ?? <LibraryManga>[];
    // Newest first.
    list.sort((a, b) => b.addedAt.compareTo(a.addedAt));
    return list;
  }

  bool contains(String key) => _ready && _box!.containsKey(key);

  /// Title-based membership - the same series has a different id per origin, so
  /// key equality alone would miss a duplicate saved from another source.
  bool containsTitle(String title) {
    if (!_ready) return false;
    final t = title.trim().toLowerCase();
    return _box!.values.any((m) => m.title.trim().toLowerCase() == t);
  }

  Future<void> add(LibraryManga entry) async {
    // Detach if the instance is bound elsewhere - Hive forbids one object in two
    // boxes (same guard the library uses).
    await _box?.put(entry.uniqueKey, entry.isInBox ? entry.clone() : entry);
  }

  Future<void> remove(String key) async => _box?.delete(key);

  Future<void> clear() async => _box?.clear();
}
