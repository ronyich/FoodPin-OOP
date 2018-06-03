//
//  AddRestaurantController.swift
//  FoodPin
//
//  Created by Ron Yi on 2018/5/13.
//  Copyright © 2018年 Ron Yi. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
class AddRestaurantController: UITableViewController ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    
    var restaurants:RestaurantMO!
    var isVisited = true
    
    @IBOutlet var photoImageView: UIImageView!
    
    @IBOutlet var nameTextField:UITextField!
    @IBOutlet var typeTextField:UITextField!
    @IBOutlet var locationTextField:UITextField!
    @IBOutlet var phoneTextField:UITextField!
    
    @IBOutlet var yesButton:UIButton!
    @IBOutlet var noButton:UIButton!
    
    @IBAction func toggleBeenHereButton(sender: UIButton){
        //Yes按鈕被點擊
        if sender == yesButton{
            isVisited = true
            yesButton.backgroundColor = .red
            noButton.backgroundColor = .gray
        }else if sender == noButton{
            isVisited = false
            yesButton.backgroundColor = .gray
            noButton.backgroundColor = .red
        }
    }

    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        if nameTextField.text == "" || typeTextField.text == "" || locationTextField.text == "" || phoneTextField.text == ""{
                let myAlert = UIAlertController(title: "No input", message: "Please enter somthing", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                myAlert.addAction(okAction)
                present(myAlert, animated: true, completion: nil)
            }
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                restaurants = RestaurantMO(context: appDelegate.persistentContainer.viewContext)
                restaurants.name = nameTextField.text
                restaurants.type = typeTextField.text
                restaurants.location = locationTextField.text
                restaurants.phone = phoneTextField.text
                restaurants.isVisited = isVisited
                
                if let restaurantImage = photoImageView.image {
                    if let imageData = UIImagePNGRepresentation(restaurantImage) {
                        restaurants.image = NSData(data: imageData) as Data
                    }
                }
                print("Saving data to context...")
                appDelegate.saveContext()
            }
            dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //didSelectRowAt方法在其中一個cell被選取時呼叫，但我們只想要第一個cell被選取時帶出照片庫，所以只在最前面設定條件檢查，要載入照片庫必須建立UIImagePickerController的實體，並將sourceType設定為photoLibrary，接著用present帶出照片庫
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    //實作委派方法，將user選擇的照片呈現在photoImageView上
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
            //photoImageView佈局
            let leadingConstraint = NSLayoutConstraint(item: photoImageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: photoImageView.superview, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
            leadingConstraint.isActive = true
            
            let trailingConstraint = NSLayoutConstraint(item: photoImageView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: photoImageView.superview, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
            trailingConstraint.isActive = true
            
            let topConstraint = NSLayoutConstraint(item: photoImageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: photoImageView.superview, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
            topConstraint.isActive = true
            
            let bottomConstraint = NSLayoutConstraint(item: photoImageView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: photoImageView.superview, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            bottomConstraint.isActive = true
            
            dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source
/*  因為是要使用靜態格視圖，所以不需要這兩個方法
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
