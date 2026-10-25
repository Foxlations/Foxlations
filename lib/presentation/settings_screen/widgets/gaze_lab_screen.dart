import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/services/gaze_scroll_service.dart';
import '../../../core/services/settings_store.dart';

const Color _accent = Color(0xFFFF7A5C);

/// Dev-only gaze tuning lab (iOS). A live dot on a labelled % grid, the raw
/// signal readout, sliders that push to the engine in real time (no rebuild),
/// and manual per-point calibration so the mapping can be dialled in on-device
/// and the good numbers reported back. Reached from More → Debug; not user-facing.
class GazeLabScreen extends StatefulWidget {
  const GazeLabScreen({super.key});
  @override
  State<GazeLabScreen> createState() => _GazeLabScreenState();
}

class _GazeLabScreenState extends State<GazeLabScreen> {
  double _gx = 0, _gy = 0, _fv = 0, _fh = 0, _fp = 0;
  GazeDirection _dir = GazeDirection.none;
  double _intensity = 0;

  double _threshold = 0.8, _smoothing = 0.25, _gain = 0.38;
  String _mode = 'combined';
  bool _useLookAt = true;
  bool _useGeometric = true;
  bool _testing = false;

  // Manual capture points → {v,h,p}. Keys: center/top/bottom/left/right.
  final Map<String, Map<String, double>> _pts = {};
  String _status = 'Tip: capture Top/Bottom/Left/Right, then Apply.';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _threshold = SettingsStore.instance.getDouble('reader_gaze_threshold') ?? 0.8;
    _smoothing = SettingsStore.instance.getDouble('reader_gaze_smoothing') ?? 0.25;
    _mode = SettingsStore.instance.getString('reader_gaze_mode') ?? 'combined';
    _useGeometric =
        SettingsStore.instance.getBool('reader_gaze_geometric') ?? true;
    await GazeScroll.updateSettings(GazeSettings(
        mode: _mode,
        threshold: _threshold,
        smoothing: _smoothing,
        useLookAt: _useLookAt,
        useGeometric: _useGeometric));
    await GazeScroll.setPreview(true, onPreview: (gx, gy) {
      if (mounted) setState(() { _gx = gx; _gy = gy; });
    }, onDebug: (m) {
      if (mounted) setState(() { _fv = m['fv'] ?? 0; _fh = m['fh'] ?? 0; _fp = m['fp'] ?? 0; });
    });
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    GazeScroll.setPreview(false);
    GazeScroll.disable();
    super.dispose();
  }

  Future<void> _push() async {
    await GazeScroll.updateSettings(GazeSettings(
        mode: _mode,
        threshold: _threshold,
        smoothing: _smoothing,
        useLookAt: _useLookAt,
        useGeometric: _useGeometric));
    await SettingsStore.instance.setDouble('reader_gaze_threshold', _threshold);
    await SettingsStore.instance.setDouble('reader_gaze_smoothing', _smoothing);
    await SettingsStore.instance.setString('reader_gaze_mode', _mode);
    await SettingsStore.instance.setBool('reader_gaze_geometric', _useGeometric);
  }

  Future<void> _capture(String key) async {
    setState(() => _status = 'Look at $key and hold…');
    final c = Completer<Map<String, double>>();
    await GazeScroll.calibrate(durationMs: 700, adopt: false, onDone: (m) {
      if (!c.isCompleted) c.complete(m);
    });
    final m = await c.future;
    if (!mounted) return;
    setState(() { _pts[key] = m; _status = 'Captured $key: v=${m['v']!.toStringAsFixed(3)}'; });
  }

  Future<void> _apply() async {
    final c = _pts['center'], t = _pts['top'], b = _pts['bottom'], l = _pts['left'], r = _pts['right'];
    if (t == null || b == null || l == null || r == null) {
      setState(() => _status = 'Need Top, Bottom, Left, Right captured first.');
      return;
    }
    double vv(Map<String, double> m) => m['v'] ?? 0;
    double hh(Map<String, double> m) => m['h'] ?? 0;
    double pp(Map<String, double> m) => m['p'] ?? 0;
    // Neutral = midpoint of the actual extremes (more stable than a captured centre).
    final cV = (vv(t) + vv(b)) / 2;
    final cH = (hh(l) + hh(r)) / 2;
    final cP = c != null ? pp(c) : (pp(t) + pp(b)) / 2;
    final model = <String, double>{
      'v': cV, 'h': cH, 'p': cP,
      'down': vv(b) - cV, 'up': vv(t) - cV,
      'right': hh(r) - cH, 'left': hh(l) - cH,
      'pdown': pp(b) - cP, 'pup': pp(t) - cP,
    };
    await SettingsStore.instance.setDouble('reader_gaze_base_v', cV);
    await SettingsStore.instance.setDouble('reader_gaze_base_h', cH);
    await SettingsStore.instance.setDouble('reader_gaze_base_p', cP);
    await SettingsStore.instance.setDouble('reader_gaze_span_down', model['down']!);
    await SettingsStore.instance.setDouble('reader_gaze_span_up', model['up']!);
    await SettingsStore.instance.setDouble('reader_gaze_span_right', model['right']!);
    await SettingsStore.instance.setDouble('reader_gaze_span_left', model['left']!);
    await SettingsStore.instance.setDouble('reader_gaze_span_pdown', model['pdown']!);
    await SettingsStore.instance.setDouble('reader_gaze_span_pup', model['pup']!);
    await GazeScroll.setModel(model);
    if (mounted) {
      setState(() => _status =
          'Applied. up=${model['up']!.toStringAsFixed(2)} down=${model['down']!.toStringAsFixed(2)} L=${model['left']!.toStringAsFixed(2)} R=${model['right']!.toStringAsFixed(2)}');
    }
  }

  Future<void> _toggleTest() async {
    if (_testing) {
      await GazeScroll.disable();
      setState(() { _testing = false; _dir = GazeDirection.none; });
    } else {
      await GazeScroll.enable((e) {
        if (mounted) setState(() { _dir = e.direction; _intensity = e.intensity; });
      });
      setState(() => _testing = true);
    }
  }

  double _fracX(double w) => (0.5 + _gain * _gx).clamp(0.03, 0.97) * w;
  double _fracY(double h) => (0.5 + _gain * _gy).clamp(0.03, 0.97) * h;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Gaze Lab'),
      ),
      body: Column(children: [
        Expanded(
          flex: 3,
          child: LayoutBuilder(builder: (ctx, box) {
            final w = box.maxWidth, h = box.maxHeight;
            return Stack(children: [
              // % grid
              for (int i = 0; i <= 5; i++)
                Positioned(
                  top: (i / 5) * h - 6,
                  left: 0,
                  right: 0,
                  child: Row(children: [
                    SizedBox(
                        width: 44,
                        child: Text('${(i * 20)}%',
                            style: const TextStyle(color: Colors.white38, fontSize: 10))),
                    Expanded(child: Container(height: 1, color: Colors.white12)),
                  ]),
                ),
              // dead-zone band (|gy| < threshold)
              Positioned(
                top: (0.5 - _gain * _threshold).clamp(0.0, 1.0) * h,
                height: (2 * _gain * _threshold).clamp(0.0, 1.0) * h,
                left: 0,
                right: 0,
                child: Container(color: Colors.white.withValues(alpha: 0.045)),
              ),
              // live dot
              Positioned(
                left: _fracX(w) - 13,
                top: _fracY(h) - 13,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _accent.withValues(alpha: 0.5),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
              if (_dir != GazeDirection.none)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        color: _accent, borderRadius: BorderRadius.circular(12)),
                    child: Text('${_dir.name}  ${_intensity.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                  ),
                ),
            ]);
          }),
        ),
        Expanded(
          flex: 4,
          child: Container(
            color: const Color(0xFF111118),
            child: ListView(padding: const EdgeInsets.all(12), children: [
              _readout(),
              const SizedBox(height: 6),
              _slider('Dead zone', _threshold, 0.2, 1.2, (v) { setState(() => _threshold = v); _push(); }),
              _slider('Smoothing', _smoothing, 0.05, 0.6, (v) { setState(() => _smoothing = v); _push(); }),
              _slider('Dot gain', _gain, 0.15, 0.6, (v) => setState(() => _gain = v)),
              _modeRow(),
              _sourceRow(),
              _projectRow(),
              const SizedBox(height: 8),
              const Text('Manual calibrate - look, then tap:',
                  style: TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 6),
              _captureRow(),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: FilledButton(onPressed: _apply, child: const Text('Apply model'))),
                const SizedBox(width: 8),
                Expanded(
                    child: OutlinedButton(
                        onPressed: _toggleTest,
                        child: Text(_testing ? 'Stop test' : 'Test triggers'))),
              ]),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(_status, style: const TextStyle(color: _accent, fontSize: 12)),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _readout() {
    String f(double x) => x.toStringAsFixed(3);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace'),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('gx ${f(_gx)}    gy ${f(_gy)}'),
          Text('fv ${f(_fv)}    fh ${f(_fh)}    fp ${f(_fp)}'),
          Text('pts: ${_pts.keys.join(", ")}'),
        ]),
      ),
    );
  }

  Widget _slider(String label, double val, double min, double max, ValueChanged<double> onCh) {
    return Row(children: [
      SizedBox(
          width: 92,
          child: Text('$label\n${val.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white70, fontSize: 11))),
      Expanded(
          child: Slider(
              value: val.clamp(min, max),
              min: min,
              max: max,
              activeColor: _accent,
              onChanged: onCh)),
    ]);
  }

  Widget _modeRow() {
    Widget chip(String m, String label) => Padding(
          padding: const EdgeInsets.only(right: 6),
          child: ChoiceChip(
            label: Text(label, style: const TextStyle(fontSize: 11)),
            selected: _mode == m,
            selectedColor: _accent,
            onSelected: (_) { setState(() => _mode = m); _push(); },
          ),
        );
    return Row(children: [
      const SizedBox(width: 56, child: Text('Mode', style: TextStyle(color: Colors.white70, fontSize: 12))),
      chip('eyesOnly', 'Eyes'),
      chip('headOnly', 'Head'),
      chip('combined', 'Both'),
    ]);
  }

  Widget _sourceRow() {
    Widget chip(bool la, String label) => Padding(
          padding: const EdgeInsets.only(right: 6),
          child: ChoiceChip(
            label: Text(label, style: const TextStyle(fontSize: 11)),
            selected: _useLookAt == la,
            selectedColor: _accent,
            onSelected: (_) { setState(() => _useLookAt = la); _push(); },
          ),
        );
    return Row(children: [
      const SizedBox(width: 56, child: Text('Source', style: TextStyle(color: Colors.white70, fontSize: 12))),
      chip(false, 'Blendshape'),
      chip(true, 'LookAt'),
    ]);
  }

  Widget _projectRow() {
    Widget chip(bool g, String label) => Padding(
          padding: const EdgeInsets.only(right: 6),
          child: ChoiceChip(
            label: Text(label, style: const TextStyle(fontSize: 11)),
            selected: _useGeometric == g,
            selectedColor: _accent,
            onSelected: (_) { setState(() => _useGeometric = g); _push(); },
          ),
        );
    return Row(children: [
      const SizedBox(width: 56, child: Text('Project', style: TextStyle(color: Colors.white70, fontSize: 12))),
      chip(false, 'Raw'),
      chip(true, 'Geometric'),
    ]);
  }

  Widget _captureRow() {
    return Wrap(spacing: 6, runSpacing: 6, children: [
      for (final k in ['center', 'top', 'bottom', 'left', 'right'])
        OutlinedButton(
          onPressed: () => _capture(k),
          style: OutlinedButton.styleFrom(
              foregroundColor: _pts.containsKey(k) ? _accent : Colors.white70,
              side: BorderSide(color: _pts.containsKey(k) ? _accent : Colors.white24)),
          child: Text(k),
        ),
    ]);
  }
}
