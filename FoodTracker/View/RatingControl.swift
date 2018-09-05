//
//  RatingControl.swift
//  FoodTracker
//
//  Created by admin on 7/30/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
// xếp hạng
@IBDesignable class RatingControl: UIStackView {
    
        

    //xac ding so nut va kich thuoc
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5{
        didSet {
            setupButtons()
        }
    }
    
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet {
            updateButtonSelectionsState()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }

    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButton array: \(ratingButtons)")
        }
        let selectedRating = index + 1
        if selectedRating == rating {
            rating = 0
            
        } else {
            rating = selectedRating
        }
        
    }
    private func updateButtonSelectionsState() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            }else {
                hintString = nil
            }
            //ting chuoi gia tri
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) star set"
            }
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
    private func setupButtons(){
        
        //xoa moi nut hien co
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        //load Button Image
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let hightlightedStar = UIImage(named: "hightlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
    
        for index in 0..<starCount {
        //tao button
        let button = UIButton()
            button.accessibilityLabel = "Set \(index + 1) star rating"
        //set the button image
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(hightlightedStar, for: .highlighted)
            button.setImage(hightlightedStar, for: [.highlighted, .selected])
            
        //add constraints
        //vo hieu hoa cac rang buoc duoc tao tu dong cua nut
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
        //dat hanh dong cho button
        button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            //add button toi stack
        addArrangedSubview(button)
            
            //add new button toi mang ratingButton
        ratingButtons.append(button)
        }
    updateButtonSelectionsState()
    }
    
}
