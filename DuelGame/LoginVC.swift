//
//  LoginVC.swift
//  DuelGame
//
//  Created by 黃德桑 on 2019/5/26.
//  Copyright © 2019 sun. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    @IBOutlet weak var tfaccount: UITextField!
    @IBOutlet weak var tfpassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clicklogin(_ sender: Any) {
        if tfaccount.text! != "" {
            checkaccount()
        }else{
            let alertcontroller = UIAlertController(title: "錯誤", message: "沒有輸入帳號ㄎ", preferredStyle: .alert)
            let cannel = UIAlertAction(title: "確認", style: .cancel, handler: nil)
            alertcontroller.addAction(cannel)
            self.present(alertcontroller, animated: true, completion: nil)
        }
        
    }
    func getuserdata(){
        let db = Firestore.firestore()
        db.collection("User").document("1").collection("\(tfaccount.text!)").whereField("account", isEqualTo: "\(tfaccount.text!)").getDocuments{(querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                if querySnapshot.documents.first?.data() != nil {
                    user.id = (querySnapshot.documents.first?.data()["account"] as! String)
                    user.money = (querySnapshot.documents.first?.data()["money"] as! Int)
                    user.playcards = (querySnapshot.documents.first?.data()["playcard"] as! [Int])
                    user.cards = (querySnapshot.documents.first?.data()["card"] as! [Int])
                    owncard()
                    addplaycard()
                    self.performSegue(withIdentifier: "Login", sender: self)
                }
            }
        }
    }
    
    
    func checkaccount(){
        let db = Firestore.firestore()
        db.collection("User").document("1").collection("\(tfaccount.text!)").getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                if (querySnapshot.documents.first?.data()["account"] as! String?) != nil {
                    if querySnapshot.documents.first?.data()["account"] as! String? == self.tfaccount.text!{
                        self.getuserdata()
                    }else{
                        let alertcontroller = UIAlertController(title: nil, message: "帳號輸入錯誤", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                        alertcontroller.addAction(ok)
                        self.present(alertcontroller, animated: true, completion: nil)
                    }
                    
                }else{
                    let alertcontroller = UIAlertController(title: "錯誤", message: "無此帳號", preferredStyle: .alert)
                    let cannel = UIAlertAction(title: "確認", style: .cancel, handler: nil)
                    alertcontroller.addAction(cannel)
                    self.present(alertcontroller, animated: true, completion: nil)
                }
            }
        }
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
