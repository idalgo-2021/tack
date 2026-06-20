# CI/CD Pipeline — Tack

## Веточная стратегия

- `main` — стабильный релиз. Только через PR из `develop`.
- `develop` — разработка. Прямые коммиты + PR из feature-веток.
- `feature/*` — фичи от `develop`, PR → `develop`.

Правила:
- В `main` коммиты запрещены — только squash-merge через PR.
- В `develop` можно коммитить напрямую, но рекомендуется PR.
- Теги `v*` (`v1.0.0`, `v1.1.0`) ставятся только на `main`.

---

## Порядок работы CI

### На каждый push / PR в `develop` и `main`

Триггер: `push` / `pull_request` → `main | develop`

**Шаги:**

1. **Checkout** — клонировать репозиторий
2. **Setup Flutter** — установить последний стабильный Flutter SDK (через `subosito/flutter-action`)
3. `flutter pub get` — установить зависимости
4. `dart run build_runner build` — сгенерировать Riverpod-код из аннотаций
5. `flutter gen-l10n` — сгенерировать Dart-классы локализации из .arb
6. `dart analyze` — статический анализ (должен быть 0 ошибок)
7. `flutter test` — прогон тестов (любой упавший тест → статус ❌)

Результат: зелёная галочка на коммите/PR. При ошибке — PR блокируется для merge.

### На тег `v*` (релиз)

Триггер: `push` → `refs/tags/v*` или ручной запуск (`workflow_dispatch`)

**Шаги:**

1. Checkout + Setup Flutter + pub get + build_runner + gen-l10n
2. **Decode keystore** — из `${{ secrets.KEYSTORE_BASE64 }}` восстановить `android/app/keystore.jks`
3. `flutter build apk --release --split-per-abi` — собрать APK для arm64-v8a, armeabi-v7a, x86_64
4. **Upload artifacts** — все `.apk` сохранить как артефакты сборки
5. **GitHub Release** — создать Release с телом "Tack v{tag}" и прикрепить APK

### Подпись APK (Signing)

Keystore хранится в GitHub Secrets:
- `KEYSTORE_BASE64` — сам файл `keystore.jks` в base64
- `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD` — параметры подписи

`build.gradle` (app-level) должен читать переменные окружения:

```groovy
signingConfigs {
    release {
        storeFile file(System.getenv("KEYSTORE_PATH") ?: "keystore.jks")
        storePassword System.getenv("KEYSTORE_PASSWORD")
        keyAlias System.getenv("KEY_ALIAS")
        keyPassword System.getenv("KEY_PASSWORD")
    }
}
```

---

## Локальная сборка (без CI)

```bash
flutter pub get
dart run build_runner build
flutter gen-l10n
dart analyze
flutter test
flutter build apk --release --split-per-abi
```

---

## Файлы

| Файл | Назначение |
|---|---|
| `.github/workflows/ci.yml` | CI — анализ + тесты на push/PR |
| `.github/workflows/release.yml` | CD — сборка релизного APK |
| `.github/CI_CD_PLAN.ru.md` | (этот файл) документация пайплайна |

---

## Начальная настройка репозитория

```bash
git init
git add .
git commit -m "initial commit"
git branch -M main
git remote add origin <url>
git push -u origin main

git checkout -b develop
git push -u origin develop
```
