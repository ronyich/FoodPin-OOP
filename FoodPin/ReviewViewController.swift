//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by Ron Yi on 2018/5/9.
//  Copyright © 2018年 Ron Yi. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    @IBOutlet var backgroundImageView:UIImageView!
    @IBOutlet var containerView:UIView!
    
    @IBOutlet var restaurantImageView:UIImageView!
    var restaurant:RestaurantMO?

    override func viewDidLoad() {
        super.viewDidLoad()
        //背景圖片加入模糊效果
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        //設定動畫變形的起始座標
        let scaleTransform = CGAffineTransform.init(scaleX: 0, y: 0)
        //將畫面從視圖外-1000的位置，然後再移回來正確的位置
        let translateTransform = CGAffineTransform.init(translationX: 0, y: -1000)
        let combineTransform = scaleTransform.concatenating(translateTransform)
        containerView.transform = combineTransform
        
        //設定到動畫終止狀態時的彈跳阻力
        //UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
            //self.containerView.transform = CGAffineTransform.identity
        //}, completion: nil)
        
        //作業1:評論顯示該餐廳圖片
        if let restaurant = restaurant {
            restaurantImageView.image = UIImage(data: restaurant.image as! Data)
        }
    }
    //設定動畫持續時間
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.containerView.transform = CGAffineTransform.identity
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
