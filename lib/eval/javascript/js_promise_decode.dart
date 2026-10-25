import 'dart:convert';

/// Decodes a JSON payload coming back from the flutter_js runtime, undoing the
/// iOS double-encode.
///
/// flutter_js uses a different engine per platform - QuickJS on Android,
/// JavaScriptCore on iOS - and they resolve promises differently. QuickJS hands
/// the resolved value back and stringifies it once, but JSC reports
/// `[object Promise]` and takes the branch in flutter_js `handle_promises.dart`
/// that runs `JSON.stringify()` over the value a SECOND time. Since the source
/// wrappers (`jsonStringify(...)` for the manga lane, the LNReader `{ok,data}`
/// envelope for novels) already return a string, iOS payloads arrive
/// double-encoded and a single decode yields a String instead of the Map/List
/// the caller expects.
///
/// Detect that structurally: re-decode when the caller wants something other
/// than a String (the string is clearly a wrapper), or - when [T] is dynamic,
/// as it is for getHtmlContent - when the payload still looks like encoded JSON.
/// Real string results (page HTML) start with `<` or plain text, so they're
/// left alone on both platforms.
///
/// This is the single home for the heuristic the manga lane
/// (`JsExtensionService`) and the LNReader envelope decoder
/// (`LnrExtensionService`) both rely on - keep it here rather than re-deriving
/// the rule in two places where they can drift apart.
T decodeJsPromiseResult<T>(String raw) {
  dynamic value = jsonDecode(raw);
  if (value is String) {
    // Re-decode when the caller wants something other than a String (the string
    // is clearly a wrapper), or - when T is dynamic, as it is for
    // getHtmlContent - when the payload still looks like encoded JSON.
    final trimmed = value.trimLeft();
    final looksEncoded = trimmed.startsWith('{') ||
        trimmed.startsWith('[') ||
        trimmed.startsWith('"');
    if (value is! T || looksEncoded) {
      try {
        value = jsonDecode(value);
      } catch (_) {
        // Not double-encoded after all - keep the string as-is.
      }
    }
  }
  return value as T;
}
