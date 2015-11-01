//
//  MainViewController.swift
//  RGViewPager
//
//  Created by Ronny Gerasch on 10.11.14.
//  Copyright (c) 2014 Ronny Gerasch. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: RGPageViewController, RGPageViewControllerDataSource, RGPageViewControllerDelegate {
    override var pagerOrientation: UIPageViewControllerNavigationOrientation {
        get {
            if DeviceType.iPad {
                return .Vertical
            }
            
            return .Horizontal
        }
    }
    
    override var tabbarPosition: RGTabbarPosition {
        get {
            if DeviceType.iPad {
                return .Right
            }
            
            return .Top
        }
    }
    
    override var tabbarStyle: RGTabbarStyle {
        get {
            if DeviceType.iPad {
                return .Solid
            }
            
            return .Blurred
        }
    }
    
    override var tabIndicatorColor: UIColor {
        get {
            return UIColor.blackColor()
        }
    }
    
    override var barTintColor: UIColor? {
        get {
            if DeviceType.iPad {
                return nil
            }
            
            return self.navigationController?.navigationBar.barTintColor
        }
    }
    
    override var tabStyle: RGTabStyle {
        get {
            return .InactiveFaded
        }
    }
    
    override var tabbarWidth: CGFloat {
        get {
            return 140.0
        }
    }
    
    override var tabMargin: CGFloat {
        get {
            return 16.0
        }
    }
    
    let bcs = ["title": "Better Call Saul", "desc": "Six years before Saul Goodman meets Walter White. We meet him when the man who will become Saul Goodman is known as Jimmy McGill, a small-time lawyer searching for his destiny, and, more immediately, hustling to make ends meet. Working alongside, and, often, against Jimmy, is \"fixer\" Mike Erhmantraut. The series will track Jimmy's transformation into Saul Goodman, the man who puts “criminal” in \"criminal lawyer\".", "image": "better_call_saul", "rating": 9.4, "tags": "Comedy | Crime | Drama"]
    let bb = ["title": "Breaking Bad", "desc": "Breaking Bad is an American crime drama television series created and produced by Vince Gilligan. Set and produced in Albuquerque, New Mexico, Breaking Bad is the story of Walter White, a struggling high school chemistry teacher who is diagnosed with inoperable lung cancer at the beginning of the series. He turns to a life of crime, producing and selling methamphetamine, in order to secure his family's financial future before he dies, teaming with his former student, Jesse Pinkman. Heavily serialized, the series is known for positioning its characters in seemingly inextricable corners and has been labeled a contemporary western by its creator.", "image": "breaking_bad", "rating": 9.5, "tags": "Crime | Drama | Thriller"]
    let fs = ["title": "Falling Skies", "desc": "Falling Skies is an American science fiction dramatic television series about a group of civilians and fighters fleeing post-apocalyptic Boston following an alien invasion that devastated the planet six months before the events of season one.", "image": "falling_skies", "rating": 7.3, "tags": "Action | Sci-Fi | Thriller"]
    let f = ["title": "Friends", "desc": "Friends is an American sitcom created by David Crane and Marta Kauffman, which aired on NBC from September 22, 1994 to May 6, 2004. The series revolves around a group of friends in the New York City borough of Manhattan. The series was produced by Bright/Kauffman/Crane Productions, in association with Warner Bros. Television. The original executive producers were Crane, Kauffman, and Kevin S. Bright, with numerous others being promoted in later seasons.", "image": "friends", "rating": 9.0, "tags": "Comedy | Romance"]
    let got = ["title": "Game of Thrones", "desc": "Game of Thrones is an American fantasy drama television series created for HBO by David Benioff and D. B. Weiss. It is an adaptation of A Song of Ice and Fire, George R. R. Martin's series of fantasy novels, the first of which is titled A Game of Thrones.", "image": "game_of_thrones", "rating": 9.5, "tags": "Adventure | Drama | Fantasy"]
    let g = ["title": "Gotham", "desc": "Everyone knows the name Commissioner Gordon. He is one of the crime world's greatest foes, a man whose reputation is synonymous with law and order. But what is known of Gordon's story and his rise from rookie detective to Police Commissioner? What did it take to navigate the multiple layers of corruption that secretly ruled Gotham City, the spawning ground of the world's most iconic villains? And what circumstances created them – the larger-than-life personas who would become Catwoman, The Penguin, The Riddler, Two-Face and The Joker?", "image": "gotham", "rating": 8.1, "tags": "Crime | Drama | Thriller"]
    let hoc = ["title": "House of Cards", "desc": "House of Cards is an American political drama series developed and produced by Beau Willimon. It is an adaptation of a previous BBC miniseries of the same name, which is based on the novel by Michael Dobbs.\nSet in present day Washington, D.C., House of Cards is the story of Frank Underwood, a Democrat from South Carolina's 5th congressional district and the House Majority Whip who, after getting passed over for appointment to Secretary of State, decides to exact his revenge on those who betrayed him.", "image": "house_of_cards", "rating": 9.1, "tags": "Drama"]
    let himym = ["title": "How I Met Your Mother", "desc": "How I Met Your Mother is an American sitcom that premiered on CBS on September 19, 2005. The 2013–14 season will be the show's ninth and final season. The series follows the main character, Ted Mosby, and his group of friends in Manhattan. As a framing device, Ted, in the year 2030, recounts to his son and daughter the events that led to his meeting their mother.", "image": "how_i_met_your_mother", "rating": 8.5, "tags": "Comedy | Drama | Romance"]
    let s = ["title": "Shameless", "desc": "Chicagoan Frank Gallagher is the proud single dad of six smart, industrious, independent kids, who without him would be... perhaps better off. When Frank's not at the bar spending what little money they have, he's passed out on the floor. But the kids have found ways to grow up in spite of him. They may not be like any family you know, but they make no apologies for being exactly who they are.", "image": "shameless", "rating": 8.7, "tags": "Comedy | Drama"]
    let tbbt = ["title": "The Big Bang Theory", "desc": "The Big Bang Theory is centered on five characters living in Pasadena, California: roommates Leonard Hofstadter and Sheldon Cooper; Penny, a waitress and aspiring actress who lives across the hall; and Leonard and Sheldon's equally geeky and socially awkward friends and co-workers, mechanical engineer Howard Wolowitz and astrophysicist Raj Koothrappali. The geekiness and intellect of the four guys is contrasted for comic effect with Penny's social skills and common sense.", "image": "the_big_bang_theory", "rating": 8.6, "tags": "Comedy"]
    let twd = ["title": "The Walking Dead", "desc": "The Walking Dead is an American horror drama television series developed by Frank Darabont. It is based on the comic book series of the same name by Robert Kirkman, Tony Moore, and Charlie Adlard. The series stars Andrew Lincoln as sheriff's deputy Rick Grimes, who awakens from a coma to find a post-apocalyptic world dominated by flesh-eating zombies. He sets out to find his family and encounters many other survivors along the way.", "image": "the_walking_dead", "rating": 8.7, "tags": "Drama | Horror | Thriller"]
    
    var data: [[String: AnyObject]] = []
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
      
      self.currentTabIndex = 3
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      
      self.currentTabIndex = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DeviceType.iPad {
            self.navigationController?.navigationBar.barTintColor = nil
        }
        
        data = [bcs, bb, fs, f, got, g, hoc, himym, s, tbbt, twd]
        
        datasource = self
        delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func reloadPager(sender: UIBarButtonItem) {
        reloadData()
    }
    
    // MARK: - RGPageViewController Data Source
    func numberOfPagesForViewController(pageViewController: RGPageViewController) -> Int {
        return data.count
    }
    
    func tabViewForPageAtIndex(pageViewController: RGPageViewController, index: Int) -> UIView {
        var tabView: UIView!
        
        if !DeviceType.iPad {
            tabView = UILabel()
            
            (tabView as! UILabel).font = UIFont.systemFontOfSize(17)
            (tabView as! UILabel).text = data[index]["title"] as? String
            
            (tabView as! UILabel).sizeToFit()
        } else {
            tabView = UIImageView(frame: CGRectMake(0.0, 0.0, 115.0, 164.0))
            let imageName: String = data[index]["image"] as! String
            
            tabView.contentMode = UIViewContentMode.ScaleAspectFill
            tabView.backgroundColor = UIColor.whiteColor()
            
            (tabView as! UIImageView).image = UIImage(named: "\(imageName)_poster.jpg")
        }
        
        return tabView
    }
    
    func viewControllerForPageAtIndex(pageViewController: RGPageViewController, index: Int) -> UIViewController? {
        if (data.count == 0) || (index >= data.count) {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let dataViewController = storyboard!.instantiateViewControllerWithIdentifier("DataViewController") as! DataViewController
        
        dataViewController.dataObject = data[index]
        
        return dataViewController
    }
    
    // MARK: - RGPageViewController Delegate
    // use this to set a custom height for the tabbar
    func heightForTabAtIndex(index: Int) -> CGFloat {
        return 164.0
    }
    
    // use this to set a custom width for a tab
    func widthForTabAtIndex(index: Int) -> CGFloat {
        if DeviceType.iPad {
            return tabbarWidth
        } else {
            var tabSize = (data[index]["title"] as! String).sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17)])
            
            tabSize.width += 32
            
            return tabSize.width
        }
    }
    
    // use this to change the height of the tab indicator
    func widthOrHeightForIndicator() -> CGFloat {
        if DeviceType.iPad {
            return 4.0
        }
        
        return 2.0
    }
}