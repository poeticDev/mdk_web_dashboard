1. 내가 Flutter 프로젝트에 적용하려는 테마 구조에 대한 설명

- AdaptiveTheme를 사용해서 light/dark 모드 토글 및 저장을 관리할 거야.
- ThemeData는 직접 설계한 AppTheme에서 만든다.
- AppTheme는 다음 순서로 구성돼:
  - AppColors (semantic color 토큰)
  - AppTypography (플랫폼별 TextTheme)
  - AppTheme.light / AppTheme.dark (ThemeData를 만들어주는 팩토리)
- AdaptiveTheme는 AppTheme에서 만든 light/dark ThemeData를 받아서 모드를 전환한다.
- UI에서는 AdaptiveTheme에 직접 접근하지 않고, ThemeController를 거친다.
- 테마 토글 버튼은 ThemeToggle 위젯으로 적절한 위치에 붙여서 쓸 거야.
- 나중에 ThemeBrand를 추가해서 브랜드별 테마(light/dark 세트)를 여러 개 둘 계획이지만, 지금은 defaultBrand 하나만 쓴다.
- 샘플 코드 위치: lib/theme/

이 구조를 기준으로, 내가 제공한 샘플 코드들을 현재 프로젝트에 맞게 채워 넣고, 기존 색상과 스타일을 Theme 설정을 이 구조로 이전하자.
먼저 현재 제공된 샘플코드를 읽어보렴.

2. 작업 단계
2.1 앱컬러
이 프로젝트에 이미 존재하는 색상 설정을 기반으로
AppColors.light / AppColors.dark의 값을 채워줘.

규칙:
- AppColors에 정의된 각 필드의 기존 색상은 변경하지 않는다.
- 현재 프로젝트에서 사용 중이지만, AppColors에 의미상 매핑되지 않는 값이 있다면 AppColors에 새로 정의한다. (예: border, divider 등).
- 하지만 ColorScheme에 꼭 써먹을 수 있는 의미 있는 필드만 추가해줘.

2.2 앱 타이포
폰트 전략은 다음과 같아.
- 웹: GoogleFonts 기반 Pretendard (또는 비슷한 폰트) 사용