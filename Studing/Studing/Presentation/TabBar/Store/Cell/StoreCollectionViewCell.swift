//
//  StoreCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/7/24.
//

import UIKit

import SnapKit
import Then

protocol StoreCellDelegate: AnyObject {
   func expandedCellTap(_ cell: StoreCollectionViewCell)
}

final class StoreCollectionViewCell: UICollectionViewCell {
    
    var isExpanded: Bool = false {
        didSet {
            updateCategoryLayout()
        }
    }
    
    private let contentStackView = UIStackView()
    private let titleStackView = UIStackView()
    private let categoryStackView = UIStackView()
    private let addressStackView = UIStackView()
    
    private let expandedBenefitView = ExpandedBenefitView()
    
    private let storeImageView = UIImageView()
    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let categoryImageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let addressImageView = UIImageView()
    private let addressLabel = UILabel()
    private let benefitButton = UIButton()
    
    weak var delegate: StoreCellDelegate?

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension StoreCollectionViewCell {
    func configureCell(forModel model: StoreModel) {
        titleLabel.text = model.name
        categoryLabel.text = model.category.title
        categoryImageView.image = model.category.icon
        descriptionLabel.text = model.description
        addressLabel.text = model.address
        isExpanded = model.isExpanded
    }
}

private extension StoreCollectionViewCell {
    
    @objc private func benefitButtonTapped() {
        isExpanded.toggle()
        expandedBenefitView.configureData(forModel: BenefitModel(title: ["19시 이전 방문시, 소주 또는 맥주 1병 제공", "3만원 이상 주문시, 파인샤베트 제공", "5만원 이상 주문시, 모듬 감자튀김 제공", "영수증 리뷰 및 인스타(@sibam_official) 태그 후 업로드 시 음료 또는 면 추가 제공"]))
        delegate?.expandedCellTap(self)
    }
    
    func setupStyle() {
        contentView.backgroundColor = .white.withAlphaComponent(0.5)
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.white.cgColor
        
        contentStackView.do {
            $0.addArrangedSubviews(titleStackView, descriptionLabel, addressStackView)
            $0.axis = .vertical
            $0.spacing = 8
            $0.setCustomSpacing(15, after: descriptionLabel)
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        titleStackView.do {
            $0.addArrangedSubviews(titleLabel, categoryStackView)
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fill
            $0.alignment = .top
        }
        
        categoryStackView.do {
            $0.addArrangedSubviews(categoryImageView, categoryLabel)
            $0.axis = .horizontal
            $0.spacing = 2
            $0.distribution = .fillProportionally
            $0.alignment = .center
        }
        
        addressStackView.do {
            $0.addArrangedSubviews(addressImageView, addressLabel)
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.spacing = 2
        }

        titleLabel.do {
            $0.font = .interSubtitle3()
            $0.numberOfLines = 1
            $0.textColor = .black50
            $0.lineBreakMode = .byTruncatingTail
        }
        
        categoryLabel.do {
            $0.font = .interCaption11()
            $0.textColor = .black30
        }
        
        storeImageView.do {
            $0.image = UIImage(resource: .dumpstore)
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
        }
        
        descriptionLabel.do {
            $0.font = .interBody5()
            $0.textColor = .black50
            $0.numberOfLines = 2
        }
        
        addressLabel.do {
            $0.font = .interBody4()
            $0.textColor = .black30
        }
        
        addressImageView.do {
            $0.image = UIImage(resource: .locationOn)
            $0.contentMode = .scaleAspectFill
        }
        
        categoryImageView.do {
            $0.contentMode = .scaleAspectFill
        }
        
        benefitButton.do {
            var config = UIButton.Configuration.plain()
            config.image = UIImage(resource: .down)
            config.imagePlacement = .trailing
            config.imagePadding = 8
            
            // 텍스트 스타일 전체 설정
            let container = AttributeContainer([
                .font: UIFont.interHeadline5(),
                .foregroundColor: UIColor.black20
            ])
            config.attributedTitle = AttributedString("제휴 혜택", attributes: container)
            
            $0.configuration = config
            $0.isHidden = false
            $0.addTarget(self, action: #selector(benefitButtonTapped), for: .touchUpInside)
        }
        
        expandedBenefitView.do {
            $0.isHidden = true
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(contentStackView, storeImageView, benefitButton, expandedBenefitView)
    }
    
    func setupLayout() {
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(storeImageView.snp.leading).offset(-40)
        }
        
        storeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(92)
        }
        
        benefitButton.snp.makeConstraints {
            $0.top.equalTo(contentStackView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        expandedBenefitView.snp.makeConstraints {
            $0.top.equalTo(contentStackView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        categoryStackView.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(34)
        }
        
        categoryImageView.snp.makeConstraints {
            $0.size.equalTo(12)
        }
        
        addressImageView.snp.makeConstraints {
            $0.width.equalTo(9)
            $0.height.equalTo(11)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(0)
        }
    }
    
    func setupDelegate() {
        expandedBenefitView.delegate = self
    }
    
    func chagneHiddenAndAlpha() {
        switch self.isExpanded {
        case true:
            self.benefitButton.alpha = 0
            self.benefitButton.isHidden = true

        case false:
            self.expandedBenefitView.alpha = 0
            self.expandedBenefitView.isHidden = true
        }
    }
    
    func updateCategoryLayout() {
        
        self.titleLabel.numberOfLines = self.isExpanded ? 0 : 1
        self.descriptionLabel.numberOfLines = self.isExpanded ? 0 : 2
        
        if self.isExpanded {

            self.expandedBenefitView.isHidden = false
            self.expandedBenefitView.alpha = 0
            
            self.expandedBenefitView.snp.makeConstraints {
                $0.top.equalTo(self.contentStackView.snp.bottom).offset(24)
                $0.horizontalEdges.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview().inset(16)
            }
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.contentView.backgroundColor = UIColor.white
                self.benefitButton.alpha = 0
                
                self.benefitButton.snp.removeConstraints()

            } completion: { _ in

                self.benefitButton.isHidden = true
                self.expandedBenefitView.isHidden = false
                
                UIView.animate(withDuration: 0.3) {

                    self.expandedBenefitView.alpha = 1
                    
                } completion: { _ in
                    self.layoutIfNeeded()
                }
            }
        } else {
            self.benefitButton.isHidden = false
            self.benefitButton.alpha = 0
            
            self.benefitButton.snp.makeConstraints {
                $0.top.equalTo(self.contentStackView.snp.bottom).offset(16)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(24)
                $0.bottom.equalToSuperview().inset(10)
            }
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.contentView.backgroundColor = .white.withAlphaComponent(0.5)
                self.expandedBenefitView.alpha = 0

            } completion: { _ in
                self.expandedBenefitView.snp.removeConstraints()
                self.benefitButton.isHidden = false
                
                UIView.animate(withDuration: 0.3) {

                    self.benefitButton.alpha = 1
                    
                } completion: { _ in
                    self.expandedBenefitView.isHidden = true
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    func removeGradient() {
        contentView.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
    }
}

extension StoreCollectionViewCell: ClosedBenefitDelegate {
    func closedExpandedCellTap() {
        isExpanded = false
        
//        updateCategoryLayout()
        print("닫기 버튼 눌림 Expanded:", isExpanded)
        delegate?.expandedCellTap(self)
    }
}
