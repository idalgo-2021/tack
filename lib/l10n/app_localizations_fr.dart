// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Tack';

  @override
  String get notes => 'Notes';

  @override
  String get tags => 'Étiquettes';

  @override
  String get settings => 'Paramètres';

  @override
  String get search => 'Recherche';

  @override
  String get newNote => 'Nouvelle note';

  @override
  String get editNote => 'Modifier';

  @override
  String get deleteNote => 'Supprimer la note?';

  @override
  String get deleteConfirm => 'Cette action ne peut pas être annulée.';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get save => 'Enregistrer';

  @override
  String get done => 'Terminé';

  @override
  String get startWriting => 'Commencez à écrire...';

  @override
  String get addTag => 'Ajouter une étiquette...';

  @override
  String get noNotes => 'Aucune note';

  @override
  String noNotesWithTag(Object tag) {
    return 'Aucune note avec l\'étiquette $tag';
  }

  @override
  String get noTags => 'Aucune étiquette';

  @override
  String get tagsAutoCreate =>
      'Les étiquettes sont créées automatiquement lorsqu\'elles sont ajoutées aux notes';

  @override
  String get tapToCreate => 'Appuyez sur + pour créer';

  @override
  String get searchHint => 'Rechercher des notes...';

  @override
  String get searchNotesHint => 'Rechercher des notes... (#tag)';

  @override
  String get noResults => 'Rien trouvé';

  @override
  String get typeToSearch => 'Tapez pour rechercher';

  @override
  String get newTag => 'Nouvelle étiquette';

  @override
  String get tagName => 'Nom de l\'étiquette';

  @override
  String get renameTag => 'Renommer l\'étiquette';

  @override
  String get renameTagHint => 'Nouveau nom';

  @override
  String get deleteTag => 'Supprimer l\'étiquette?';

  @override
  String get tagDeleteWarning =>
      'L\'étiquette sera supprimée de toutes les notes.';

  @override
  String get createTag => 'Créer';

  @override
  String get saveChanges => 'Enregistrer les modifications?';

  @override
  String get discard => 'Ignorer';

  @override
  String get noteNotFound => 'Note introuvable';

  @override
  String get noteDeleted => 'La note a été supprimée';

  @override
  String get allNotes => 'Toutes les notes';

  @override
  String get photo => 'Photo';

  @override
  String get audio => 'Audio';

  @override
  String get attachedFiles => 'Fichiers joints';

  @override
  String get addPhoto => 'Ajouter une photo';

  @override
  String get recordAudio => 'Enregistrer un audio';

  @override
  String get appearance => 'Apparence';

  @override
  String get colorScheme => 'Schéma de couleurs';

  @override
  String get language => 'Langue';

  @override
  String get viewMode => 'Mode d\'affichage';

  @override
  String get fontSize => 'Taille de police';

  @override
  String get grouping => 'Regroupement';

  @override
  String get sorting => 'Tri';

  @override
  String get behavior => 'Comportement';

  @override
  String get autoSave => 'Auto-sauvegarde';

  @override
  String get autoSaveDesc => 'Sauvegarder automatiquement en quittant';

  @override
  String get compressImages => 'Compresser les images';

  @override
  String get compressImagesDesc =>
      'Réduire la taille des photos lors de l\'ajout';

  @override
  String get autoGeotag => 'Géo-tag automatique';

  @override
  String get autoGeotagDesc => 'Ajouter automatiquement les coordonnées';

  @override
  String get showFileNames => 'Noms de fichiers';

  @override
  String get showFileNamesDesc => 'Afficher les noms dans la carte de note';

  @override
  String get showTimestamp => 'Horodatage';

  @override
  String get showTimestampDesc =>
      'Date et heure dans la carte et la vue détaillée';

  @override
  String get updateTimestampOnEdit =>
      'Mettre à jour l\'horodatage lors de l\'édition';

  @override
  String get updateTimestampOnEditDesc =>
      'Définir l\'horodatage à l\'heure actuelle lors de l\'enregistrement';

  @override
  String get data => 'Données';

  @override
  String get exportFormat => 'Format d\'exportation';

  @override
  String get archiveOnShare => 'Archiver lors du partage';

  @override
  String get archiveOnShareDesc => 'Tout emballer dans ZIP avant Partager';

  @override
  String get exportZip => 'Exporter en ZIP';

  @override
  String get exportZipDesc =>
      'Exporter toutes les notes (format des paramètres)';

  @override
  String get viewModeList => 'Liste';

  @override
  String get viewModeGrid => 'Grille (2 colonnes)';

  @override
  String get fontSizeSmall => 'Petit';

  @override
  String get fontSizeMedium => 'Moyen';

  @override
  String get fontSizeLarge => 'Grand';

  @override
  String get groupModeNone => 'Aucun regroupement';

  @override
  String get groupModeDay => 'Par jour';

  @override
  String get groupModeWeek => 'Par semaine';

  @override
  String get groupModeMonth => 'Par mois';

  @override
  String get sortModeDateDesc => 'Date (plus récentes d\'abord)';

  @override
  String get sortModeDateAsc => 'Date (plus anciennes d\'abord)';

  @override
  String get colorSchemeSage => 'Sauge';

  @override
  String get colorSchemePeach => 'Pêche';

  @override
  String get colorSchemeSky => 'Ciel';

  @override
  String get colorSchemeYellow => 'Jaune';

  @override
  String get colorSchemeBlue => 'Bleu';

  @override
  String get colorSchemeCoral => 'Corail';

  @override
  String get colorSchemeNavy => 'Bleu marine';

  @override
  String get colorSchemeDialog => 'Schéma de couleurs';

  @override
  String get languageDialog => 'Langue';

  @override
  String get viewModeDialog => 'Mode d\'affichage';

  @override
  String get fontSizeDialog => 'Taille de police';

  @override
  String get groupingDialog => 'Regroupement';

  @override
  String get sortingDialog => 'Tri';

  @override
  String get exportFormatDialog => 'Format d\'exportation';

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
  String get dateToday => 'Aujourd\'hui';

  @override
  String get dateYesterday => 'Hier';

  @override
  String dateWeekHeader(Object week, Object year) {
    return 'Semaine $week, $year';
  }

  @override
  String get justNow => 'À l\'instant';

  @override
  String minutesAgo(Object minutes) {
    return 'il y a $minutes min';
  }

  @override
  String hoursAgo(Object hours) {
    return 'il y a $hours h';
  }

  @override
  String daysAgo(Object days) {
    return 'il y a $days j';
  }

  @override
  String deleteSelected(Object count) {
    return 'Supprimer $count notes?';
  }

  @override
  String get clearFilter => 'Effacer le filtre';

  @override
  String selectedCount(Object count) {
    return 'Sélectionnées: $count';
  }

  @override
  String get textCopied => 'Texte copié';

  @override
  String get deleteGeotag => 'Supprimer le géo-tag?';

  @override
  String get deleteGeotagConfirm =>
      'Les coordonnées seront supprimées de la note.';

  @override
  String get emptyNote => 'Note vide';

  @override
  String get emptyNoteConfirm => 'La note est vide. Enregistrer?';

  @override
  String get makePhoto => 'Prendre une photo';

  @override
  String get chooseFromGallery => 'Choisir dans la galerie';

  @override
  String get selectTag => 'Sélectionner une étiquette';

  @override
  String get manage => 'Gérer';

  @override
  String get stopLabel => 'Arrêter';

  @override
  String get addFile => 'Fichier';

  @override
  String get recording => 'Enregistrement...';

  @override
  String get selectTags => 'Sélectionner des étiquettes';

  @override
  String get searchTags => 'Rechercher des étiquettes...';

  @override
  String get clearAll => 'Tout effacer';

  @override
  String get noTagsForQuery => 'Aucune étiquette pour la recherche';

  @override
  String get apply => 'Appliquer';

  @override
  String get noTagsCreated => 'Aucune étiquette créée';

  @override
  String get dates => 'Dates';

  @override
  String get files => 'Fichiers';

  @override
  String get clearFilters => 'Effacer les filtres';

  @override
  String get quickFilter => 'Filtre rapide par étiquettes:';

  @override
  String get byName => 'Par nom';

  @override
  String get byCount => 'Par quantité';

  @override
  String get noMatches => 'Aucune correspondance';

  @override
  String get exportTitle => 'Tack — Exportation';

  @override
  String exportDate(Object date) {
    return 'Date d\'exportation: $date';
  }

  @override
  String noteFrom(Object date) {
    return 'Note du $date';
  }

  @override
  String get locationPermissionDenied =>
      'Permission de localisation non accordée. Activez-la dans les paramètres du téléphone.';

  @override
  String get version => 'Tack v1.0.0';

  @override
  String get error => 'Erreur';

  @override
  String notesCount(Object count) {
    return '$count notes';
  }

  @override
  String get theme => 'Thème';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeHighContrast => 'Contraste élevé';

  @override
  String get themeDialog => 'Thème';

  @override
  String get exportNoNotes => 'No notes to export';

  @override
  String exportError(Object error) {
    return 'Export error: $error';
  }

  @override
  String get exportFormatMarkdown => 'Markdown';

  @override
  String get exportFormatJson => 'JSON';

  @override
  String fromDate(Object date) {
    return 'From: $date';
  }

  @override
  String toDate(Object date) {
    return 'To: $date';
  }

  @override
  String get recordingError => 'Recording failed. Please try again.';
}
