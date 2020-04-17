//
//  ReviewViewController.swift
//  FoodPie
//
//  Created by ciggo on 4/7/20.
//  Copyright © 2020 ciggo. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!

    @IBOutlet var rateButtons: [UIButton]!

    @IBOutlet var closeButton: UIButton!

    var restaurant: RestaurantMO!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let restaurantImage = restaurant.image {
            backgroundImageView.image = UIImage(data: restaurantImage as Data)
        }

        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.bounds
        backgroundImageView.addSubview(visualEffectView)

        // affine
        let affineTransform = CGAffineTransform(translationX: 600, y: 0)
        let scaleUpTransform = CGAffineTransform(scaleX: 5.0, y: 5.0)
        let moveScaleTransform = scaleUpTransform.concatenating(affineTransform)

        let translationYTransform = CGAffineTransform(translationX: 0.0, y: -500)

        for rateButton in rateButtons {
            rateButton.alpha = 0
            rateButton.transform = moveScaleTransform
        }

        closeButton.alpha = 0.0
        closeButton.transform = translationYTransform
    }

    func viewAnimate(view: UIView, duration: TimeInterval = 0.4, delay: TimeInterval) {
        UIView.animate(withDuration: duration, delay: delay, options: [], animations: {
            view.alpha = 1.0
            view.transform = .identity
        }, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        // fade in
//        UIView.animate(withDuration: 2.0, animations: {
//            self.rateButtons[0].alpha = 1.0
//            self.rateButtons[1].alpha = 1.0
//            self.rateButtons[2].alpha = 1.0
//            self.rateButtons[3].alpha = 1.0
//            self.rateButtons[4].alpha = 1.0
//        })

                // Spring Animation
        //        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.1, options: [], animations: {
        //            self.rateButtons[0].alpha = 1.0
        //            self.rateButtons[0].transform = .identity
        //        }, completion: nil)

        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.closeButton.alpha = 1.0
            self.closeButton.transform = .identity
        }, completion: nil)

        var delay = 0.1
        for rateButton in self.rateButtons {
            delay += 0.05
            viewAnimate(view: rateButton, duration: 0.4, delay: delay)
        }

//        viewAnimate(view: self.rateButtons[0], duration: 0.4, delay: 0.1)
//        viewAnimate(view: self.rateButtons[1], duration: 0.4, delay: 0.15)
//        viewAnimate(view: self.rateButtons[2], duration: 0.4, delay: 0.2)
//        viewAnimate(view: self.rateButtons[3], duration: 0.4, delay: 0.25)
//        viewAnimate(view: self.rateButtons[4], duration: 0.4, delay: 0.3)

//        UIView.animate(withDuration: 0.4, delay: 0.1, options: [], animations: {
//            self.rateButtons[0].alpha = 1.0
//            self.rateButtons[0].transform = .identity
//        }, completion: nil)
//
//        UIView.animate(withDuration: 0.4, delay: 0.15, options: [], animations: {
//            self.rateButtons[1].alpha = 1.0
//            self.rateButtons[1].transform = .identity
//        }, completion: nil)
//
//        UIView.animate(withDuration: 0.4, delay: 0.2, options: [], animations: {
//            self.rateButtons[2].alpha = 1.0
//            self.rateButtons[2].transform = .identity
//        }, completion: nil)
//
//        UIView.animate(withDuration: 0.4, delay: 0.25, options: [], animations: {
//            self.rateButtons[3].alpha = 1.0
//            self.rateButtons[3].transform = .identity
//        }, completion: nil)
//
//        UIView.animate(withDuration: 0.4, delay: 0.3, options: [], animations: {
//            self.rateButtons[4].alpha = 1.0
//            self.rateButtons[4].transform = .identity
//        }, completion: nil)
    }
}
