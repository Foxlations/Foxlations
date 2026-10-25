import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'app_logger.dart';

/// A folder the user picked outside the app sandbox, with the security-scoped
/// bookmark that lets us re-open it on a later launch.
class PickedFolder {
  final String path;
  final String bookmark;
  const PickedFolder(this.path, this.bookmark);
}

/// iOS-only bridge to the native document-folder picker + security-scoped
/// bookmarks (foxlations/folder). On every other platform the plain directory
/// picker is enough, so these calls simply report "unsupported" (null) and the
/// caller falls back to FilePicker.getDirectoryPath.
class IosFolderAccess {
  IosFolderAccess._();
  static final IosFolderAccess instance = IosFolderAccess._();

  static const _channel = MethodChannel('foxlations/folder');

  bool get isSupported => Platform.isIOS;

  /// Present the folder picker. Returns the picked folder + its bookmark, or
  /// null if the user cancelled / it failed.
  Future<PickedFolder?> pickFolder() async {
    if (!isSupported) return null;
    try {
      final res = await _channel.invokeMapMethod<String, dynamic>('pickFolder');
      return _toPicked(res);
    } catch (e) {
      await logger.warning('iOS folder pick failed',
          category: LogCategory.general, detail: e.toString());
      return null;
    }
  }

  /// Re-acquire access to a previously bookmarked folder. Returns the live path
  /// (and a possibly-refreshed bookmark) or null if access was revoked. Safe to
  /// call repeatedly - the native side keeps the scope alive for the session.
  Future<PickedFolder?> resolve(String bookmark) async {
    if (!isSupported || bookmark.isEmpty) return null;
    try {
      final res = await _channel.invokeMapMethod<String, dynamic>(
          'resolveBookmark', bookmark);
      return _toPicked(res);
    } catch (e) {
      await logger.warning('iOS folder bookmark resolve failed',
          category: LogCategory.general, detail: e.toString());
      return null;
    }
  }

  /// Give up access to a bookmarked folder (e.g. when the user removes it).
  Future<void> release(String bookmark) async {
    if (!isSupported || bookmark.isEmpty) return;
    try {
      await _channel.invokeMethod('release', bookmark);
    } catch (_) {}
  }

  PickedFolder? _toPicked(Map<String, dynamic>? res) {
    if (res == null) return null;
    final path = res['path'] as String?;
    final bookmark = res['bookmark'] as String?;
    if (path == null || path.isEmpty || bookmark == null || bookmark.isEmpty) {
      return null;
    }
    return PickedFolder(path, bookmark);
  }
}
