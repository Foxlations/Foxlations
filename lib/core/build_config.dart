/// Compile-time build-flavor flags.
///
/// [kDevBuild] is true only when the app is built with
/// `--dart-define=FOX_DEV=true` (the Foxlations-Dev CI workflows). Public
/// release builds leave it false, so dev-only surfaces (e.g. Gaze Lab) never
/// ship to end users.
const bool kDevBuild = bool.fromEnvironment('FOX_DEV');
