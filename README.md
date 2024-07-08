
# Particle

## 서비스 소개
![180](https://hackmd.io/_uploads/Bylt5yLWUp.png)


앨범에 모아두었던 스크린샷에서 문장을 선택해 내용들을 하나의 글로 정리해 나만의 `파티클`을 만들 수 있는 앱 입니다.
<br>

## 📑 목차

- [🖥️ 개발환경](#🖥%EF%B8%8F-개발-환경)
- [🔑 핵심기술](#%F0%9F%94%91-핵심-기술)
- [🧑🏻‍💻 팀원 소개](#🧑🏻%E2%80%8D💻-팀원-소개)
- [📱 실행화면](#📱-실행화면)
- [🔭 프로젝트 구조](#🔭-프로젝트-RIB-구조)
- [🛠 트러블 슈팅](#🛠%EF%B8%8F-트러블-슈팅)

<br>

## 🖥️ 개발 환경

- Xcode 14.3
- Swift 5.8
- 배포타겟: iOS 16
- 의존성 관리: Cocoapod, SPM
- 작업 일정관리: Notion 스프린트

<br>

## 🔑 핵심 기술 

### 🗃️ 프레임워크
- UI : UIKit
- LiveText : VisionKit, PhotoKit
- 애플로그인 : AuthenticationServices
- 로컬푸시알림 : UserNotifications

### 🗂️ 외부 의존성
- 아키텍쳐 : RIBs
- 네트워킹 : Alamofire
- 소셜로그인 : KakaoSDK
- 원격푸시알림 : FirebaseMessaging
- 오토레이아웃 : Snapkit
- ReactiveX : RxSwift, RxRelay, RxCocoa, RxDataSources, RxKeyboard



<br>

## 🧑🏻‍💻 팀원 소개

### Designer

|[권숙경]()|[김규원]()|
|:---:|:---:|

### Developer

|[홍석현]()|[이원빈](https://github.com/wongbingg)|[조현준]()|
|:---:|:---:|:---:|

<br>

## 📱 실행화면
    
### 홈 화면
|메인화면|아티클 추가|태그별 아티클 조회|
|:---:|:---:|:---:|
|<img src="https://hackmd.io/_uploads/SyLeeMODR.gif" width="200">|<img src="https://hackmd.io/_uploads/B1TJGzuw0.gif" width="200">|<img src="https://hackmd.io/_uploads/HJCngzuP0.gif" width="200">|
|`CollectionView`|`화면 상세설명`||

    
<!-- ### 탐색 화면
|화면1| 화면2 |화면3|
|:---:|:---:|:---:|
|<img src="" width="200">|<img src = "" width="200">|<img src="" width="200">|
|`화면 상세설명`|`화면 상세설명`|`화면 상세설명`|

### 검색 화면
|화면1|화면2|화면3|
|:---:|:---:|:---:|
|<img src="" width="200">|<img src="" width="200">|<img src="" width="200">|
|`화면 상세설명`|`화면 상세설명`|`화면 상세설명`| -->

### 마이페이지 화면
|마이페이지|알람설정|관심태그 설정|
|:---:|:---:|:---:|
|<img src="https://hackmd.io/_uploads/Bk1OzzdDA.png" width="200">|<img src="https://hackmd.io/_uploads/Hy_GGfuvR.png" width="200">|<img src="https://hackmd.io/_uploads/r10QMG_v0.png" width="200">|
|`화면 상세설명`|`화면 상세설명`|`화면 상세설명`|

<br>
	
## 🔭 프로젝트 RIB 구조

![](https://hackmd.io/_uploads/HJNODaPlT.png)

<br>

## 🛠️ 트러블 슈팅

### ⚠️ 로컬 푸시알림 구현 
