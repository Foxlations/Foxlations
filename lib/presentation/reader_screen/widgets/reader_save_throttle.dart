import 'dart:async';

/// Coalesces frequent reader progress-save requests into infrequent writes.
///
/// Both readers save the reading position as the page turns or the view
/// scrolls. Writing to the store on every one of those made continuous
/// scrolling janky and could pile up unbounded async writes over a long
/// session (the lag and crash fixed in builds 240 and 241). This owns the one
/// coalescing timer so that rule lives in a single place and can't drift
/// between the manga and the novel reader.
///
/// The caller keeps its own pending state and flushes the exact final position
/// itself on exit or background; this only decides WHEN a coalesced save fires,
/// in one of two modes:
///
///  * [leading] guarantees one [onFire] within [window] starting at the first
///    request. Later requests inside the window are coalesced (the timer is not
///    restarted), so the first change is saved promptly and the rest ride the
///    same window. The manga reader uses this.
///  * [trailing] fires [onFire] once [window] has passed since the most recent
///    request (the timer restarts on every call), so a burst of scroll events
///    settles into one write. The novel reader uses this.
class ReaderSaveThrottle {
  Timer? _timer;

  bool get isPending => _timer != null;

  void leading(Duration window, void Function() onFire) {
    _timer ??= Timer(window, onFire);
  }

  void trailing(Duration window, void Function() onFire) {
    _timer?.cancel();
    _timer = Timer(window, onFire);
  }

  /// Stops any pending fire. Call this from an explicit flush and from dispose.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}
