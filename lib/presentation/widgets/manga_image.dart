import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/material.dart';
import '../../core/services/image_loader.dart';
import '../../core/services/image_crop.dart';
import '../../l10n/app_localizations.dart';

/// Image widget that loads images through our Cloudflare-aware HTTP pipeline.
class MangaImage extends StatefulWidget {
  final String imageUrl;
  final String? referer;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Uint8List? translatedBytes;

  /// Fired once (after the frame) when the image's bytes have loaded
  /// successfully. Used by the reader to hide the HUD after the first page
  /// actually appears.
  final VoidCallback? onLoaded;

  /// Fired once with the image's intrinsic pixel size (read from the header, no
  /// full decode) after its bytes load. Used by the dual-page reader to spot a
  /// wide double-spread so it can be shown on its own instead of squished next
  /// to a portrait page. Only wired up when that option is on, so the extra
  /// header read is skipped otherwise.
  final void Function(Size size)? onSize;

  /// Trim solid white/black page margins before displaying (reader pages only).
  final bool autoCrop;

  const MangaImage({
    super.key,
    required this.imageUrl,
    this.referer,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    this.translatedBytes,
    this.onLoaded,
    this.onSize,
    this.autoCrop = false,
  });

  @override
  State<MangaImage> createState() => _MangaImageState();
}

