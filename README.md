# Daily Quotes 앱

Flutter로 개발된 일일 명언 앱입니다. iOS와 Android에서 동시에 실행 가능하며, 영어와 한국어를 지원합니다.

## 주요 기능

### 📱 플랫폼 지원
- **iOS**: 완전 지원
- **Android**: 완전 지원
- **네트워크 없이 동작**: 모든 데이터가 로컬에 저장되어 오프라인에서도 사용 가능

### 🌍 다국어 지원
- **한국어**: 기본 언어
- **영어**: 전환 가능
- 앱 내에서 실시간 언어 전환

### 📅 일일 명언
- **날짜 기반 인덱스**: 매일 다른 명언이 표시됩니다
- **31개의 명언**: 한 달 동안 매일 다른 명언을 제공
- **로컬 데이터**: `assets/quotes.json`에서 명언 데이터를 불러옵니다

### ❤️ 즐겨찾기 기능
- **로컬 저장**: SharedPreferences를 사용하여 즐겨찾기 저장
- **즐겨찾기 관리**: 추가/제거 기능
- **즐겨찾기 화면**: 별도 화면에서 즐겨찾기된 명언들을 확인 가능

### 📤 공유 기능
- **텍스트 공유**: 명언을 텍스트로 공유
- **다양한 플랫폼**: 다른 앱으로 명언 공유 가능

### 🎨 미니멀 UI
- **깔끔한 디자인**: Material Design 3 기반
- **그라데이션 카드**: 시각적으로 매력적인 명언 카드
- **직관적인 인터페이스**: 사용하기 쉬운 UI/UX

## 앱 구조

```
lib/
├── main.dart                 # 앱 진입점
├── models/
│   └── quote.dart           # 명언 데이터 모델
├── services/
│   ├── quote_service.dart   # 명언 데이터 관리
│   ├── favorites_service.dart # 즐겨찾기 관리
│   └── share_service.dart   # 공유 기능
├── screens/
│   ├── home_screen.dart     # 메인 화면
│   └── favorites_screen.dart # 즐겨찾기 화면
└── widgets/
    ├── quote_card.dart      # 명언 카드 위젯
    └── language_selector.dart # 언어 선택 위젯
```

## 설치 및 실행

### 필요 조건
- Flutter SDK 3.5.0 이상
- Dart SDK
- iOS 개발: Xcode (macOS)
- Android 개발: Android Studio

### 설치 방법

1. **저장소 클론**
   ```bash
   git clone <repository-url>
   cd daily_quote_app
   ```

2. **의존성 설치**
   ```bash
   flutter pub get
   ```

3. **앱 실행**
   ```bash
   # iOS 시뮬레이터에서 실행
   flutter run -d ios
   
   # Android 에뮬레이터에서 실행
   flutter run -d android
   
   # 연결된 디바이스에서 실행
   flutter run
   ```

### 빌드 방법

#### iOS 빌드
```bash
flutter build ios
```

#### Android 빌드
```bash
flutter build apk
# 또는
flutter build appbundle
```

## 사용법

### 기본 사용법
1. 앱을 실행하면 오늘의 명언이 표시됩니다
2. 언어 전환 버튼(한/EN)을 눌러 한국어/영어를 전환할 수 있습니다
3. 하트 버튼을 눌러 명언을 즐겨찾기에 추가할 수 있습니다
4. 공유 버튼을 눌러 명언을 다른 앱으로 공유할 수 있습니다

### 즐겨찾기 관리
1. 상단의 하트 아이콘을 눌러 즐겨찾기 화면으로 이동합니다
2. 즐겨찾기된 명언들을 확인할 수 있습니다
3. 각 명언에서 하트 버튼을 눌러 즐겨찾기에서 제거할 수 있습니다
4. 휴지통 아이콘을 눌러 모든 즐겨찾기를 한 번에 제거할 수 있습니다

## 기술 스택

- **Flutter**: 크로스 플랫폼 UI 프레임워크
- **Dart**: 프로그래밍 언어
- **SharedPreferences**: 로컬 데이터 저장
- **share_plus**: 공유 기능
- **intl**: 국제화 지원

## 데이터 구조

### Quote 모델
```dart
class Quote {
  final int id;           // 명언 ID
  final String english;   // 영어 명언
  final String korean;    // 한국어 명언
  final String author;    // 작가명
}
```

### JSON 데이터 형식
```json
{
  "quotes": [
    {
      "id": 1,
      "english": "The only way to do great work is to love what you do.",
      "korean": "훌륭한 일을 하는 유일한 방법은 자신이 하는 일을 사랑하는 것이다.",
      "author": "Steve Jobs"
    }
  ]
}
```

## 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.

## 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 문의사항

프로젝트에 대한 문의사항이 있으시면 이슈를 생성해 주세요.