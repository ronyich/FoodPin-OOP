//
//  MapViewController.swift
//  FoodPin
//
//  Created by Ron Yi on 2018/5/11.
//  Copyright © 2018年 Ron Yi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController ,MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    var restaurants:RestaurantMO!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //把MapViewController(self)當作mapView的委派物件，才會實作viewFor方法
        mapView.delegate = self
        
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsTraffic = true

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
                //加上標註、標題
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurants.name
                annotation.subtitle = self.restaurants.type
                
                if let loaction = placemarks.location{
                    annotation.coordinate = loaction.coordinate
                    
                    //顯示標註，showAnnotations方法會自動判斷大頭針的合適區域
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        if annotation.isKind(of: MKUserLocation.self){
            return nil
        }
        //如果可以的話重複使用這個標註
        var annotationView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRect.init(x: 0,y: 0,width: 53,height: 53))
        leftIconView.image = UIImage(data: restaurants.image as! Data)
        annotationView?.leftCalloutAccessoryView = leftIconView
        annotationView?.pinTintColor = UIColor.orange
        
        return annotationView
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