class _MangaImageState extends State<MangaImage>
    with AutomaticKeepAliveClientMixin {
  Uint8List? _bytes;
  bool _loading = true;
  bool _error = false;
  bool _noImage = false; // blank imageUrl - show a placeholder, not the retry state

  // Keep alive so ListView doesn't destroy/rebuild during scroll
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(MangaImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      // Drop the previous image immediately - otherwise gaplessPlayback keeps
      // showing the OLD cover until the new one loads, which (when a widget is
      // reused for a different title) reads as a cover "duping" onto neighbours.
      _bytes = null;
      _error = false;
      _noImage = false;
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    _noImage = false;
    if (widget.imageUrl.isEmpty) {
      // Blank cover - common for anime sources that only fill the cover on the detail
      // page. Show a neutral "no cover" placeholder, not the retry/error state (there's
      // no URL to retry, and a grid full of Retry buttons looks broken).
      if (mounted) setState(() { _loading = false; _error = false; _noImage = true; });
      return;
    }

    // Handle local file:// URLs
    if (widget.imageUrl.startsWith('file://')) {
      try {
        final path = widget.imageUrl.replaceFirst('file://', '');
        var bytes = await File(path).readAsBytes();
        bytes = await _maybeCrop(bytes);
        if (!mounted) return;
        setState(() { _bytes = bytes; _loading = false; _error = false; });
        _notifyLoaded();
      } catch (_) {
        if (mounted) setState(() { _loading = false; _error = true; });
      }
      return;
    }

    // Don't reset to loading if we already have bytes (prevents flicker)
    if (_bytes == null) {
      if (mounted) setState(() { _loading = true; _error = false; });
    }

    // Build referer: if explicitly provided, use as-is (source knows best).
    // If falling back to imageUrl, add www. - many CDNs require it.
    var referer = widget.referer ?? widget.imageUrl;
    if (widget.referer == null) {
      final uri = Uri.tryParse(referer);
      if (uri != null && !uri.host.startsWith('www.')) {
        referer = referer.replaceFirst('://${uri.host}', '://www.${uri.host}');
      }
    }
    if (!referer.endsWith('/')) referer = '$referer/';

    var bytes = await ImageLoader().loadImage(
      widget.imageUrl,
      headers: {'Referer': referer},
    );
    if (!mounted) return;
    if (bytes != null) bytes = await _maybeCrop(bytes);
    if (!mounted) return;
    setState(() {
      _bytes = bytes;
      _loading = false;
      _error = bytes == null;
    });
    if (bytes != null) _notifyLoaded();
  }

  void _notifyLoaded() {
    final cb = widget.onLoaded;
    if (cb != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => cb());
    }
    if (widget.onSize != null && _bytes != null) _reportSize(_bytes!);
  }

  // Report the image's pixel dimensions by reading only the header (no raster),
  // so the reader can tell a wide double-spread from a normal page cheaply.
  Future<void> _reportSize(Uint8List bytes) async {
    try {
      final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
      final descriptor = await ui.ImageDescriptor.encoded(buffer);
      final size = Size(descriptor.width.toDouble(), descriptor.height.toDouble());
      descriptor.dispose();
      buffer.dispose();
      if (mounted) widget.onSize?.call(size);
    } catch (_) {}
  }

  // Auto-crop solid page margins off-thread, cached per URL so each page is
  // only processed once. Returns the original bytes if there's nothing to trim.
  static final Map<String, Uint8List> _cropCache = {};
  Future<Uint8List> _maybeCrop(Uint8List raw) async {
    if (!widget.autoCrop) return raw;
    final key = widget.imageUrl;
    final cached = _cropCache[key];
    if (cached != null) return cached;
    try {
      final cropped = await compute(cropImageBorders, raw);
      if (cropped != null) {
        if (_cropCache.length > 40) _cropCache.remove(_cropCache.keys.first);
        _cropCache[key] = cropped;
        return cropped;
      }
    } catch (_) {}
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required by AutomaticKeepAliveClientMixin

    if (_loading) {
      return widget.placeholder ?? _defaultPlaceholder(context);
    }
    if (_noImage) {
      return _noCover(context);
    }
    if (_error || _bytes == null) {
      return widget.errorWidget ?? _defaultError(context);
    }
    final displayBytes = widget.translatedBytes ?? _bytes!;

    // Decode covers at their DISPLAY size, not full resolution - a ~1400px cover
    // decoded full-size is ~11 MB of ARGB for a thumbnail a couple hundred px
    // wide; a grid of them blows the image cache and thrashes decode on scroll.
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final width = widget.width;

    Widget buildImage(int? cacheWidth) => Image.memory(
          displayBytes,
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
          cacheWidth: cacheWidth,
          gaplessPlayback: true, // Prevents flicker during rebuild
          errorBuilder: (_, _, _) =>
              widget.errorWidget ?? _defaultError(context),
        );

    if (width != null && width.isFinite && width > 0) {
      // Explicit finite width (list rows): decode to it.
      return buildImage((width * dpr).round());
    }
    if (width != null) {
      // Non-finite width (double.infinity) = reader pages: keep full-res so they
      // stay sharp when zoomed.
      return buildImage(null);
    }
    // No width given (the main cover grid uses a Stack/expand with no width):
    // derive the decode size from the laid-out cell so covers aren't full-res.
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final maxW = constraints.maxWidth;
        final cw = (maxW.isFinite && maxW > 0) ? (maxW * dpr).round() : null;
        return buildImage(cw);
      },
    );
  }

  void _retry() {
    if (!mounted) return;
    // A user-initiated Retry should genuinely re-request - clear any session
    // block on this image's domain (e.g. from an earlier 403) so it isn't a
    // no-op, and so it picks up a Cloudflare clearance solved since.
    ImageLoader().unblockDomainFor(widget.imageUrl);
    setState(() {
      _error = false;
      _loading = true;
    });
    _loadImage();
  }

  /// Shown when the source gave no cover URL - neutral, not a failed-load/retry state.
  Widget _noCover(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: widget.width,
      height: widget.height,
      color: cs.surfaceContainerHighest,
      child: Center(
        child: Icon(Icons.image_not_supported_outlined,
            size: 28, color: cs.outline.withAlpha(120)),
      ),
    );
  }

  Widget _defaultPlaceholder(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Static tinted tile (matches the empty-cover placeholder) instead of a
    // spinner - a grid full of spinning rings during a library update looked
    // busy; covers now just fade in when ready.
    return Container(
      width: widget.width,
      height: widget.height,
      alignment: Alignment.center,
      color: cs.surfaceContainerHighest,
      child: Icon(Icons.image_rounded, color: cs.outlineVariant, size: 26),
    );
  }

  Widget _defaultError(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return GestureDetector(
      onTap: _retry,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: widget.width,
        height: widget.height ?? 320.0,
        color: cs.surfaceContainerHighest,
        child: LayoutBuilder(
          builder: (ctx, c) {
            // Only show the Retry affordance where there's room (reader pages),
            // not on tiny cover thumbnails.
            final big = c.maxHeight >= 90 && c.maxWidth >= 90;
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Opacity(
                    opacity: 0.25,
                    child: Image.asset('assets/images/foxlations.png',
                        width: big ? 44 : 28, height: big ? 44 : 28),
                  ),
                  if (big) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: cs.primary.withAlpha(36),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: cs.primary.withAlpha(90)),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.refresh_rounded, size: 16, color: cs.primary),
                        const SizedBox(width: 6),
                        Text(t.readerRetry,
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: cs.primary)),
                      ]),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
