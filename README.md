
# Particle

## 서비스 소개
![180](https://hackmd.io/_uploads/Bylt5yLWUp.png)


앨범에 모아두었던 스크린샷에서 문장을 선택해 내용들을 하나의 글로 정리해 나만의 `파티클`을 만들 수 있는 앱. [앱스토어에서 다운받기](https://apps.apple.com/kr/app/particle/id6464103528)
<br>

## 📑 목차

- [🖥️ 개발환경](#🖥%EF%B8%8F-개발-환경)
- [🔑 핵심기술](#%F0%9F%94%91-핵심-기술)
- [🔭 프로젝트 구조](#🔭-프로젝트-RIB-구조)
- [🔭 네트워킹 모듈설계](#🔭-네트워킹-모듈-설계)
- [📱 실행화면](#📱-실행화면)
- [🧑🏻‍💻 팀원 소개](#🧑🏻%E2%80%8D💻-팀원-소개)
- [⛹️‍♀️ 협업 방식](#⛹%EF%B8%8F%E2%80%8D♀%EF%B8%8F-협업-방식)
- [🚀 운영](#🚀-운영)
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

## 🔭 프로젝트 RIB 구조

![](https://hackmd.io/_uploads/HJNODaPlT.png)

<br>

## 🔭 네트워킹 모듈 설계
- Repository : 도메인 모델을 CRUD 하는 계층
    - DataSource : DTO 모델을 CRUD 하는 계층
        - Remote : DataTransferService를 의존성으로 가짐.
        - Local : CoreData를 의존성으로 가짐.
    - Mapper : DTO 모델 -> 도메인 모델로 변환해주는 객체
- DataTransferService : EndPoint 를 받아 Response Data로 반환하는 객체
- EndPoint : URLRequest 를 만드는데 필요한 모든 정보를 담는 객체

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

## 🧑🏻‍💻 팀원 소개

### Designer

|[권숙경]()|[김규원]()|
|:---:|:---:|

### Developer

|[홍석현]()|[이원빈](https://github.com/wongbingg)|[조현준]()|
|:---:|:---:|:---:|

<br>

## ⛹️‍♀️ 협업 방식

1. 작업 관리
- 5명의 팀원 간 작업상태 공유 및 회의를 위한 방법이 필요. 회사에서 사용 중인 Notion의 Sprint템플릿을 가져와 팀원들에게 사용법을 설명 후 도입.작업 현황을 한 눈에 파악 가능하여 개발 일정산출 시간을 줄이는데 기여
2. 디자이너와 협업
- Figma 디자인 결과물에 대한 정확한 수치값 적용과 빠른 화면개발이필요.타이포그래피,컬러칩 등 디자이너가 미리 작업해둔 수치값들을 앱에서 열거형을 활용하여 정의. 예외 케이스를 제외하고 재사용 컴포넌트를 사용하는 화면에는 요구사항을 빠르게 반영
3. 서버 개발자와 협업
- 제공받은 Swagger를 통해 명세서를 파악한 뒤, 필요한 httpMethods,baseURL,path값 들을 열거형을 활용하여 정의. 요청이 추가 되거나 path값이 변경 되어도 빠르게 프로젝트 전체에 반영하여 요구사항 변경에 대응.

<br>

## 🚀 운영
1. 배포 자동화
- 아카이빙 과정에 드는 시간비용을 단축하기 위해 Fastlane을 도입하여 터미널 명령 한 줄로 테스트 플라이트 배포가 가능하도록 자동화 스크립트를 작성하여 적용.
- 주 1회 테스트 플라이트 배포를 통해 지속적으로 내부 테스팅, 디자인 점검, 기능 점검을 수행.
2. 서버 없이 앱 출시
- 출시 예정일 한 달 앞두고, 사정상 서버 지원이 중단되며 앱 동작에 문제가 발생.
- Repository 계층 안에서 DataSourceProtocol을 채택하는 기존 RemoteDataSource 객체를 로컬 데이터베이스(CoreData 사용)로 변경하여 대응.
- 서버가 필요한 기능을 제외한 나머지 기능들을 보존하여 앱 출시. 

<br>

## 🛠️ 트러블 슈팅

### ⚠️ RIBs 구조 초기세팅
- RIBs 를 나눌 단위에 대해 고민. 팀원과 논의 결과 Interactor가 MVVM 구조의 ViewModel 역할을 하는 것으로 파악하여 뷰 하나당 하나의 RIB 를 구성하기로 결정.
- Viewless RIB 를 이용하여 여러 뷰를 하나의 흐름 단위로 묶어서 사용. 


### ⚠️ CoreData 버전추가
- 좋아요 기능 추가를 위해서 CDUser Entity에 interestedRecords 프로퍼티를 추가.
- 기존 Entity에 그대로 Attribute 만 추가하여 빌드하니 오류가 발생. 
- 사용하는 모델파일 클릭 후 상단 Editor - Add Model Version 을 탭하여 새로운 버전을 추가하여 그 안에서 변경할 내용을 반영한 후 Inspector 창에 Model Version - Current 를 새로 추가한 버전으로 설정해주어 해결. 

### ⚠️ 사진 셀 재사용 오류
- 앨범에서 사진을 불러와 CollectionViewCell로 표현하는 과정에 스크롤 후 멈출 시, 여러 사진이 번갈아가며 랜더링 되는 오류 발생.
- 셀이 재사용될 때, prepareForReuse() 메서드를 오버라이딩 하여 이전에 요청했던 사진 렌더링을 취소해주어 중복 렌더링 현상 해결.

### ⚠️ 사진 셀 내부 버튼 탭 인식 오류
- 선택한 사진 목록을 보여주는 하단 바에서 사진 선택 취소를 위해 셀 내부에 X 버튼을 생성하여 액션을 등록해주었지만, 반응하지 않는 오류 발생.
- 뷰 디버깅 툴로 확인 결과 (셀 - 이미지뷰 - x버튼) 순서로 쌓여있고, 중간 층인 이미지뷰에서 User Interaction Enable 속성이 꺼져있던 것을 켜주어 오류 해결.[이슈체크](https://github.com/wongbingg/Particle/issues/1#issuecomment-2192855097)
