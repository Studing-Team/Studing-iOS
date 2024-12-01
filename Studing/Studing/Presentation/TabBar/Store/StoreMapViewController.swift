//
//  StoreMapViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/28/24.
//

import Combine
import CoreLocation
import UIKit

import SnapKit
import Then

import NMapsMap

final class StoreMapViewController: UIViewController {
    
    // MARK: - Properties
    
    private let storeMapViewModel: StoreMapViewModel
    weak var coordinator: StoreCoordinator?
    private let locationManager = CLLocationManager()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let mapView = NMFMapView()
    private let storeMarker = NMFMarker()
    private var currentLocationMarker: NMFMarker?
    
    private let addressBackgroundView = UIView()
    private let addressTitleLabel = UILabel()
    private let addressImage = UIImageView()
    private let backButton = UIButton()
    
    private let storeInfoView = StoreInfoView()
    private let myLocationButton = UIButton()
    
    // MARK: - init
    
    init(storeMapViewModel: StoreMapViewModel,
        coordinator: StoreCoordinator) {
        self.storeMapViewModel = storeMapViewModel
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        bindViewModel()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

// MARK: - Private Extensions

private extension StoreMapViewController {
    func bindViewModel() {
        let input = StoreMapViewModel.Input(
            backButtonAction: backButton.tapPublisher,
            myLocationButtonAction: myLocationButton.tapPublisher
        )
        
        let output = storeMapViewModel.transform(input: input)
        
        output.selectedStoreData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] storeData in
                self?.updateStoreData(data: storeData)
                self?.makeStoreMaker(lat: storeData.latitude, lng: storeData.longitude)
            }
            .store(in: &cancellables)
        
        output.backButtonResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stores in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
        
        output.myLocationButtonResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stores in
                self?.myLocationButton.isSelected.toggle()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension StoreMapViewController {
    func setupStyle() {
        addressBackgroundView.do {
            $0.backgroundColor = .white.withFigmaStyleAlpha(0.7)
            $0.layer.cornerRadius = 24
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 1
            $0.layer.shadowColor = UIColor.storeBackgroundBlur.cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: 3)  // 그림자 위치
            $0.layer.shadowOpacity = 0.2  // 그림자 투명도
            $0.layer.shadowRadius = 6  // 그림자 퍼짐 정도
        }
        
        backButton.do {
            $0.setImage(.backStore, for: .normal)
            $0.backgroundColor = .white.withFigmaStyleAlpha(0.7)
            $0.layer.cornerRadius = 24
            $0.layer.shadowColor = UIColor.storeBackgroundBlur.cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: 3)  // 그림자 위치
            $0.layer.shadowOpacity = 0.2  // 그림자 투명도
            $0.layer.shadowRadius = 6  // 그림자 퍼짐 정도
            $0.alpha = 0.95
        }
        
        addressTitleLabel.do {
            $0.font = .interBody2()
            $0.textColor = .black50
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
        
        addressImage.do {
            $0.image = UIImage(resource: .storeLocation)
            $0.contentMode = .scaleAspectFit
        }
        
        storeInfoView.do {
            $0.layer.shadowColor = UIColor.storeBackgroundBlur.cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: 3)  // 그림자 위치
            $0.layer.shadowOpacity = 0.2  // 그림자 투명도
            $0.layer.shadowRadius = 15  // 그림자 퍼짐 정도
        }
        
        myLocationButton.do {
            $0.setImage(.myLocation, for: .normal)
            $0.setImage(.myLocation.withTintColor(.primary50), for: .selected)
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 27
            $0.layer.shadowColor = UIColor.black20.cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: 3)  // 그림자 위치
            $0.layer.shadowOpacity = 0.2  // 그림자 투명도
            $0.layer.shadowRadius = 32  // 그림자 퍼짐 정도
            $0.addTarget(self, action: #selector(myLocationButtonTapped), for: .touchUpInside)
        }
        
        storeMarker.do {
            $0.iconImage = NMFOverlayImage(name: "storeMarker")
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(mapView, addressBackgroundView, backButton, storeInfoView, myLocationButton)
        addressBackgroundView.addSubviews(addressTitleLabel, addressImage)
    }
    
    func setupLayout() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(73)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(48)
        }
        
        addressBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(73)
            $0.leading.equalTo(backButton.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
        
        storeInfoView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(124)
        }
        
        addressTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
            $0.trailing.equalTo(addressImage.snp.leading).inset(15)
        }
 
        addressImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15)
            $0.width.equalTo(24)
        }
        
        myLocationButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(25)
            $0.bottom.equalToSuperview().inset(39)
            $0.size.equalTo(54)
        }
    }
    
    func setupDelegate() {
        mapView.addCameraDelegate(delegate: self)
    }
    
    func updateStoreData(data: StoreEntity) {
        addressTitleLabel.text = data.address
        storeInfoView.configure(forModel: data)
    }
    
    @objc private func myLocationButtonTapped() {
        // 위치 권한 확인
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            // 권한 없음 알림
//            showLocationPermissionAlert()
            break
        }
    }
}

extension StoreMapViewController: NMFMapViewCameraDelegate {
    
    func makeStoreMaker(lat: Double, lng: Double) {
        let storeLocation = NMGLatLng(lat: lat, lng: lng)
        storeMarker.position = storeLocation
        
        self.storeMarker.mapView = self.mapView
        moveCameraToMarker(storeLocation)
    }
    
    func moveCameraToMarker(_ position: NMGLatLng) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: position)
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)
    }
    
    private func updateMapToCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
        // 현재 위치로 카메라 이동
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude))
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)
        
        // 마커 업데이트
        if currentLocationMarker == nil {
            currentLocationMarker = NMFMarker()
        }
        
        currentLocationMarker?.position = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
        currentLocationMarker?.mapView = mapView
    }
}


// MARK: - CLLocationManagerDelegate
extension StoreMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        updateMapToCurrentLocation(location.coordinate)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}

