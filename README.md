# web_dashboard

mdk web dashboard

## 배포 가이드 (Web)

### 1) 환경 설정 파일 준비
`assets/env/prod.json`에 배포용 API 경로를 설정한다.

```json
{
  "BASE_URL": "/api/v1"
}
```

### 2) 웹 빌드
```bash
flutter build web --release --dart-define-from-file=assets/env/prod.json
```

### 3) 산출물 배포
`build/web/` 디렉터리를 정적 파일로 배포한다. (예: `/srv/console`)

### 4) Caddy 프록시 예시
```caddyfile
192.168.219.136, localhost, :443 {
  tls internal
  encode gzip

  root * /srv/console
  file_server

  # API 프록시 설정 (경로 기반)
  @api path /api/*
  reverse_proxy @api dashboard-api:3000
}
```

### 5) GitHub Actions로 배포 빌드 + 릴리스
태그(`v*`)를 푸시하면 `.github/workflows/release-web.yml`이 실행되어
웹 빌드 후 Release에 zip을 첨부한다.

```bash
git tag v0.1.1
git push origin v0.1.1
```

수동 실행 시 `define_file` 입력으로 환경 파일을 지정할 수 있다.
기본값은 `assets/env/prod.json`이다.

## 개발 빌드/실행

### 1) 개발 환경 설정 파일 준비
`assets/env/dev.json`에 개발용 API 경로를 설정한다.

```json
{
  "BASE_URL": "https://localhost:3000/api/v1"
}
```

### 2) 개발 실행 (Web)
```bash
flutter run -d chrome --dart-define-from-file=assets/env/dev.json
```

### 3) 개발용 웹 빌드 (선택)
```bash
flutter build web --dart-define-from-file=assets/env/dev.json
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
