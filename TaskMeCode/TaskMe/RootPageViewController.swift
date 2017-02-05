//
//  RootUIPageViewController.swift
//  TaskMe
//
//  Created by Pietro Sette on 2/4/17.
//  Copyright © 2017 Pietro Sette. All rights reserved.
//

import UIKit

class RootPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    lazy var viewControllerList:[UIViewController] = {
        let sb = UIStoryboard(name: "Main", bundle:nil)
        
        let vc1 = sb.instantiateViewController(withIdentifier: "Welcome")
        let vc2 = sb.instantiateViewController(withIdentifier: "LoginSignUp")
        
        return [vc1,vc2]
        
    
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        if let firstViewController = viewControllerList.first{
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else{        return nil}
        let previousIndex = vcIndex - 1
        guard  previousIndex >= 0 else {
            return nil
        }
        guard viewControllerList.count > previousIndex else {
            return nil
        }
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        let nextIndex = vcIndex + 1
        guard viewControllerList.count != nextIndex else {
            return nil
        }
        guard viewControllerList.count > nextIndex else {
            return nil
        }
        return viewControllerList[nextIndex]
    }
}
