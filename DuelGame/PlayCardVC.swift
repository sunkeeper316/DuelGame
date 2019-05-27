//
//  PlayCardVC.swift
//  DuelGame
//
//  Created by 黃德桑 on 2019/5/22.
//  Copyright © 2019 sun. All rights reserved.
//

import UIKit
import Firebase

class PlayCardVC: UIViewController ,UITableViewDataSource ,UITableViewDelegate,UICollectionViewDelegate ,UICollectionViewDataSource{
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var collectionview: UICollectionView!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.playcards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playcardCell", for: indexPath) as! playcardCell
        let card = user.playcards[indexPath.row]
        cell.ivImage.image = UIImage(named: "\(card)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.owncards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell") as! CardCell
        let card = user.owncards[indexPath.row]
        cell.lbcardcount.text = "數量:\(card.count!)"
        cell.lbname?.text = String(card.carno)
        cell.ivImage?.image = UIImage(named: "\(card.carno!)")
        
        return cell
    }
    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = user.owncards[indexPath.row]
        let alertcontroller = UIAlertController(title: nil, message: "要加入牌組嗎？", preferredStyle: .alert)
        let addplaycard = UIAlertAction(title: "加入牌組", style: .default) { (alertaction) in
            if card.count > 0 && user.playcards.count <= 30{
                user.playcards.append(card.carno)
                user.owncards[indexPath.row].count -= 1
            }
            self.updataplaycard()
            self.tableview.reloadData()
            self.collectionview.reloadData()
        }
        let carddetail = UIAlertAction(title: "查看卡片資訊", style: .default) { (alertaction) in
            self.performSegue(withIdentifier: "CarddetailVC", sender: self)
        }
        alertcontroller.addAction(addplaycard)
        alertcontroller.addAction(carddetail)
        present(alertcontroller, animated: true, completion: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CarddetailVC"{
            let indexpath = self.tableview.indexPathForSelectedRow
            let card = user.owncards[(indexpath?.row)!].carno
            let carddetailVC = segue.destination as! CarddetailVC
            carddetailVC.carddetail = card
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

        self.tableview.reloadData()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.reloadData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickinplaycard(_ sender: UIButton) {
        
        
        navigationController?.popViewController(animated: true)
    }
    func updataplaycard() {
        user.playcards.sort()
        let db = Firestore.firestore()
        db.collection("User").document("1").collection("\(user.id!)").getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                querySnapshot.documents.first?.reference.updateData(["playcard":user.playcards], completion: { (error) in
                })
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
