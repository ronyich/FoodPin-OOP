//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by Ron Yi on 2018/5/2.
//  Copyright © 2018年 Ron Yi. All rights reserved.
//

import UIKit
import MapKit

@available(iOS 10.0, *)
class RestaurantDetailViewController: UIViewController ,UITableViewDataSource ,UITableViewDelegate{
    
    @IBOutlet var restaurantImageView:UIImageView!
    var restaurants:RestaurantMO!
    
    @IBOutlet var tableView:UITableView!
    
    @IBAction func close(segue:UIStoryboardSegue){
        
    }
    
    @IBAction func ratingButtonTapped(segue: UIStoryboardSegue){
        if let rating = segue.identifier{
            restaurants.isVisited = true
            
            switch rating{
            case "great": restaurants.rating = "Absolutely love it!"
            case "good": restaurants.rating = "Pretty good."
            case "dislile": restaurants.rating = "I don't like it."
            default:break
            }
        }
        //呼叫saveContext()方法將評價永久儲存
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            appDelegate.saveContext()
        }
        
        tableView.reloadData()
    }
    
    @IBOutlet var mapView: MKMapView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantDetailTableViewCell
        //Set Cell
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = restaurants.name
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = restaurants.type
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = restaurants.location
        case 3:
            cell.fieldLabel.text = "Phone"
            cell.valueLabel.text = restaurants.phone
        case 4:
            cell.fieldLabel.text = "Been Here"
            cell.valueLabel.text = (restaurants.isVisited) ? "Yes, I've been here before. \(restaurants.rating)" : "No"
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        //清除cell的背景顏色(設為透明，才能設成別的顏色)
        cell.backgroundColor = UIColor.clear
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantImageView.image = UIImage(data: restaurants.image as! Data)
        tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)
        //移除空白列的分隔線(將顏色設為空白)，然後變更分隔線的顏色
        //tableView.tableFooterView = UIView(frame: CGRect.zero)刪除以顯示地圖
        tableView.separatorColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0.8)
        title = restaurants.name
        
        navigationController?.hidesBarsOnSwipe = false
        //GestureRecognizer為偵測手勢SDK，用UITapGestureRecognizer處理點擊手勢
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMap))
        mapView.addGestureRecognizer(tapGestureRecognizer)
        
        //建立一個CLGeocoder的實體，然後把地址:字串轉換成地圖上的座標，並顯示在小地圖上
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurants.location!) { (placemarks, error) in
            if error != nil {
                print(error!)
                return
            }
            if let placemarks = placemarks{
                //取得第一個地標
                let placemarks = placemarks[0]
                //加上標註
                let annotation = MKPointAnnotation()
                if let loaction = placemarks.location{
                    annotation.coordinate = loaction.coordinate
                    self.mapView.addAnnotation(annotation)
                //設定縮放程度
                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
                    self.mapView.setRegion(region, animated: false)
                }
            }
        }
    }
    
    @objc func showMap(){
        performSegue(withIdentifier: "showMap", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReview"{
            let dvc = segue.destination as! ReviewViewController
            dvc.restaurant = restaurants
        }
        else if segue.identifier == "showMap"{
            let dvc = segue.destination as! MapViewController
            dvc.restaurants = restaurants
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
