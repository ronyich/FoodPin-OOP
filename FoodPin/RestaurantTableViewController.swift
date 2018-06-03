//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Ron Yi on 2018/4/18.
//  Copyright © 2018年 Ron Yi. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
class RestaurantTableViewController: UITableViewController,NSFetchedResultsControllerDelegate,UISearchResultsUpdating{
    
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue){
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var restaurants:[RestaurantMO] = []
    var fetchResultController: NSFetchedResultsController<RestaurantMO>!
    
    var searchController:UISearchController!
    var searchResults:[RestaurantMO] = [] //用來儲存過濾搜尋內容
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
        
        //檢查搜尋控制器是否啟動，當使用者執行搜尋時，是從搜尋結果取得餐廳，而不是餐廳陣列取得。
        let restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
        
        //預設屬性
        //cell.textLabel?.text = restaurantNames[indexPath.row]
        //cell.imageView?.image = UIImage(named: restaurantImages[indexPath.row])
        //Set cell 由預設改成自訂類別的屬性
        cell.nameLabel?.text = restaurants[indexPath.row].name
        cell.thumbnailImageView?.image = UIImage(data: restaurants[indexPath.row].image! as Data)
        cell.locationLabel?.text = restaurants[indexPath.row].location
        cell.typeLabel?.text = restaurants[indexPath.row].type
        
        //設成圓角
        cell.thumbnailImageView?.layer.cornerRadius = 30
        cell.thumbnailImageView?.clipsToBounds = true
        
        //更新輔助視圖簡寫
        cell.accessoryType = restaurants[indexPath.row].isVisited ? .checkmark : .none
        //更新輔助視圖一般寫法
//        if restaurants[indexPath.row].isVisited{
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        
        return cell
    }
/*
    //點選row後需要執行的動作
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //建立一個類似動作清單的選單
        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
        //加入動作至選單中
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        //呈現選單
        present(optionMenu, animated: true, completion: nil)
        
        //加入Call的動作
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            let alertMessage = UIAlertController(title: "Service Unavailable", message: "Sorry, the call feature is not available yet. Please try later.", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        }
        
        let callAction = UIAlertAction(title: "Call " + "123-000-\(indexPath.row)", style: .default, handler: callActionHandler)
        optionMenu.addAction(callAction)
        
        /*//Check-in動作
        let checkInAction = UIAlertAction(title: "Check in", style: .default,handler: { (action:UIAlertAction!) -> Void in
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            self.restaurantIsVisited[indexPath.row] = true //修正bug
        })
        optionMenu.addAction(checkInAction)
        //取消勾選 (Homework)
        if restaurantIsVisited[indexPath.row] == true{
            let undoCheckInAction = UIAlertAction(title: "Undo Check In", style: .default,handler: { (action:UIAlertAction!) -> Void in
                let cell = tableView.cellForRow(at: indexPath)
                cell?.accessoryType = .none
                self.restaurantIsVisited[indexPath.row] = false
            })
            optionMenu.addAction(undoCheckInAction)
        }*/
        
        //課本示範簡潔寫法
        let checkInTitle = restaurantIsVisited[indexPath.row] ? "Undo Check in" : "Check in"
        let checkInAction = UIAlertAction(title: checkInTitle, style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            let cell = tableView.cellForRow(at: indexPath)
            
            // Toggle check-in and undo-check-in
            self.restaurantIsVisited[indexPath.row] = self.restaurantIsVisited[indexPath.row] ? false : true
            cell?.accessoryType = self.restaurantIsVisited[indexPath.row] ? .checkmark : .none
        })
        optionMenu.addAction(checkInAction)
        
        //取消列的選取(選取列的時候出現的灰色)
        tableView.deselectRow(at: indexPath, animated: false)
    }
*/
    
    //啟動滑動刪除功能
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            restaurants.remove(at: indexPath.row)
        }
        //編輯後需要reload更新陣列中的最新資料，否則資料刪除了但會發生還顯示在畫面上
        //tableView.reloadData() 由下列取代這行，滑動可選擇其他動畫
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

    //在cell上往左滑動帶出其他動作
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //社群分享按鈕
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Share") { (action, indexPath) in
            let defaultText = "Just checking in at" + self.restaurants[indexPath.row].name!
            
            //UIActivityViewController為提供數種基本服務，如複製項目、分享到社群
            if let imageToShare = UIImage(data: self.restaurants[indexPath.row].image! as Data){
                let activityController = UIActivityViewController(activityItems:[defaultText,imageToShare], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        //刪除按鈕
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete") { (action, indexPath) in
            
            //self.restaurants.remove(at: indexPath.row)
            //self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            //呼叫saveContext方法來變更，確實刪除永久儲存的資料
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let restaurantToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(restaurantToDelete)
                
                appDelegate.saveContext()
            }
        }
        
        shareAction.backgroundColor = UIColor(red: 48.0/255.0, green: 173.0/255, blue: 99.0/255, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 202/255, green: 203/255, blue: 203/255, alpha: 1.0)
        return [deleteAction,shareAction]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //移除返回按鈕的標題，navigationBar為現在這個class，而非Detail
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        //滑動回到上一頁
        navigationController?.hidesBarsOnSwipe = true
        
        //啟用自適應cell，還需要變更Storyboard中ValueLabel的Lines為0
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension //維持尺寸
        
        //從資料儲存區中讀取資料
        let fetchRequest: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    restaurants = fetchedObjects
                }
            }catch{
                print(error)
            }
        }
        
        //加上搜尋列
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchResultsUpdater = self //指定目前類別為搜尋結果更新器
        //控制底下內容於搜尋期間是否變為黯淡的狀態，由於我們是要呈現搜尋結果在相同視圖，因此要設false
        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchBar.tintColor = .gray
    }
    //當NSFetchRequestResult準備開始處理內容變更時被呼叫
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            restaurants = fetchedObjects as! [RestaurantMO]
        }
    }
    //過濾搜尋到的內容，restaurants.filter方法將符合的內容回傳一個新陣列searchResults，若有值符合就回傳true
    //localizedCaseInsensitiveContains方法為不區分搜尋到的大小寫
    func filterContent(for searchText: String) {
        searchResults = restaurants.filter({ (restaurant) -> Bool in
            if let name = restaurant.name ,let location = restaurant.location {
                let isMatch = name.localizedCaseInsensitiveContains(searchText) || location.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            return false
        })
    }
    //更新搜尋結果，讓搜尋結果直接顯示
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return restaurants.count
        //使用isActive(預設true)來判斷要顯示全部餐廳 or 搜尋後的餐廳，並在cellForRowAt加入判斷式
        if searchController.isActive {
            return searchResults.count
        }else{
            return restaurants.count
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    
    // 當使用者滑過cell，不要在搜尋結果顯示按鈕(Share & Delete)
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        
        if searchController.isActive {
            return false
        }else{
            return true
        }
    }

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    //轉場到RestaurantDetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurants = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
                //在Detail頁面隱藏Favorite標籤列，也可以再Storyboard設定
                destinationController.hidesBottomBarWhenPushed = true
            }
        }
//        if segue.identifier == "addRestaurant"{
//            if let indexPath = tableView.indexPathForSelectedRow{
//                let destinationController = segue.destination as! AddRestaurantController
//                destinationController.restaurants = restaurants[indexPath.row]
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
        //從UserDefaults取得"hasViewedWalkthrough"的key並檢查其值
        //讓導覽列只在值設定為false時才會呈現，在nextButtonTapped預設值為true
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough"){
            return
        }
        
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? WalkthroughPageViewController {
            present(pageViewController, animated: true, completion: nil)
        }
    }
    
    
    
    
}
