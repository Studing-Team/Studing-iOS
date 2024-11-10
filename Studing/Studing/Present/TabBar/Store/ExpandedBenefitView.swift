//
//  ExpandedBenefitView.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/7/24.
//

import UIKit

import SnapKit
import Then

protocol ClosedBenefitDelegate: AnyObject {
    func closedExpandedCellTap()
}

struct BenefitModel {
    let title: [String]
}

final class ExpandedBenefitView: UIView {
    
    private var bemefitData: [String]? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.benefitCollectionView.reloadData()
            }
        }
    }
    weak var delegate: ClosedBenefitDelegate?
    
    // MARK: - UI Properties
    
    private let containerView = UIView()
    private let emptyImageView = UIImageView()
    private let titleLabel = UILabel()
    
    private let closeButton = UIButton()
    private let showMapButton = UIButton()
    
    lazy var benefitCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData(forModel model: BenefitModel) {
        self.bemefitData = model.title
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(15)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(15), top: .fixed(0), trailing: .fixed(15), bottom: .fixed(0))
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(15)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 15,
            leading: 0,
            bottom: 15,
            trailing: 0
        )
        
        section.interGroupSpacing = 10 // 아이템 간 간격
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Private Extensions

private extension ExpandedBenefitView {
    func setupStyle() {
        titleLabel.do {
            $0.text = "🍀 제휴 혜택 🍀"
            $0.textColor = .black50
            $0.font = .interBody2()
        }
        
        benefitCollectionView.do {
            $0.layer.cornerRadius = 10
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            
            let dashedBorder = CAShapeLayer()
            dashedBorder.strokeColor = UIColor.black10.cgColor
            dashedBorder.lineDashPattern = [5, 5]
            dashedBorder.frame = benefitCollectionView.bounds
            dashedBorder.fillColor = nil
            dashedBorder.path = UIBezierPath(roundedRect: benefitCollectionView.bounds, cornerRadius: 10).cgPath
            
            $0.layer.addSublayer(dashedBorder)
//            $0.layer.borderColor = UIColor.black30.cgColor
//            $0.layer.borderWidth = 1
        }
        
        closeButton.do {
            $0.backgroundColor = .black20
            
            var config = UIButton.Configuration.plain()
            
            // 텍스트 스타일 전체 설정
            let container = AttributeContainer([
                .font: UIFont.interSubtitle3(),
                .foregroundColor: UIColor.black5
            ])
            config.attributedTitle = AttributedString("접기", attributes: container)
            
            $0.configuration = config
            $0.layer.cornerRadius = 10
            $0.addTarget(self, action: #selector(closeBeneiftTapped), for: .touchUpInside)
        }
        
        showMapButton.do {
            $0.backgroundColor = .primary50
            
            var config = UIButton.Configuration.plain()
            config.image = UIImage(resource: .showMap)
            config.imagePlacement = .trailing
            config.imagePadding = 5
            
            // 텍스트 스타일 전체 설정
            let container = AttributeContainer([
                .font: UIFont.interSubtitle3(),
                .foregroundColor: UIColor.black5
            ])
            config.attributedTitle = AttributedString("지도보기", attributes: container)
            
            $0.configuration = config
            $0.layer.cornerRadius = 10
//            $0.addTarget(self, action: #selector(benefitButtonTapped), for: .touchUpInside)
        }
    }
    
    func setupHierarchy() {
        self.addSubview(containerView)
        containerView.addSubviews(titleLabel, benefitCollectionView, closeButton, showMapButton)
    }
    
    func setupLayout() {
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        benefitCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(7)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(109)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(benefitCollectionView.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(convertByWidthRatio(58))
            $0.height.equalTo(convertByHeightRatio(36))
        }
        
        showMapButton.snp.makeConstraints {
            $0.top.equalTo(benefitCollectionView.snp.bottom).offset(20)
            $0.leading.equalTo(closeButton.snp.trailing).offset(convertByWidthRatio(6))
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(36))
        }
    }
    
    func setupDelegate() {
        benefitCollectionView.dataSource = self
    }
    
    func setupCollectionView() {
        benefitCollectionView.register(BenefitListCollectionViewCell.self, forCellWithReuseIdentifier: BenefitListCollectionViewCell.className)
    }
    
    @objc func closeBeneiftTapped(_ sender: UIButton) {
        delegate?.closedExpandedCellTap()
    }
}

extension ExpandedBenefitView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let data = bemefitData  {
            return data.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BenefitListCollectionViewCell.className,for: indexPath) as! BenefitListCollectionViewCell
        
        if let data = bemefitData?[indexPath.row] {
            cell.configureCell(title: data)
        }
        
        return cell
    }
}
