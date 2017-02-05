//
//  ViewController.swift
//  TaskMe
//
//  Created by Pietro Sette on 1/27/17.
//  Copyright © 2017 Pietro Sette. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController!
    var pageTitles: NSArray!
    var pageImages: NSArray!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.pageTitles = NSArray(objects: "Login", "SignUp")
        self.pageImages = NSArray(objects: #imageLiteral(resourceName: "background"), #imageLiteral(resourceName: "img2"))
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let startVC = self.viewControllerAtIndex(index: 0) as ContentViewController
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers((viewControllers as! [UIViewController]), direction: .forward, animated: true, completion: nil)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func viewControllerAtIndex(index: Int) -> ContentViewController
    {
        if(self.pageTitles.count == 0 || index >= self.pageTitles.count){
            return ContentViewController()
        }
        let vc: ContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "Welcome") as! ContentViewController
        vc.imageFile = self.pageImages[index] as! String
        vc.titleText = self.pageTitles[index] as! String
        vc.pageIndex = index
        return vc
    }
    // MARK: - Page View Controller Data Source
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        if(index == 0 || index == NSNotFound){
        return nil
        }
        index -= 1
        return self.viewControllerAtIndex(index: index)
    }
    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        if(index == NSNotFound){
            return nil
        }
        index += 1
        if( index == self.pageTitles.count){
            return nil
        }
        return self.viewControllerAtIndex(index: index)
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

