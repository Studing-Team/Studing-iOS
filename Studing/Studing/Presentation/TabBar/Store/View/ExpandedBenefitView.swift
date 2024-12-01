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

protocol ShowStoreMapDelegate: AnyObject {
    func showStoreMap(storeName: String)
}

struct BenefitModel {
    let title: [String]
}

final class ExpandedBenefitView: UIView {
    var storeName: String?
    private var benefitData: [String]? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.benefitCollectionView.reloadData()
            }
        }
    }
    weak var delegate: ClosedBenefitDelegate?
    weak var mapDelegate: ShowStoreMapDelegate?
    
    // MARK: - UI Properties
    
    private let containerView = UIView()
    private let emptyImageView = UIImageView()
    private let titleLabel = UILabel()
    
    private let closeButton = UIButton()
    private let showMapButton = UIButton()
    
    private let collectionContainer = UIView()
    lazy var benefitCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private let dashedBorder = CAShapeLayer()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupCollectionView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 레이아웃이 완전히 적용된 후 실행
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // 기존 테두리 제거
            self.dashedBorder.removeFromSuperlayer()
            
            // CollectionView의 실제 프레임으로 테두리 설정
            let bounds = self.collectionContainer.bounds
            self.dashedBorder.frame = bounds
            self.dashedBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
            self.collectionContainer.layer.addSublayer(self.dashedBorder)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData(forModel model: BenefitModel, storeName: String?) {
        self.benefitData = model.title
        self.storeName = storeName
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(15)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(15)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 15,
            leading: 15,
            bottom: 15,
            trailing: 15
        )
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Private Extensions

private extension ExpandedBenefitView {
    
    func setupStyle() {
        titleLabel.do {
            $0.text = "🍀 제휴 혜택 🍀"
            $0.textColor = .black50
            $0.font = .interSubtitle3()
        }
        
        benefitCollectionView.do {
            $0.layer.cornerRadius = 10
            $0.showsVerticalScrollIndicator = false
            
            dashedBorder.strokeColor = UIColor.black10.cgColor
            dashedBorder.lineDashPattern = [5, 5]
            dashedBorder.lineWidth = 2
            dashedBorder.fillColor = nil
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
            $0.addTarget(self, action: #selector(showMapButtonTapped), for: .touchUpInside)
        }
    }
    
    func setupHierarchy() {
        self.addSubview(containerView)
        containerView.addSubviews(titleLabel, collectionContainer, closeButton, showMapButton)
        collectionContainer.addSubview(benefitCollectionView)
        
    }
    
    func setupLayout() {
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        benefitCollectionView.snp.makeConstraints { //benefitCollectionView
            $0.edges.equalTo(collectionContainer)
        }
        
        collectionContainer.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(7)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(109)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(collectionContainer.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(convertByWidthRatio(58))
            $0.height.equalTo(convertByHeightRatio(36))
        }
        
        showMapButton.snp.makeConstraints {
            $0.top.equalTo(collectionContainer.snp.bottom).offset(20)
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
    
    @objc func showMapButtonTapped(_ sender: UIButton) {
        if let storeName = storeName {
            mapDelegate?.showStoreMap(storeName: storeName)
        }
    }
}

extension ExpandedBenefitView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let data = benefitData  {
            return data.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BenefitListCollectionViewCell.className,for: indexPath) as! BenefitListCollectionViewCell
        
        if let data = benefitData?[indexPath.row] {
            cell.configureCell(title: data)
        }
        
        return cell
    }
}
