//
//  SectionViewController.swift
//  RGViewPager
//
//  Created by Ronny Gerasch on 29.01.17.
//  Copyright © 2017 Ronny Gerasch. All rights reserved.
//

import UIKit

class SectionViewController: UIViewController {
  @IBOutlet weak var sectionImage: UIImageView!
  @IBOutlet weak var sectionTitleLabel: UILabel!
  
  var sectionTitle: String!
  var imageName: String!
  var color: UIColor!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    sectionTitleLabel.text = sectionTitle
    sectionTitleLabel.textColor = color
    
    sectionImage.image = UIImage(named: "\(imageName!)_large")
    sectionImage.tintColor = color
  }
}
