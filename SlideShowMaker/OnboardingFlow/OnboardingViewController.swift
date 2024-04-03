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
                buttonLabel.text = String(localized: "Try Free Trial")
            }
            else {
                buttonLabel.text = String(localized: "Next")
            }
        }
    }

    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = false

        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(OnboardingCollectionViewCell.self,
                                forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        return collectionView
    }()

    private let nextButton: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "unboardingButton")
        iv.tintColor = .white
        iv.isUserInteractionEnabled = true
        return iv
    }()

    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.gilroyMedium(ofSize: 14)
        label.text = String(localized: "Go")
        label.isUserInteractionEnabled = false
        return label
    }()

    private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .black
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

    // MARK: - UI Setup
    private func setupViews() {
        view.backgroundColor = .backgroundWhite
        navigationController?.isNavigationBarHidden = true

        view.addSubview(collectionView)
        view.addSubview(nextButton)
        view.addSubview(buttonLabel)
        view.addSubview(pageControl)

        slides = createOnboardingSlides()

        pageControl.numberOfPages = slides.count
    }
}

private extension OnboardingViewController {
    func createOnboardingSlides() -> [OnboardingSlide] {
        let slide1Title = String(localized: "Make a SlideShow\nwith your pictures")
        let slide1Description = String(localized: "Turn your photo memories\ninto slideshow fast & easy")

        let slide2Title = String(localized: "Your ratings\nOur updates")
        let slide2Description = String(localized: "Your rating and feedback allow us to\nimprove the app and add your ideas")

        let slide3Title = String(localized: "Powerful tools\nfor creativity")
        let slide3Description = String(localized: "Use special effects, cut, put music, add text,\nstickers and more 24 hours a day")

        let slide4Title = String(localized: "Start to Continue\nSlideShow Maker")
        let slide4Description = String(localized: "Start to continue SlideShow Maker\nwith a 3-day trial and $5,99 per week")

        let slides = [
            OnboardingSlide(title: slide1Title, description: slide1Description, image: UIImage(named: "Onb1") ?? UIImage()),
            OnboardingSlide(title: slide2Title, description: slide2Description, image: UIImage(named: "Onb2") ?? UIImage()),
            OnboardingSlide(title: slide3Title, description: slide3Description, image: UIImage(named: "Onb3") ?? UIImage()),
            OnboardingSlide(title: slide4Title, description: slide4Description, image: UIImage(named: "Onb4") ?? UIImage())
        ]
        return slides
    }
}

private extension OnboardingViewController {
    func setupGestures() {
        let nextButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(nextButtonTupped))
        nextButton.addGestureRecognizer(nextButtonTapGesture)
    }
}

// MARK: - Constraints
private extension OnboardingViewController {
    func setupConstraints() {
        let screenHeight = UIScreen.main.bounds.height

        let topOffset: CGFloat
        let bottomOffset: CGFloat

        if screenHeight <= 667 { // Height of iPhone SE (2nd generation)
            topOffset = -95
            bottomOffset = -10
        }
        else {
            topOffset = 0
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

        buttonLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(nextButton)
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
