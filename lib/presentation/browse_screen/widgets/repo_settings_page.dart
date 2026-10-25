import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/providers/source_provider.dart';
import '../../../core/services/repo_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/ds/ds.dart';

class RepoSettingsPage extends StatefulWidget {
  const RepoSettingsPage({super.key});

  @override
  State<RepoSettingsPage> createState() => _RepoSettingsPageState();
}

class _RepoSettingsPageState extends State<RepoSettingsPage> {
  final _urlController = TextEditingController();
  bool _isAdding = false;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);

    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final isKeyboardOpen = keyboardHeight > 0;

    return DraggableScrollableSheet(
      initialChildSize: isKeyboardOpen ? 0.85 : 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      expand: false,
      snap: true,
      snapSizes: const [0.55, 0.85],
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: keyboardHeight,
            ),
            child: Column(
              children: [
                // Drag handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: cs.outline.withAlpha(77),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: oledIconChip(context,
                            color: cs.primary,
                            fill: cs.primary.withAlpha(31)),
                        child: Icon(Icons.folder_special_rounded,
                            size: 18, color: cs.primary),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        t.miscExtensionRepositories,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Add repo input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                      border: Border.all(
                          color: cs.primary.withAlpha(51), width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Icon(Icons.link_rounded,
                            size: 18, color: cs.outline),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _urlController,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: cs.onSurface),
                            decoration: InputDecoration(
                              hintText: t.miscRepositoryUrlHint,
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: cs.outline),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              filled: false,
                            ),
                            onSubmitted: (_) => _addRepo(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _isAdding ? null : _addRepo,
                          child: AnimatedContainer(
                            duration: AppTheme.fastMicro,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: cs.primary,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusFull),
                            ),
                            child: _isAdding
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    t.miscAdd,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                Divider(height: 1, color: cs.surfaceContainerHighest),

                // Repo list header
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: Row(
                    children: [
                      Text(
                        t.miscRepositoriesHeader,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: cs.outline,
                              letterSpacing: 1.2,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Consumer<SourceProvider>(
                        builder: (_, p, _) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerHighest,
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusFull),
                          ),
                          child: Text(
                            '${p.repoUrls.length}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: cs.outline,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Repo list
                Expanded(
                  child: Consumer<SourceProvider>(
                    builder: (_, provider, _) {
                      final repos = provider.repoUrls;
                      if (repos.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.inbox_rounded,
                                  size: 32, color: cs.outline),
                              const SizedBox(height: 8),
                              Text(
                                t.miscNoReposYet,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: cs.outline),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.only(bottom: 32),
                        itemCount: repos.length,
                        itemBuilder: (_, i) {
                          final url = repos[i];
                          final index = provider.repoIndexes[url];
                          return _RepoItem(
                            url: url,
                            name: index?.repoName,
                            sourceCount: index?.totalCount ?? 0,
                            onTap: () => _showRepoOptions(url, index),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addRepo() async {
    final t = AppLocalizations.of(context);
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    setState(() => _isAdding = true);
    try {
      await context.read<SourceProvider>().addRepo(url);
      _urlController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.miscFailedToAddRepo(e.toString()))),
        );
      }
    }
    if (mounted) setState(() => _isAdding = false);
  }

  void _showRepoOptions(String url, RepoIndexResult? index) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final name = (index?.repoName.isNotEmpty ?? false)
        ? index!.repoName
        : (Uri.tryParse(url)?.host ?? url);
    final gh = _githubPage(url);
    final website = index?.website ?? '';
    final discord = index?.discord ?? '';
    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        Widget tile(IconData icon, String label, VoidCallback onTap,
                {Color? color}) =>
            ListTile(
              leading: Icon(icon, size: 20, color: color ?? cs.onSurface),
              title: Text(label,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: color ?? cs.onSurface)),
              onTap: () {
                Navigator.pop(ctx);
                onTap();
              },
            );
        return SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(children: [
                Icon(Icons.folder_rounded, size: 18, color: cs.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface)),
                ),
              ]),
            ),
            Divider(height: 1, color: cs.surfaceContainerHighest),
            tile(Icons.refresh_rounded, t.repoReinstallSources,
                () => _reinstallRepo(url)),
            tile(Icons.copy_rounded, t.repoCopyUrl, () => _copyUrl(url)),
            if (gh != null)
              tile(Icons.open_in_new_rounded, t.repoOpenGithubPage,
                  () => _open(gh)),
            if (website.isNotEmpty && website != gh)
              tile(Icons.language_rounded, t.repoOpenWebsite, () => _open(website)),
            if (discord.isNotEmpty)
              tile(Icons.forum_rounded, t.repoOpenDiscord, () => _open(discord)),
            tile(Icons.delete_outline_rounded, t.repoDeleteRepo,
                () => _confirmDelete(url, name),
                color: AppTheme.error),
            const SizedBox(height: 8),
          ]),
        );
      },
    );
  }

  /// Best-effort GitHub repo page from a raw/pages index URL. Null if not GitHub.
  String? _githubPage(String url) {
    final u = Uri.tryParse(url);
    if (u == null) return null;
    final host = u.host;
    final segs = u.pathSegments.where((s) => s.isNotEmpty).toList();
    if (host == 'raw.githubusercontent.com' || host == 'github.com') {
      if (segs.length >= 2) return 'https://github.com/${segs[0]}/${segs[1]}';
    }
    if (host.endsWith('.github.io')) {
      final owner = host.substring(0, host.length - '.github.io'.length);
      return segs.isNotEmpty
          ? 'https://github.com/$owner/${segs[0]}'
          : 'https://github.com/$owner';
    }
    return null;
  }

  Future<void> _open(String url) async {
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final ok =
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      if (!ok && mounted) {
        messenger.showSnackBar(SnackBar(content: Text(t.repoCouldNotOpen(url))));
      }
    } catch (_) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text(t.repoCouldNotOpen(url))));
      }
    }
  }

  void _copyUrl(String url) {
    Clipboard.setData(ClipboardData(text: url));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              AppLocalizations.of(context).setxAdvancedCopiedToClipboard)));
    }
  }

  Future<void> _reinstallRepo(String url) async {
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    messenger
        .showSnackBar(SnackBar(content: Text(t.repoReinstalling)));
    try {
      final n = await context.read<SourceProvider>().reinstallRepo(url);
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(
          content: Text(n == 0
              ? t.repoRefreshed
              : t.repoReinstalledCount(n))));
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
            SnackBar(content: Text(t.repoReinstallFailed(e.toString()))));
      }
    }
  }

  Future<void> _confirmDelete(String url, String name) async {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surfaceContainerHighest,
        title: Text(t.repoDeleteTitle,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        content: Text(t.repoDeleteBody(name),
            style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(t.repoCancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
              child: Text(t.repoDeleteConfirm)),
        ],
      ),
    );
    if (ok == true && mounted) {
      await context.read<SourceProvider>().removeRepo(url);
    }
  }
}

class _RepoItem extends StatelessWidget {
  final String url;
  final String? name;
  final int sourceCount;
  final VoidCallback onTap;

  const _RepoItem({
    required this.url,
    this.name,
    required this.sourceCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final displayName =
        name?.isNotEmpty == true ? name! : Uri.tryParse(url)?.host ?? url;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: cs.primary.withAlpha(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: oledIconChip(context,
                    color: cs.primary,
                    fill: cs.primary.withAlpha(20),
                    radius: AppTheme.radiusSmall),
                child: Icon(Icons.folder_rounded,
                    size: 20, color: cs.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: cs.onSurface,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t.repoSourceCount(sourceCount),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: cs.outline,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.more_vert_rounded, size: 20, color: cs.outline),
            ],
          ),
        ),
      ),
    );
  }
}
