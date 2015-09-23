//
//  DataViewController.swift
//  RGViewPager
//
//  Created by Ronny Gerasch on 08.11.14.
//  Copyright (c) 2014 Ronny Gerasch. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {
    @IBOutlet weak var posterView: UIView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!

    var dataObject: [String: AnyObject]!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        posterView.layer.borderWidth = 0.75
        posterView.layer.borderColor = UIColor(white: 0.25, alpha: 0.45).CGColor
        posterView.layer.cornerRadius = 2.0
        posterView.layer.shadowColor = UIColor(white: 0.85, alpha: 0.85).CGColor
        posterView.layer.shadowOpacity = 0.25
        posterView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        posterView.layer.shadowRadius = 1.0
        posterView.layer.masksToBounds = false
        posterView.layer.shouldRasterize = true
        
        if DeviceType.iPad {
            descriptionView.hidden = true
            
            if let imageName = dataObject["image"] as? String {
                bgImage.image = UIImage(named: "\(imageName)_bg.jpg")
                image.image = UIImage(named: "\(imageName)_poster.jpg")
            }
            
            if let desc = dataObject["desc"] as? String {
                descriptionLabel.text = desc
            }
        } else {
            bgImage.hidden = true
            descriptionLabel.hidden = true
            
            if let imageName = dataObject["image"] as? String {
                image.image = UIImage(named: "\(imageName)_poster.jpg")
            }
            
            if let desc = dataObject["desc"] as? String {
                descriptionView.text = desc
            }
        }
        
        if let title = dataObject["title"] as? String {
            nameLabel.text = title
        }
        
        if let genres = dataObject["tags"] as? String {
            genreLabel.text = genres
        }
        
        if let rating = dataObject["rating"] as? Double {
            let _rating = Int(rating + 0.5)
            var ratingStr = ""
            
            for _ in 0 ..< _rating {
                ratingStr += "\u{2605}"
            }
            
            ratingLabel.text = ratingStr
        }
    }
}

