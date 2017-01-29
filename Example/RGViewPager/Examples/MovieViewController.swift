//
//  MovieViewController.swift
//  RGViewPager
//
//  Created by Ronny Gerasch on 08.11.14.
//  Copyright (c) 2014 Ronny Gerasch. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var posterImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var yearLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var networkLabel: UILabel!
  
  var movieData: [String:Any]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let imageName = movieData["image"] as? String {
      backgroundImage.image = UIImage(named: "\(imageName)_bg.jpg")
      posterImage.image = UIImage(named: "\(imageName)_poster.jpg")
    }
    
    if let title = movieData["title"] as? String {
      titleLabel.text = title
    }
    
    if let year = movieData["year"] as? String {
      yearLabel.text = " (\(year))"
    }
    
    if let desc = movieData["desc"] as? String {
      descriptionLabel.text = desc
    }
    
    if let network = movieData["network"] as? String {
      networkLabel.text = network
    }
    
    if let genres = movieData["tags"] as? String {
      genreLabel.text = genres
    }
    
    if let rating = movieData["rating"] as? Double {
      ratingLabel.text = "\u{2605} \(rating)"
    }
  }
}

