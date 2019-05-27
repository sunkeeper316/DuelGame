//
//  ShopTVC.swift
//  DuelGame
//
//  Created by 黃德桑 on 2019/5/22.
//  Copyright © 2019 sun. All rights reserved.
//

import UIKit
import Firebase

class ShopTVC: UITableViewController {

    @IBOutlet weak var shopcard: UITableViewCell!
    @IBOutlet weak var lbMoney: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lbShow.text = "抽卡商店\n一次十連抽同一張卡只能放在牌組三張\n所以超過三張的卡系統會自動刪掉\n存在自己的卡片檔案"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @IBOutlet weak var lbShow: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        lbMoney.text = String(user.money)
    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
//        self.tableView.cellForRow(at: indexPath)
//        shopcard.
//    }
    
    // MARK: - Table view data source

    

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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if user.money == 0 {
            let alertcontroller = UIAlertController(title: "寶石不夠", message: "建議購買寶石！！", preferredStyle: .alert)
            let ok = UIAlertAction(title: "確定", style: .cancel, handler: nil)
            alertcontroller.addAction(ok)
            present(alertcontroller, animated: true, completion: nil)
            return false
        } else {
            
            return true
        }
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        user.money -= 1
        let db = Firestore.firestore()
        db.collection("User").document("1").collection("\(user.id!)").getDocuments{(querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                if querySnapshot.documents.first?.data() != nil {
                    
                    querySnapshot.documents.first?.reference.updateData(["money":user.money!])
                    
                   
                }
            }
        }
    }
    

}
