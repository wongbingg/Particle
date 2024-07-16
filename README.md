
# Particle

## 서비스 소개
![180](https://hackmd.io/_uploads/Bylt5yLWUp.png)


앨범에 모아두었던 스크린샷에서 문장을 선택해 내용들을 하나의 글로 정리해 나만의 `파티클`을 만들 수 있는 앱 입니다. [앱스토어에서 다운받기](https://apps.apple.com/kr/app/particle/id6464103528)
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

<br>
	
## 🔭 프로젝트 RIB 구조

![](https://hackmd.io/_uploads/HJNODaPlT.png)

<br>

## 🛠️ 트러블 슈팅

### ⚠️ RIBs 구조 초기세팅
- RIBs 를 나눌 단위에 대해 고민했습니다. 팀원과 논의 결과 Interactor가 MVVM 구조의 ViewModel 역할을 하는 것으로 파악하여 뷰 하나당 하나의 RIB 를 구성하기로 결정했습니다.
- Viewless RIB 를 이용하여 여러 뷰를 하나의 흐름 단위로 묶어서 사용했습니다. 

### ⚠️ 네트워킹 모듈 설계
- Repository : 도메인 모델을 CRUD 하는 계층 입니다.
    - DataSource : DTO 모델을 CRUD 하는 계층 입니다. 
    - Mapper : DTO 모델 -> 도메인 모델로 변환해주는 객체입니다.

### ⚠️ CoreData 버전추가
- 좋아요 기능 추가를 위해서 CDUser Entity에 interestedRecords 프로퍼티를 추가했습니다.
- 기존 Entity에 그대로 Attribute 만 추가하여 빌드하니 오류가 발생했습니다. 
- 사용하는 모델파일 클릭 후 상단 Editor - Add Model Version 을 탭하여 새로운 버전을 추가하여 그 안에서 변경할 내용을 반영한 후 Inspector 창에 Model Version - Current 를 새로 추가한 버전으로 설정해주니 해결되었습니다. 