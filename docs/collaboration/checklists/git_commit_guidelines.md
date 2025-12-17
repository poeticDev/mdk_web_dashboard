# Git Commit Guidelines

## 메시지 포맷
- 헤더: `<Type(scope)>:한글 요약`
- `Type`는 PascalCase 영문(예: `Feat`, `Fix`, `Doc`, `Refactor`, `Chore`, `Test`).
- `scope`는 선택 사항이며 소문자 snake_case 또는 핵심 모듈명을 사용한다.
- `:` 뒤 본문은 한글로 작성한다. 필요 시 본문/푸터를 추가할 수 있지만, 헤더 규칙은 반드시 지킨다.
- Body(본문)는 빈 줄 하나 뒤에 작성하며, 각 줄에 핵심 변경 사항 또는 실행한 테스트를 bullet(`- `)로 정리한다.

## 예시
- `Feat(classroom):강의실 주간 캘린더 추가`
- `Fix(auth):만료 세션 리다이렉트 처리`
- `Doc(timetable):시간표 API 문서 동기화`

## 체크리스트
- [ ] 단일 책임(commit)으로 묶었는가?
- [ ] 헤더 타입/스코프를 영문으로, 나머지 메시지를 한글로 작성했는가?
- [ ] Body에 핵심 변경사항과 테스트 결과를 bullet로 정리했는가?
- [ ] 관련 이슈/PR을 커밋 푸터(예: `Refs #123`)에 연결했는가?
