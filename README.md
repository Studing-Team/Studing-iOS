# 스튜딩 - 학생회와 함께 만들어가는 대학생활 필수 앱

> 스튜딩은 학생회 운영을 돕기 위해 만든 서비스입니다. <br> 헌신하고, 봉사하고, 가치로운 일을 하고픈 학생회 여러분들의 꿈을 <br> 스튜딩이 함께 이루겠습니다!

<br>

## 🗓️ 프로젝트 일정
- 2025.01 ~ 2025.03 - 1차 스프린트 기능 추가 (푸쉬 알림, 공지사항 수정 & 삭제, 선착순 이벤트, 이미지 확대 기능 )
- 2024.09 ~ 2024.12 - UI 설계 
- 2024.08 ~ 2024.09 - 기획, 디자인 및 프로젝트 초기 설정

<br>


<details>
  **<summary>Studing UI 및 핵심 플로우</summary>**
  
  ![Studing UI 및 핵심 플로우](https://github.com/user-attachments/assets/af88eaa1-4e56-4cf8-803e-ceaf20e563db)
  
</details>


<br>

## 1차 스프린트


### 1. 상속 기반의 모달에서 Composition 패턴을 도입한 모달로 변경

<br>

기존 Custom 모달의 경우 상속을 기반으로 `BaseSheetViewController` 는 공통적인 컨텐츠 레이아웃, `Single & DoubleButtonSheetViewController` 는 하단 버튼의 개수에 따른 클래스를 구현했습니다. 시간이 지나면서 몇 가지 한계가 눈에 띄었습니다. 버튼 개수나 콘텐츠가 달라질 때마다 새로운 서브클래스를 만들어야 했기 때문에 클래스가 점점 늘어나면서 관리하기가 점점 어려워졌습니다. 

<br>

공통 레이아웃을 상속으로 처리했지만 버튼 설정이나 스타일 조정 같은 부분이 각 모달마다 반복되다 보니 코드 중복도 피할 수 없었습니다. 상속 구조 자체가 버튼 위치를 바꾸거나 새로운 UI 요구사항이 생겼을 때 빠르게 대응하기 힘들 정도로 유연성이 부족했고 모달의 UI와 동작이 강하게 결합되어 있어 테스트하거나 수정할 때도 복잡함을 느꼈습니다.

<br>

이런 문제를 해결하고자 대안을 찾아보던 중, **Composition 패턴**을 발견하게 되었습니다. 이 패턴은 개별 컴포넌트를 독립적으로 설계한 뒤 이를 조합해서 전체 모달을 구성하는 방식으로 상속보다 훨씬 유연하고 재사용성이 높다는 점이 매력적이었습니다. 그래서 `SheetContentConfigurable`과 `SheetButtonsConfigurable` 프로토콜을 만들어 콘텐츠와 버튼을 분리하고 `BaseSheetViewController`에서 이들을 동적으로 조합하도록 리팩토링했습니다. 결과적으로 버튼 개수나 콘텐츠 종류에 상관없이 한 클래스로 다양한 모달을 처리할 수 있게 되었고 유지보수성을 개선할 수 있었습니다.

<br>

![modal](https://github.com/user-attachments/assets/03ce10cf-09ea-4cc8-9d03-73365822e227)


<br>

**🔗 [[Feat] #56 - 1차 스프린트 관련 QA 반영](https://github.com/Studing-Team/Studing-iOS/pull/57)**

<br>

### 2. 푸시 알림 딥링크 처리 - Coordinator 기반

<br>

활성화된 코디네이터와 대기 중인 딥링크를 일관되게 관리하고 푸시 알림은 앱이 종료된 상태에서도 발생할 수 있어 코디네이터 초기화 타이밍과 관계없이 데이터를 안전하게 처리할 수 있는 전역 인스턴스가 필요했습니다. 이는 코디네이터가 초기화되지 않은 상황에서 호출되면서 지속적으로 에러가 발생되어 데이터가 손실되거나 사용자 경험이 저하되는 문제가 발생하기 때문에 흐름을 보장하기 위해 `DeepLinkNavigator` 를 싱글톤으로 설계했습니다.

<Br>

딥링크 처리는 앱 전역에서 발생하는 이벤트이기 때문에 모든 코디네이터와 뷰 컨트롤러가 공유해야 하는 공통 상태를 관리해야합니다. 앱 전체적으로 중앙에서 관리하도록 통합하여 코디네이터 초기화 타이밍과 관계없이 안정적으로 처리할 수 있게 되었습니다. 싱글톤의 단점(테스트 어려움, 메모리 유지)은 있지만 `DeepLinkCoordinator` 프로토콜과 함께 설계했기 때문에 단위 테스트에서 `Mock DeepLinkNavigator`를 구현하거나 테스트용 싱글톤 인스턴스를 제공해 테스트를 용이하게 설계 했습니다.

<br>

또한 Coordinator 패턴과 자연스럽게 통합하기 위해 `DeepLinkCoordinator` 프로토콜을 정의해 딥링크 처리를 할 수 있게 구현했습니다. 이 프로토콜은 `navigate(to: data:)`와 `coordinatorType()` 메서드를 포함해 각 코디네이터가 딥링크 목적지(`DeepLinkDestination`)로 이동할 수 있는 로직을 추상화합니다. 새로운 딥링크 목적지나 화면 전환 로직을 추가할 때, `DeepLinkCoordinator` 를 구현한 코디네이터를 쉽게 확장하거나 기존 코디네이터를 조정해 적용할 수 있어, 유지보수성과 확장성을 크게 향상시켰습니다.

<br>

![Coordinator Pattern](https://github.com/user-attachments/assets/8c6fe384-7b1c-411f-8b84-c8737ed1b5ff)


<br>

**🔗 [[Feat] #50 - 푸시 알람 딥링크 로직 구현](https://github.com/Studing-Team/Studing-iOS/pull/53)**

<br>

## 💻 Development Environment
![Xcode](https://img.shields.io/badge/Xcode-16.2-skyblue)
![iOS](https://img.shields.io/badge/iOS-17.0+-white)

<br>

## 📦 Using Libraries

| Library | Description | Dependency |
|:-----:|:-----:|:-----:|
| [**Firebase**](https://github.com/Moya/Moya](https://github.com/firebase)) | 실시간 푸시 알림을 구현하여 사용자와의 즉각적인 상호작용을 지원합니다 |SPM |
| [**Alamofire**](https://github.com/Alamofire/Alamofire.git) | RESTful API 호출을 간소화하고 Endpoint 구조와 결합해 네트워크 로직을 최적화합니다 |SPM |
| [**Amplitude-Swift**](https://github.com/amplitude/Amplitude-Swift) | 사용자 행동 분석을 통해 데이터 기반의 앱 개선을 가능하게 합니다 | SPM |
| [**NMapsMap**](https://github.com/navermaps/SPM-NMapsMap) | 네이버 지도 SDK를 활용해 고성능 지도 기능과 위치 기반 서비스를 제공합니다 | SPM |
| [**SnapKit**](https://github.com/SnapKit/SnapKit) | AutoLayout을 코드 기반으로 간결하게 설정하며 UI 개발 생산성을 높입니다 | SPM |
| [**Then**](https://github.com/devxoul/Then) | 클로저 기반 인스턴스 초기화를 지원해 코드 가독성과 간결함을 개선합니다 | SPM |
