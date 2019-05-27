//
//  SignupVC.swift
//  DuelGame
//
//  Created by 黃德桑 on 2019/5/26.
//  Copyright © 2019 sun. All rights reserved.
//

import UIKit
import Firebase

class SignupVC: UIViewController {
    
    @IBOutlet weak var tfAccount: UITextField!
    @IBOutlet weak var tfpassword: UITextField!
    @IBOutlet weak var tfpasswordcheck: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clicksubmit(_ sender: UIButton) {
        if tfpassword.text == tfpasswordcheck.text {
            checkaccount()
            
        }
    }
    
    @IBAction func clickBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    func setSignup(){
        let db = Firestore.firestore()
    db.collection("User").document("1").collection("\(tfAccount.text!)").document("\(tfAccount.text!)").setData(["account":"\(self.tfAccount.text!)"])
        setother()
        
    }
    func setother(){
        let db = Firestore.firestore()
        db.collection("User").document("1").collection("\(tfAccount.text!)").whereField("account", isEqualTo: "\(self.tfAccount.text!)").getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                querySnapshot.documents.first?.reference.updateData(["money":5])
                querySnapshot.documents.first?.reference.updateData(["card":[]])
                querySnapshot.documents.first?.reference.updateData(["playcard":[]])
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    func checkaccount(){
        let db = Firestore.firestore()
        db.collection("User").document("1").collection("\(tfAccount.text!)").getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                if (querySnapshot.documents.first?.data()["account"] as! String?) != nil {
                    if querySnapshot.documents.first?.data()["account"] as! String? == self.tfAccount.text!{
                        let alertcontroller = UIAlertController(title: nil, message: "帳號重複", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                        alertcontroller.addAction(ok)
                        self.present(alertcontroller, animated: true, completion: nil)
                    }
                    
                }else{
                    self.setSignup()
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
