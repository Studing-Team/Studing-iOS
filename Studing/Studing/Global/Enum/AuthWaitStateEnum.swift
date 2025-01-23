//
//  AuthWaitStateEnum.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/16/24.
//

import UIKit

/// `AuthWaitState` 열거형은 인증 절차의 각 단계별 상태를 관리합니다.
/// 제출부터 최종 승인까지의 전체 프로세스를 5단계로 구분하며,
/// 각 단계별 폰트, 색상, 상태 이미지에 대한 스타일링을 제공합니다.
///
/// - Note: `Int` 타입의 원시값을 사용하여 각 단계를 1부터 5까지 순차적으로 표현합니다.
///
/// ## 열거형의 각 케이스
///   - `summit`: (1) 서류 제출 상태
///   - `checking`: (2) 서류 확인 중인 상태
///   - `checked`: (3) 서류 확인이 완료된 상태
///   - `complete`: (4) 최종 승인이 완료된 상태
///   - `failure`: (5) 인증 실패 상태
///
/// ## 주요 메서드
///   - `font(step:)`: 현재 단계에 따른 폰트를 반환합니다.
///   - `fontColor(step:)`: 현재 단계에 따른 폰트 색상을 반환합니다.
///   - `stateImage(step:type:)`: 현재 단계와 타입에 따른 상태 이미지를 반환합니다.
///
enum AuthWaitState: Int {
   /// 서류 제출 단계 (Step 1)
   case summit = 1
   
   /// 서류 확인 중인 단계 (Step 2)
   case checking = 2
   
   /// 서류 확인 완료 단계 (Step 3)
   case checked = 3
   
   /// 최종 승인 완료 단계 (Step 4)
   case complete = 4
   
   /// 인증 실패 단계 (Step 5)
   case failure = 5
   
   /// 현재 진행 단계에 따른 폰트를 반환하는 메서드
   /// - Parameter step: 확인할 단계 번호
   /// - Returns: 해당 단계에 적용할 UIFont
   func font(step: Int) -> UIFont {
       if step <= self.rawValue {
           return .interSubtitle3()
       } else {
           return .interBody2()
       }
   }
   
   /// 현재 진행 단계에 따른 폰트 색상을 반환하는 메서드
   /// - Parameter step: 확인할 단계 번호
   /// - Returns: 해당 단계에 적용할 UIColor
   func fontColor(step: Int) -> UIColor {
       if step <= self.rawValue {
           return .primary50
       } else {
           return .black30
       }
   }
   
   /// 현재 진행 단계와 인증 타입에 따른 상태 이미지를 반환하는 메서드
   /// - Parameters:
   ///   - step: 확인할 단계 번호
   ///   - type: 인증 확인 타입 (홈/기타)
   /// - Returns: 해당 단계에 표시할 UIImage
   func stateImage(step: Int, type: AuthWaitCheckType) -> UIImage {
       // 미확인 상태 이미지 (타입에 따라 다른 색상 적용)
       let notCheck = UIImage(resource: .notCheck)
           .withRenderingMode(.alwaysOriginal)
           .withTintColor(type == .home ? .black20 : .black10)
       
       switch self {
       case .summit:
           // 제출 단계에서는 첫 단계만 제출 이미지 표시
           if step == 1 {
               return UIImage(resource: .summit)
           } else {
               return notCheck
           }
           
       case .checking:
           // 확인 중 단계에서는 진행 상황에 따라 이미지 변경
           if step == 1 {
               return UIImage(resource: .summit)
           } else if step == 2 {
               return UIImage(resource: .checking)
           } else {
               return notCheck
           }
           
       case .checked:
           // 확인 완료 단계에서는 1단계와 3단계에 제출 이미지 표시
           if step == 1 || step == 3 {
               return UIImage(resource: .summit)
           } else {
               return notCheck
           }
           
       case .complete:
           // 승인 완료 단계에서는 모든 단계에 제출 이미지 표시
           return UIImage(resource: .summit)
           
       case .failure:
           // 실패 단계에서는 마지막 단계만 실패 이미지 표시
           if step < 5 {
               return UIImage(resource: .summit)
           } else {
               return UIImage(resource: .failure)
           }
       }
   }
}
