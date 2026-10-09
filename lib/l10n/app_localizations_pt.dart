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
  String get settingsRepoForgeTitle => 'RepoForge';

  @override
  String get settingsRepoForgeSubtitle =>
      'Crie e gerencie fontes a partir de qualquer URL';

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
  String get libraryApply => 'Aplicar';

  @override
  String get libraryAscending => 'Crescente';

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
  String get libraryChaptersRead => 'Capítulos Lidos';

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
  String get libraryCoverSize => 'Tamanho da Capa';

  @override
  String libraryDaysCount(Object days) {
    return '$days dias';
  }

  @override
  String get libraryDescending => 'Decrescente';

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
  String get libraryMonthlyActivity => 'Atividade Mensal';

  @override
  String get libraryMore => 'Mais';

  @override
  String get libraryMostReadSeries => 'Séries Mais Lidas';

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
  String get libraryNoNewChapters => 'Nenhum capítulo novo';

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
  String get libraryReadingStreak => 'Sequência de Leitura';

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
  String get librarySeries => 'Séries';

  @override
  String get libraryShowNumberOfItems => 'Mostrar número de itens';

  @override
  String get librarySizeLarge => 'Grande';

  @override
  String get librarySizeMedium => 'Médio';

  @override
  String get librarySizeSmall => 'Pequeno';

  @override
  String get librarySortLastUpdated => 'Última Atualização';

  @override
  String get librarySortRating => 'Avaliação';

  @override
  String get librarySortTitle => 'Título';

  @override
  String get librarySortUnreadCount => 'Quantidade Não Lida';

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
  String get libraryStreakBest => 'Melhor';

  @override
  String get libraryStreakCurrent => 'Atual';

  @override
  String libraryStreakDaysStrong(Object days) {
    return '$days dias seguidos — continue assim!';
  }

  @override
  String get libraryStreakKeepGoing => 'Leia amanhã para manter a sequência!';

  @override
  String get libraryStreakStart => 'Comece uma sequência lendo hoje!';

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
  String get libraryTotalChapters => 'Total de Capítulos';

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
  String get libraryVaultBreakdown => 'Detalhamento do Cofre';

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
  String get readerImageZoom => 'Zoom da Imagem';

  @override
  String get readerAutoPreloadNextChapter => 'Pré-carregar Próximo Capítulo';

  @override
  String get readerAutoPreloadNextChapterSubtitle =>
      'Carregar o próximo capítulo em segundo plano';

  @override
  String get readerCropBorders => 'Cortar Bordas';

  @override
  String get readerCropBordersSubtitle => 'Remover bordas brancas das páginas';

  @override
  String get readerGrayscale => 'Escala de Cinza';

  @override
  String get readerGrayscaleSubtitle => 'Exibir páginas em escala de cinza';

  @override
  String get readerAutoCrop => 'Auto-crop borders';

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
  String get readerZoomStartPosition => 'Posição Inicial do Zoom';

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
  String get readerTransitions => 'Transições';

  @override
  String get readerPageTransition => 'Transição de Página';

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
  String readerFinishedChapter(Object name) {
    return 'Concluído: $name';
  }

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
  String get browseRepoForgeTooltip => 'RepoForge — crie e gerencie fontes';

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
  String get browseNoResultsFound => 'Nenhum resultado encontrado';

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
  String get commonBeta => 'BETA';

  @override
  String get setxAdvancedSectionBeta => 'Experimental';

  @override
  String get setxAdvancedBeta => 'Beta features';

  @override
  String get setxAdvancedBetaDesc =>
      'Show experimental features — hands-free & volume-key scrolling, RepoForge, AI translation and auto-crop. They may be unstable or change.';

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
  String get repoDeleteSourceTitle => 'Excluir fonte?';

  @override
  String repoDeleteSourceBody(Object name) {
    return '\"$name\" será removida de Minhas Fontes.';
  }

  @override
  String get repoCancel => 'Cancelar';

  @override
  String get repoDelete => 'Excluir';

  @override
  String repoDeletedSource(Object name) {
    return '\"$name\" excluída';
  }

  @override
  String get repoNoSourcesToExport => 'Nenhuma fonte para exportar';

  @override
  String get repoExportDialogTitle => 'Exportar fontes do RepoForge';

  @override
  String repoExportedSources(Object count) {
    return '$count fontes exportadas';
  }

  @override
  String repoExportFailed(Object error) {
    return 'Falha na exportação: $error';
  }

  @override
  String repoImportedSources(Object count) {
    return '$count fonte(s) importada(s)';
  }

  @override
  String repoImportFailed(Object error) {
    return 'Falha na importação: $error';
  }

  @override
  String get repoBuildFromUrl => 'Crie fontes a partir de qualquer URL';

  @override
  String get repoBeta => 'BETA';

  @override
  String get repoHeroDescription =>
      'Detecte o framework de um site, ajuste os seletores e instale uma fonte funcional de mangá / anime / novel — sem servidor, tudo no dispositivo. O RepoForge está em beta, então nem sempre acerta uma fonte — confira o resultado e ajuste os seletores se um site não sair correto.';

  @override
  String repoCoverageSummary(Object frameworks, Object manga, Object novel) {
    return '$frameworks frameworks · $manga sites de mangá + $novel de novel conhecidos';
  }

  @override
  String get repoNewSource => 'Nova Fonte';

  @override
  String get repoImport => 'Importar';

  @override
  String get repoMySources => 'MINHAS FONTES';

  @override
  String get repoExportAll => 'Exportar tudo';

  @override
  String get repoNoSourcesYet => 'Nenhuma fonte ainda';

  @override
  String get repoEmptyStateHint =>
      'Toque em \"Nova Fonte\" para gerar uma a partir da URL de um site.';

  @override
  String get repoNotInstalled => 'não instalada';

  @override
  String get repoOpenInBrowse => 'Abrir em Explorar';

  @override
  String get repoEditRedetect => 'Editar / detectar novamente';

  @override
  String get repoKnownNovelSite => 'Site de light novel conhecido';

  @override
  String get repoNovelGenericDetail =>
      'Reconhecido como um site de novel — gerado com o corpo genérico de novel (a exploração pode precisar de ajuste dos seletores).';

  @override
  String repoNovelFrameworkDetail(Object framework) {
    return 'Gerado como uma fonte de Novel usando o corpo $framework — a navegação e o leitor funcionam de imediato.';
  }

  @override
  String get repoKnownMangaSite => 'Site de mangá conhecido';

  @override
  String get repoMangaApiDetail =>
      'Fonte de API verificada pela comunidade — o RepoForge a constrói a partir da API do site.';

  @override
  String repoMangaThemeDetail(Object theme) {
    return 'Tema verificado pela comunidade: $theme — os seletores são conhecidos.';
  }

  @override
  String get repoMangaCustomDetail =>
      'Há seletores personalizados verificados pela comunidade registrados para este site.';

  @override
  String get repoNotInKb => 'Não está na base de conhecimento';

  @override
  String get repoNotInKbDetail =>
      'O RepoForge detectará o framework em tempo real ao adicioná-lo e, se for personalizado, recorrerá a uma raspagem heurística de \"o que é o quê\".';

  @override
  String get repoCoverage => 'Cobertura';

  @override
  String get repoCheckASite => 'Verificar um site';

  @override
  String get repoPasteSiteUrlHint => 'cole a URL de um site';

  @override
  String get repoCheck => 'Verificar';

  @override
  String get repoSupportedFrameworks => 'Frameworks suportados';

  @override
  String get repoMangaSites => 'sites de mangá';

  @override
  String get repoNovelSites => 'sites de novel';

  @override
  String get repoFrameworks => 'frameworks';

  @override
  String get repoRoleItem => 'Item da lista (cada card)';

  @override
  String get repoRoleTitle => 'Título';

  @override
  String get repoRoleCover => 'Imagem de capa';

  @override
  String get repoRoleNextPage => 'Link da próxima página';

  @override
  String get repoRoleDetailTitle => 'Detalhe — título';

  @override
  String get repoRoleChapters => 'Item da lista de capítulos';

  @override
  String get repoRolePageImages => 'Imagens das páginas do leitor';

  @override
  String get repoRoleEpisodes => 'Lista de episódios (anime)';

  @override
  String get repoStepFetching => 'Buscando página…';

  @override
  String get repoStepMatching => 'Comparando assinaturas de frameworks…';

  @override
  String get repoStepExtracting => 'Extraindo seletores…';

  @override
  String get repoStepFinalizing => 'Finalizando…';

  @override
  String get repoEnterUrlFirst => 'Insira a URL de um site primeiro.';

  @override
  String repoDetectionFailed(Object error) {
    return 'Falha na detecção: $error';
  }

  @override
  String get repoFetchFailed => 'Falha ao buscar';

  @override
  String repoFetchedChars(Object count) {
    return '$count caracteres obtidos — agora teste os seletores';
  }

  @override
  String get repoFetchPageFirst => 'Busque uma página primeiro';

  @override
  String repoGenerationFailed(Object error) {
    return 'Falha na geração: $error';
  }

  @override
  String get repoDetectSiteFirst => 'Detecte um site primeiro';

  @override
  String repoCreatedInstalled(Object name) {
    return '\"$name\" criada e instalada';
  }

  @override
  String repoSaveFailed(Object error) {
    return 'Falha ao salvar: $error';
  }

  @override
  String get repoCreateSource => 'Criar Fonte';

  @override
  String get repoSiteUrl => 'URL do site';

  @override
  String get repoDetect => 'Detectar';

  @override
  String repoConfidence(Object pct) {
    return 'confiança $pct%';
  }

  @override
  String get repoApiSource => 'Fonte de API';

  @override
  String get repoDetails => 'Detalhes';

  @override
  String get repoSourceNameHint => 'Nome da fonte';

  @override
  String get repoName => 'Nome';

  @override
  String get repoLang => 'Idioma';

  @override
  String get repoManga => 'Mangá';

  @override
  String get repoAnime => 'Anime';

  @override
  String get repoNovel => 'Novel';

  @override
  String get repoNsfw => 'NSFW';

  @override
  String get repoScrapingStudio => 'Estúdio de Raspagem';

  @override
  String get repoScrapingStudioHint =>
      'Busque uma página e teste cada seletor para ver quantos elementos ele corresponde.';

  @override
  String get repoUrlToTestHint => 'URL para testar';

  @override
  String get repoFetch => 'Buscar';

  @override
  String get repoFetchFailedBlocked =>
      'Falha ao buscar — o site pode bloquear o acesso automatizado.';

  @override
  String repoLoadedChars(Object count) {
    return '$count caracteres carregados.';
  }

  @override
  String get repoPreviewJs => 'Visualizar JS';

  @override
  String get repoCreateInstall => 'Criar e Instalar';

  @override
  String get repoPickKnownSelector => 'Escolha um seletor conhecido';

  @override
  String get repoTest => 'Testar';

  @override
  String repoNoCatalogedSelectors(Object label) {
    return 'Nenhum seletor catalogado para \"$label\"';
  }

  @override
  String get repoInvalid => 'inválido';

  @override
  String get repoNoMatch => 'sem correspondência';

  @override
  String get repoGeneratedSource => 'Fonte gerada';

  @override
  String get repoCopy => 'Copiar';

  @override
  String get repoCopiedToClipboard =>
      'Fonte copiada para a área de transferência';

  @override
  String repoSelectorFor(Object field) {
    return 'Seletor para $field';
  }

  @override
  String get repoSearchSelectors => 'Buscar seletores…';

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
  String get setdVaultContentsInLibrary => 'Na sua biblioteca';

  @override
  String get setdVaultContentsMoveIntoHint => '→ mover para o cofre';

  @override
  String get setdVaultContentsInVault => 'No cofre';

  @override
  String get setdVaultContentsMoveOutHint => '← mover de volta para fora';

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
