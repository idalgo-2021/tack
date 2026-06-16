// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Tack';

  @override
  String get notes => 'Note';

  @override
  String get tags => 'Tag';

  @override
  String get settings => 'Impostazioni';

  @override
  String get search => 'Cerca';

  @override
  String get newNote => 'Nuova nota';

  @override
  String get editNote => 'Modifica';

  @override
  String get deleteNote => 'Eliminare nota?';

  @override
  String get deleteConfirm => 'Questa azione non può essere annullata.';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Elimina';

  @override
  String get save => 'Salva';

  @override
  String get done => 'Fatto';

  @override
  String get startWriting => 'Inizia a scrivere...';

  @override
  String get addTag => 'Aggiungi tag...';

  @override
  String get noNotes => 'Nessuna nota';

  @override
  String noNotesWithTag(Object tag) {
    return 'Nessuna nota con tag $tag';
  }

  @override
  String get noTags => 'Nessun tag';

  @override
  String get tagsAutoCreate =>
      'I tag vengono creati automaticamente quando aggiunti alle note';

  @override
  String get tapToCreate => 'Tocca + per creare';

  @override
  String get searchHint => 'Cerca note...';

  @override
  String get searchNotesHint => 'Cerca note... (#tag)';

  @override
  String get noResults => 'Niente trovato';

  @override
  String get typeToSearch => 'Digita per cercare';

  @override
  String get newTag => 'Nuovo tag';

  @override
  String get tagName => 'Nome del tag';

  @override
  String get renameTag => 'Rinomina tag';

  @override
  String get renameTagHint => 'Nuovo nome';

  @override
  String get deleteTag => 'Eliminare tag?';

  @override
  String get tagDeleteWarning => 'Il tag verrà rimosso da tutte le note.';

  @override
  String get createTag => 'Crea';

  @override
  String get saveChanges => 'Salvare le modifiche?';

  @override
  String get discard => 'Scarta';

  @override
  String get noteNotFound => 'Nota non trovata';

  @override
  String get noteDeleted => 'La nota è stata eliminata';

  @override
  String get allNotes => 'Tutte le note';

  @override
  String get photo => 'Foto';

  @override
  String get audio => 'Audio';

  @override
  String get attachedFiles => 'File allegati';

  @override
  String get addPhoto => 'Aggiungi foto';

  @override
  String get recordAudio => 'Registra audio';

  @override
  String get appearance => 'Aspetto';

  @override
  String get colorScheme => 'Schema colori';

  @override
  String get language => 'Lingua';

  @override
  String get viewMode => 'Modalità vista';

  @override
  String get fontSize => 'Dimensione carattere';

  @override
  String get grouping => 'Raggruppamento';

  @override
  String get sorting => 'Ordinamento';

  @override
  String get behavior => 'Comportamento';

  @override
  String get autoSave => 'Salvataggio automatico';

  @override
  String get autoSaveDesc => 'Salva automaticamente all\'uscita';

  @override
  String get compressImages => 'Comprimi immagini';

  @override
  String get compressImagesDesc => 'Riduci dimensione foto quando aggiunte';

  @override
  String get autoGeotag => 'Geo-tag automatico';

  @override
  String get autoGeotagDesc => 'Aggiungi coordinate automaticamente';

  @override
  String get showFileNames => 'Nomi file';

  @override
  String get showFileNamesDesc => 'Mostra nomi nella card della nota';

  @override
  String get showTimestamp => 'Data e ora';

  @override
  String get showTimestampDesc =>
      'Data e ora nella card e nella vista dettaglio';

  @override
  String get updateTimestampOnEdit => 'Aggiorna data durante modifica';

  @override
  String get updateTimestampOnEditDesc =>
      'Imposta data sull\'ora corrente al salvataggio';

  @override
  String get data => 'Dati';

  @override
  String get exportFormat => 'Formato di esportazione';

  @override
  String get archiveOnShare => 'Archivia quando condividi';

  @override
  String get archiveOnShareDesc =>
      'Impacchetta tutto in ZIP prima di Condividi';

  @override
  String get exportZip => 'Esporta in ZIP';

  @override
  String get exportZipDesc =>
      'Esporta tutte le note (formato dalle impostazioni)';

  @override
  String get viewModeList => 'Elenco';

  @override
  String get viewModeGrid => 'Griglia (2 colonne)';

  @override
  String get fontSizeSmall => 'Piccolo';

  @override
  String get fontSizeMedium => 'Medio';

  @override
  String get fontSizeLarge => 'Grande';

  @override
  String get groupModeNone => 'Nessun raggruppamento';

  @override
  String get groupModeDay => 'Per giorno';

  @override
  String get groupModeWeek => 'Per settimana';

  @override
  String get groupModeMonth => 'Per mese';

  @override
  String get sortModeDateDesc => 'Data (più recenti prima)';

  @override
  String get sortModeDateAsc => 'Data (più vecchie prima)';

  @override
  String get colorSchemeSage => 'Salvia';

  @override
  String get colorSchemePeach => 'Pesca';

  @override
  String get colorSchemeSky => 'Cielo';

  @override
  String get colorSchemeYellow => 'Giallo';

  @override
  String get colorSchemeBlue => 'Blu';

  @override
  String get colorSchemeCoral => 'Corallo';

  @override
  String get colorSchemeNavy => 'Blu scuro';

  @override
  String get colorSchemeDialog => 'Schema colori';

  @override
  String get languageDialog => 'Lingua';

  @override
  String get viewModeDialog => 'Modalità vista';

  @override
  String get fontSizeDialog => 'Dimensione carattere';

  @override
  String get groupingDialog => 'Raggruppamento';

  @override
  String get sortingDialog => 'Ordinamento';

  @override
  String get exportFormatDialog => 'Formato di esportazione';

  @override
  String get localeRu => 'Русский';

  @override
  String get localeEn => 'English';

  @override
  String get localeEs => 'Español';

  @override
  String get localeDe => 'Deutsch';

  @override
  String get localeUk => 'Українська';

  @override
  String get localePl => 'Polski';

  @override
  String get localeIt => 'Italiano';

  @override
  String get localeFr => 'Français';

  @override
  String get localeKk => 'Қазақша';

  @override
  String get localeKy => 'Кыргызча';

  @override
  String get localeTr => 'Türkçe';

  @override
  String get localeZh => '简体中文';

  @override
  String get localeJa => '日本語';

  @override
  String get dateToday => 'Oggi';

  @override
  String get dateYesterday => 'Ieri';

  @override
  String dateWeekHeader(Object week, Object year) {
    return 'Settimana $week, $year';
  }

  @override
  String get justNow => 'Proprio ora';

  @override
  String minutesAgo(Object minutes) {
    return '$minutes min fa';
  }

  @override
  String hoursAgo(Object hours) {
    return '$hours h fa';
  }

  @override
  String daysAgo(Object days) {
    return '$days g fa';
  }

  @override
  String deleteSelected(Object count) {
    return 'Eliminare $count note?';
  }

  @override
  String get clearFilter => 'Cancella filtro';

  @override
  String selectedCount(Object count) {
    return 'Selezionate: $count';
  }

  @override
  String get textCopied => 'Testo copiato';

  @override
  String get deleteGeotag => 'Eliminare geo-tag?';

  @override
  String get deleteGeotagConfirm =>
      'Le coordinate verranno rimosse dalla nota.';

  @override
  String get emptyNote => 'Nota vuota';

  @override
  String get emptyNoteConfirm => 'La nota è vuota. Salvare?';

  @override
  String get makePhoto => 'Scatta foto';

  @override
  String get chooseFromGallery => 'Scegli dalla galleria';

  @override
  String get selectTag => 'Seleziona tag';

  @override
  String get manage => 'Gestisci';

  @override
  String get stopLabel => 'Stop';

  @override
  String get addFile => 'File';

  @override
  String get recording => 'Registrazione...';

  @override
  String get selectTags => 'Seleziona tag';

  @override
  String get searchTags => 'Cerca tag...';

  @override
  String get clearAll => 'Cancella tutto';

  @override
  String get noTagsForQuery => 'Nessun tag per la ricerca';

  @override
  String get apply => 'Applica';

  @override
  String get noTagsCreated => 'Nessun tag creato';

  @override
  String get dates => 'Date';

  @override
  String get files => 'File';

  @override
  String get clearFilters => 'Cancella filtri';

  @override
  String get quickFilter => 'Filtro rapido per tag:';

  @override
  String get byName => 'Per nome';

  @override
  String get byCount => 'Per quantità';

  @override
  String get noMatches => 'Nessuna corrispondenza';

  @override
  String get exportTitle => 'Tack — Esportazione';

  @override
  String exportDate(Object date) {
    return 'Data di esportazione: $date';
  }

  @override
  String noteFrom(Object date) {
    return 'Nota del $date';
  }

  @override
  String get locationPermissionDenied =>
      'Permesso di posizione non concesso. Abilita nelle impostazioni del telefono.';

  @override
  String get version => 'Tack v1.0.0';

  @override
  String get error => 'Errore';

  @override
  String notesCount(Object count) {
    return '$count note';
  }

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get themeHighContrast => 'Alto contrasto';

  @override
  String get themeDialog => 'Tema';
}
