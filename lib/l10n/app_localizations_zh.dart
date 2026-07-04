// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Tack';

  @override
  String get notes => '笔记';

  @override
  String get tags => '标签';

  @override
  String get settings => '设置';

  @override
  String get search => '搜索';

  @override
  String get newNote => '新笔记';

  @override
  String get editNote => '编辑';

  @override
  String get deleteNote => '删除笔记？';

  @override
  String get deleteConfirm => '此操作无法撤销。';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get save => '保存';

  @override
  String get done => '完成';

  @override
  String get startWriting => '开始写...';

  @override
  String get addTag => '添加标签...';

  @override
  String get noNotes => '没有笔记';

  @override
  String noNotesWithTag(Object tag) {
    return '没有标签为 $tag 的笔记';
  }

  @override
  String get noTags => '没有标签';

  @override
  String get tagsAutoCreate => '标签在添加到笔记时会自动创建';

  @override
  String get tapToCreate => '点击 + 创建';

  @override
  String get searchHint => '搜索笔记...';

  @override
  String get searchNotesHint => '搜索笔记... (#标签)';

  @override
  String get noResults => '未找到结果';

  @override
  String get typeToSearch => '输入搜索内容';

  @override
  String get newTag => '新标签';

  @override
  String get tagName => '标签名称';

  @override
  String get renameTag => '重命名标签';

  @override
  String get renameTagHint => '新名称';

  @override
  String get deleteTag => '删除标签？';

  @override
  String get tagDeleteWarning => '该标签将从所有笔记中移除。';

  @override
  String get createTag => '创建';

  @override
  String get saveChanges => '保存更改？';

  @override
  String get discard => '放弃';

  @override
  String get noteNotFound => '未找到笔记';

  @override
  String get noteDeleted => '笔记已删除';

  @override
  String get allNotes => '所有笔记';

  @override
  String get audio => '音频';

  @override
  String get camera => '相机';

  @override
  String get attachedFiles => '附件';

  @override
  String get addPhoto => '添加照片';

  @override
  String get recordAudio => '录制音频';

  @override
  String get recordVideo => '录制视频';

  @override
  String get appearance => '外观';

  @override
  String get colorScheme => '颜色方案';

  @override
  String get language => '语言';

  @override
  String get viewMode => '视图模式';

  @override
  String get fontSize => '字体大小';

  @override
  String get grouping => '分组';

  @override
  String get sorting => '排序';

  @override
  String get behavior => '行为';

  @override
  String get autoSave => '自动保存';

  @override
  String get autoSaveDesc => '退出时自动保存';

  @override
  String get autoGeotag => '自动地理标签';

  @override
  String get autoGeotagDesc => '自动添加坐标';

  @override
  String get showTimestamp => '时间戳';

  @override
  String get showTimestampDesc => '卡片和详情中的日期与时间';

  @override
  String get updateTimestampOnEdit => '编辑时更新时间戳';

  @override
  String get updateTimestampOnEditDesc => '保存时将时间戳设为当前时间';

  @override
  String get data => '数据';

  @override
  String get exportFormat => '导出格式';

  @override
  String get archiveOnShare => '分享时打包';

  @override
  String get archiveOnShareDesc => '分享前将所有内容打包为ZIP';

  @override
  String get viewModeList => '列表';

  @override
  String get viewModeGrid => '网格';

  @override
  String get fontSizeSmall => '小';

  @override
  String get fontSizeMedium => '中';

  @override
  String get fontSizeLarge => '大';

  @override
  String get groupModeNone => '不分组';

  @override
  String get groupModeDay => '按天';

  @override
  String get groupModeWeek => '按周';

  @override
  String get groupModeMonth => '按月';

  @override
  String get sortModeDateDesc => '日期（最新优先）';

  @override
  String get sortModeDateAsc => '日期（最早优先）';

  @override
  String get colorSchemeSage => '鼠尾草';

  @override
  String get colorSchemePeach => '桃色';

  @override
  String get colorSchemeSky => '天蓝';

  @override
  String get colorSchemeYellow => '黄色';

  @override
  String get colorSchemeBlue => '蓝色';

  @override
  String get colorSchemeCoral => '珊瑚';

  @override
  String get colorSchemeNavy => '深蓝';

  @override
  String get colorSchemeDialog => '颜色方案';

  @override
  String get languageDialog => '语言';

  @override
  String get viewModeDialog => '视图模式';

  @override
  String get fontSizeDialog => '字体大小';

  @override
  String get groupingDialog => '分组';

  @override
  String get sortingDialog => '排序';

  @override
  String get exportFormatDialog => '导出格式';

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
  String get dateToday => '今天';

  @override
  String get dateYesterday => '昨天';

  @override
  String dateWeekHeader(Object week, Object year) {
    return '第$week周, $year';
  }

  @override
  String get justNow => '刚刚';

  @override
  String minutesAgo(Object minutes) {
    return '$minutes分钟';
  }

  @override
  String hoursAgo(Object hours) {
    return '$hours小时';
  }

  @override
  String daysAgo(Object days) {
    return '$days天';
  }

  @override
  String deleteSelected(Object count) {
    return '删除$count条笔记？';
  }

  @override
  String get clearFilter => '清除筛选';

  @override
  String selectedCount(Object count) {
    return '已选: $count';
  }

  @override
  String get textCopied => '文本已复制';

  @override
  String get deleteGeotag => '删除地理标签？';

  @override
  String get deleteGeotagConfirm => '坐标将从笔记中移除。';

  @override
  String get emptyNote => '空笔记';

  @override
  String get emptyNoteConfirm => '笔记为空。保存？';

  @override
  String get saveBeforeAttach => '将保存笔记以附加文件。继续？';

  @override
  String get makePhoto => '拍照';

  @override
  String get chooseFromGallery => '从相册选择';

  @override
  String get selectTag => '选择标签';

  @override
  String get manage => '管理';

  @override
  String get stopLabel => '停止';

  @override
  String get addFile => '文件';

  @override
  String get recording => '录制中...';

  @override
  String get selectTags => '选择标签';

  @override
  String get searchTags => '搜索标签...';

  @override
  String get clearAll => '清除全部';

  @override
  String get noTagsForQuery => '没有匹配的标签';

  @override
  String get apply => '应用';

  @override
  String get noTagsCreated => '尚未创建标签';

  @override
  String get dates => '日期';

  @override
  String get files => '文件';

  @override
  String get clearFilters => '清除筛选条件';

  @override
  String get quickFilter => '按标签快速筛选：';

  @override
  String get byName => '按名称';

  @override
  String get byCount => '按数量';

  @override
  String get noMatches => '无匹配';

  @override
  String get exportTitle => 'Tack — 导出';

  @override
  String exportDate(Object date) {
    return '导出日期: $date';
  }

  @override
  String noteFrom(Object date) {
    return '$date的笔记';
  }

  @override
  String get locationPermissionDenied => '未获取位置权限。请在手机设置中启用。';

  @override
  String get version => 'Tack v1.0.0';

  @override
  String get error => '错误';

  @override
  String notesCount(Object count) {
    return '$count条笔记';
  }

  @override
  String get theme => '主题';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get themeHighContrast => '高对比度';

  @override
  String get themeDialog => '主题';

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
  String get openIn => '用...打开';

  @override
  String get shareFile => '分享';

  @override
  String get moreOptions => '更多选项';

  @override
  String get shirt => '背景';

  @override
  String get noColor => '无颜色';

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
