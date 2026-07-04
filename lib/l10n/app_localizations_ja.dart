// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Tack';

  @override
  String get notes => 'ノート';

  @override
  String get tags => 'タグ';

  @override
  String get settings => '設定';

  @override
  String get search => '検索';

  @override
  String get newNote => '新しいノート';

  @override
  String get editNote => '編集';

  @override
  String get deleteNote => 'ノートを削除しますか？';

  @override
  String get deleteConfirm => 'この操作は元に戻せません。';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get save => '保存';

  @override
  String get done => '完了';

  @override
  String get startWriting => '書き始めてください...';

  @override
  String get addTag => 'タグを追加...';

  @override
  String get noNotes => 'ノートがありません';

  @override
  String noNotesWithTag(Object tag) {
    return 'タグ $tag のノートはありません';
  }

  @override
  String get noTags => 'タグがありません';

  @override
  String get tagsAutoCreate => 'タグはノートに追加されると自動的に作成されます';

  @override
  String get tapToCreate => '＋をタップして作成';

  @override
  String get searchHint => 'ノートを検索...';

  @override
  String get searchNotesHint => 'ノートを検索... (#タグ)';

  @override
  String get noResults => '見つかりませんでした';

  @override
  String get typeToSearch => '入力して検索';

  @override
  String get newTag => '新しいタグ';

  @override
  String get tagName => 'タグ名';

  @override
  String get renameTag => 'タグ名を変更';

  @override
  String get renameTagHint => '新しい名前';

  @override
  String get deleteTag => 'タグを削除しますか？';

  @override
  String get tagDeleteWarning => 'タグはすべてのノートから削除されます。';

  @override
  String get createTag => '作成';

  @override
  String get saveChanges => '変更を保存しますか？';

  @override
  String get discard => '破棄';

  @override
  String get noteNotFound => 'ノートが見つかりません';

  @override
  String get noteDeleted => 'ノートは削除されました';

  @override
  String get allNotes => 'すべてのノート';

  @override
  String get audio => '音声';

  @override
  String get camera => 'カメラ';

  @override
  String get attachedFiles => '添付ファイル';

  @override
  String get addPhoto => '写真を追加';

  @override
  String get recordAudio => '音声を録音';

  @override
  String get recordVideo => 'ビデオを録画';

  @override
  String get appearance => '外観';

  @override
  String get colorScheme => '配色';

  @override
  String get language => '言語';

  @override
  String get viewMode => '表示モード';

  @override
  String get fontSize => 'フォントサイズ';

  @override
  String get grouping => 'グループ化';

  @override
  String get sorting => '並び替え';

  @override
  String get behavior => '動作';

  @override
  String get autoSave => '自動保存';

  @override
  String get autoSaveDesc => '終了時に自動保存';

  @override
  String get autoGeotag => '自動ジオタグ';

  @override
  String get autoGeotagDesc => '座標を自動的に追加';

  @override
  String get showTimestamp => 'タイムスタンプ';

  @override
  String get showTimestampDesc => 'カードと詳細画面の日時';

  @override
  String get updateTimestampOnEdit => '編集中にタイムスタンプを更新';

  @override
  String get updateTimestampOnEditDesc => '保存時にタイムスタンプを現在時刻に設定';

  @override
  String get data => 'データ';

  @override
  String get exportFormat => 'エクスポート形式';

  @override
  String get archiveOnShare => '共有時にアーカイブ';

  @override
  String get archiveOnShareDesc => '共有前にすべてをZIPにパッケージ化';

  @override
  String get viewModeList => 'リスト';

  @override
  String get viewModeGrid => 'グリッド';

  @override
  String get fontSizeSmall => '小';

  @override
  String get fontSizeMedium => '中';

  @override
  String get fontSizeLarge => '大';

  @override
  String get groupModeNone => 'グループ化しない';

  @override
  String get groupModeDay => '日ごと';

  @override
  String get groupModeWeek => '週ごと';

  @override
  String get groupModeMonth => '月ごと';

  @override
  String get sortModeDateDesc => '日付（新しい順）';

  @override
  String get sortModeDateAsc => '日付（古い順）';

  @override
  String get colorSchemeSage => 'セージ';

  @override
  String get colorSchemePeach => 'ピーチ';

  @override
  String get colorSchemeSky => 'スカイ';

  @override
  String get colorSchemeYellow => 'イエロー';

  @override
  String get colorSchemeBlue => 'ブルー';

  @override
  String get colorSchemeCoral => 'コーラル';

  @override
  String get colorSchemeNavy => 'ネイビー';

  @override
  String get colorSchemeDialog => '配色';

  @override
  String get languageDialog => '言語';

  @override
  String get viewModeDialog => '表示モード';

  @override
  String get fontSizeDialog => 'フォントサイズ';

  @override
  String get groupingDialog => 'グループ化';

  @override
  String get sortingDialog => '並び替え';

  @override
  String get exportFormatDialog => 'エクスポート形式';

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
  String get dateToday => '今日';

  @override
  String get dateYesterday => '昨日';

  @override
  String dateWeekHeader(Object week, Object year) {
    return '$week週目, $year';
  }

  @override
  String get justNow => 'たった今';

  @override
  String minutesAgo(Object minutes) {
    return '$minutes分';
  }

  @override
  String hoursAgo(Object hours) {
    return '$hours時間';
  }

  @override
  String daysAgo(Object days) {
    return '$days日';
  }

  @override
  String deleteSelected(Object count) {
    return '$count件のノートを削除しますか？';
  }

  @override
  String get clearFilter => 'フィルターをクリア';

  @override
  String selectedCount(Object count) {
    return '選択中: $count';
  }

  @override
  String get textCopied => 'テキストをコピーしました';

  @override
  String get deleteGeotag => 'ジオタグを削除しますか？';

  @override
  String get deleteGeotagConfirm => '座標はノートから削除されます。';

  @override
  String get emptyNote => '空のノート';

  @override
  String get emptyNoteConfirm => 'ノートは空です。保存しますか？';

  @override
  String get saveBeforeAttach => 'ファイルを添付するためにノートを保存します。続行しますか？';

  @override
  String get makePhoto => '写真を撮る';

  @override
  String get chooseFromGallery => 'ギャラリーから選択';

  @override
  String get selectTag => 'タグを選択';

  @override
  String get manage => '管理';

  @override
  String get stopLabel => '停止';

  @override
  String get addFile => 'ファイル';

  @override
  String get recording => '録音中...';

  @override
  String get selectTags => 'タグを選択';

  @override
  String get searchTags => 'タグを検索...';

  @override
  String get clearAll => 'すべてクリア';

  @override
  String get noTagsForQuery => '検索条件に一致するタグがありません';

  @override
  String get apply => '適用';

  @override
  String get noTagsCreated => 'タグが作成されていません';

  @override
  String get dates => '日付';

  @override
  String get files => 'ファイル';

  @override
  String get clearFilters => 'フィルターをクリア';

  @override
  String get quickFilter => 'タグで絞り込み:';

  @override
  String get byName => '名前順';

  @override
  String get byCount => '数順';

  @override
  String get noMatches => '一致なし';

  @override
  String get exportTitle => 'Tack — エクスポート';

  @override
  String exportDate(Object date) {
    return 'エクスポート日: $date';
  }

  @override
  String noteFrom(Object date) {
    return '$dateのノート';
  }

  @override
  String get locationPermissionDenied => '位置情報の許可が得られませんでした。電話の設定で有効にしてください。';

  @override
  String get version => 'Tack v1.0.0';

  @override
  String get error => 'エラー';

  @override
  String notesCount(Object count) {
    return '$count件のノート';
  }

  @override
  String get theme => 'テーマ';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get themeHighContrast => 'ハイコントラスト';

  @override
  String get themeDialog => 'テーマ';

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

  @override
  String get openIn => 'で開く...';

  @override
  String get shareFile => '共有';

  @override
  String get moreOptions => 'その他のオプション';

  @override
  String get shirt => '背景色';

  @override
  String get noColor => '色なし';

  @override
  String get selectAll => 'Select All';

  @override
  String get deselectAll => 'Deselect All';

  @override
  String get pin => 'Pin';

  @override
  String get unpin => 'Unpin';

  @override
  String get pinned => 'Pinned';
}
