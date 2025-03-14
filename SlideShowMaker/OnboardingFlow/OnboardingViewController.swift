//
//  OnboardingViewController.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 29.11.23.
//

import SnapKit
import UIKit

final class OnboardingViewController: UIViewController {
    // MARK: - Variables
    weak var coordinator: Coordinator?

    private var slides: [OnboardingSlide] = []

    private var completion: (() -> Void)?

    private var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextButton.setTitle(String(localized: "Start"), for: .normal)
                buttonBack.isHidden = false
            }
            else if currentPage == 0 {
                buttonBack.isHidden = true
            }
            else {
                nextButton.setTitle(String(localized: "Next"), for: .normal)
                buttonBack.isHidden = false
            }
        }
    }

    // MARK: - UI Components
    private let buttonBack: UIButton = {
        $0.backgroundColor = .gray.withAlphaComponent(0.1)
        $0.tintColor = .white
        $0.layer.cornerRadius = 12
        $0.setTitle(String(localized: " back"), for: .normal)
        $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        $0.isHidden = true
        return $0
    }(UIButton())

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = .mainBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(OnboardingCollectionViewCell.self,
                                forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        return collectionView
    }()

    private let nextButton: AnimatedGradientButton = {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .red
        $0.tintColor = .white
        $0.setTitle(String(localized: "Go"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 35
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        let image = UIImage(systemName: "arrow.forward.circle")
        $0.setImage(image)
        return $0
    }(AnimatedGradientButton())

    private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .button1
        pageControl.pageIndicatorTintColor = .gray
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()

    init(coordinator: Coordinator, completion: @escaping () -> Void) {
        self.coordinator = coordinator
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self

        setupViews()
        setupConstraints()
        setupGestures()
    }

    // MARK: - Selectors
    @objc
    func nextButtonTupped(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
            completion?()
        }
        else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

    @objc func backButtonTapped(_ sender: UIButton) {
        if currentPage > 0 {
            currentPage -= 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

    // MARK: - UI Setup
    private func setupViews() {
        view.backgroundColor = .mainBackground
        navigationController?.isNavigationBarHidden = true

        view.addSubview(collectionView)
        view.addSubview(nextButton)
        view.addSubview(pageControl)
        view.addSubview(buttonBack)

        slides = createOnboardingSlides()

        pageControl.numberOfPages = slides.count
    }
}

private extension OnboardingViewController {
    func createOnboardingSlides() -> [OnboardingSlide] {
        let slide1Title = String(localized: "Make a SlideShow\nwith your pictures")
        let slide1Description = String(localized: "Turn your photo\ninto slideshow fast & easy")

        let slide2Title = String(localized: "Add your photos\nfrom the gallery")
        let slide2Description = String(localized: "A slideshow will be created from these images")

        let slide3Title = String(localized: "Choose\naspect ratio")
        let slide3Description = String(localized: "The slideshow will be saved\nin your chosen aspect ratio")

        let slide4Title = String(localized: "Timing")
        let slide4Description = String(localized: "You can change the duration time\nfor an image and see\nthe total time of the slideshow")

        let slides = [
            OnboardingSlide(title: slide1Title, description: slide1Description, image: UIImage(named: "onb1") ?? UIImage()),
            OnboardingSlide(title: slide2Title, description: slide2Description, image: UIImage(named: "onb2") ?? UIImage()),
            OnboardingSlide(title: slide3Title, description: slide3Description, image: UIImage(named: "onb3") ?? UIImage()),
            OnboardingSlide(title: slide4Title, description: slide4Description, image: UIImage(named: "onb4") ?? UIImage())
        ]
        return slides
    }
}

private extension OnboardingViewController {
    func setupGestures() {
        let nextButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(nextButtonTupped))
        nextButton.addGestureRecognizer(nextButtonTapGesture)

        buttonBack.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
    }
}

// MARK: - Constraints
private extension OnboardingViewController {
    func setupConstraints() {
        let screenHeight = UIScreen.main.bounds.height

        let topOffset: CGFloat
        let bottomOffset: CGFloat

        if screenHeight <= 667 { // Height of iPhone SE (2nd generation)
            topOffset = -30
            bottomOffset = -10
        }
        else {
            topOffset = -30
            bottomOffset = -70
        }

        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(topOffset)
            make.bottom.equalTo(pageControl.snp.top).offset(-screenHeight * 0.01)
        }

        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-screenHeight * 0.01)
        }

        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(bottomOffset)
            make.width.equalTo(333)
            make.height.equalTo(68)
        }

        buttonBack.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(44)
            make.leading.equalTo(nextButton)
            make.bottom.equalTo(nextButton.snp.top).offset(-50)
        }
    }
}

// MARK: - CollectionViewDelegate & CollectionViewDataSource
extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as? OnboardingCollectionViewCell else {
            fatalError("Unable to dequeue OnboardingCollectionViewCell")
        }
        cell.configureOnboardingCell(slides[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
