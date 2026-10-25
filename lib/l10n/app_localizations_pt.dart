// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Foxlations';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsSectionApp => 'Aplicativo';

  @override
  String get settingsSectionManga => 'Mangá';

  @override
  String get settingsSectionSystem => 'Sistema';

  @override
  String get settingsLanguageTitle => 'Idioma';

  @override
  String get settingsLanguageEntrySubtitle =>
      'Idioma de exibição do aplicativo';

  @override
  String get settingsLanguageSubtitle => 'Escolha o idioma do aplicativo';

  @override
  String get settingsLanguageSystemDefault => 'Padrão do sistema';

  @override
  String get settingsLanguageHeader => 'Idioma do aplicativo';

  @override
  String get settingsAppearanceTitle => 'Aparência';

  @override
  String get settingsAppearanceSubtitle => 'Tema, modo escuro, exibição';

  @override
  String get settingsNotificationsTitle => 'Notificações';

  @override
  String get settingsNotificationsSubtitle =>
      'Alertas push, frequência, lembretes';

  @override
  String get settingsStorageTitle => 'Armazenamento';

  @override
  String get settingsStorageSubtitle => 'Downloads, pastas, sincronização';

  @override
  String get settingsLibraryTitle => 'Biblioteca';

  @override
  String get settingsLibrarySubtitle =>
      'Categorias, atualização global, exibição';

  @override
  String get settingsReaderTitle => 'Leitor';

  @override
  String get settingsReaderSubtitle => 'Modo de leitura, exibição, navegação';

  @override
  String get settingsPlayerTitle => 'Player';

  @override
  String get settingsPlayerSubtitle =>
      'Avanço, gestos, velocidade, reprodução automática';

  @override
  String get settingsDownloadsTitle => 'Downloads';

  @override
  String get settingsDownloadsSubtitle =>
      'Downloads automáticos, excluir capítulos';

  @override
  String get settingsTrackingTitle => 'Rastreamento';

  @override
  String get settingsTrackingSubtitle => 'MAL, AniList, Kitsu e mais';

  @override
  String get settingsAiTitle => 'IA e Tradução';

  @override
  String get settingsAiSubtitle =>
      'Provedor, chaves de API, detecção de balões de fala';

  @override
  String get settingsBrowseTitle => 'Explorar';

  @override
  String get settingsBrowseSubtitle => 'Fontes, extensões, busca global';

  @override
  String get settingsBackupTitle => 'Backup e Restauração';

  @override
  String get settingsBackupSubtitle =>
      'Criar/restaurar backups, importar, backup automático';

  @override
  String get settingsSecurityTitle => 'Segurança e Privacidade';

  @override
  String get settingsSecuritySubtitle =>
      'Bloqueio do app, biometria, segurança da tela';

  @override
  String get settingsAdvancedTitle => 'Avançado';

  @override
  String get settingsAdvancedSubtitle => 'Rede, extensões, registros, dados';

  @override
  String get settingsAboutTitle => 'Sobre';

  @override
  String get settingsAboutSubtitle => 'Versão, licenças, links';

  @override
  String get libraryAdd => 'Adicionar';

  @override
  String get libraryAddAnime => 'Adicionar Anime';

  @override
  String get libraryAddLNs => 'Adicionar LNs';

  @override
  String get libraryAddManga => 'Adicionar Mangá';

  @override
  String get libraryBadges => 'Selos';

  @override
  String get libraryBatchMigrate => 'Migrar';

  @override
  String get libraryBatchMove => 'Mover';

  @override
  String get libraryBatchRead => 'Lido';

  @override
  String get libraryBatchRemove => 'Remover';

  @override
  String get libraryBatchUnread => 'Não lido';

  @override
  String get libraryCategoryUpdate => 'Atualizar Categoria';

  @override
  String libraryCategoryUpdateDesc(Object category) {
    return 'Verificar novos capítulos em \"$category\"';
  }

  @override
  String libraryChapterProgress(Object read, Object total) {
    return 'Cap. $read/$total';
  }

  @override
  String libraryEpisodeProgress(Object read, Object total) {
    return 'Ep. $read/$total';
  }

  @override
  String libraryChaptersAbbrev(Object n) {
    return '$n cap';
  }

  @override
  String get libraryCheckForUpdates => 'Verificar atualizações';

  @override
  String get libraryClose => 'Fechar';

  @override
  String get libraryCloseSearch => 'Fechar busca';

  @override
  String get libraryCompleted => 'Concluído';

  @override
  String get libraryContinueReading => 'Continuar Lendo';

  @override
  String get libraryContinueWatching => 'Continuar Assistindo';

  @override
  String get readerListen => 'Listen';

  @override
  String get readerTtsStop => 'Stop';

  @override
  String get readerTtsSpeed => 'Speed';

  @override
  String get readerTtsVoice => 'Voice';

  @override
  String get readerTtsNoVoices => 'No voices available on this device';

  @override
  String get readerTtsSystemVoice => 'System default';

  @override
  String libraryDaysCount(Object days) {
    return '$days dias';
  }

  @override
  String get libraryDeselectAll => 'Desmarcar tudo';

  @override
  String get libraryDisplayMode => 'Modo de Exibição';

  @override
  String get libraryDownloaded => 'Baixado';

  @override
  String get libraryEmpty => 'A biblioteca está vazia';

  @override
  String get libraryEmptyDesc =>
      'Sua biblioteca está vazia. Explore fontes para adicionar mangás.';

  @override
  String libraryEmptyStatsLibrary(Object word) {
    return 'Adicione $word à sua biblioteca e comece a ler para ver suas estatísticas aqui.';
  }

  @override
  String libraryEmptyStatsVault(Object word) {
    return 'Adicione $word ao seu cofre e comece a ler para ver as estatísticas aqui.';
  }

  @override
  String get libraryFilterSortDisplay => 'Filtrar, ordenar e exibir';

  @override
  String get libraryGlobalUpdate => 'Atualização Global';

  @override
  String get libraryGlobalUpdateDesc =>
      'Verificar todos os itens da sua biblioteca';

  @override
  String get libraryHeatmapLess => 'Menos';

  @override
  String get libraryHeatmapMore => 'Mais';

  @override
  String get libraryItemsPerRow => 'Itens por linha';

  @override
  String libraryLastChecked(Object when) {
    return 'Última verificação: $when';
  }

  @override
  String get libraryLibrary => 'Biblioteca';

  @override
  String libraryListChapters(Object read, Object total) {
    return '$read/$total capítulos';
  }

  @override
  String get libraryMore => 'Mais';

  @override
  String get libraryMoveToCategory => 'Mover para Categoria';

  @override
  String get libraryNever => 'nunca';

  @override
  String get libraryNoBookmarks => 'Nenhum favorito ainda';

  @override
  String get libraryNoBookmarksDesc =>
      'Mantenha um mangá pressionado e favorite-o para vê-lo aqui.';

  @override
  String get libraryNoNewChaptersLastCheck =>
      'Nenhum capítulo novo foi encontrado na última verificação.';

  @override
  String get libraryNoResults => 'Nenhum resultado';

  @override
  String libraryNoResultsDesc(Object query) {
    return 'Nenhum resultado para \"$query\". Tente outra busca.';
  }

  @override
  String get libraryNoStatsYet => 'Nenhuma estatística ainda';

  @override
  String get libraryOpenRandomEntry => 'Abrir item aleatório';

  @override
  String get libraryResetToDefault => 'Restaurar padrão';

  @override
  String get librarySave => 'Salvar';

  @override
  String get librarySearchHint => 'Buscar na biblioteca...';

  @override
  String get librarySearchLibrary => 'Buscar na biblioteca';

  @override
  String get librarySelect => 'Selecionar';

  @override
  String get librarySelectAll => 'Selecionar tudo';

  @override
  String librarySelectedCount(Object n) {
    return '$n selecionado(s)';
  }

  @override
  String get libraryShowNumberOfItems => 'Mostrar número de itens';

  @override
  String get librarySizeMedium => 'Médio';

  @override
  String get librarySources => 'Fontes';

  @override
  String get libraryStats => 'Estatísticas';

  @override
  String get libraryStatusAll => 'Todos';

  @override
  String get libraryStatusCompleted => 'Concluído';

  @override
  String get libraryStatusDropped => 'Abandonado';

  @override
  String get libraryStatusOnHold => 'Em Espera';

  @override
  String get libraryStatusPlanToRead => 'Pretendo Ler';

  @override
  String get libraryStatusReading => 'Lendo';

  @override
  String get libraryStatusUnknown => 'Desconhecido';

  @override
  String libraryStreakDaysStrong(Object days) {
    return '$days dias seguidos — continue assim!';
  }

  @override
  String get libraryTabDisplay => 'Exibir';

  @override
  String get libraryTabFilter => 'Filtrar';

  @override
  String get libraryTabSort => 'Ordenar';

  @override
  String get libraryTabs => 'Abas';

  @override
  String libraryTotalAbbrev(Object n) {
    return '$n no total';
  }

  @override
  String get libraryTypeMenuBarrier => 'Library type';

  @override
  String libraryTypeBreakdown(Object type) {
    return 'Detalhamento de $type';
  }

  @override
  String get libraryUnread => 'Não lido';

  @override
  String get libraryUpdatesSummary => 'Resumo das Atualizações';

  @override
  String get libraryUpdatesSummaryDesc =>
      'O que a última verificação encontrou';

  @override
  String get libraryVault => 'Cofre';

  @override
  String get libraryVaultStats => 'Estatísticas do Cofre';

  @override
  String get detailAdd => 'Adicionar';

  @override
  String get detailAddNoteHint => 'Adicione uma nota para este título…';

  @override
  String get detailAddToCategory => 'Adicionar à Categoria';

  @override
  String get detailAddToLibrary => 'Adicionar à Biblioteca';

  @override
  String get detailAddWithoutCategory => 'Adicionar sem Categoria';

  @override
  String get detailBelowRead => 'Abaixo lidos';

  @override
  String get detailBelowUnread => 'Abaixo não lidos';

  @override
  String get detailBookmark => 'Favoritar';

  @override
  String get detailBookmarked => 'Favoritado';

  @override
  String get detailCancel => 'Cancelar';

  @override
  String get detailChapterFallback => 'Capítulo';

  @override
  String detailCopiedTo(Object source) {
    return 'Copiado para $source';
  }

  @override
  String detailCountSelected(Object count) {
    return '$count selecionado(s)';
  }

  @override
  String get detailDeleteDownload => 'Excluir download';

  @override
  String get detailDone => 'Concluído';

  @override
  String get detailDownload => 'Baixar';

  @override
  String get detailDownloadAllChapters => 'Todos os capítulos';

  @override
  String get detailDownloadAllUnread => 'Todos não lidos';

  @override
  String get detailDownloaded => 'Baixado';

  @override
  String get detailDownloadNext10 => 'Próximos 10 capítulos';

  @override
  String get detailDownloadNext5 => 'Próximos 5 capítulos';

  @override
  String get detailDownloadNextChapter => 'Próximo capítulo';

  @override
  String get detailDownloadNextEpisode => 'Next episode';

  @override
  String get detailDownloadNext5Episodes => 'Next 5 episodes';

  @override
  String get detailDownloadNext10Episodes => 'Next 10 episodes';

  @override
  String get detailDownloadAllEpisodes => 'All episodes';

  @override
  String get detailSelectEpisodes => 'Select episodes';

  @override
  String get detailEditCategories => 'Editar categorias';

  @override
  String get detailEditCategoriesTitle => 'Editar Categorias';

  @override
  String get detailFilter => 'Filtrar';

  @override
  String get detailInProgress => 'Em andamento';

  @override
  String get detailLogIn => 'Entrar';

  @override
  String get detailMangaNotFound => 'Mangá não encontrado na biblioteca';

  @override
  String get detailMarkAllAsRead => 'Marcar tudo como lido';

  @override
  String get detailMarkAllAsUnread => 'Marcar tudo como não lido';

  @override
  String get detailMarkAllBelowRead => 'Marcar tudo abaixo como lido';

  @override
  String get detailMarkAsUnread => 'Marcar como não lido';

  @override
  String get detailMarkChapterAsRead => 'Marcar capítulo como lido';

  @override
  String get detailMarkRead => 'Marcar lido';

  @override
  String get detailMarkUnread => 'Marcar não lido';

  @override
  String get detailMigrate => 'Migrar';

  @override
  String get detailMigrateCategories => 'Categorias';

  @override
  String get detailMigrateChapters => 'Capítulos';

  @override
  String get detailMigrateCopy => 'Copiar';

  @override
  String get detailMigrateDownloadsNoTransfer =>
      'Capítulos baixados não são transferidos.';

  @override
  String detailMigratedTo(Object source) {
    return 'Migrado para $source';
  }

  @override
  String detailMigrateEntriesToSource(Object count, Object source) {
    return '$count itens → $source';
  }

  @override
  String get detailMigrateInfo =>
      'Selecione o mesmo mangá de outra fonte. O progresso de leitura será transferido.';

  @override
  String get detailMigrateRemoveDownloads => 'Remover downloads ao migrar';

  @override
  String get detailMigrateSelectData => 'Selecione os dados a incluir';

  @override
  String get detailMigrateShowEntry => 'Mostrar item';

  @override
  String detailMigrateTitleToSource(Object title, Object source) {
    return '$title → $source';
  }

  @override
  String get detailMigrateTracking => 'Rastreamento';

  @override
  String get detailMigrating => 'Migrando…';

  @override
  String get detailNewestFirst => 'Mais recentes primeiro';

  @override
  String get detailNoChaptersFound => 'Nenhum capítulo encontrado';

  @override
  String get detailNoChaptersLoginHint =>
      'Nada foi carregado para este título. Tente novamente — ou, nesta fonte, entrar às vezes pode liberar mais conteúdo.';

  @override
  String get detailNoChaptersRetryHint =>
      'Nada foi carregado para este título. Pode não haver nenhum ainda, ou a fonte teve problemas para carregá-los. Tente novamente.';

  @override
  String get detailNoResults => 'Nenhum resultado encontrado';

  @override
  String get detailNotes => 'Notas';

  @override
  String get detailNothingToDownload => 'Nada para baixar';

  @override
  String get detailOldestFirst => 'Mais antigos primeiro';

  @override
  String get detailOpenInBrowser => 'Abrir no navegador';

  @override
  String get webviewOpenFailed => 'Couldn\'t open the browser';

  @override
  String detailPage(Object page) {
    return 'Página $page';
  }

  @override
  String get detailRefresh => 'Atualizar';

  @override
  String get detailRemove => 'Remover';

  @override
  String get detailRemoveBookmark => 'Remover favorito';

  @override
  String get detailRemoveFromLibrary => 'Remover da biblioteca';

  @override
  String get detailRemoveFromLibraryTitle => 'Remover da biblioteca?';

  @override
  String get detailResume => 'Continuar';

  @override
  String get detailRetry => 'Tentar novamente';

  @override
  String get detailSave => 'Salvar';

  @override
  String get detailSearchChapters => 'Buscar capítulos';

  @override
  String get detailSearchChaptersHint => 'Buscar capítulos...';

  @override
  String get detailSearchEpisodes => 'Buscar episódios';

  @override
  String get detailSearchHint => 'Buscar título de mangá...';

  @override
  String get detailSearchingSources => 'Buscando nas fontes…';

  @override
  String get detailSelectAll => 'Selecionar tudo';

  @override
  String get detailSelectChapters => 'Selecionar capítulos';

  @override
  String get detailTracking => 'Rastreamento';

  @override
  String get detailUnbookmark => 'Desfavoritar';

  @override
  String get detailUnread => 'Não lido';

  @override
  String get detailWebView => 'WebView';

  @override
  String get appNavLibrary => 'Biblioteca';

  @override
  String get appNavUpdates => 'Atualizações';

  @override
  String get appNavBrowse => 'Explorar';

  @override
  String get appNavDiscover => 'Discover';

  @override
  String get appNavMore => 'Mais';

  @override
  String get appNavVault => 'Cofre';

  @override
  String get appUpdatesTitle => 'Atualizações';

  @override
  String get appNoNewChapters => 'Nenhum capítulo novo';

  @override
  String get appCheckForUpdates => 'Verificar atualizações';

  @override
  String get appClearAll => 'Limpar tudo';

  @override
  String appCheckingProgress(Object checked, Object total) {
    return 'Verificando $checked / $total...';
  }

  @override
  String appLastChecked(Object time) {
    return 'Última verificação: $time';
  }

  @override
  String get appNoUpdatesYet => 'Nenhuma atualização ainda';

  @override
  String get appTapRefreshForChapters =>
      'Toque em atualizar para verificar novos capítulos';

  @override
  String get appCheckNow => 'Verificar Agora';

  @override
  String get appJustNow => 'Agora mesmo';

  @override
  String appMinutesAgo(Object m) {
    return 'há ${m}min';
  }

  @override
  String appHoursAgo(Object h) {
    return 'há ${h}h';
  }

  @override
  String appDaysAgo(Object d) {
    return 'há ${d}d';
  }

  @override
  String get appToday => 'HOJE';

  @override
  String get appYesterday => 'ONTEM';

  @override
  String get appOnLatestVersion => 'Você está na versão mais recente';

  @override
  String get appUpdateAvailable => 'Atualização disponível';

  @override
  String appVersionBuild(Object version, Object build) {
    return 'v$version · build $build';
  }

  @override
  String get appDownloadUpdate => 'Baixar atualização';

  @override
  String appDownloadVersion(Object version) {
    return 'Baixar v$version';
  }

  @override
  String get appApkDownloadHint =>
      'Abre o download do APK. O Android pedirá confirmação para instalar.';

  @override
  String get appIosUpdateHint =>
      'Atualize pelo AltStore ou SideStore — abra o app e atualize. O iOS não consegue instalar um aplicativo baixado pelo navegador.';

  @override
  String get appSourceUrlCopied =>
      'URL da fonte copiada — adicione-a no AltStore';

  @override
  String get appCopyAltstoreUrl => 'Copiar URL da fonte do AltStore';

  @override
  String get appBack => 'Voltar';

  @override
  String get appForward => 'Avançar';

  @override
  String get appReload => 'Recarregar';

  @override
  String get appDoneSaveCookies => 'Concluído — salvar cookies';

  @override
  String get appVaultPassword => 'Senha do Cofre';

  @override
  String get appEnterPassword => 'Digite a senha';

  @override
  String get appWrongPassword => 'Senha incorreta';

  @override
  String get appCancel => 'Cancelar';

  @override
  String get appUnlock => 'Desbloquear';

  @override
  String get appBiometrics => 'Biometrics';

  @override
  String appVaultTapsToEnter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more taps to enter vault',
      one: '1 more tap to enter vault',
    );
    return '$_temp0';
  }

  @override
  String appVaultTapsToExit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more taps to exit vault',
      one: '1 more tap to exit vault',
    );
    return '$_temp0';
  }

  @override
  String detailRemoveFromLibraryBody(String title) {
    return 'Remove \"$title\" from your library?';
  }

  @override
  String get detailThisTitle => 'this title';

  @override
  String get detailTitleCopied => 'Title copied';

  @override
  String get detailSortBy => 'Sort by';

  @override
  String get detailSortSourceOrder => 'Source order';

  @override
  String get detailSortChapterNumber => 'Chapter number';

  @override
  String get detailSortUploadDate => 'Upload date';

  @override
  String get detailLoginPageTitle => 'Login';

  @override
  String get detailRemovedFromLibrary => 'Removed from library';

  @override
  String get detailUndo => 'Undo';

  @override
  String detailQueuePosition(int position, int total) {
    return '$position of $total';
  }

  @override
  String get insightsTitle => 'Reading Insights';

  @override
  String get insightsEmptyTitle => 'Nothing to rank yet';

  @override
  String get insightsEmptyBody =>
      'Read a little and your most-read titles show up here.';

  @override
  String get insightsEstimatedFromHistory => 'Estimated from your history';

  @override
  String insightsTrackedSince(String month, String year) {
    return 'Tracked since $month $year';
  }

  @override
  String get insightsMonthJanuary => 'January';

  @override
  String get insightsMonthFebruary => 'February';

  @override
  String get insightsMonthMarch => 'March';

  @override
  String get insightsMonthApril => 'April';

  @override
  String get insightsMonthMay => 'May';

  @override
  String get insightsMonthJune => 'June';

  @override
  String get insightsMonthJuly => 'July';

  @override
  String get insightsMonthAugust => 'August';

  @override
  String get insightsMonthSeptember => 'September';

  @override
  String get insightsMonthOctober => 'October';

  @override
  String get insightsMonthNovember => 'November';

  @override
  String get insightsMonthDecember => 'December';

  @override
  String get repoNoTitlesToMigrate => 'No titles in this library to migrate.';

  @override
  String get repoChooseSourceFirst => 'Choose a source to migrate from first.';

  @override
  String get trackProviderClaudeDesc => 'Best for nuanced translation';

  @override
  String get trackProviderOpenaiDesc => 'Fast & accurate';

  @override
  String get trackProviderGeminiDesc => 'Multilingual specialist';

  @override
  String get trackProviderDeeplDesc => 'High-quality European languages';

  @override
  String get trackProviderHuggingfaceDesc => 'Open-source - Offline capable';

  @override
  String get trackProviderOpenrouterDesc =>
      'One key, many models - free tier available';

  @override
  String get trackBadgeRecommended => 'Recommended';

  @override
  String get trackBadgeOffline => 'Offline';

  @override
  String get trackBadgeFree => 'Free models';

  @override
  String get setdAppearanceSectionPalette => 'Palette';

  @override
  String get setdAppearanceThemeStrength => 'Theme color strength';

  @override
  String get setdAppearanceThemeStrengthDesc =>
      'How much the theme color takes over the app. 0 keeps the usual dark or light background; higher tints the whole app with the theme color.';

  @override
  String get setxBackupCreateComplete => 'Backup complete';

  @override
  String setxBackupCreateFailed(String error) {
    return 'Backup failed: $error';
  }

  @override
  String get setxBackupExportComplete => 'Export complete';

  @override
  String setxBackupExportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get setxBackupTargetApp => 'Target app';

  @override
  String get setxBackupIncludeLabel => 'Include';

  @override
  String get setxBackupTypeNovels => 'Light novels';

  @override
  String get setxBackupAutoTag => 'auto';

  @override
  String get setdDownloadsChaptersAhead => 'Chapters ahead';

  @override
  String get setdLibraryNoItemsToRefresh => 'No library items to refresh';

  @override
  String get setdLibraryRefreshingCovers => 'Refreshing covers';

  @override
  String get setdLibraryCoverRefreshStopped => 'Cover refresh stopped';

  @override
  String setdLibraryCoversRefreshed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Refreshed $count covers',
      one: 'Refreshed 1 cover',
    );
    return '$_temp0';
  }

  @override
  String get setdLibrarySectionContinueReading => 'Continue reading';

  @override
  String get setdLibraryContinueShowAs => 'Show as';

  @override
  String get setdLibraryDefaultCategory => 'Default category';

  @override
  String get setdLibraryAlwaysAsk => 'Always ask';

  @override
  String get setdLibrarySkipHasUnread => 'Skip titles with unread chapters';

  @override
  String get setdLibrarySkipHasUnreadDesc =>
      'Don\'t check titles you haven\'t caught up on yet';

  @override
  String get setdLibrarySkipCompleted => 'Skip completed series';

  @override
  String get setdLibrarySkipCompletedDesc =>
      'Finished series won\'t get new chapters';

  @override
  String get setdLibraryRefreshCovers => 'Refresh library covers';

  @override
  String get setdLibraryRefreshCoversDesc => 'Fetch covers again from source';

  @override
  String get setdActionMove => 'Move';

  @override
  String get setdActionConfirm => 'Confirm';

  @override
  String get setdActionRemove => 'Remove';

  @override
  String get setdActionUndo => 'Undo';

  @override
  String get setxSecurityLockAfterTitle => 'Lock after';

  @override
  String get setxSecurityLockAfterSubtitle =>
      'Wait this long before re-locking on reopen';

  @override
  String get setxSecurityLockAfterImmediately => 'Immediately';

  @override
  String setxSecurityLockAfterMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String get setdVaultChangeDecoyPassword => 'Change decoy password';

  @override
  String get setdVaultSetDecoyPassword => 'Set decoy password';

  @override
  String get setdVaultDecoyPasswordDesc =>
      'A second password that opens a separate, empty-looking vault';

  @override
  String get setdVaultBiometricUnlock => 'Unlock with biometrics';

  @override
  String get setdVaultBiometricDesc =>
      'Use Face ID / fingerprint to open the vault';

  @override
  String get setdVaultConfirmPasswordTitle => 'Confirm vault password';

  @override
  String get setdVaultBiometricEnabled => 'Biometric unlock enabled';

  @override
  String get setdVaultShakeToExit => 'Shake to exit';

  @override
  String get setdVaultShakeToExitDesc =>
      'While in the vault, shake the phone to instantly leave it';

  @override
  String get setdVaultLibraryMoveAction => 'Move-to-vault in library';

  @override
  String get setdVaultLibraryMoveActionDesc =>
      'Add a \"Move to vault\" action when selecting titles in your library';

  @override
  String get setdVaultPasswordHint => 'Password';

  @override
  String get setdVaultDecoyPasswordDialogTitle => 'Decoy password';

  @override
  String get setdVaultDecoyPasswordExplain =>
      'Entering this instead of your real password opens a separate, isolated vault - so you can hand over the phone without revealing your real content.';

  @override
  String get setdVaultDecoyPasswordHint => 'Decoy password';

  @override
  String get setdVaultEnterPassword => 'Enter a password';

  @override
  String get setdVaultDecoyPasswordSet => 'Decoy password set';

  @override
  String get setdVaultDecoyMustDiffer => 'Must differ from your real password';

  @override
  String setdVaultContentsMovedInCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Moved $count to vault',
      one: 'Moved 1 to vault',
    );
    return '$_temp0';
  }

  @override
  String setdVaultContentsMovedOutCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Moved $count out of vault',
      one: 'Moved 1 out of vault',
    );
    return '$_temp0';
  }

  @override
  String setdVaultContentsMoveConfirmTitle(String what) {
    return 'Move $what?';
  }

  @override
  String setdVaultContentsMoveConfirmBody(int count, String dest, String into) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Move $count titles to $dest$into?',
      one: 'Move 1 title to $dest$into?',
    );
    return '$_temp0';
  }

  @override
  String get setdVaultContentsDestVault => 'the vault';

  @override
  String get setdVaultContentsDestLibrary => 'your library';

  @override
  String setdVaultContentsIntoCategory(String name) {
    return ' → \"$name\"';
  }

  @override
  String setdVaultContentsMoveAllShown(int count) {
    return 'all $count shown';
  }

  @override
  String setdVaultContentsMoveEverythingIn(String name) {
    return 'everything in \"$name\"';
  }

  @override
  String get setdVaultContentsNoMatches => 'No matches';

  @override
  String get setdVaultContentsDone => 'Done';

  @override
  String get setdVaultContentsSelect => 'Select';

  @override
  String get setdVaultContentsDirToVault => 'To Vault';

  @override
  String get setdVaultContentsDirFromVault => 'From Vault';

  @override
  String get setdVaultContentsSearchHint => 'Search titles';

  @override
  String get setdVaultContentsMoveCategoryTooltip => 'Move a category';

  @override
  String get setdVaultContentsMoveAllToVault => 'Move all to vault';

  @override
  String get setdVaultContentsMoveAllOut => 'Move all out';

  @override
  String get setdVaultContentsSelectNone => 'None';

  @override
  String get setdVaultContentsSelectAll => 'All';

  @override
  String setdVaultContentsSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected',
      one: '1 selected',
    );
    return '$_temp0';
  }

  @override
  String get setdVaultContentsMoveToVault => 'Move to vault';

  @override
  String get setdVaultContentsMoveOut => 'Move out';

  @override
  String get setdVaultContentsPickSourceLibrary =>
      'Move which library category?';

  @override
  String get setdVaultContentsPickSourceVault => 'Move which vault category?';

  @override
  String get setdVaultContentsPickDestVault => 'Into which vault category?';

  @override
  String get setdVaultContentsPickDestLibrary => 'Into which library category?';

  @override
  String get setdVaultContentsNoCategoriesToPick =>
      'No categories to pick from.';

  @override
  String get setdVaultContentsNoCategory => 'No category';

  @override
  String setdVaultContentsNothingIn(String name) {
    return 'Nothing in \"$name\"';
  }

  @override
  String get settingsHelpSubtitle => 'Tutorial, Discord & quick tips';

  @override
  String get dictNetworkError =>
      'Couldn\'t reach the dictionary. Check your connection and try again.';

  @override
  String dictNoDefinition(String word) {
    return 'No definition found for \"$word\".';
  }

  @override
  String get readerAlignment => 'Alignment';

  @override
  String get readerBrightness => 'Brightness';

  @override
  String readerCalibrateSampleLine(int n) {
    return 'Sample line $n';
  }

  @override
  String get readerChapterArrowsSubtitle =>
      'Prev / next chapter beside the page slider';

  @override
  String get readerChapterArrowsTitle => 'Chapter arrows on the slider';

  @override
  String get readerCustomizeMenu => 'Customize menu';

  @override
  String get readerCustomizeMenuMangaSubtitle =>
      'Choose and reorder the manga actions';

  @override
  String get readerCustomizeMenuNovelSubtitle =>
      'Choose and reorder the light novel actions';

  @override
  String get readerDoublePages => 'Double pages';

  @override
  String get readerDoublePagesSubtitle =>
      'Show two pages side-by-side when the phone is in landscape (page-by-page modes only)';

  @override
  String get readerHandsFreeIntro =>
      'Scroll or turn pages without touching the screen. These share one scroll input, so turning one on turns the others off.';

  @override
  String get readerHandsFreeMotion => 'Hands-free & motion';

  @override
  String get readerHandsFreeMotionSubtitle =>
      'Volume buttons, tilt and gaze scrolling';

  @override
  String get readerHyphenation => 'Hyphenation';

  @override
  String get readerHyphenationSubtitle =>
      'Break long words to even out justified lines';

  @override
  String get readerLightNovel => 'Light novel';

  @override
  String get readerLightNovelMenu => 'Light novel menu';

  @override
  String get readerLineSpacing => 'Line spacing';

  @override
  String get readerManga => 'Manga';

  @override
  String get readerMangaMenu => 'Manga menu';

  @override
  String get readerMargins => 'Margins';

  @override
  String get readerMenuStyle => 'Menu style';

  @override
  String get readerMenuStyleTail => 'Tail';

  @override
  String get readerMenuStyleWheel => 'Wheel';

  @override
  String get readerModeLtrShort => 'LTR';

  @override
  String get readerModeRtlShort => 'RTL';

  @override
  String get readerModeVerticalShort => 'Vertical';

  @override
  String get readerNovelLayoutPaged => 'Paged';

  @override
  String get readerNovelLayoutScroll => 'Scroll';

  @override
  String get readerNovelRadialMenuSubtitle =>
      'Use the wheel in the novel reader (off = classic bars)';

  @override
  String get readerPitch => 'Pitch';

  @override
  String readerRadialReorderHint(int count) {
    return 'Drag to reorder the wheel; toggle to show or hide. $count shown.';
  }

  @override
  String get readerReaderTheme => 'Reader theme';

  @override
  String get readerReset => 'Reset';

  @override
  String get readerSectionEyeComfort => 'Eye comfort';

  @override
  String get readerSectionImage => 'Image';

  @override
  String get readerSectionLayout => 'Layout';

  @override
  String get readerSectionListen => 'Listen (text to speech)';

  @override
  String get readerSectionText => 'Text';

  @override
  String get readerSentenceHighlight => 'Sentence highlight';

  @override
  String get readerSettingsFor => 'Settings for';

  @override
  String get readerSideLeft => 'Left';

  @override
  String get readerSideRight => 'Right';

  @override
  String get readerSplitWidePages => 'Split wide pages';

  @override
  String get readerSplitWidePagesSubtitle =>
      'Give a wide double-page spread its own screen instead of pairing it with another page';

  @override
  String get readerTextSize => 'Text size';

  @override
  String get readerVolumeAutoScroll => 'Volume sets auto-scroll speed';

  @override
  String get readerVolumeAutoScrollSubtitle =>
      'While the manga reader auto-scrolls, the volume buttons speed it up or slow it down. They do not turn pages.';

  @override
  String get readerVolumeButtons => 'Volume buttons';

  @override
  String get readerWarmFilter => 'Warm filter';

  @override
  String get readerWordHighlight => 'Word highlight';

  @override
  String get libraryUpdateTitle => 'Library update';

  @override
  String libraryUpdateCounts(int completed, int skipped, int failed) {
    return '$completed completed · $skipped skipped · $failed failed';
  }

  @override
  String libraryNewChaptersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new chapters',
      one: '1 new chapter',
    );
    return '$_temp0';
  }

  @override
  String get libraryUpToDate => 'Up to date';

  @override
  String get librarySkipped => 'Skipped';

  @override
  String libraryUpdateCount(int count) {
    return 'Update $count';
  }

  @override
  String libraryStatusTapUpdate(String status) {
    return '$status · tap Update to force';
  }

  @override
  String libraryStatusNoNewChapters(String status) {
    return '$status · no new chapters expected';
  }

  @override
  String get libraryUpdateThisTitle => 'Update this title';

  @override
  String get libraryFailed => 'Failed';

  @override
  String get libraryRetryAll => 'Retry all';

  @override
  String get libraryUpdateFailedTapOpen => 'Update failed · tap to open';

  @override
  String get libraryRetryThisTitle => 'Retry this title';

  @override
  String get libraryNoTitlesChecked => 'No titles were checked.';

  @override
  String libraryCategoryWithCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String libraryEntriesWithNewChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries have new chapters.',
      one: '1 entry has new chapters.',
    );
    return '$_temp0';
  }

  @override
  String get libraryUnlockVaultFirst =>
      'Unlock the vault first to move titles into it';

  @override
  String get libraryCouldNotMoveToVault => 'Could not move to vault';

  @override
  String get libraryCouldNotMoveOutOfVault => 'Could not move out of vault';

  @override
  String libraryMovedToVault(int count) {
    return 'Moved $count to vault';
  }

  @override
  String libraryMovedOutOfVault(int count) {
    return 'Moved $count out of vault';
  }

  @override
  String get libraryMoveOut => 'Move out';

  @override
  String get libraryToVault => 'To vault';

  @override
  String get libraryUpdateComplete => 'Update complete';

  @override
  String libraryUpdatingProgress(String title, int checked, int total) {
    return 'Updating $title  $checked/$total';
  }

  @override
  String get libraryUpdating => 'Updating…';

  @override
  String get libraryTapRetryUpdateSkipped => 'Tap to retry / update skipped';

  @override
  String get librarySortBy => 'Sort by';

  @override
  String get libraryCoverTitle => 'Cover title';

  @override
  String get libraryBadgePlacement => 'Badge placement';

  @override
  String get libraryReadingProgress => 'Reading progress';

  @override
  String get libraryLanguage => 'Language';

  @override
  String get libraryLocal => 'Local';

  @override
  String get libraryFilterShowOnly => 'show only';

  @override
  String get libraryFilterHide => 'hide';

  @override
  String get libraryArchetypeNewcomer => 'The Newcomer';

  @override
  String get libraryArchetypeNewcomerDesc =>
      'Just getting started - your type sharpens as you read.';

  @override
  String get libraryArchetypeOmnivore => 'The Omnivore';

  @override
  String get libraryArchetypeOmnivoreDesc =>
      'A bit of everything - manga, anime and novels all in rotation.';

  @override
  String get libraryArchetypeBinger => 'The Binger';

  @override
  String get libraryArchetypeBingerDesc =>
      'You tear through chapters in long sittings.';

  @override
  String get libraryArchetypeCompletionist => 'The Completionist';

  @override
  String get libraryArchetypeCompletionistDesc =>
      'You go deep - few series at a time, read to the end.';

  @override
  String get libraryArchetypeDevoted => 'The Devoted';

  @override
  String get libraryArchetypeDevotedDesc =>
      'Day after day - you keep a steady habit.';

  @override
  String get libraryArchetypeExplorer => 'The Explorer';

  @override
  String get libraryArchetypeExplorerDesc =>
      'Always something new - you spread across many series.';

  @override
  String libraryChaptersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chapters',
      one: '1 chapter',
    );
    return '$_temp0';
  }

  @override
  String libraryBestStreakDays(int days) {
    return '$days-day best streak';
  }

  @override
  String librarySeriesCount(int count) {
    return '$count series';
  }

  @override
  String get libraryReadingActivity => 'Reading activity';

  @override
  String get libraryChaptersPerDayHint =>
      'Chapters read each day - brighter = more.';

  @override
  String get libraryByType => 'Library by type';

  @override
  String get libraryByStatus => 'Library by status';

  @override
  String get libraryBacklog => 'Backlog';

  @override
  String libraryWaitingCount(int count) {
    return '$count waiting';
  }

  @override
  String get libraryAddedNeverStarted => 'Added but never started';

  @override
  String get libraryNothingWaiting =>
      'Nothing waiting - you\'ve started everything.';

  @override
  String get libraryMilestones => 'Milestones';

  @override
  String get libraryReadingPersonality => 'Reading personality';

  @override
  String get libraryTotalTimeRead => 'Total time read · tap for breakdown';

  @override
  String get libraryStatTitles => 'Titles';

  @override
  String get libraryStatChaptersRead => 'Chapters read';

  @override
  String get libraryStatDayStreak => 'Day streak';

  @override
  String libraryActivitySummary(int activeDays, int chapters) {
    return 'You read on $activeDays of the last 35 days · $chapters chapters this week.';
  }

  @override
  String libraryTrendVsLastWeek(int pct) {
    return '$pct% vs last week';
  }

  @override
  String get libraryStatusOther => 'Other';

  @override
  String libraryMostReadGenre(String genre) {
    return 'Most-read genre · $genre';
  }

  @override
  String get libraryContentWordManga => 'manga';

  @override
  String get libraryContentWordAnime => 'anime';

  @override
  String get libraryContentWordLightNovels => 'light novels';

  @override
  String libraryBacklogAddedAge(String age, String type) {
    return 'Added $age · $type';
  }

  @override
  String get libraryStart => 'Start';

  @override
  String get libraryAllMilestonesUnlocked => 'All milestones unlocked 🎉';

  @override
  String get libraryNextUp => 'NEXT UP';

  @override
  String get libraryYourReadingType => 'YOUR READING TYPE';

  @override
  String get libraryAxisVolume => 'Volume';

  @override
  String get libraryAxisDepth => 'Depth';

  @override
  String get libraryAxisConsistency => 'Consist.';

  @override
  String get libraryAxisBreadth => 'Breadth';

  @override
  String get libraryAxisVariety => 'Variety';

  @override
  String get libraryUnitChapters => 'ch';

  @override
  String get libraryUnitHours => 'h';

  @override
  String get libraryUnitDays => 'days';

  @override
  String get libraryUnitTitles => 'titles';

  @override
  String get libraryUnitSources => 'sources';

  @override
  String get libraryUnitFormats => 'formats';

  @override
  String get libraryUnitEpisodes => 'ep';

  @override
  String get libraryBadgeFirstSteps => 'First Steps';

  @override
  String get libraryBadgeFirstStepsDesc => 'Read your first chapter.';

  @override
  String get libraryBadgeGettingStarted => 'Getting Started';

  @override
  String get libraryBadgeGettingStartedDesc => 'Read 10 chapters.';

  @override
  String get libraryBadgeBookworm => 'Bookworm';

  @override
  String get libraryBadgeBookwormDesc => 'Read 50 chapters.';

  @override
  String get libraryBadgeCenturion => 'Centurion';

  @override
  String get libraryBadgeCenturionDesc => 'Read 100 chapters.';

  @override
  String get libraryBadgeDevourer => 'Devourer';

  @override
  String get libraryBadgeDevourerDesc => 'Read 250 chapters.';

  @override
  String get libraryBadgeQuincentenary => 'Quincentenary';

  @override
  String get libraryBadgeQuincentenaryDesc => 'Read 500 chapters.';

  @override
  String get libraryBadgeMarathoner => 'Marathoner';

  @override
  String get libraryBadgeMarathonerDesc => 'Read 1,000 chapters.';

  @override
  String get libraryBadgeChapterFiend => 'Chapter Fiend';

  @override
  String get libraryBadgeChapterFiendDesc => 'Read 2,500 chapters.';

  @override
  String get libraryBadgeLoremaster => 'Loremaster';

  @override
  String get libraryBadgeLoremasterDesc => 'Read 5,000 chapters.';

  @override
  String get libraryBadgeTenThousandClub => 'Ten-Thousand Club';

  @override
  String get libraryBadgeTenThousandClubDesc => 'Read 10,000 chapters.';

  @override
  String get libraryBadgeFirstHour => 'First Hour';

  @override
  String get libraryBadgeFirstHourDesc => 'Spend 1 hour reading.';

  @override
  String get libraryBadgeGettingComfortable => 'Getting Comfortable';

  @override
  String get libraryBadgeGettingComfortableDesc => 'Spend 10 hours reading.';

  @override
  String get libraryBadgeWeekendLost => 'Weekend Lost';

  @override
  String get libraryBadgeWeekendLostDesc => 'Spend 50 hours reading.';

  @override
  String get libraryBadgeDedicated => 'Dedicated';

  @override
  String get libraryBadgeDedicatedDesc => 'Spend 100 hours reading.';

  @override
  String get libraryBadgeTimeSink => 'Time Sink';

  @override
  String get libraryBadgeTimeSinkDesc => 'Spend 250 hours reading.';

  @override
  String get libraryBadgeImmersed => 'Immersed';

  @override
  String get libraryBadgeImmersedDesc => 'Spend 500 hours reading.';

  @override
  String get libraryBadgeEternal => 'Eternal';

  @override
  String get libraryBadgeEternalDesc => 'Spend 1,000 hours reading.';

  @override
  String get libraryBadgeWarmingUp => 'Warming Up';

  @override
  String get libraryBadgeWarmingUpDesc => 'Read 3 days in a row.';

  @override
  String get libraryBadgeHotStreak => 'Hot Streak';

  @override
  String get libraryBadgeHotStreakDesc => 'Read 7 days in a row.';

  @override
  String get libraryBadgeFortnight => 'Fortnight';

  @override
  String get libraryBadgeFortnightDesc => 'Read 14 days in a row.';

  @override
  String get libraryBadgeDevoted => 'Devoted';

  @override
  String get libraryBadgeDevotedDesc => 'Read 30 days in a row.';

  @override
  String get libraryBadgeStarterShelf => 'Starter Shelf';

  @override
  String get libraryBadgeStarterShelfDesc => 'Collect 10 titles.';

  @override
  String get libraryBadgeBibliophile => 'Bibliophile';

  @override
  String get libraryBadgeBibliophileDesc => 'Collect 50 titles.';

  @override
  String get libraryBadgeCurator => 'Curator';

  @override
  String get libraryBadgeCuratorDesc => 'Collect 100 titles.';

  @override
  String get libraryBadgeArchivist => 'Archivist';

  @override
  String get libraryBadgeArchivistDesc => 'Collect 250 titles.';

  @override
  String get libraryBadgeExplorer => 'Explorer';

  @override
  String get libraryBadgeExplorerDesc => 'Read from 5 sources.';

  @override
  String get libraryBadgeGlobetrotter => 'Globetrotter';

  @override
  String get libraryBadgeGlobetrotterDesc => 'Read from 15 sources.';

  @override
  String get libraryBadgeBoundless => 'Boundless';

  @override
  String get libraryBadgeBoundlessDesc => 'Read from 30 sources.';

  @override
  String get libraryBadgeDabbler => 'Dabbler';

  @override
  String get libraryBadgeDabblerDesc => 'Read 2 different formats.';

  @override
  String get libraryBadgeOmnivore => 'Omnivore';

  @override
  String get libraryBadgeOmnivoreDesc => 'Read all 3 formats.';

  @override
  String get libraryBadgeMangaDevotee => 'Manga Devotee';

  @override
  String get libraryBadgeMangaDevoteeDesc => 'Read 500 manga chapters.';

  @override
  String get libraryBadgeBingeWatcher => 'Binge Watcher';

  @override
  String get libraryBadgeBingeWatcherDesc => 'Watch 250 anime episodes.';

  @override
  String get libraryBadgeNovelNerd => 'Novel Nerd';

  @override
  String get libraryBadgeNovelNerdDesc => 'Read 250 novel chapters.';

  @override
  String get discoverGenres => 'Genres';

  @override
  String get discoverRemovedFromWishlist => 'Removed from wishlist';

  @override
  String get discoverRemove => 'Remove';

  @override
  String get novelDefine => 'Define';

  @override
  String get novelTts => 'Text-to-speech';

  @override
  String get novelVoice => 'Voice';

  @override
  String get novelVoiceSystemDefault => 'System default';

  @override
  String get novelVoiceEngine => 'Voice engine (experimental)';

  @override
  String get novelVoiceDevice => 'Device';

  @override
  String get novelSearchVoices => 'Search voices';

  @override
  String get novelResetPill => 'Reset pill position';

  @override
  String get novelMoreVoices => 'More voices & tuning →';

  @override
  String get novelActionSize => 'Size';

  @override
  String get novelActionTheme => 'Theme';

  @override
  String get novelActionAlign => 'Align';

  @override
  String get novelActionSpacing => 'Spacing';

  @override
  String get novelActionListen => 'Listen';

  @override
  String get novelHighlightColours => 'Highlight colours';

  @override
  String get novelHighlightSentence => 'Sentence';

  @override
  String get novelHighlightWord => 'Word';

  @override
  String get readerExperimentalOnIos => 'Experimental no iOS';

  @override
  String get readerIosVolumeWarning =>
      'O iOS não tem uma API adequada para os botões de volume, então isso funciona monitorando o volume do sistema — pode apresentar falhas. Durante a leitura, o volume do que você estiver ouvindo (música, podcast) ficará fixo em 50% e não poderá ser alterado. Ativar mesmo assim?';

  @override
  String get readerCancel => 'Cancelar';

  @override
  String get readerEnable => 'Ativar';

  @override
  String get readerTitle => 'Leitor';

  @override
  String get readerPreferences => 'Preferências';

  @override
  String get readerReadingMode => 'Modo de Leitura';

  @override
  String get readerFontSize => 'Tamanho da Fonte';

  @override
  String get readerAutoPreloadNextChapter => 'Pré-carregar Próximo Capítulo';

  @override
  String get readerAutoPreloadNextChapterSubtitle =>
      'Carregar o próximo capítulo em segundo plano';

  @override
  String get readerGrayscale => 'Escala de Cinza';

  @override
  String get readerGrayscaleSubtitle => 'Exibir páginas em escala de cinza';

  @override
  String get readerAutoCrop => 'Auto-crop borders';

  @override
  String get readerAutoScroll => 'Auto-scroll';

  @override
  String get readerAutoScrollSpeed => 'Auto-scroll speed';

  @override
  String get readerFilterReset => 'Reset';

  @override
  String get readerFilterPaper => 'Paper';

  @override
  String get readerFilterNight => 'Night';

  @override
  String get readerFilterVivid => 'Vivid';

  @override
  String get readerFilterSepia => 'Sepia';

  @override
  String get readerFilterContrast => 'Contrast';

  @override
  String get readerFilterSaturation => 'Saturation';

  @override
  String get readerEyeComfort => 'Eye comfort';

  @override
  String get readerEyeComfortWarm => 'Warm';

  @override
  String get readerEyeComfortBrightness => 'Brightness';

  @override
  String get readerGazeModeEyes => 'Eyes';

  @override
  String get readerGazeModeHead => 'Head';

  @override
  String get readerGazeModeBoth => 'Both';

  @override
  String get readerAutoCropSubtitle =>
      'Trim solid white/black margins so pages fill the screen';

  @override
  String get readerInvertColors => 'Inverter Cores';

  @override
  String get readerInvertColorsSubtitle => 'Trocar cores claras e escuras';

  @override
  String get readerDisplay => 'Exibição';

  @override
  String get readerScaleType => 'Tipo de Escala';

  @override
  String get readerBackgroundColor => 'Cor de Fundo';

  @override
  String get readerKeepScreenOn => 'Manter Tela Ligada';

  @override
  String get readerKeepScreenOnSubtitle => 'Impedir que a tela apague';

  @override
  String get readerShowPageNumber => 'Mostrar Número da Página';

  @override
  String get readerShowPageNumberSubtitle =>
      'Exibir indicador de página na tela';

  @override
  String get readerFullscreen => 'Tela Cheia';

  @override
  String get readerFullscreenSubtitle =>
      'Ocultar barras do sistema durante a leitura';

  @override
  String get readerNavigation => 'Navegação';

  @override
  String get readerNavigationLayout => 'Layout de Navegação';

  @override
  String get readerInvertTapZones => 'Inverter Zonas de Toque';

  @override
  String get readerInvertTapZonesSubtitle =>
      'Trocar navegação por toque esquerda/direita';

  @override
  String get readerVolumeKeys => 'Botões de Volume';

  @override
  String get readerVolumeKeysSubtitle =>
      'Toque para virar a página/rolar; segure para rolar (webtoon)';

  @override
  String get readerHoldScrollSpeed => 'Velocidade da Rolagem Contínua';

  @override
  String get readerSourceNotInstalled => 'Fonte não instalada';

  @override
  String get readerSourceNotInstalledHint =>
      'This title\'s source isn\'t installed — this can happen after restoring a backup. Install it from Extensions, then try again.';

  @override
  String get readerTranslating => 'Traduzindo…';

  @override
  String get readerRetry => 'Tentar novamente';

  @override
  String get readerPageShare => 'Share';

  @override
  String get readerPageSave => 'Save image';

  @override
  String get readerPageSetCover => 'Set as cover';

  @override
  String get readerPageRecognizeText => 'Recognize text';

  @override
  String get readerPageSaved => 'Saved to gallery';

  @override
  String get readerPageSaveFailed => 'Couldn\'t save the image';

  @override
  String get readerPageCoverSet => 'Cover updated';

  @override
  String get readerPageCoverNeedsLibrary =>
      'Add this title to your library first';

  @override
  String get readerPageImageUnavailable => 'Image isn\'t available yet';

  @override
  String get readerPageOcrTitle => 'Recognized text';

  @override
  String get readerPageOcrEmpty => 'No text found on this page';

  @override
  String get readerPageOcrCopy => 'Copy';

  @override
  String get readerLoadingNextChapter => 'Carregando próximo capítulo...';

  @override
  String get readerAllCaughtUp => 'Você está em dia!';

  @override
  String get readerEndOfChapter => 'Fim do Capítulo';

  @override
  String get readerLatestChapterAvailable =>
      'Este é o capítulo mais recente disponível.';

  @override
  String get readerLoadNextChapter => 'Carregar Próximo Capítulo';

  @override
  String get readerBack => 'Voltar';

  @override
  String get readerSettings => 'Configurações';

  @override
  String get readerAiTranslate => 'Traduzir com IA';

  @override
  String get readerPreviousChapter => 'Capítulo anterior';

  @override
  String get readerBookmark => 'Favoritar';

  @override
  String get readerNextChapter => 'Próximo capítulo';

  @override
  String readerTranslationFailed(Object error) {
    return 'Falha na tradução: $error';
  }

  @override
  String get readerModeLtrLabel => 'Esquerda para Direita';

  @override
  String get readerModeRtlLabel => 'Direita para Esquerda';

  @override
  String get readerModeVerticalLabel => 'Rolagem Contínua';

  @override
  String get readerModeWebtoonLabel => 'Webtoon';

  @override
  String get readerModeLtrSubtitle =>
      'Toque à esquerda/direita para virar as páginas';

  @override
  String get readerModeRtlSubtitle =>
      'Estilo mangá, da direita para a esquerda';

  @override
  String get readerModeVerticalSubtitle => 'Role verticalmente pelas páginas';

  @override
  String get readerModeWebtoonSubtitle =>
      'Otimizado para tiras verticais longas';

  @override
  String get readerChapters => 'Capítulos';

  @override
  String readerPageOf(int current, int total) {
    return 'Página $current de $total';
  }

  @override
  String get readerTabProvider => 'Provedor';

  @override
  String get readerTabTarget => 'Destino';

  @override
  String get readerTabSource => 'Origem';

  @override
  String get readerTabFont => 'Fonte';

  @override
  String get readerFontNormal => 'Normal';

  @override
  String get readerFontManga => 'Mangá';

  @override
  String get readerFontNormalDesc => 'Sans-serif limpa';

  @override
  String get readerFontMangaDesc => 'Estilo de quadrinhos em negrito';

  @override
  String get readerFontSample => 'Olá Mundo';

  @override
  String get readerNoChapterText => 'Nenhum texto de capítulo encontrado';

  @override
  String get readerReadingTitle => 'Lendo';

  @override
  String get readerSmallerText => 'Texto menor';

  @override
  String get readerLargerText => 'Texto maior';

  @override
  String get readerPrevious => 'Anterior';

  @override
  String get readerNext => 'Próximo';

  @override
  String get browseTitle => 'Explorar';

  @override
  String get browseGlobalSearch => 'Busca global';

  @override
  String get browseRefreshingRepos => 'Atualizando repositórios...';

  @override
  String get browseRefreshRepos => 'Atualizar repositórios';

  @override
  String get browseSearch => 'Buscar';

  @override
  String get browseAddRepo => 'Adicionar repositório';

  @override
  String get browseTabSources => 'Fontes';

  @override
  String get browseTabExtensions => 'Extensões';

  @override
  String get browseTabLocal => 'Local';

  @override
  String get browseSearchHint => 'Buscar extensões e fontes...';

  @override
  String browseRemoveSourceConfirm(Object name) {
    return 'Remover $name?';
  }

  @override
  String get browseRemoveSourceDesc =>
      'A fonte será desinstalada. Os itens da sua biblioteca vindos dela são mantidos, mas você não poderá abri-los até reinstalá-la.';

  @override
  String get browseCancel => 'Cancelar';

  @override
  String get browseRemove => 'Remover';

  @override
  String get browseProvidedByThisSource => 'FORNECIDO POR ESTA FONTE';

  @override
  String get browseCouldNotLoadOptions =>
      'Não foi possível carregar as opções da fonte';

  @override
  String get browseNoSourceOptions =>
      'Esta fonte não define opções próprias. As configurações acima ainda se aplicam a ela.';

  @override
  String get browseBaseUrl => 'URL base';

  @override
  String get browseUsingSourceDefault => 'Usando o padrão da fonte';

  @override
  String browseBaseUrlDefault(Object url) {
    return '$url  (padrão)';
  }

  @override
  String get browseResetToDefault => 'Restaurar padrão';

  @override
  String get browsePinToTop => 'Fixar no topo';

  @override
  String get browsePinToTopDesc =>
      'Mostrar esta fonte primeiro na lista de fontes';

  @override
  String get browseSkipGlobalSearch => 'Ignorar na busca global';

  @override
  String get browseSkipGlobalSearchDesc =>
      'Deixar esta fonte de fora ao buscar em tudo';

  @override
  String get browseSkipLibraryUpdates =>
      'Ignorar nas atualizações da biblioteca';

  @override
  String get browseSkipLibraryUpdatesDesc =>
      'Não verificar novos capítulos nesta fonte';

  @override
  String get browseRequestDesktopSite => 'Solicitar versão para computador';

  @override
  String get browseRequestDesktopSiteDesc =>
      'Tente isto se a fonte não encontrar nada ou não mostrar capítulos — alguns sites enviam uma página reduzida para celulares';

  @override
  String get browseSave => 'Salvar';

  @override
  String get browseNone => 'Nenhum';

  @override
  String browseSelectedCount(Object count) {
    return '$count selecionado(s)';
  }

  @override
  String get browseNotSet => 'Não definido';

  @override
  String get browseIosFolderWarning =>
      'O iOS não permite que aplicativos mantenham acesso a uma pasta. Use \"Importar Arquivo\" para adicionar .cbz/.cbr/.zip/.epub/.pdf.';

  @override
  String browseImportedFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos importados',
      one: '1 arquivo importado',
    );
    return '$_temp0';
  }

  @override
  String get browseNothingImported =>
      'Nada importado (não suportado ou ilegível)';

  @override
  String browseFolderCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pastas',
      one: '1 pasta',
    );
    return '$_temp0';
  }

  @override
  String get browseManageFolders => 'Gerenciar pastas';

  @override
  String get browseImportFileTooltip => 'Importar arquivo (CBZ/ZIP/EPUB/PDF)';

  @override
  String get browseAddFolder => 'Adicionar pasta';

  @override
  String get browseRescan => 'Reescanear';

  @override
  String get browseNothingImportedYet => 'Nada importado ainda';

  @override
  String get browseNoLocalSources => 'Nenhuma fonte local';

  @override
  String get browseLocalSourcesDesc =>
      'Adicione uma pasta de mangás ou importe um único arquivo.\nSuportados: imagens (JPG, PNG, WebP, GIF), CBZ/ZIP, EPUB e PDF.\n(CBR/RAR apenas se o arquivo for realmente compactado em ZIP — RAR de verdade não é suportado.)';

  @override
  String get browseAddFolderButton => 'Adicionar Pasta';

  @override
  String get browseImportFile => 'Importar Arquivo';

  @override
  String get browseLocalSourceFolders => 'Pastas de Fontes Locais';

  @override
  String get browseNoFoldersAdded => 'Nenhuma pasta adicionada';

  @override
  String browseChaptersAbbrev(Object n) {
    return '$n cap';
  }

  @override
  String get browseInstalled => 'INSTALADAS';

  @override
  String get browseAvailable => 'DISPONÍVEIS';

  @override
  String get browseSourceNotInstalled => 'A fonte não está instalada';

  @override
  String get browseManga => 'Mangá';

  @override
  String get browseAnime => 'Anime';

  @override
  String get browseNovels => 'Novels';

  @override
  String get browseAllLanguages => 'Todos os idiomas';

  @override
  String get browseFilter => 'Filtrar';

  @override
  String browseLanguagesCount(Object count) {
    return '$count idiomas';
  }

  @override
  String get browseFilterRepository => 'Repository';

  @override
  String get browseAllRepositories => 'All repositories';

  @override
  String browseReposCount(Object count) {
    return '$count repositories';
  }

  @override
  String browseResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count resultados',
      one: '1 resultado',
    );
    return '$_temp0';
  }

  @override
  String get browseNoExtensions => 'Nenhuma extensão ainda';

  @override
  String get browseNoExtensionsDesc =>
      'Adicione um repositório usando o botão de\nconfigurações acima para explorar extensões.';

  @override
  String browseUpdatedSources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fontes atualizadas',
      one: '1 fonte atualizada',
    );
    return '$_temp0';
  }

  @override
  String get browseSourceUpdated => 'Fonte atualizada';

  @override
  String get browseNoUpdateAvailable => 'Nenhuma atualização disponível';

  @override
  String browseUpdateFailed(Object error) {
    return 'Falha na atualização: $error';
  }

  @override
  String browseRefreshFailed(Object error) {
    return 'Falha ao atualizar: $error';
  }

  @override
  String browseUpdatesAvailable(Object count) {
    return 'ATUALIZAÇÕES DISPONÍVEIS ($count)';
  }

  @override
  String get browseUpdateAll => 'Atualizar tudo';

  @override
  String get browseUpdate => 'Atualizar';

  @override
  String get browseSettings => 'Configurações';

  @override
  String get browseInstall => 'Instalar';

  @override
  String get browseInstalledBadge => 'Instalada';

  @override
  String get browseAbout => 'SOBRE';

  @override
  String browseSourceFrom(Object url) {
    return 'Fonte de $url';
  }

  @override
  String browseLanguageLabel(Object lang) {
    return 'Idioma: $lang';
  }

  @override
  String get browseUsesCloudflare => 'Usa proteção Cloudflare';

  @override
  String get browseNoCloudflare => 'Sem Cloudflare';

  @override
  String get browseAdultContent => 'Conteúdo 18+';

  @override
  String get browseSafeForWork => 'Seguro para o trabalho';

  @override
  String get browseFeatures => 'RECURSOS';

  @override
  String get browsePopular => 'Populares';

  @override
  String get browseLatest => 'Recentes';

  @override
  String browseSourceAction(Object name) {
    return 'Explorar $name';
  }

  @override
  String get browseRemoving => 'Removendo...';

  @override
  String get browseInstalling => 'Instalando...';

  @override
  String browseFailed(Object error) {
    return 'Falhou: $error';
  }

  @override
  String get browseNoLanguagesMatch => 'No languages match';

  @override
  String get browseYourLanguages => 'Your languages';

  @override
  String get browseSearchLanguages => 'Search languages';

  @override
  String get browseUpdating => 'Atualizando...';

  @override
  String get browseUpdateExtensionCode => 'Atualizar código da extensão';

  @override
  String browseUpdatedSource(Object name) {
    return '$name atualizada';
  }

  @override
  String get browsePinned => 'FIXADAS';

  @override
  String get browseAll => 'Todas';

  @override
  String get browseNoInstalledSources => 'Nenhuma fonte instalada';

  @override
  String get browseNoInstalledSourcesDesc =>
      'Instale extensões na aba Extensões\npara ver as fontes aqui.';

  @override
  String get browseUnpin => 'Desafixar';

  @override
  String get browsePin => 'Fixar';

  @override
  String get browseSourceNotInstalledBody => 'Fonte não instalada';

  @override
  String get browseBypassingCloudflare =>
      'Contornando a proteção Cloudflare...';

  @override
  String get browseOpenInWebView => 'Abrir no WebView';

  @override
  String get browseCloudflareProtection => 'Proteção Cloudflare';

  @override
  String get browseFailedToLoad => 'Falha ao carregar';

  @override
  String get browseCloudflareChallengeDesc =>
      'Esta fonte exige resolver primeiro um desafio Cloudflare no navegador.';

  @override
  String get browseSolveCloudflare => 'Resolver Cloudflare';

  @override
  String get browseRetry => 'Tentar novamente';

  @override
  String get browseContentAnime => 'anime';

  @override
  String get browseContentNovels => 'light novels';

  @override
  String get browseContentManga => 'mangá';

  @override
  String browseNoContentFound(Object noun) {
    return 'Nenhum $noun encontrado';
  }

  @override
  String get browseAllCategories => 'Todas as categorias';

  @override
  String get browseNoCategories => 'Nenhuma categoria';

  @override
  String get browseSearchMangaHint => 'Buscar mangá...';

  @override
  String get browseUnknown => 'Desconhecido';

  @override
  String get browseSearchAllSourcesHint => 'Buscar em todas as fontes...';

  @override
  String get browseNoSourcesInstalled => 'Nenhuma fonte instalada';

  @override
  String get browseNoSourcesInstalledDesc =>
      'Instale extensões na aba Explorar.';

  @override
  String get browseSearchAllSources => 'Buscar em Todas as Fontes';

  @override
  String browseSearchSourcesAtOnce(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Buscar em $count fontes ao mesmo tempo.',
      one: 'Buscar em 1 fonte ao mesmo tempo.',
    );
    return '$_temp0';
  }

  @override
  String browseSearchingSources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Buscando em $count fontes...',
      one: 'Buscando em 1 fonte...',
    );
    return '$_temp0';
  }

  @override
  String get browseSeeAll => 'Ver tudo';

  @override
  String get globalSearchSourceNoResults => 'No results';

  @override
  String get globalSearchSourceFailed => 'Couldn\'t search this source';

  @override
  String get browseSectionSources => 'Fontes';

  @override
  String get browseShowNsfw => 'Mostrar Fontes NSFW';

  @override
  String get browseShowNsfwDesc =>
      'Mostrar fontes 18+ na exploração e na busca';

  @override
  String get browsePinnedOnly => 'Apenas Fontes Fixadas';

  @override
  String get browsePinnedOnlyBrowseDesc =>
      'Mostrar apenas fontes fixadas na exploração';

  @override
  String get browseSectionGlobalSearch => 'Busca Global';

  @override
  String get browsePinnedOnlyGlobalSearchDesc =>
      'Buscar apenas em fontes fixadas na busca global';

  @override
  String get browseSectionWebView => 'WebView';

  @override
  String get browseAdBlocker => 'Bloqueador de Anúncios';

  @override
  String get browseAdBlockerDesc =>
      'Bloquear anúncios, pop-ups e sobreposições no navegador';

  @override
  String get browseSectionExtensions => 'Extensões';

  @override
  String get browseAutoUpdate => 'Atualizar Extensões Automaticamente';

  @override
  String get browseAutoUpdateDesc =>
      'Atualizar o código das extensões instaladas ao abrir o app';

  @override
  String get setxAdvancedTitle => 'Avançado';

  @override
  String get setxAdvancedSectionLogging => 'Registros';

  @override
  String get setxAdvancedVerboseLoggingTitle => 'Registro Detalhado';

  @override
  String get setxAdvancedVerboseLoggingSubtitle =>
      'Registrar informações detalhadas de depuração';

  @override
  String get setxAdvancedViewErrorLogsTitle => 'Ver Registros de Erros';

  @override
  String get setxAdvancedViewErrorLogsSubtitle =>
      'Consultar registros de depuração e erros';

  @override
  String get setxAdvancedSectionNetwork => 'Rede';

  @override
  String get setxAdvancedDnsOverHttpsTitle => 'DNS sobre HTTPS';

  @override
  String get setxAdvancedDnsOverHttpsSubtitle => 'Usar resolução de DNS segura';

  @override
  String get setxAdvancedDnsProviderTitle => 'Provedor de DNS';

  @override
  String get setxAdvancedDnsAddCustom => 'Add custom DNS';

  @override
  String get setxAdvancedDnsName => 'Name';

  @override
  String get setxAdvancedDnsNameHint => 'My DNS';

  @override
  String get setxAdvancedDnsUrlLabel => 'DoH URL';

  @override
  String get setxAdvancedDnsInvalidUrl => 'Enter a valid https:// URL';

  @override
  String get setxAdvancedDnsAdd => 'Add';

  @override
  String get setxAdvancedDnsDelete => 'Delete';

  @override
  String get setxAdvancedDnsDeleteTitle => 'Delete custom DNS?';

  @override
  String setxAdvancedDnsDeleteBody(String name) {
    return 'Remove \"$name\" from your DNS providers?';
  }

  @override
  String get commonBeta => 'BETA';

  @override
  String get setxAdvancedSectionBeta => 'Experimental';

  @override
  String get setxAdvancedBeta => 'Beta features';

  @override
  String get setxAdvancedBetaDesc =>
      'Show experimental features: hands-free and volume-key scrolling, AI translation and auto-crop. They may be unstable or change.';

  @override
  String get setxAdvancedSectionExtensions => 'Extensões';

  @override
  String get setxAdvancedThirdPartyTitle => 'Extensões de Terceiros';

  @override
  String get setxAdvancedThirdPartySubtitle =>
      'Permitir extensões de fontes desconhecidas';

  @override
  String get setxAdvancedExtUpdateTitle =>
      'Alertas de Atualização de Extensões';

  @override
  String get setxAdvancedExtUpdateSubtitle =>
      'Notificar quando houver atualizações de extensões';

  @override
  String get setxAdvancedSectionBrowser => 'Navegador';

  @override
  String get setxAdvancedExternalBrowserTitle => 'Navegador Externo';

  @override
  String get setxAdvancedExternalBrowserSubtitle =>
      'Abrir links no navegador do sistema';

  @override
  String get setxAdvancedSectionData => 'Dados';

  @override
  String get setxAdvancedClearCacheTitle => 'Limpar Cache de Capítulos';

  @override
  String get setxAdvancedClearCacheSubtitle =>
      'Liberar espaço de armazenamento';

  @override
  String get setxAdvancedClearDbEntryTitle => 'Limpar Banco de Dados';

  @override
  String get setxAdvancedClearDbEntrySubtitle =>
      'Redefinir biblioteca, categorias e histórico de leitura';

  @override
  String get setxAdvancedCacheCleared => 'Cache de imagens dos capítulos limpo';

  @override
  String get setxAdvancedClearDbTitle => 'Limpar banco de dados?';

  @override
  String get setxAdvancedClearDbBody =>
      'Isso exclui permanentemente sua biblioteca, categorias e histórico de leitura. Extensões instaladas e downloads não são afetados.';

  @override
  String get setxAdvancedCancel => 'Cancelar';

  @override
  String get setxAdvancedClear => 'Limpar';

  @override
  String get setxAdvancedDbCleared =>
      'Banco de dados limpo — reinicie o app para recriar os padrões';

  @override
  String get setxAdvancedErrorLogsTitle => 'Registros de Erros';

  @override
  String get setxAdvancedClearAllLogsTooltip => 'Limpar todos os registros';

  @override
  String get setxAdvancedFilterCategory => 'Categoria';

  @override
  String get setxAdvancedFilterLevel => 'Nível';

  @override
  String get setxAdvancedLogAll => 'All';

  @override
  String get setxAdvancedLogCatRepo => 'Repo';

  @override
  String get setxAdvancedLogCatExtension => 'Extension';

  @override
  String get setxAdvancedLogCatNetwork => 'Network';

  @override
  String get setxAdvancedLogCatInstall => 'Install';

  @override
  String get setxAdvancedLogCatLibrary => 'Library';

  @override
  String get setxAdvancedLogCatGeneral => 'General';

  @override
  String get setxAdvancedLogLvlDebug => 'Debug';

  @override
  String get setxAdvancedLogLvlInfo => 'Info';

  @override
  String get setxAdvancedLogLvlWarning => 'Warning';

  @override
  String get setxAdvancedLogLvlError => 'Error';

  @override
  String get setxAdvancedNoLogs => 'Nenhum registro ainda';

  @override
  String get setxAdvancedNoLogsSubtitle =>
      'Os registros aparecerão aqui conforme você usa o app';

  @override
  String get setxAdvancedClearLogsTitle => 'Limpar todos os registros?';

  @override
  String get setxAdvancedClearLogsBody =>
      'Isso excluirá permanentemente todos os registros armazenados.';

  @override
  String get setxAdvancedLogsCleared => 'Registros limpos';

  @override
  String get setxAdvancedCopiedToClipboard =>
      'Copiado para a área de transferência';

  @override
  String get setxNotifTitle => 'Notificações';

  @override
  String get setxNotifSectionChapterUpdates => 'Atualizações de Capítulos';

  @override
  String get setxNotifNewChaptersTitle => 'Novos Capítulos';

  @override
  String get setxNotifNewChaptersSubtitle =>
      'Notificar quando houver novos capítulos disponíveis';

  @override
  String get setxNotifLibraryUpdatesTitle => 'Atualizações da Biblioteca';

  @override
  String get setxNotifLibraryUpdatesSubtitle =>
      'Notificar após a conclusão da atualização da biblioteca';

  @override
  String get setxNotifSectionDownloads => 'Downloads';

  @override
  String get setxNotifDownloadCompleteTitle => 'Download Concluído';

  @override
  String get setxNotifDownloadCompleteSubtitle =>
      'Notificar quando os capítulos terminarem de baixar';

  @override
  String get setxNotifDownloadErrorTitle => 'Erro no Download';

  @override
  String get setxNotifDownloadErrorSubtitle =>
      'Notificar quando um download falhar';

  @override
  String get setxNotifSectionBehavior => 'Comportamento';

  @override
  String get setxNotifSoundTitle => 'Som';

  @override
  String get setxNotifSoundSubtitle => 'Reproduzir som nas notificações';

  @override
  String get setxNotifVibrationTitle => 'Vibração';

  @override
  String get setxNotifVibrationSubtitle => 'Vibrar nas notificações';

  @override
  String get setxNotifGroupTitle => 'Agrupar Notificações';

  @override
  String get setxNotifGroupSubtitle => 'Combinar várias notificações';

  @override
  String get setxSecurityTitle => 'Segurança e Privacidade';

  @override
  String get setxSecuritySectionAppLock => 'Bloqueio do App';

  @override
  String get setxSecurityAppLockTitle => 'Bloqueio do App';

  @override
  String get setxSecurityAppLockSubtitle =>
      'Exigir autenticação para abrir o app';

  @override
  String get setxSecurityBiometricsTitle => 'Biometria';

  @override
  String get setxSecurityBiometricsSubtitle =>
      'Usar impressão digital ou rosto para desbloquear';

  @override
  String get setxSecuritySectionPrivacy => 'Privacidade';

  @override
  String get setxSecurityIncognitoTitle => 'Incognito mode';

  @override
  String get setxSecurityIncognitoSubtitle =>
      'Don\'t save reading history or update trackers';

  @override
  String get libraryIncognitoActive => 'Incognito mode on';

  @override
  String get setxSecuritySecureScreenTitle => 'Tela Segura';

  @override
  String get setxSecuritySecureScreenSubtitle =>
      'Ocultar o conteúdo do app na lista de apps recentes';

  @override
  String get setxSecurityHideNotifTitle => 'Ocultar Conteúdo das Notificações';

  @override
  String get setxSecurityHideNotifSubtitle =>
      'Mostrar texto genérico nas notificações';

  @override
  String get notifChannelUpdatesName => 'Library updates';

  @override
  String get notifChannelUpdatesDesc => 'New chapters and update summaries';

  @override
  String get notifChannelDownloadsName => 'Downloads';

  @override
  String get notifChannelDownloadsDesc => 'Download completion and errors';

  @override
  String get notifDownloadCompleteTitle => 'Download complete';

  @override
  String get notifDownloadFailedTitle => 'Download failed';

  @override
  String get notifDownloadsDoneTitle => 'Downloads complete';

  @override
  String notifDownloadsDoneBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items downloaded',
      one: '1 item downloaded',
    );
    return '$_temp0';
  }

  @override
  String notifDownloadsDoneBodyFailed(int count, int failed) {
    return '$count downloaded · $failed failed';
  }

  @override
  String notifNewChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new chapters',
      one: '1 new chapter',
    );
    return '$_temp0';
  }

  @override
  String get notifLibraryUpdatedTitle => 'Library updated';

  @override
  String notifLibrarySummaryBody(int count, int titles) {
    return '$count new chapters across $titles titles';
  }

  @override
  String get notifHiddenBody => 'New activity';

  @override
  String get notifExtensionUpdatesTitle => 'Extension updates';

  @override
  String notifExtensionUpdates(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count extension updates available',
      one: '1 extension update available',
    );
    return '$_temp0';
  }

  @override
  String get securityLockedTitle => 'Foxlations is locked';

  @override
  String get securityUnlock => 'Unlock';

  @override
  String get securityUnlockReason => 'Unlock Foxlations';

  @override
  String get setxBackupTitle => 'Backup e Restauração';

  @override
  String get setxBackupSectionFoxlations => 'Backup do Foxlations';

  @override
  String get setxBackupCreateTitle => 'Criar backup';

  @override
  String get setxBackupCreateSubtitle =>
      'Salve sua biblioteca, categorias, progresso de leitura, fontes e rastreamento';

  @override
  String get setxBackupRestoreTitle => 'Restaurar backup';

  @override
  String get backupIncludeVault => 'Include vault';

  @override
  String get backupIncludeVaultSubtitle =>
      'Adds your vault titles under “Vault-” categories — requires unlocking';

  @override
  String get backupUnlockVaultTitle => 'Unlock vault';

  @override
  String get backupUnlockVaultHint => 'Vault password';

  @override
  String get backupRestoreConfirmTitle => 'Restore this backup?';

  @override
  String backupRestoreConfirmBody(String name) {
    return 'This adds “$name” to your library. You can cancel if you changed your mind.';
  }

  @override
  String get setxBackupRestoreSubtitle =>
      'Restaurar a partir de um arquivo .fxbackup do Foxlations';

  @override
  String get setxBackupSectionTachiyomi => 'Tachiyomi / Mihon e forks';

  @override
  String get setxBackupCreateCompatTitle => 'Criar backup compatível';

  @override
  String get setxBackupCreateCompatSubtitle =>
      'Exportar um .tachibk que você pode importar no Tachiyomi, Mihon e forks';

  @override
  String get setxBackupRestoreTachiyomiTitle => 'Restaurar do Tachiyomi/Mihon';

  @override
  String get setxBackupRestoreTachiyomiSubtitle =>
      'Importar um backup .tachibk / .tmb / .proto.gz (corresponde às fontes pelo nome)';

  @override
  String get setxBackupSectionAutomatic => 'Backup automático';

  @override
  String get setxBackupFrequency => 'Frequência';

  @override
  String setxBackupAutoSubtitle(Object freq) {
    return 'Criar um backup automaticamente $freq';
  }

  @override
  String setxBackupSectionBackups(Object count) {
    return 'Backups ($count)';
  }

  @override
  String get setxBackupNone => 'Nenhum backup ainda.';

  @override
  String get setxBackupMenuRestore => 'Restaurar';

  @override
  String get setxBackupMenuDelete => 'Excluir';

  @override
  String get setxBackupFreqOff => 'Desativado';

  @override
  String get setxBackupFreqDaily => 'Diário';

  @override
  String get setxBackupFreqWeekly => 'Semanal';

  @override
  String get setxBackupFreqMonthly => 'Mensal';

  @override
  String setxBackupImportedManga(Object count) {
    return '$count mangás importados';
  }

  @override
  String get setxBackupRestoreComplete => 'Restauração concluída';

  @override
  String get backupOrganizeTitle => 'Organize imported categories';

  @override
  String backupOrganizePrompt(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'The backup added $count categories. Keep each, or send it to one of yours.',
      one: 'The backup added 1 category. Keep it, or send it to one of yours.',
    );
    return '$_temp0';
  }

  @override
  String get backupOrganizeKeepAll => 'Keep as-is';

  @override
  String get backupOrganizeApply => 'Apply';

  @override
  String get backupOrganizeKeep => 'Keep';

  @override
  String get backupOrganizeShowVault => 'Show vault categories';

  @override
  String get backupOrganizeUnlockVault =>
      'Unlock the vault to use its categories';

  @override
  String backupOrganizeVaultPrefix(String name) {
    return 'Vault: $name';
  }

  @override
  String backupOrganizeItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titles',
      one: '1 title',
    );
    return '$_temp0';
  }

  @override
  String backupOrganizeDone(int count) {
    return 'Reorganized $count titles';
  }

  @override
  String setxBackupRestoreFailed(Object error) {
    return 'Falha na restauração: $error';
  }

  @override
  String get setxAboutTitle => 'Sobre';

  @override
  String get setxAboutSectionApp => 'Aplicativo';

  @override
  String get setxAboutWhatsNewTitle => 'Novidades';

  @override
  String get setxAboutWhatsNewSubtitle =>
      'Registro de alterações e notas de versão';

  @override
  String get setxAboutCheckUpdatesTitle => 'Verificar Atualizações';

  @override
  String get setxAboutCheckUpdatesSubtitle =>
      'Ver se uma versão mais recente foi lançada';

  @override
  String get setxAboutSectionLegal => 'Jurídico';

  @override
  String get setxAboutLicensesTitle => 'Licenças';

  @override
  String get setxAboutLicensesSubtitle => 'Licenças de código aberto';

  @override
  String get setxAboutSectionLinks => 'Links';

  @override
  String get setxAboutSourceCodeTitle => 'Código-Fonte';

  @override
  String get setxAboutSourceCodeSubtitle => 'Toque para copiar a URL do GitHub';

  @override
  String get setxAboutReportBugTitle => 'Relatar um Bug';

  @override
  String get setxAboutReportBugSubtitle =>
      'Toque para copiar a URL do rastreador de problemas';

  @override
  String get setxAboutClose => 'Fechar';

  @override
  String setxAboutVersionBuild(String version, String build) {
    return 'Version $version (Build $build)';
  }

  @override
  String get setxAboutDiscordSubtitle => 'Join the community';

  @override
  String get helpTipsTitle => 'Help & Tips';

  @override
  String get helpTipsViewTutorial => 'View tutorial';

  @override
  String get helpTipsViewTutorialSub => 'A quick tour of the app';

  @override
  String get helpTipsDiscord => 'Join our Discord';

  @override
  String get helpTipsDiscordSub => 'Help, requests & community';

  @override
  String get helpTipsSectionTips => 'Tips';

  @override
  String get helpTipsNoContentTitle => 'No content showing?';

  @override
  String get helpTipsNoContentBody =>
      'Add an extension repository in Browse → ⋯ to install sources first.';

  @override
  String get helpTipsGesturesTitle => 'Reader gestures';

  @override
  String get helpTipsGesturesBody =>
      'Tap the edges to turn pages, the center to show controls; long-press a page for more.';

  @override
  String get helpTipsVaultTitle => 'The Vault';

  @override
  String get helpTipsVaultBody =>
      'Move private titles into the Vault to keep them behind a lock.';

  @override
  String get helpTipsUpdateTitle => 'Keep up to date';

  @override
  String get helpTipsUpdateBody =>
      'Pull down on the Library to check for new chapters; set a schedule in Library settings.';

  @override
  String get tutorialSkip => 'Skip';

  @override
  String get tutorialNext => 'Next';

  @override
  String get tutorialGetStarted => 'Get started';

  @override
  String get tutorialJoinDiscord => 'Join Discord';

  @override
  String get tutorialSlide1Title => 'Welcome to Foxlations';

  @override
  String get tutorialSlide1Body =>
      'One app for manga and manhwa, anime, and light novels - read, watch and listen, all from sources you add yourself. No account, no ads, nothing phoning home.';

  @override
  String get tutorialSlide2Title => 'Get your content';

  @override
  String get tutorialSlide2Body =>
      'Foxlations ships empty - you choose the sources. In the Browse tab, open the ⋯ menu to add an extension repository (a link your community shares). Installed sources show up ready to search.';

  @override
  String get tutorialSlide3Title => 'Build your library';

  @override
  String get tutorialSlide3Body =>
      'Search a source or use global search across all of them, open a title, and tap the heart to add it. Your library is organized with categories (Reading, On-hold, your own…) and a “Continue reading” shortcut right up top.';

  @override
  String get tutorialSlide4Title => 'Read your way';

  @override
  String get tutorialSlide4Body =>
      'Paged, webtoon or double-page; tap the edges to turn pages and the centre for controls. Dial in eye-comfort (warm filter + dim), customise the novel reader, let it read novels aloud, and skip anime intros automatically.';

  @override
  String get tutorialSlide5Title => 'Private & offline';

  @override
  String get tutorialSlide5Body =>
      'Download chapters and episodes to read with no connection, back up your whole library, and keep private titles locked away in the Vault. There’s incognito mode and an app lock too.';

  @override
  String get tutorialSlide6Title => 'Join the community';

  @override
  String get tutorialSlide6Body =>
      'Questions, source help, feature requests, or just want to chat? Come say hi on our Discord - and you can reopen this tour any time from Settings → Help & Tips.';

  @override
  String setxAboutWhatsNewVersioned(Object version) {
    return 'Novidades da v$version';
  }

  @override
  String setxAboutLinkCopied(Object label) {
    return 'Link de $label copiado para a área de transferência';
  }

  @override
  String get setxAboutSourceCodeLabel => 'Código-fonte';

  @override
  String get setxAboutBugReportLabel => 'Relatório de bug';

  @override
  String get miscResumePlaybackTitle => 'Retomar a reprodução?';

  @override
  String miscStoppedWatchingAt(Object time) {
    return 'Você parou de assistir em $time.';
  }

  @override
  String get miscStartOver => 'Recomeçar';

  @override
  String miscContinueAt(Object time) {
    return 'Continuar ($time)';
  }

  @override
  String get miscQuality => 'Qualidade';

  @override
  String miscSourceIndex(Object index) {
    return 'Fonte $index';
  }

  @override
  String get miscSubtitles => 'Legendas';

  @override
  String get miscSubtitleOff => 'Desativado';

  @override
  String get miscUnknownTrack => 'Desconhecida';

  @override
  String get miscSubtitleDelay => 'Atraso da legenda';

  @override
  String get miscAudio => 'Áudio';

  @override
  String get miscPlaybackSpeed => 'Velocidade de reprodução';

  @override
  String get miscSkipOutro => 'Pular Encerramento';

  @override
  String get miscSkipIntro => 'Pular Abertura';

  @override
  String get miscUnlockControls => 'Desbloquear controles';

  @override
  String get miscUnknownError => 'Erro desconhecido';

  @override
  String get miscRetry => 'Tentar novamente';

  @override
  String get miscExtensionRepositories => 'Repositórios de Extensões';

  @override
  String get miscRepositoryUrlHint => 'URL do repositório (index.json)';

  @override
  String get miscAdd => 'Adicionar';

  @override
  String get deeplinkAddRepoTitle => 'Add source repo?';

  @override
  String deeplinkFromHost(String host) {
    return 'From $host';
  }

  @override
  String deeplinkAddedNamed(String name) {
    return 'Added \"$name\" - see Browse > Extensions';
  }

  @override
  String get deeplinkAdded => 'Repo added - see Browse > Extensions';

  @override
  String deeplinkAddFailed(String error) {
    return 'Couldn\'t add repo: $error';
  }

  @override
  String get miscRepositoriesHeader => 'REPOSITÓRIOS';

  @override
  String get miscNoReposYet => 'Nenhum repositório adicionado ainda';

  @override
  String miscFailedToAddRepo(Object error) {
    return 'Falha ao adicionar repositório: $error';
  }

  @override
  String get miscVerifyHuman => 'Verifique que você é humano';

  @override
  String get miscCfInstructions =>
      'Conclua a verificação do site abaixo. Ela fecha automaticamente e não perguntará novamente enquanto a verificação durar.';

  @override
  String get trackTitle => 'Rastreamento';

  @override
  String get trackNoTrackerConnected => 'Nenhum rastreador conectado';

  @override
  String get trackConnectHint =>
      'Conecte AniList, MyAnimeList ou Kitsu em Configurações › Rastreamento.';

  @override
  String trackNotLinkedOn(Object name) {
    return 'Não vinculado no $name';
  }

  @override
  String get trackLink => 'Vincular';

  @override
  String get trackUnlink => 'Desvincular';

  @override
  String get trackStatus => 'Status';

  @override
  String get trackChapters => 'Capítulos';

  @override
  String get trackScore => 'Nota';

  @override
  String trackLinkedTo(Object name) {
    return 'Vinculado a $name';
  }

  @override
  String trackLinkOn(Object name) {
    return 'Vincular no $name';
  }

  @override
  String get trackSearchTitleHint => 'Buscar título';

  @override
  String get trackSearch => 'Buscar';

  @override
  String get trackNoResults => 'Nenhum resultado';

  @override
  String trackChaptersShort(Object count) {
    return '$count cap';
  }

  @override
  String trackConnectTracker(Object name) {
    return 'Conectar $name';
  }

  @override
  String get trackOauthInstructions =>
      'Faça login e toque em Autorizar. Você será conectado automaticamente.';

  @override
  String get trackServices => 'Serviços';

  @override
  String get trackServicesDescription =>
      'Conecte um serviço de rastreamento para sincronizar seu progresso de leitura. Depois que um mangá é vinculado, o progresso é atualizado automaticamente conforme você lê.';

  @override
  String trackLogInTo(Object name) {
    return 'Entrar no $name';
  }

  @override
  String get trackEmailOrUsername => 'E-mail ou nome de usuário';

  @override
  String get trackPassword => 'Senha';

  @override
  String get trackCancel => 'Cancelar';

  @override
  String get trackLogIn => 'Entrar';

  @override
  String trackConnectedTo(Object name) {
    return 'Conectado a $name';
  }

  @override
  String get trackLoginFailed => 'Falha no login — verifique suas credenciais';

  @override
  String get trackSetClientIdFirst => 'Defina um client ID primeiro';

  @override
  String get trackCouldNotCompleteSignIn => 'Não foi possível concluir o login';

  @override
  String trackClientIdTitle(Object name) {
    return 'Client ID do $name (avançado)';
  }

  @override
  String trackClientIdDescription(Object name) {
    return 'Opcional. O Foxlations já tem um client ID integrado do $name — basta tocar em Conectar. Defina isto apenas se você registrou seu próprio app de desenvolvedor no $name e quer usá-lo.';
  }

  @override
  String get trackClientId => 'Client ID';

  @override
  String get trackSave => 'Salvar';

  @override
  String get trackPasteAccessToken => 'Cole o token de acesso';

  @override
  String get trackPasteTokenHint => 'Cole o token exibido após a autorização';

  @override
  String get trackConnect => 'Conectar';

  @override
  String get trackCouldNotVerifyToken => 'Não foi possível verificar o token';

  @override
  String get trackConnected => 'Conectado';

  @override
  String trackConnectedAs(Object username) {
    return 'Conectado como $username';
  }

  @override
  String get trackTapConnectToAuthorize => 'Toque em Conectar para autorizar';

  @override
  String get trackSignInWithAccount => 'Entre com sua conta';

  @override
  String get trackDisconnect => 'Desconectar';

  @override
  String get trackAiTitle => 'IA e Tradução';

  @override
  String get trackTabTranslation => 'Tradução';

  @override
  String get trackTabApiKeys => 'Chaves de API';

  @override
  String get trackTabModels => 'Modelos';

  @override
  String get trackEnableAiTranslation => 'Ativar Tradução por IA';

  @override
  String get trackEnableAiTranslationDesc =>
      'Mostrar o botão de tradução no leitor';

  @override
  String get trackProvider => 'Provedor';

  @override
  String get trackOfflineMode => 'Modo Offline';

  @override
  String get trackOfflineModeDesc => 'Usar modelos baixados sem internet';

  @override
  String get trackTranslationSettings => 'Configurações de Tradução';

  @override
  String get trackTargetLanguage => 'Idioma de Destino';

  @override
  String get trackTargetLanguageDesc =>
      'Traduzir o texto do mangá para este idioma';

  @override
  String get trackBubbleDetection => 'Detecção de Balões';

  @override
  String get trackBubbleDetectionDesc =>
      'Detectar automaticamente balões de fala nas páginas de mangá';

  @override
  String get trackQuality => 'Qualidade';

  @override
  String get trackQualityFast => 'Rápida';

  @override
  String get trackQualityBalanced => 'Equilibrada';

  @override
  String get trackQualityHigh => 'Alta Qualidade';

  @override
  String get trackKoharuServer => 'Servidor Koharu';

  @override
  String get trackServerUrl => 'URL do servidor';

  @override
  String get trackKoharuServerDesc =>
      'Reconstrução completa do mangá via servidor Docker local';

  @override
  String get trackApiKeyRequired => 'Chave de API necessária';

  @override
  String get trackApiKeysNotice =>
      'As chaves são armazenadas localmente no seu dispositivo e nunca enviadas aos nossos servidores.';

  @override
  String get trackModelsPlatformOnly =>
      'Os modelos de tradução no dispositivo estão disponíveis no Android e no iOS.';

  @override
  String get trackModelsDescription =>
      'Baixe um idioma para traduzi-lo totalmente offline. Cada pacote tem cerca de 30 MB e também é baixado automaticamente na primeira vez que você traduz aquele idioma.';

  @override
  String get trackTranslationLanguages => 'IDIOMAS DE TRADUÇÃO';

  @override
  String get trackDownloaded => 'Baixado — disponível offline';

  @override
  String get trackNotDownloaded => 'Não baixado';

  @override
  String get trackDelete => 'Excluir';

  @override
  String get trackDownload => 'Baixar';

  @override
  String trackDownloadFailed(Object error) {
    return 'Falha no download: $error';
  }

  @override
  String trackDeleteFailed(Object error) {
    return 'Falha ao excluir: $error';
  }

  @override
  String get repoReinstallSources => 'Reinstall sources';

  @override
  String get repoCopyUrl => 'Copy repo URL';

  @override
  String get repoOpenGithubPage => 'Open GitHub page';

  @override
  String get repoOpenWebsite => 'Open website';

  @override
  String get repoOpenDiscord => 'Open Discord';

  @override
  String get repoDeleteRepo => 'Delete repo';

  @override
  String repoCouldNotOpen(String url) {
    return 'Couldn\'t open $url';
  }

  @override
  String get repoReinstalling => 'Reinstalling sources…';

  @override
  String get repoRefreshed => 'Repo refreshed';

  @override
  String repoReinstalledCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Reinstalled $count sources',
      one: 'Reinstalled 1 source',
    );
    return '$_temp0';
  }

  @override
  String repoReinstallFailed(String error) {
    return 'Reinstall failed: $error';
  }

  @override
  String get repoDeleteTitle => 'Delete repo?';

  @override
  String repoDeleteBody(String name) {
    return 'Remove \"$name\" and uninstall its sources?';
  }

  @override
  String get repoDeleteConfirm => 'Delete';

  @override
  String repoSourceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources',
      one: '1 source',
    );
    return '$_temp0';
  }

  @override
  String get repoCancel => 'Cancelar';

  @override
  String get repoName => 'Nome';

  @override
  String repoImportedSource(Object id) {
    return 'Fonte importada · $id';
  }

  @override
  String get repoCheckingMatches => 'Verificando correspondências';

  @override
  String get repoMigrating => 'Migrando';

  @override
  String get repoMigrateThisSource => 'Migrar esta fonte?';

  @override
  String repoMatchedByUrl(Object count) {
    return '$count correspondência(s) por URL';
  }

  @override
  String repoMatchedByTitle(Object count) {
    return '$count correspondência(s) por título';
  }

  @override
  String repoNotFoundLeftInPlace(Object count) {
    return '$count não encontrada(s) — mantida(s) no lugar';
  }

  @override
  String get repoMigrateCarryOver =>
      'Progresso de leitura, categorias e rastreamento são transferidos. Os originais são removidos apenas dos itens que forem movidos.';

  @override
  String repoMigrateCount(Object count) {
    return 'Migrar $count';
  }

  @override
  String get repoMigrateASource => 'Migrar uma fonte';

  @override
  String get repoMigrateIntro =>
      'Mova todos os itens da biblioteca de uma fonte para outra. Trocas no mesmo site correspondem exatamente por URL; itens importados de um backup também podem ser realocados para uma fonte real.';

  @override
  String get repoFrom => 'DE';

  @override
  String get repoSelectSource => 'Selecione uma fonte…';

  @override
  String get repoTo => 'PARA';

  @override
  String get repoAlsoMatchByTitle => 'Também corresponder por título';

  @override
  String get repoAlsoMatchByTitleHint =>
      'Para movimentações entre sites: se um item não for encontrado por URL, busca na nova fonte pelo título e usa a correspondência mais próxima. Desativado por padrão para não vincular a série errada.';

  @override
  String get repoMigrateSource => 'Migrar fonte';

  @override
  String get repoMigrationComplete => 'Migração concluída';

  @override
  String repoMovedByUrl(Object count) {
    return '$count movida(s) por URL';
  }

  @override
  String repoMovedByTitle(Object count) {
    return '$count movida(s) por título';
  }

  @override
  String repoLeftInPlace(Object count) {
    return '$count mantida(s) no lugar';
  }

  @override
  String get repoNotMigratedHeader => 'Não migradas (ainda na fonte antiga):';

  @override
  String get repoUsePerTitleMigrate => 'Use a migração por título para estas.';

  @override
  String get repoDone => 'Concluído';

  @override
  String get setdDownloadsTitle => 'Downloads';

  @override
  String get setdDownloadsSectionAutomatic => 'Downloads Automáticos';

  @override
  String get setdDownloadsNewChapters => 'Baixar Novos Capítulos';

  @override
  String get setdDownloadsNewChaptersDesc =>
      'Baixar novos capítulos automaticamente';

  @override
  String get setdDownloadsWifiOnly => 'Somente Wi-Fi';

  @override
  String get setdDownloadsWifiOnlyDesc => 'Baixar somente no Wi-Fi';

  @override
  String get setdDownloadsChargingOnly => 'Somente Carregando';

  @override
  String get setdDownloadsChargingOnlyDesc =>
      'Baixar somente enquanto conectado à energia';

  @override
  String get setdDownloadsAhead => 'Baixar Adiante Durante a Leitura';

  @override
  String get setdDownloadsAheadDesc =>
      'Baixar o próximo capítulo antecipadamente enquanto você lê';

  @override
  String get setdDownloadsSectionQueue => 'Fila de Download';

  @override
  String get setdDownloadsSimultaneous => 'Downloads Simultâneos';

  @override
  String get setdDownloadsQuality => 'Qualidade do Download';

  @override
  String get setdDownloadsSectionDelete => 'Excluir Capítulos Baixados';

  @override
  String get setdDownloadsAfterReading => 'Após a Leitura';

  @override
  String get setdDownloadsAfterReadingDesc =>
      'Excluir capítulos depois de lidos';

  @override
  String get setdDownloadsIncludeBookmarked => 'Incluir Capítulos Favoritados';

  @override
  String get setdDownloadsIncludeBookmarkedDesc =>
      'Excluir capítulos favoritados junto com os demais';

  @override
  String get setdDownloadsAutoDelete =>
      'Excluir Capítulos Lidos Automaticamente';

  @override
  String get setdDownloadsSectionFormat => 'Formato';

  @override
  String get setdDownloadsSaveCbz => 'Salvar como CBZ';

  @override
  String get setdDownloadsSaveCbzDesc =>
      'Arquivar capítulos como arquivos CBZ com metadados';

  @override
  String get setdDownloadsSavePdf => 'Salvar como PDF';

  @override
  String get setdDownloadsSavePdfDesc =>
      'Empacotar capítulos como um único PDF (uma imagem por página)';

  @override
  String get setdDownloadsSectionLocation => 'Local de Download';

  @override
  String get setdDownloadsDefaultLocation => 'Local Padrão';

  @override
  String get setdDownloadsCustomLocation => 'Local Personalizado';

  @override
  String get setdDownloadsChooseFolder => 'Escolher Pasta';

  @override
  String get setdDownloadsIosFolderWarning =>
      'O iOS não permite que aplicativos mantenham acesso a uma pasta. Os downloads ficam na pasta do app, acessível em Arquivos › No meu iPhone › Foxlations.';

  @override
  String get setdDownloadsReset => 'Redefinir';

  @override
  String get setdDownloadsSectionStorage => 'Armazenamento';

  @override
  String setdDownloadsTotalSize(Object size) {
    return 'Total: $size MB';
  }

  @override
  String setdDownloadsLibraryVaultSize(Object lib, Object vault) {
    return 'Biblioteca: $lib MB  |  Cofre: $vault MB';
  }

  @override
  String get dlQueueTitle => 'Downloads';

  @override
  String get dlQueueSettingsTooltip => 'Download settings';

  @override
  String get dlQueueRecent => 'Recently Downloaded';

  @override
  String get dlQueueResume => 'Resume';

  @override
  String get dlQueuePause => 'Pause';

  @override
  String dlQueueConcurrent(Object count) {
    return 'Concurrent downloads: $count';
  }

  @override
  String get dlQueueEmpty => 'No Downloads';

  @override
  String get dlQueuePaused => 'Downloads paused';

  @override
  String get dlQueueStatusQueued => 'Queued';

  @override
  String get dlQueueStatusDownloading => 'Downloading';

  @override
  String get dlQueueCancelAll => 'Cancel all';

  @override
  String get dlQueueCancelItem => 'Cancel download';

  @override
  String dlQueueProgress(Object done, Object total) {
    return '$done / $total';
  }

  @override
  String get dlQueueRecentTitle => 'Recently Downloaded';

  @override
  String get dlQueueRecentEmpty => 'Nothing downloaded yet';

  @override
  String get dlQueueRecentClear => 'Clear';

  @override
  String get dlQueueRecentNote => 'This session only';

  @override
  String get setdVaultTitle => 'Cofre';

  @override
  String get setdVaultSectionAccess => 'Acesso';

  @override
  String get setdVaultEnable => 'Ativar Cofre';

  @override
  String get setdVaultEnableDesc =>
      'Permitir acesso ao cofre oculto tocando 8 vezes em Biblioteca';

  @override
  String get setdVaultSectionSecurity => 'Segurança';

  @override
  String get setdVaultChangePassword => 'Alterar Senha';

  @override
  String get setdVaultSetPassword => 'Definir Senha';

  @override
  String get setdVaultPasswordSetDesc =>
      'Senha definida — toque para alterar ou remover';

  @override
  String get setdVaultPasswordUnsetDesc =>
      'Proteger o acesso ao cofre com uma senha';

  @override
  String get setdVaultSectionCategories => 'Categorias do Cofre';

  @override
  String get setdVaultEditCategories => 'Editar Categorias do Cofre';

  @override
  String get setdVaultEditCategoriesDesc =>
      'Adicionar, remover e reordenar categorias do cofre';

  @override
  String get setdVaultSectionContents => 'Conteúdo';

  @override
  String get setdVaultManageContents => 'Gerenciar Conteúdo do Cofre';

  @override
  String get setdVaultManageContentsDesc =>
      'Mover mangás, animes ou novels para dentro e para fora do cofre';

  @override
  String get setdVaultUnlockFirstSnack =>
      'Desbloqueie o cofre primeiro (acesse pela biblioteca)';

  @override
  String get setdVaultSectionHiddenSources => 'Fontes Ocultas';

  @override
  String get setdVaultOnlySources => 'Fontes Apenas do Cofre';

  @override
  String setdVaultHiddenSourcesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fontes ocultas',
      one: '1 fonte oculta',
    );
    return '$_temp0';
  }

  @override
  String get setdVaultSectionInfo => 'Informações';

  @override
  String get setdVaultInfoText =>
      'O cofre é uma biblioteca oculta com suas próprias categorias e mangás. Toque rapidamente 8 vezes na aba Biblioteca para alternar o modo cofre. Os mangás do cofre são armazenados separadamente e nunca aparecem na sua biblioteca principal.';

  @override
  String get setdVaultCurrentPasswordHint => 'Senha atual';

  @override
  String get setdVaultNewPasswordHint =>
      'Nova senha (deixe em branco para remover)';

  @override
  String get setdVaultConfirmPasswordHint => 'Confirmar nova senha';

  @override
  String get setdVaultCurrentPasswordWrong => 'A senha atual está incorreta';

  @override
  String get setdVaultPasswordsMismatch => 'As senhas não coincidem';

  @override
  String get setdVaultRemovingEncryption => 'Removendo criptografia…';

  @override
  String get setdVaultEncrypting => 'Criptografando o cofre…';

  @override
  String get setdVaultPasswordRemoved =>
      'Senha removida — o cofre não está mais criptografado';

  @override
  String get setdVaultPasswordSet => 'Senha definida — cofre criptografado';

  @override
  String get setdVaultNoCategories => 'Nenhuma categoria no cofre';

  @override
  String setdVaultDeleteCategoryConfirm(Object name) {
    return 'Tem certeza de que deseja excluir \"$name\"? Os mangás desta categoria não serão removidos do cofre.';
  }

  @override
  String get setdVaultNoInstalledSources => 'Nenhuma fonte instalada';

  @override
  String get setdVaultHiddenSourcesToggleHint =>
      'Alterne as fontes para torná-las visíveis apenas no modo cofre.';

  @override
  String get setdVaultSearchSourcesHint => 'Buscar fontes...';

  @override
  String get setdCategoryNameHint => 'Nome da categoria';

  @override
  String get setdNewCategory => 'Nova Categoria';

  @override
  String get setdRenameCategory => 'Renomear Categoria';

  @override
  String get setdDeleteCategory => 'Excluir Categoria';

  @override
  String get setdActionCancel => 'Cancelar';

  @override
  String get setdActionSave => 'Salvar';

  @override
  String get setdActionAdd => 'Adicionar';

  @override
  String get setdActionDelete => 'Excluir';

  @override
  String get setdTapToAddCategory => 'Toque em + para adicionar uma categoria';

  @override
  String get setdVaultContentsTitle => 'Conteúdo do Cofre';

  @override
  String get setdVaultContentsLockedMessage =>
      'Desbloqueie o cofre primeiro para gerenciar seu conteúdo.';

  @override
  String get setdVaultContentsTabManga => 'Mangá';

  @override
  String get setdVaultContentsTabAnime => 'Anime';

  @override
  String get setdVaultContentsTabNovels => 'Novels';

  @override
  String setdVaultContentsEmptyLibrary(Object type) {
    return 'Nenhum $type na sua biblioteca';
  }

  @override
  String setdVaultContentsEmptyVault(Object type) {
    return 'Nenhum $type no cofre';
  }

  @override
  String setdVaultContentsMovedIn(Object title) {
    return '\"$title\" movido para o cofre';
  }

  @override
  String setdVaultContentsMovedOut(Object title) {
    return '\"$title\" movido para fora do cofre';
  }

  @override
  String setdVaultContentsReadProgress(Object read, Object total) {
    return '$read/$total lidos';
  }

  @override
  String get setdLibraryTitle => 'Biblioteca';

  @override
  String get setdLibrarySectionCategories => 'Categorias';

  @override
  String get setdLibraryEditCategories => 'Editar Categorias';

  @override
  String get setdLibraryEditCategoriesDesc =>
      'Adicionar, remover e reordenar categorias';

  @override
  String get setdLibraryHideEmpty => 'Ocultar Categorias Vazias';

  @override
  String get setdLibraryHideEmptyDesc => 'Mostrar apenas categorias com mangás';

  @override
  String get setdLibrarySectionGlobalUpdate => 'Atualização Global';

  @override
  String get setdLibraryUpdateFrequency => 'Frequência de Atualização';

  @override
  String get setdLibraryWifiOnly => 'Somente Wi-Fi';

  @override
  String get setdLibraryWifiOnlyDesc => 'Atualizar somente em conexões Wi-Fi';

  @override
  String get setdLibraryChargingOnly => 'Somente Carregando';

  @override
  String get setdLibraryChargingOnlyDesc =>
      'Atualizar somente quando o dispositivo estiver carregando';

  @override
  String get setdLibrarySectionRestrictions => 'Restrições de Atualização';

  @override
  String get setdLibrarySkipNotStarted => 'Ignorar Não Iniciados';

  @override
  String get setdLibrarySkipNotStartedDesc =>
      'Ignorar mangás sem progresso de leitura';

  @override
  String get setdLibraryShowUpdateCount =>
      'Mostrar Contagem de Novos Capítulos';

  @override
  String get setdLibraryShowUpdateCountDesc =>
      'Mostrar selo nos cards de mangá da biblioteca';

  @override
  String get setdLibrarySectionData => 'Dados';

  @override
  String get setdLibraryMigrateSource => 'Migrar uma Fonte';

  @override
  String get setdLibraryMigrateSourceDesc =>
      'Mover todos os itens de uma fonte para outra';

  @override
  String get setdLibraryNoCategories => 'Nenhuma categoria';

  @override
  String setdLibraryDeleteCategoryConfirm(Object name) {
    return 'Tem certeza de que deseja excluir \"$name\"? Os mangás desta categoria não serão removidos da sua biblioteca.';
  }

  @override
  String get setdPlayerTitle => 'Player';

  @override
  String get setdPlayerSectionSeek => 'TOQUE DUPLO PARA AVANÇAR';

  @override
  String get setdPlayerSkipForward => 'Avançar';

  @override
  String get setdPlayerSkipBackward => 'Retroceder';

  @override
  String get setdPlayerSectionGestures => 'GESTOS';

  @override
  String get setdPlayerHoldToSpeed => 'Segurar para acelerar';

  @override
  String setdPlayerHoldToSpeedDesc(Object speed) {
    return 'Pressione e segure em qualquer lugar para reproduzir a ${speed}x';
  }

  @override
  String get setdPlayerHoldSpeed => 'Velocidade ao segurar';

  @override
  String get setdPlayerVolumeSwipe => 'Deslizar para o volume';

  @override
  String get setdPlayerVolumeSwipeDesc =>
      'Deslize para cima/baixo na metade direita para ajustar o volume';

  @override
  String get setdPlayerBrightnessSwipe => 'Deslizar para o brilho';

  @override
  String get setdPlayerBrightnessSwipeDesc =>
      'Deslize para cima/baixo na metade esquerda para ajustar o brilho';

  @override
  String get setdPlayerSectionPlayback => 'REPRODUÇÃO';

  @override
  String get setdPlayerDefaultSpeed => 'Velocidade padrão';

  @override
  String get setdPlayerAutoplayNext =>
      'Reproduzir próximo episódio automaticamente';

  @override
  String get setdPlayerAutoplayNextDesc =>
      'Iniciar o próximo episódio automaticamente quando um terminar';

  @override
  String get setdPlayerAutoSkipIntro =>
      'Pular abertura/encerramento automaticamente';

  @override
  String get setdPlayerAutoSkipIntroDesc =>
      'Pular aberturas/encerramentos marcados pela fonte sem tocar';

  @override
  String get setdPlayerSkipAmountTitle => 'Quantidade de avanço';

  @override
  String get setdPlayerShowSkipButton => 'Skip-intro button';

  @override
  String get setdPlayerShowSkipButtonDesc =>
      'Show a Skip Intro button near the start, even when the source has no markers';

  @override
  String get setdPlayerSpeedTitle => 'Velocidade';

  @override
  String get setdAppearanceTitle => 'Aparência';

  @override
  String get setdAppearanceSectionTheme => 'Tema';

  @override
  String get setdAppearanceSectionDisplay => 'Exibição';

  @override
  String get setdAppearanceInvertColors => 'Inverter Cores';

  @override
  String get setdAppearanceInvertColorsDesc =>
      'Inverte toda a interface do app';

  @override
  String get setdAppearanceOledBlack => 'Pure black (OLED)';

  @override
  String get setdAppearanceOledBlackDesc =>
      'True-black background in dark mode — saves power on OLED screens';

  @override
  String get setdAppearanceNavOrder => 'Navigation bar';

  @override
  String get setdAppearanceNavOrderDesc =>
      'Drag to arrange the bottom tabs in any order';

  @override
  String get setdAppearanceNavOrderReset => 'Reset';

  @override
  String get setdAppearanceStartTab => 'Open to';

  @override
  String get setdAppearanceStartTabDesc =>
      'Which screen the app opens on at launch';

  @override
  String get setdAppearanceDarkMode => 'Modo Escuro';

  @override
  String get setdAppearanceLightMode => 'Modo Claro';

  @override
  String get setdAppearanceCurrentlyDark => 'Atualmente escuro';

  @override
  String get setdAppearanceCurrentlyLight => 'Atualmente claro';

  @override
  String get detailStatusOngoing => 'Em andamento';

  @override
  String get detailStatusCompleted => 'Concluído';

  @override
  String get detailStatusHiatus => 'Hiato';

  @override
  String get detailStatusCanceled => 'Cancelado';

  @override
  String get detailStatusFinished => 'Finalizado';

  @override
  String get detailStatusUnknown => 'Desconhecido';

  @override
  String detailChapterCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Capítulos',
      one: '1 Capítulo',
    );
    return '$_temp0';
  }

  @override
  String detailEpisodeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Episódios',
      one: '1 Episódio',
    );
    return '$_temp0';
  }

  @override
  String detailDownloadingChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Baixando $count capítulos',
      one: 'Baixando 1 capítulo',
    );
    return '$_temp0';
  }

  @override
  String get discoverTitle => 'Discover';

  @override
  String get discoverSort => 'Sort';

  @override
  String get discoverSortTrending => 'Trending';

  @override
  String get discoverSortPopular => 'Popular';

  @override
  String get discoverKindManga => 'Manga';

  @override
  String get discoverKindAnime => 'Anime';

  @override
  String get discoverKindNovel => 'Novels';

  @override
  String get discoverClearGenres => 'Clear';

  @override
  String get discoverEmpty => 'Nothing to recommend right now';

  @override
  String get discoverEmptyHint =>
      'Try another type, clear genre filters, or check your connection.';

  @override
  String get discoverRetry => 'Try again';

  @override
  String get discoverAddedToLibrary => 'Added to library';

  @override
  String get discoverRead => 'Read';

  @override
  String get discoverAdded => 'Added';

  @override
  String get discoverFindingSource => 'Finding a source…';

  @override
  String get discoverAddToLibrary => 'Add to Library';

  @override
  String get discoverNoSourceMatch => 'Not in your sources';

  @override
  String get discoverSaved => 'Saved';

  @override
  String get discoverSaveForLater => 'Save for later';

  @override
  String get discoverNext => 'Next';

  @override
  String get discoverWishlistTitle => 'Saved for later';

  @override
  String get discoverWishlistEmpty => 'Nothing saved yet';

  @override
  String get discoverWishlistEmptyHint =>
      'Save recommendations here to read once you have a source for them.';

  @override
  String get discoverNoSourceYet => 'No source found yet';

  @override
  String get discoverFindSource => 'Find source';

  @override
  String get discoverSource => 'Recommendation source';

  @override
  String discoverBecauseYouRead(String title) {
    return 'Because you read $title';
  }

  @override
  String get readerGazeScroll => 'Hands-free scrolling';

  @override
  String get readerGazeScrollSubtitle =>
      'Scroll by looking toward the top or bottom of the screen. Uses the front camera.';

  @override
  String get readerGazeCameraTitle => 'Use the front camera?';

  @override
  String get readerGazeCameraWarning =>
      'Hands-free scrolling watches your gaze with the front camera while you read. It runs entirely on your device — nothing is recorded or sent anywhere — but it uses extra battery.';

  @override
  String get readerGazeMode => 'Control with';

  @override
  String get readerGazeSensitivity => 'Sensitivity';

  @override
  String get readerGazeHoldTime => 'Hold time';

  @override
  String get readerGazeSmoothing => 'Smoothing';

  @override
  String get readerGazeCalibrate => 'Calibrate';

  @override
  String get readerGazeCalibrateSubtitle =>
      'Set your resting gaze and head position as the baseline.';

  @override
  String get readerGazeCalibrating => 'Look at the centre and hold still…';

  @override
  String get readerTiltScroll => 'Tilt to scroll';

  @override
  String get readerTiltScrollSubtitle =>
      'Scroll by tilting the phone forward or back. Works on any phone.';

  @override
  String get readerTiltCalibrateSubtitle =>
      'Hold the phone at your reading angle, then set it as the baseline.';

  @override
  String get readerTiltCalibrating =>
      'Hold the phone still at your reading angle…';

  @override
  String get readerScrollSpeed => 'Scroll speed';

  @override
  String get readerHandsFreeOptions => 'Hands-free options';

  @override
  String get readerCalibrateTitle => 'Gaze calibration';

  @override
  String get readerCalibrateInstruction => 'Look at the dot and hold still';

  @override
  String get readerCalibrateSuccess => 'Calibrated!';

  @override
  String get readerCalibrateTestPrompt => 'Try it — look up or down to scroll';

  @override
  String get readerCalibrateKeep => 'Save';

  @override
  String get readerCalibrateRedo => 'Recalibrate';

  @override
  String get readerCalibrateDoneTest => 'Done testing';

  @override
  String readerCalibratePointOf(int n, int total) {
    return 'Point $n of $total';
  }

  @override
  String get readerRadialMenu => 'Radial menu';

  @override
  String get readerRadialMenuSubtitle =>
      'Replace the reader bars with a back button and a corner wheel. Hold the wheel for quick actions and the page slider.';

  @override
  String get readerShiftPages => 'Shift double pages';

  @override
  String get readerShiftPagesDesc =>
      'Nudge the pairing by one if two-page spreads land split across the middle.';

  @override
  String get readerFinishedLabel => 'Finished';

  @override
  String get readerUpNextLabel => 'Up next';

  @override
  String get readerRadialCorner => 'Wheel corner';

  @override
  String get readerCalibrateGetReady => 'Follow the dot to each corner';

  @override
  String get readerCalibrateDarkTitle => 'Too dark for eye tracking';

  @override
  String get readerCalibrateDarkBody =>
      'Your eyes need some light to track. Switched to head-tilt — it works in any light. Tilt your head up or down to scroll.';

  @override
  String get readerCalibrateTestPromptHead =>
      'Tilt your head up or down to scroll';
}
