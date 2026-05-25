# Hatch_Frontend
메추리알_프론트엔드 (Flutter Project)

본 프로젝트는 Flutter로 개발된 메추리알(Hatch) 애플리케이션의 프론트엔드 저장소입니다.

---

## 🚀 시작 가이드 (Getting Started)

이 프로젝트를 로컬 환경에서 실행하고 개발하기 위한 가상 에뮬레이터 설정 및 시작 가이드입니다.

### 1. 사전 요구사항 (Prerequisites)
- [Flutter SDK Installation](https://docs.flutter.dev/get-started/install) (추천 SDK 버전: `^3.11.1` 이상)
- [Android Studio](https://developer.android.com/studio) (Android 에뮬레이터 실행용) 또는 [Xcode](https://developer.apple.com/xcode/) (macOS 사용자의 iOS 시뮬레이터 실행용)
- VS Code 또는 Android Studio (Flutter / Dart 플러그인 설치 권장)

---

### 2. 가상 환경 (에뮬레이터/시뮬레이터) 설정

#### 📱 Android 가상 디바이스 (AVD) 설정 방법
1. **Android Studio**를 실행합니다.
2. **Device Manager** (기기 관리자)를 엽니다.
3. **Create Device**를 클릭한 후, 원하는 기기(예: Pixel 6 등)를 선택하고 **Next**를 누릅니다.
4. 실행하고자 하는 Android OS 버전(시스템 이미지)을 다운로드하고 선택한 후 **Next**를 누릅니다.
5. 에뮬레이터 이름을 확인하고 **Finish**를 클릭하여 생성을 완료합니다.
6. Device Manager 목록에서 생성한 기기 옆의 **▶ (실행)** 버튼을 눌러 에뮬레이터를 구동시킵니다.

#### 🍏 iOS 가상 디바이스 (Simulator) 설정 방법 (macOS 전용)
1. 터미널을 열고 다음 명령어를 실행하여 Xcode 시뮬레이터를 실행합니다:
   ```bash
   open -a Simulator
   ```

---

### 3. 프로젝트 설치 및 실행

#### ① 패키지 종속성 설치
프로젝트 폴더 내에서 필요한 라이브러리 및 의존성 패키지를 다운로드합니다.
```bash
flutter pub get
```

#### ② 연결된 가상 디바이스 및 기기 확인
현재 감지된 기기 및 가상환경 목록을 확인합니다.
```bash
flutter devices
```

#### ③ 앱 실행하기
가상 디바이스(에뮬레이터)가 켜져 있는 상태에서 프로젝트를 빌드하고 실행합니다.
```bash
flutter run
```
- 특정 디바이스로 실행하고 싶은 경우:
  ```bash
  flutter run -d <DEVICE_ID>
  ```
  *(예: `flutter run -d chrome` 또는 `flutter run -d emulator-5554`)*

---

### 🛠 환경 진단
환경 설정에 문제가 있다면 다음 명령어를 실행하여 오류를 자가 진단할 수 있습니다:
```bash
flutter doctor
```
위 명령어를 통해 Android Toolchain, Xcode 등 부족하거나 추가 설정이 필요한 부분을 확인해 보세요.


For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
