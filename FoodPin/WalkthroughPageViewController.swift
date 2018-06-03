//
//  WalkthroughPageViewController.swift
//  FoodPin
//
//  Created by Ron Yi on 2018/5/19.
//  Copyright © 2018年 Ron Yi. All rights reserved.
//

import UIKit

class WalkthroughPageViewController: UIPageViewController ,UIPageViewControllerDataSource{
    
    var pageHeadings = ["Personalize","Locate","Discover"]
    var pageImages = ["foodpin-intro-1","foodpin-intro-2","foodpin-intro-3"]
    var pageContent = ["Pin your favorite restaurant and create your own food guide","Search and locate your favorite restaurant on Maps","Find restaurants pinned by your friends and other foodies around the world"]
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        return contentViewController(at: index)
    }
    
    func contentViewController(at index:Int) -> WalkthroughContentViewController? {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
        
        //建立新的視圖控制器，並傳遞適合的資料
        if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
            
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.content = pageContent[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        return nil
    }
    
    func forward(index: Int){
        if let nextViewController = contentViewController(at: index + 1){
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
/*    //加入預設的頁面指示器（現在改用自訂指示器，所以註解掉）
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageHeadings.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
            return pageContentViewController.index
        }
        return 0
    }
*/
    override func viewDidLoad() {
        super.viewDidLoad()

        //將資源設定為自己
        dataSource = self
        
        //建立第一個導覽畫面
        if let startingViewController = contentViewController(at: 0){
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
