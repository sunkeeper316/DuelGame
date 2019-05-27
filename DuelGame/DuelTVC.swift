//
//  DuelTVC.swift
//  DuelGame
//
//  Created by 黃德桑 on 2019/5/23.
//  Copyright © 2019 sun. All rights reserved.
//

import UIKit
import Firebase

class DuelTVC: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        lbShow.text = "遊戲規則\n每回合可以招喚一隻怪獸，每隻怪獸一回合可以攻擊一次，怪獸攻擊攻擊力高可以破壞攻擊力低並且扣掉多出來攻擊力的生命力，牌組最少要20張最多30張，一開始每人四張牌每回合補抽一張，生命值低於0牌組的牌抽光就算輸"
    }
    
    @IBOutlet weak var lbShow: UILabel!
    func getuserdata(){
        let db = Firestore.firestore()
        db.collection("User").document("1").collection("\(user.id!)").getDocuments{(querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                if querySnapshot.documents.first?.data() != nil {
                    user.playcards = (querySnapshot.documents.first?.data()["playcard"] as! [Int])
                }
            }
        }
    }
    
    func checkplay(){
        let db = Firestore.firestore()
        db.collection("Game").getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                players[0] = querySnapshot.documents.first?.data()["1player"] as! String
                players[1] = querySnapshot.documents.first?.data()["2player"] as! String
                if players[0] == "" {
                    player = 1 //1p先攻
                    print("play" + String(player))
                    self.inputname()
                    self.performSegue(withIdentifier: "GameTVC", sender: self)
                    
                }else if players[1] == ""{
                    player = 2
                    print("play" + String(player))
                    self.inputname()
                    self.performSegue(withIdentifier: "GameTVC", sender: self)
                }else{
                    let alertcontroller = UIAlertController(title: "房間已滿", message: "可能戰鬥開始！！", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "確定", style: .cancel, handler: nil)
                    alertcontroller.addAction(ok)
                    self.present(alertcontroller, animated: true, completion: nil)
                    print("gamefull")
                }
                print(players[0],players[1])
            }
        }
    }
    
    func inputname() {
        let db = Firestore.firestore()
        db.collection("Game").getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                if player == 1 {
                    players[0] = user.id
                    querySnapshot.documents.first?.reference.updateData(["1player" :"\(user.id!)"], completion: { (error) in
                        if let error = error {
                            print(error)
                            return
                        }
                    })
                }else if player == 2 {
                    players[1] = user.id
                    querySnapshot.documents.first?.reference.updateData(["2player" :"\(user.id!)"], completion: { (error) in
                        if let error = error {
                            print(error)
                            return
                        }
                    })
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        getuserdata()
    }
    @IBAction func clickplaygame(_ sender: Any) {
        getuserdata()
        if user.playcards.count < 20 {
            let alertcontroller = UIAlertController(title: "警告", message: "牌組低於20張", preferredStyle: .alert)
            let ok = UIAlertAction(title: "確定", style: .cancel, handler: nil)
            alertcontroller.addAction(ok)
            present(alertcontroller, animated: true, completion: nil)
        }else{
            checkplay()
        }
        
    }
    @IBAction func clickclearroom(_ sender: Any) {
        let alertcontroller = UIAlertController(title: "警告清理房間可能會影響到正在進行的遊戲", message: "要清理房間嗎？", preferredStyle: .alert)
        let addplaycard = UIAlertAction(title: "確定", style: .default) { (alertaction) in
            
            let db = Firestore.firestore()
            db.collection("Game").getDocuments { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    querySnapshot.documents.first?.reference.updateData(["1player" :""], completion: { (error) in
                    })
                    querySnapshot.documents.first?.reference.updateData(["2player" :""], completion: { (error) in
                    })
                }
            }
            db.collection("Player1start").getDocuments { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    querySnapshot.documents.first?.reference.updateData(["playerstatus" :false], completion: { (error) in
                        if let error = error {
                            print(error)
                            return
                        }
                    })
                }
            }
            db.collection("Player2start").getDocuments { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    querySnapshot.documents.first?.reference.updateData(["playerstatus" :false], completion: { (error) in
                        if let error = error {
                            print(error)
                            return
                        }
                    })
                }
            }
            db.collection("surrender").getDocuments { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    querySnapshot.documents.first?.reference.updateData(["surrender" :false], completion: { (error) in
                        if let error = error {
                            print(error)
                            return
                        }
                    })
                }
            }
        }
        let cannel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertcontroller.addAction(addplaycard)
        alertcontroller.addAction(cannel)
        present(alertcontroller, animated: true, completion: nil)
        
    }
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
