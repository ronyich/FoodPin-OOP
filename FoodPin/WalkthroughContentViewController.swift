//
//  WalkthroughContentViewController.swift
//  FoodPin
//
//  Created by Ron Yi on 2018/5/19.
//  Copyright © 2018年 Ron Yi. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {
    
    @IBOutlet var headingLabel:UILabel!
    @IBOutlet var contentLabel:UILabel!
    @IBOutlet var contentImageView:UIImageView!
    
    @IBOutlet var pageControl:UIPageControl!
    @IBOutlet var forwardButton:UIButton!
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        switch index {
        case 0...1: // Next按鈕
            //如果受話者是容器型控制器的子類別，則此ＶＣ會將屬性保存在其中
            //如果受話者沒有父類別，則屬性值變為nil
            let pageViewController = parent as! WalkthroughPageViewController
            pageViewController.forward(index: index)
        case 2: // Done按鈕，將導覽狀態儲存在UserDefaults
            UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    var index = 0
    var heading = ""
    var imageFile = ""
    var content = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        headingLabel.text = heading
        contentLabel.text = content
        contentImageView.image = UIImage(named: imageFile)
        
        pageControl.currentPage = index
        
        switch index {
        case 0...1: forwardButton.setTitle("Next", for: .normal)
        case 2: forwardButton.setTitle("Done", for: .normal)
        default: break
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
