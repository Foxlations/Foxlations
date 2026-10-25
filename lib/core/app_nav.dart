import 'package:flutter/foundation.dart';

/// A lightweight channel for asking the bottom-nav shell ([AppShell]) to switch
/// to one of its tabs from anywhere in the tree - e.g. the Library "Add" FAB
/// wanting to show Browse.
///
/// Before this, such buttons did `Navigator.pushNamed(..., browse)`, which
/// stacks the screen ON TOP of the shell - so the bottom nav bar vanished and
/// there was no way back. Setting [value] to a screen id (one of AppShell's
/// screen ids, e.g. 'browse') makes the shell switch tabs instead, keeping the
/// nav bar. The shell resets it to null once handled.
final ValueNotifier<String?> navTabRequest = ValueNotifier<String?>(null);
