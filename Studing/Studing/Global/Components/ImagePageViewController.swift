//
//  ImagePageViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/7/25.
//

import UIKit

import SnapKit
import Then

final class ImagePageViewController: UIPageViewController {

    // MARK: - Properties
    
    private var imageUrls: [String]
    private var currentIndex: Int = 0
    
    // MARK: - UI Properties
    
    private var backgroundView = UIView()
    
    // MARK: - Init
    
    init(
        index: Int,
        imageUrls: [String]
    ) {
        self.currentIndex = index
        self.imageUrls = imageUrls
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupDelegate()
        
        if let firstVC = createImageViewController(at: currentIndex) {
            setViewControllers([firstVC], direction: .forward, animated: true)
        }
    }
    
    func createImageViewController(at index: Int) -> ImageViewController? {
        guard index >= 0, index < imageUrls.count else { return nil }

        return ImageViewController(url: imageUrls[index], index: index)
    }
}

// MARK: - Private Extensions

private extension ImagePageViewController {
    func setupStyle() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.insertSubview(blurView, at: 0)
    }
    
    func setupDelegate() {
        self.dataSource = self
    }
    
    @objc private func dismissPageView(_ gesture: UITapGestureRecognizer) {
        self.dismiss(animated: false)
    }
}

// MARK: - UIPageViewControllerDataSource

extension ImagePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let imageVC = viewController as? ImageViewController else { return nil }
        return createImageViewController(at: imageVC.index - 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let imageVC = viewController as? ImageViewController else { return nil }
        return createImageViewController(at: imageVC.index + 1)
    }
}

final class ImageViewController: UIViewController {
    
    // MARK: - Properties
    
    let index: Int
    private var lastZoomCenter: CGPoint = .zero
    
    // MARK: - UI Properties
    
    private let scrollView = UIScrollView()
    private let imageView = AFImageView()
    
    // MARK: - Init
    
    init(url: String, index: Int) {
        self.index = index
        super.init(nibName: nil, bundle: nil)
        
        imageView.setImage(url, type: .largeImage)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupGesture()
        setupDoubleTapGesture()
    }
}

private extension ImageViewController {
    func setupScrollView() {
        scrollView.do {
            $0.minimumZoomScale = 1.0
            $0.maximumZoomScale = 6.0
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.alwaysBounceVertical = false
            $0.alwaysBounceHorizontal = false
            $0.isUserInteractionEnabled = true
            $0.isMultipleTouchEnabled = true
            $0.contentInsetAdjustmentBehavior = .never
        }
        
        imageView.do {
            $0.isUserInteractionEnabled = true
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFit
        }
    }
    
    func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
    }
    
    func setupLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(scrollView)
            $0.height.equalTo(377)
        }
    }
    
    func setupDelegate() {
        scrollView.delegate = self
    }
    
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.delegate = self
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: false)
    }
    
    private func updateZoomCenter() {
        let scrollViewSize = scrollView.bounds.size
        let imageSize = imageView.frame.size

        let verticalInset = max(0, (scrollViewSize.height - imageSize.height) / 2)
        let horizontalInset = max(0, (scrollViewSize.width - imageSize.width) / 2)

        scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)

        // 줌의 중심을 유지하기 위해 contentOffset을 다시 설정
        let newOffsetX = lastZoomCenter.x * scrollView.zoomScale - scrollView.bounds.width / 2
        let newOffsetY = lastZoomCenter.y * scrollView.zoomScale - scrollView.bounds.height / 2

        scrollView.setContentOffset(CGPoint(x: max(0, newOffsetX), y: max(0, newOffsetY)), animated: false)
    }
    
    private func centerImage() {
        let boundsSize = scrollView.bounds.size
        var frameToCenter = imageView.frame
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        
        imageView.frame = frameToCenter
    }
}

private extension ImageViewController {
    func setupDoubleTapGesture() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)
    }
    
    @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale > 1.0 {
            // 현재 확대된 상태면 원래 크기로
            scrollView.setZoomScale(1.0, animated: true)
        } else {
            // 탭한 위치를 중심으로 확대
            let location = gesture.location(in: imageView)
            let zoomRect = zoomRectForScale(scale: scrollView.maximumZoomScale, center: location)
            scrollView.zoom(to: zoomRect, animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        
        // 탭한 위치를 중심으로
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        
        return zoomRect
    }
}

// MARK: - UIScrollViewDelegate

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        // 현재 contentOffset을 기준으로 줌의 중심점을 저장
        let bounds = scrollView.bounds
        lastZoomCenter = CGPoint(
            x: (scrollView.contentOffset.x + bounds.width / 2) / scrollView.zoomScale,
            y: (scrollView.contentOffset.y + bounds.height / 2) / scrollView.zoomScale
        )
    }
}

// MARK: - UIGestureRecognizerDelegate

extension ImageViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == scrollView
    }
}
