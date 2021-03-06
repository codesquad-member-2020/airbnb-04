//
//  AccommodationsCell.swift
//  Airbnb
//
//  Created by Cloud on 2020/05/21.
//  Copyright © 2020 Cloud. All rights reserved.
//

import UIKit

final class AccommodationsCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: ThumbnailScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.layer.masksToBounds = true
            scrollView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var pageControl: UIPageControl! {
        didSet {
            configurePageControl()
        }
    }
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var accommodationsInfoView: AccommodationsInfoView!
    
    // MARK: - Properties
    static let identifier: String = "AccommodationsCell"
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollView.resetThumbnails()
        pageControl.currentPage = 0
    }
    
    // MARK: - IBActions
    @IBAction func moveToPage(_ sender: UIPageControl) {
        let page = CGFloat(sender.currentPage)
        let visibleViewRect = CGRect(x: page * scrollView.frame.width,
                                     y: scrollView.frame.minY,
                                     width: scrollView.frame.width,
                                     height: scrollView.frame.height)
        scrollView
            .scrollRectToVisible(visibleViewRect,
                                 animated: true)
    }
    
    @IBAction func buttonTouched(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    // MARK: - Methods
    private func configurePageControl() {
        pageControl.currentPage = 0
    }
    
    func apply(with viewModel: AccommodationsCellViewModel) {
        scrollView.resetThumbnails()
        pageControl.numberOfPages = viewModel.images.count
        accommodationsInfoView.apply(badge: viewModel.badge,
                                     roomType: viewModel.roomType,
                                     rate: viewModel.rate,
                                     title: viewModel.title)
        viewModel.images.forEach {
            self.scrollView.addThumbnail(image: $0)
        }
        favoritesButton.isSelected = viewModel.isFavorite
    }
}

// MARK: - UIScrollView
// MARK: Delegate
extension AccommodationsCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(page)
    }
}
