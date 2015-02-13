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
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!

    var dataObject: [String: AnyObject]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        posterView.layer.borderWidth = 0.75
        posterView.layer.borderColor = UIColor(white: 0.25, alpha: 0.85).CGColor
        posterView.layer.cornerRadius = 2.0
        posterView.layer.shadowColor = UIColor.blackColor().CGColor
        posterView.layer.shadowOpacity = 0.85
        posterView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        posterView.layer.shadowRadius = 6.0
        posterView.layer.masksToBounds = false
        posterView.layer.shouldRasterize = true
        
        if let imageName = dataObject["image"] as? String {
            self.bgImage.image = UIImage(named: "\(imageName)_bg.jpg")
            self.image.image = UIImage(named: "\(imageName)_poster.jpg")
        }
        
        if let title = dataObject["title"] as? String {
            self.nameLabel.text = title
        }
        
        if let desc = dataObject["desc"] as? String {
            self.descriptionLabel.text = desc
        }
        
        if let rating = dataObject["rating"] as? Float {
            self.ratingView.rating = rating
            self.ratingLabel.text = "\(rating)"
        }
        
        if let genres = dataObject["tags"] as? String {
            self.genreLabel.text = genres
        }
    }
}

