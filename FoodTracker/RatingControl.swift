//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Rio Michelini on 24/02/2021.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
	
	// MARK: Properties
	
	private var ratingButtons = [UIButton]()
	var rating = 0 {
		didSet {
			updateButtonSelectionStates()
		}
	}
	@IBInspectable var starSize: CGSize = CGSize(width: 50.0, height: 50.0) {
		didSet {
			setupButtons()
		}
	}
	@IBInspectable var starCount: Int = 5 {
		didSet {
			setupButtons()
		}
	}
	
	// MARK: Initialisation
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupButtons()
	}
	
	required init(coder: NSCoder) {
		super.init(coder: coder)
		setupButtons()
	}
	
	// MARK: Private Methods
	
	private func setupButtons() {
		for button in ratingButtons {
			removeArrangedSubview(button)
			button.removeFromSuperview()
		}
		ratingButtons.removeAll()
		
		let config = UIImage.SymbolConfiguration(pointSize: 48, weight: .semibold, scale: .small)
		let filledStar = UIImage(systemName: "star.fill", withConfiguration: config)
		let emptyStar = UIImage(systemName: "star", withConfiguration: config)
		let highlightedStar = UIImage(systemName: "star.fill", withConfiguration: config)
		
		for index in 0..<starCount {
			let button = UIButton()
			button.setImage(emptyStar, for: .normal)
			button.setImage(filledStar, for: .selected)
			button.setImage(highlightedStar, for: .highlighted)
			button.setImage(highlightedStar, for: [.highlighted, .selected])
			
			button.translatesAutoresizingMaskIntoConstraints =  false
			button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
			button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
			
			button.accessibilityLabel = "Set \(index + 1) star rating"
			
			button.addTarget(self, action: #selector(ratingButtonTapped), for: .touchUpInside)
			
			addArrangedSubview(button)
			ratingButtons.append(button)
		}
		
		updateButtonSelectionStates()
	}
	
	// MARK: Button Action
	@objc func ratingButtonTapped(button: UIButton) {
		guard let index = ratingButtons.firstIndex(of: button) else {
			fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
		}
		let selectedRating = index + 1
		if selectedRating == rating {
			rating = 0
		} else {
			rating = selectedRating
		}
	}
	
	private func updateButtonSelectionStates() {
		for (index, button) in ratingButtons.enumerated() {
			button.isSelected = index < rating
			
			let hintString: String?
			if rating == index + 1 {
				hintString = "Tap to reset the rating to zero"
			} else {
				hintString = nil
			}
			
			let valueString: String
			switch (rating) {
				case 0:
					valueString = "No rating set."
				case 1:
					valueString = "1 star set."
				default:
					valueString = "\(rating) stars set."
			}
			
			button.accessibilityHint = hintString
			button.accessibilityValue = valueString
		}
	}
	
}
