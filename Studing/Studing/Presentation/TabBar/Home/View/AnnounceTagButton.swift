//
//  AnnounceTagButton.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/20/24.
//

import UIKit

//enum TagStyle {
//    case announce
//    case event
//    
//    var title: String {
//        switch self {
//        case .announce:
//            return "공지"
//        case .event:
//            return "이벤트"
//        }
//    }
//    
//    var font: UIFont {
//        return .interSubtitle3()
//    }
//}
//
//enum TagButtonState {
//    case select
//    case notSelct
//    
//    var textColor: UIColor {
//        return .black30
//    }
//    
//    var selectedTextColor: UIColor {
//        return .primary50
//    }
//    
//    var background: UIColor {
//        return .white
//    }
//    
//    var borderColor: UIColor {
//        switch self {
//        case .select:
//            return UIColor.primary50
//            
//        case .notSelct:
//            return UIColor.black10
//        }
//    }
//    
////    var borderColor: CGColor {
////        switch self {
////        case .select:
////            return UIColor.primary50.cgColor
////            
////        case .notSelct:
////            return UIColor.black10.cgColor
////        }
////    }
//}
//
//final class AnnounceTagButton: UIButton {
//    var buttonStyle: TagStyle
//    
//    var buttonState: TagButtonState {
//        get {
//            return isSelected ? .select : .notSelct
//        }
//        set {
//            isSelected = (newValue == .select)
//            updateButtonState()
//        }
//    }
//    
//    override var isSelected: Bool {
//        didSet {
//            updateButtonState()
//        }
//    }
//    
//    init(buttonStyle: TagStyle) {
//        self.buttonStyle = buttonStyle
//        super.init(frame: .zero)
//        setupButton()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func updateButtonState() {
//        self.setTitleColor(buttonState.selectedTextColor, for: .normal)
//        self.layer.borderColor = buttonState.borderColor.cgColor
//    }
//    
//    private func setupButton() {
//        self.setTitle(buttonStyle.title, for: .normal)
//        self.setTitleColor(buttonState.textColor, for: .normal)  // 초기 타이틀 컬러 설정
//        self.titleLabel?.font = buttonStyle.font
//        self.layer.cornerRadius = 14
//        self.layer.borderColor = buttonState.borderColor.cgColor
//        
////        var config = UIButton.Configuration.bordered()
////        
////        let titleString = AttributedString(buttonStyle.title, attributes: .init(
////            [.font: buttonStyle.font]
////        ))
////        
////        config.attributedTitle = titleString
////        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15)
////        config.background.cornerRadius = 14
////        
////        self.configuration = config
////        updateButtonState()
//    }
//}

enum TagStyle {
   case announce
   case event
   
   var title: String {
       switch self {
       case .announce: return "공지"
       case .event: return "이벤트"
       }
   }
}

enum TagButtonState {
   case select
   case notSelct
}

final class AnnounceTagButton: UIButton {
   var buttonStyle: TagStyle
   
   var buttonState: TagButtonState = .notSelct {
       didSet {
           updateButtonState()
       }
   }
   
   init(buttonStyle: TagStyle) {
       self.buttonStyle = buttonStyle
       super.init(frame: .zero)
       setupButton()
   }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
   
   private func updateButtonState() {
       switch buttonState {
       case .select:
           if buttonStyle == .announce {
               setTitleColor(.primary50, for: .normal)
               layer.borderColor = UIColor.primary50.cgColor
           } else {
               setTitleColor(.studingRed, for: .normal)
               layer.borderColor = UIColor.studingRed.cgColor
           }
           
       case .notSelct:
           setTitleColor(.black30, for: .normal)
           layer.borderColor = UIColor.black10.cgColor
       }
   }
   
   private func setupButton() {
       setTitle(buttonStyle.title, for: .normal)
       setTitleColor(.black30, for: .normal)
       titleLabel?.font = .interSubtitle3()
       backgroundColor = .white
       
       layer.cornerRadius = 14
       layer.borderWidth = 1
       layer.borderColor = UIColor.black10.cgColor
       
       // 패딩을 위한 contentEdgeInsets 설정
       contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
   }
}
