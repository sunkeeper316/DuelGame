//
//  GameTVC.swift
//  DuelGame
//
//  Created by 黃德桑 on 2019/5/21.
//  Copyright © 2019 sun. All rights reserved.
//

import UIKit
import Firebase
var player = 0
var players = ["",""]

class GameTVC: UITableViewController ,UICollectionViewDataSource , UICollectionViewDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return handcard.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayGameCell", for: indexPath) as! PlayGameCell
        let card = handcard[indexPath.row]
        cell.ivImage.image = UIImage(named: "\(card)")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let card = handcard[indexPath.row]
        clickcard = card
        ivclick.image = UIImage(named: "\(card)")
        
    }
    var isgamewin = 0
    var roleatking = 0 //正在攻擊的人
    var attack = true
    var player1life = 4000
    var player2life = 4000
    var playstatus = true
    
    var handcard = [Int]() //預設手牌
    var mycards = [Int]() //這個遊戲要用的卡牌集合
    var clickcard = 0 //要出牌先把牌暫時放在這
    @IBOutlet weak var ivclick: UIImageView!
    var role = 1  //每回合只能招換一隻怪物要用的變數
    var roleongames = [Card]()//我方場上怪物的數量
    var enemyroles = [Card]()//敵方場上怪獸
    var roletext = "" //各種角色資訊
    
    @IBOutlet weak var lbplayer2life: UILabel!
    @IBOutlet weak var lbplayer1life: UILabel!
    
    @IBOutlet weak var bt2prole2: UIButton!
    @IBOutlet weak var bt2prole1: UIButton!
    @IBOutlet weak var bt2prole3: UIButton!
    
    
    @IBOutlet weak var btready: UIButton!
    @IBOutlet weak var collectionview: UICollectionView!
    
    
    @IBOutlet weak var bt1prole2: UIButton!
    @IBOutlet weak var bt1prole3: UIButton!
    @IBOutlet weak var bt1prole1: UIButton!
    
    @IBOutlet weak var btstart: UIButton!
    @IBOutlet weak var lb1player: UILabel!
    @IBOutlet weak var lb2player: UILabel!
    @IBOutlet weak var lbplaystatus: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionview.isHidden = true
        btstart.isHidden = true
        let count = user.playcards.count
        for _ in 1...count{
            mycards.append(user.playcards.randomElement()!)
            for (index , card) in user.playcards.enumerated(){
                if card == mycards.last{
                    user.playcards.remove(at: index)
                    break
                }
            }
        }
        
        for _ in 1...4{
            getcard()
        }
        print(mycards)
        getsurrender()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFireMethod(timer:)), userInfo: "info", repeats: true)
    }
    @objc func timerFireMethod(timer: Timer) {
        print("timer.userInfo: \(timer.userInfo!)")
        getdbname()
        lbplaystatus.text = "等待對方玩家"
        if player == 1 {
            if players[1] != "" {
                lbplaystatus.text = "遊戲開始"
                timer.invalidate()
            }
            
        }else if player == 2 {
            if players[0] != "" {
                lbplaystatus.text = "遊戲開始"
                timer.invalidate()
            }
        }else{
            timer.invalidate()
        }
    }
    
    func getcard(){
        if mycards.count != 0{
            handcard.append(mycards.last!)
            mycards.removeLast()

        }else{
            player1life = 0
            putsurrender()
            iswin()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.collectionview.reloadData()
    }
    
    func getdbname(){
        let db = Firestore.firestore()
        db.collection("Game").getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                if player == 1 {
                    players[1] = querySnapshot.documents.first?.data()["2player"] as! String
                    
                    self.lb2player.text = players[1]
                    self.lb1player.text = players[0]
                }else if player == 2{
                    players[0] = querySnapshot.documents.first?.data()["1player"] as! String
                    
                    self.lb1player.text = players[0]
                    self.lb2player.text = players[1]
                }else{
                    print("gamefull")
                }
                
                
            }
        }
    }
    
    func exchange() {
        if player == 1 {
            let db = Firestore.firestore()
            db.collection("Player2start").getDocuments { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    let document = querySnapshot.documents.first
                    document?.reference.updateData(["playerstatus": true], completion: { (error) in
                        guard error == nil else{
                            return
                        }
                    })
                    
                }
            }
            db.collection("Player1start").getDocuments { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    let document = querySnapshot.documents.first
                    document?.reference.updateData(["playerstatus": false], completion: { (error) in
                        guard error == nil else{
                            return
                        }
                        print("changeSuccess")
                    })
                    
                }
            }
        }else{
            let db = Firestore.firestore()
            db.collection("Player1start").getDocuments { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    let document = querySnapshot.documents.first
                    document?.reference.updateData(["playerstatus": true], completion: { (error) in
                        guard error == nil else{
                            return
                        }
                    })
                    
                }
            }
            db.collection("Player2start").getDocuments { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    let document = querySnapshot.documents.first
                    document?.reference.updateData(["playerstatus": false], completion: { (error) in
                        guard error == nil else{
                            return
                        }
                        print("changeSuccess")
                    })
                    
                }
            }
        }
        
        
        
    }
    
    var timer : Timer?
    func catchtrue() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Changed), userInfo: nil, repeats: true)
    }
    
    @objc func Changed() {
        
        if player == 1 {
            let db = Firestore.firestore()
            db.collection("Player1start").getDocuments { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.playstatus = querySnapshot.documents.first?.data()["playerstatus"] as! Bool
                    
                }
            }
        }else if player == 2 {
            let db = Firestore.firestore()
            db.collection("Player2start").getDocuments { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.playstatus = querySnapshot.documents.first?.data()["playerstatus"] as! Bool
                    
                }
            }
        }
        
        if  playstatus {
            gamestart()
            timer?.invalidate()
            timer = nil
            
        }
    }
    
    
    // MARK: - Table view data source
    
    @IBAction func clickexchange(_ sender: Any) {
        attack = true
        playstatus = false
        gamestart()
        exchange()
    }
    
    
    @IBAction func clickenemrole(_ sender: UIButton) {//敵人角色點擊
        if sender.image(for: .normal) != nil {
            let enemdamage = card(cardnumber: Int(sender.title(for: .normal)!)!).damage
            let alertcontroller = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            if roleatking != 0 {
                let target = UIAlertAction(title: "攻擊執行", style: .default) { (alertaction) in
                    for card in self.roleongames{
                        if card.cardNo == self.roleatking{
                            card.attack = false
                            break
                        }
                    }
                    let result = card(cardnumber: self.roleatking).damage! - enemdamage!
                    self.putattack(attackrole: self.roleatking,attackedrole:Int(sender.title(for: .normal)!)!,damage: result)
                    if result < 0 {
                        self.player1life = self.player1life + result
                        self.lbplayer1life.text = String(self.player1life)
                        self.roletext = "\(card(cardnumber: self.roleatking).Name ?? "")攻擊造成\n\(card(cardnumber: self.roleatking).Name ?? "")死亡"
                        self.lbplaystatus.text = self.roletext
                        self.button.setImage(nil, for: .normal)
                        self.button.setTitle("0", for: .normal)
                        for (index,myrole) in self.roleongames.enumerated() {
                            if myrole.cardNo == self.roleatking {
                                self.roleongames.remove(at: index)
                                break
                            }
                        }
                        UIView.animate(withDuration: 0.2, animations: {
                            sender.transform = CGAffineTransform(translationX: 50, y: -50)
                        }, completion: { (finished) in
                            if finished {
                                UIView.animate(withDuration: 0.2, animations: {
                                    sender.transform = CGAffineTransform.identity
                                })
                            }
                        })
                        UIView.animate(withDuration: 0.2, animations: {
                            self.button.transform = CGAffineTransform(translationX: 0, y: -50)
                        }, completion: { (finished) in
                            if finished {
                                UIView.animate(withDuration: 0.2, animations: {
                                    self.button.transform = CGAffineTransform.identity
                                })
                            }
                        })
                    }else if result == 0{
                        self.roletext = "\(card(cardnumber: self.roleatking).Name ?? "")攻擊造成雙方都死亡"
                        self.lbplaystatus.text = self.roletext
                        self.button.setImage(nil, for: .normal)
                        self.button.setTitle("0", for: .normal)
                        for (index,myrole) in self.roleongames.enumerated() {
                            if myrole.cardNo == self.roleatking {
                                self.roleongames.remove(at: index)
                                break
                            }
                        }
                        for (index,enemrolr) in self.enemyroles.enumerated(){
                            if enemrolr.cardNo == Int(sender.title(for: .normal)!){
                                self.enemyroles.remove(at: index)
                                break
                            }
                        }
                        UIView.animate(withDuration: 0.2, animations: {
                            sender.transform = CGAffineTransform(translationX: 50, y: -50)
                        }, completion: { (finished) in
                            if finished {
                                UIView.animate(withDuration: 0.2, animations: {
                                    sender.transform = CGAffineTransform.identity
                                })
                            }
                        })
                        sender.setImage(nil, for: .normal)
                        sender.setTitle("0", for: .normal)
                        UIView.animate(withDuration: 0.2, animations: {
                            self.button.transform = CGAffineTransform(translationX: 0, y: -50)
                        }, completion: { (finished) in
                            if finished {
                                UIView.animate(withDuration: 0.2, animations: {
                                    self.button.transform = CGAffineTransform.identity
                                })
                            }
                        })
                    }else {
                        self.player2life = self.player2life - result
                        self.lbplayer2life.text = String(self.player2life)
                        self.roletext = "\(card(cardnumber: self.roleatking).Name ?? "")攻擊造成\n\(card(cardnumber: Int(sender.title(for: .normal)!)!).Name ?? "")死亡"
                        self.lbplaystatus.text = self.roletext
                        for (index,enemrolr) in self.enemyroles.enumerated(){
                            if enemrolr.cardNo == Int(sender.title(for: .normal)!){
                                self.enemyroles.remove(at: index)
                                break
                            }
                        }
                        UIView.animate(withDuration: 0.2, animations: {
                            sender.transform = CGAffineTransform(translationX: 50, y: -50)
                        }, completion: { (finished) in
                            if finished {
                                UIView.animate(withDuration: 0.2, animations: {
                                    sender.transform = CGAffineTransform.identity
                                })
                            }
                        })
                        UIView.animate(withDuration: 0.2, animations: {
                            self.button.transform = CGAffineTransform(translationX: 0, y: -50)
                        }, completion: { (finished) in
                            if finished {
                                UIView.animate(withDuration: 0.2, animations: {
                                    self.button.transform = CGAffineTransform.identity
                                })
                            }
                        })
                        sender.setImage(nil, for: .normal)
                        sender.setTitle("0", for: .normal)
                    }
                    self.iswin()
                    self.roleatking = 0
                    
                }
                alertcontroller.addAction(target)
            }
            let data = UIAlertAction(title: "卡片資訊", style: .default) { (alertaction) in
                self.btdetal = sender
                self.performSegue(withIdentifier: "CarddetailVC", sender: self)
            }
            alertcontroller.addAction(data)
            present(alertcontroller, animated: true, completion: nil)
        }
    }
    
    func iswin(){ //    判斷輸贏
        if player1life <= 0{ //iwin
            let alertController = UIAlertController(title: "戰敗", message: "你輸了", preferredStyle: .alert)
            let ok = UIAlertAction(title: "確定", style: .default) { (alertaction) in
                self.clearroom()
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(ok)
            present(alertController, animated: true, completion: nil)
        }
        if player2life <= 0 {
            user.money += 1
            getmoney()
            let alertController = UIAlertController(title: "勝利", message: "你贏了", preferredStyle: .alert)
            let ok = UIAlertAction(title: "確定", style: .default) { (alertaction) in
                self.clearroom()
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(ok)
            present(alertController, animated: true, completion: nil)
        }
    }
    func getmoney() {
        let db = Firestore.firestore()
        db.collection("User").document("1").collection("\(user.id!)").getDocuments{(querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                if querySnapshot.documents.first?.data() != nil {
                    
                    querySnapshot.documents.first?.reference.updateData(["money":user.money!])
                    
                    
                }
            }
        }
    }
    
    func clearroom(){
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
    var button = UIButton()
    var btdetal = UIButton()
    @IBAction func clickrole(_ sender: UIButton) {    //招喚放置角色   以及各種指令
        
        if sender.image(for: .normal) == nil{
            if role == 1 && roleongames.count < 4 {
                sender.setImage(UIImage(named: "\(clickcard)"), for: .normal)
                sender.setTitle("\(clickcard)", for: .normal)
                role = 0
                
                roleongames.append(card(cardnumber: clickcard))
                roletext = "招換了一隻怪物\n\(card(cardnumber: clickcard).Name!)"
                putrole(clickcard: clickcard)
                for (index,card) in handcard.enumerated(){
                    if card == clickcard{
                        handcard.remove(at: index)
                        collectionview.reloadData()
                        break
                    }
                }
                clickcard = 0
                ivclick.image = nil
                
            }
        }else{
            if attack && sender.image(for: .normal) != nil{
                let role = sender.title(for: .normal)
                let alertcontroller = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                for roleongame in roleongames{
                    if String(roleongame.cardNo) == role && roleongame.attack{
                        var atk = UIAlertAction()
                        if enemyroles.count == 0 && attack{
                            
                            atk = UIAlertAction(title: "直接攻擊", style: .default) { (alertaction) in
                                roleongame.attack = false
                                self.roleatking = Int(role ?? "")!
                                self.player2life = self.player2life - roleongame.damage
                                self.iswin()
                                self.lbplayer2life.text = String(self.player2life)
                                self.roletext = "\(self.roleatking)發動直接攻擊\n造成\(roleongame.damage ?? 0)傷害"
                                self.lbplaystatus.text = self.roletext
                                self.putattack(attackrole: self.roleatking, attackedrole: 0, damage: roleongame.damage)
                                UIView.animate(withDuration: 0.2, animations: {
                                    sender.transform = CGAffineTransform(translationX: 0, y: -50)
                                }, completion: { (finished) in
                                    if finished {
                                        UIView.animate(withDuration: 0.2, animations: {
                                            sender.transform = CGAffineTransform.identity
                                        })
                                    }
                                })
                            }
                            
                        }else if roleongame.attack{
                            atk = UIAlertAction(title: "攻擊", style: .default) { (alertaction) in
                                self.roleatking = Int(role ?? "")!
                                self.button = sender
                                self.lbplaystatus.text = "\(self.roleatking)發動攻擊\n請指定攻擊對象"
                            }
                        }
                        let data = UIAlertAction(title: "卡片資訊", style: .default) { (alertaction) in
                            self.btdetal = sender
                            self.performSegue(withIdentifier: "CarddetailVC", sender: self)
                        }
                        alertcontroller.addAction(data)
                        alertcontroller.addAction(atk)
                        present(alertcontroller, animated: true, completion: nil)
                        break
                    }
                    
                }
            }else{
                self.lbplaystatus.text = "第一回合無法攻擊"
            }
        }
    }
    var a: ListenerRegistration?
    
    var b: ListenerRegistration?
    
    func getrole(player:Int) {
        
        let db = Firestore.firestore()
        a  = db.collection("Player\(player)start").addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot, querySnapshot.documentChanges.count > 0 {
        
                let documentChange = querySnapshot.documentChanges[0]
                if documentChange.type == .modified {
                    let context = documentChange.document.data()["playertext"] as? [Any]
                    if context![0] as? Int != 0 {
                        self.getenemyrole(imageint: context![0] as! Int)
                        self.lbplaystatus.text = (context![1] as! String)
                        querySnapshot.documents.first?.reference.updateData(["playertext" : [0,""]])
                    }
                    
                }
                
            }
        }
    }
    
    func getenemyrole(imageint :Int) { //獲得敵人角色招喚
        if bt2prole2.image(for: .normal) == nil {
            bt2prole2.setImage(UIImage(named: "\(imageint)"), for: .normal)
            bt2prole2.setTitle("\(imageint)", for: .normal)
        }else if bt2prole1.image(for: .normal) == nil {
            bt2prole1.setImage(UIImage(named: "\(imageint)"), for: .normal)
            bt2prole1.setTitle("\(imageint)", for: .normal)
        }else if bt2prole3.image(for: .normal) == nil{
            bt2prole3.setImage(UIImage(named: "\(imageint)"), for: .normal)
            bt2prole3.setTitle("\(imageint)", for: .normal)
        }
        enemyroles.append(card(cardnumber: imageint))
    }
    
    func putrole(clickcard: Int){
        var text = ""
        if player == 1 {
            text = "Player2start"
        }else{
            text = "Player1start"
        }
        
        let db = Firestore.firestore()
        db.collection(text).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                let document = querySnapshot.documents.first
                document?.reference.updateData(["playertext": [clickcard,self.roletext]], completion: { (error) in
                    guard error == nil else{
                        return
                    }
                })
            }
        }
    }
    
    func putattack(attackrole: Int,attackedrole:Int,damage:Int){  //  傳送戰鬥資訊
        var text = ""
        if player == 1 {
            text = "Player2start"
        }else{
            text = "Player1start"
        }
        
        let db = Firestore.firestore()
        db.collection(text).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                let document = querySnapshot.documents.first
                document?.reference.updateData(["attack": [attackrole,attackedrole,self.roletext,damage]], completion: { (error) in
                    guard error == nil else{
                        return
                    }
                })
            }
        }
    }
    
    func getattack(player:Int) {
        
        let db = Firestore.firestore()
        b  = db.collection("Player\(player)start").addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot, querySnapshot.documentChanges.count > 0 {
                
                //                    print("aaaaaa", querySnapshot.documentChanges.count)
                let documentChange = querySnapshot.documentChanges[0]
                if documentChange.type == .modified {
                    let context = documentChange.document.data()["attack"] as? [Any]
                    if context![0] as? Int != 0 {
                        let result = context![3] as? Int
                        if result! < 0 {
                            for (index,enemy) in self.enemyroles.enumerated(){
                                if enemy.cardNo == context![0] as? Int{
                                    self.enemyroles.remove(at: index)
                                    break
                                }
                            }
                            self.findmyanimatebutton (cardNo: (context![1] as? Int)!)
                            self.findenemyanimatebutton (cardNo: (context![0] as? Int)!)
                            self.findenemybutton(cardNo: (context![0] as? Int)!)
                            self.player2life = self.player2life + result!
                            self.lbplayer2life.text = String(self.player2life)
                        }else if result! == 0{
                            for (index,enemy) in self.enemyroles.enumerated(){
                                if enemy.cardNo == context![0] as? Int{
                                    self.enemyroles.remove(at: index)
                                    break
                                }
                            }
                            for (index,myrole) in self.roleongames.enumerated(){
                                if myrole.cardNo == context![1] as? Int{
                                    self.roleongames.remove(at: index)
                                    break
                                }
                            }
                            self.findmyanimatebutton (cardNo: (context![1] as? Int)!)
                            self.findenemyanimatebutton (cardNo: (context![0] as? Int)!)
                            self.findenemybutton(cardNo: (context![0] as? Int)!)
                            self.findmybutton(cardNo: (context![1] as? Int)!)
                        }else{
                            for (index,myrole) in self.roleongames.enumerated(){
                                if myrole.cardNo == context![1] as? Int{
                                    self.roleongames.remove(at: index)
                                    break
                                }
                            }
                            self.findmyanimatebutton (cardNo: (context![1] as? Int)!)
                            self.findenemyanimatebutton (cardNo: (context![0] as? Int)!)
                            self.findmybutton(cardNo: (context![1] as? Int)!)
                            self.player1life = self.player1life - result!
                            self.lbplayer1life.text = String(self.player1life)
                        }
                        self.iswin()
                        self.lbplaystatus.text = (context![2] as! String)
                        
                        querySnapshot.documents.first?.reference.updateData(["attack" : [0,0,"",0]])
                    }
                    
                }
                
            }
        }
    }
    func findmyanimatebutton (cardNo: Int) {
        if bt1prole2.title(for: .normal) == String(cardNo){
            UIView.animate(withDuration: 0.2, animations: {
                self.bt1prole2.transform = CGAffineTransform(translationX: -50, y: 50)
            }, completion: { (finished) in
                if finished {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.bt1prole2.transform = CGAffineTransform.identity
                    })
                }
            })
        }else if bt1prole1.title(for: .normal) == String(cardNo){
            UIView.animate(withDuration: 0.2, animations: {
                self.bt1prole1.transform = CGAffineTransform(translationX: -50, y: 50)
            }, completion: { (finished) in
                if finished {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.bt1prole1.transform = CGAffineTransform.identity
                    })
                }
            })
        }else{
            UIView.animate(withDuration: 0.2, animations: {
                self.bt1prole3.transform = CGAffineTransform(translationX: -50, y: 50)
            }, completion: { (finished) in
                if finished {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.bt1prole3.transform = CGAffineTransform.identity
                    })
                }
            })
        }
    }
    
    func findenemyanimatebutton (cardNo: Int) {
        if bt2prole2.title(for: .normal) == String(cardNo){
            UIView.animate(withDuration: 0.2, animations: {
                self.bt2prole2.transform = CGAffineTransform(translationX: 0, y: 50)
            }, completion: { (finished) in
                if finished {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.bt2prole2.transform = CGAffineTransform.identity
                    })
                }
            })
        }else if bt2prole1.title(for: .normal) == String(cardNo){
            UIView.animate(withDuration: 0.2, animations: {
                self.bt2prole1.transform = CGAffineTransform(translationX: 0, y: 50)
            }, completion: { (finished) in
                if finished {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.bt2prole1.transform = CGAffineTransform.identity
                    })
                }
            })
        }else{
            UIView.animate(withDuration: 0.2, animations: {
                self.bt2prole3.transform = CGAffineTransform(translationX: 0, y: 50)
            }, completion: { (finished) in
                if finished {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.bt2prole3.transform = CGAffineTransform.identity
                    })
                }
            })
        }
    }
    
    func findmybutton(cardNo: Int) {
        if bt1prole2.title(for: .normal) == String(cardNo){
            bt1prole2.setTitle("0", for: .normal)
            bt1prole2.setImage(nil, for: .normal)
            
            
        }else if bt1prole1.title(for: .normal) == String(cardNo){
            bt1prole1.setTitle("0", for: .normal)
            bt1prole1.setImage(nil, for: .normal)
            
            
        }else{
            bt1prole3.setTitle("0", for: .normal)
            bt1prole3.setImage(nil, for: .normal)
            
        }
    }
    func findenemybutton(cardNo: Int) {
        if bt2prole2.title(for: .normal) == String(cardNo){
            bt2prole2.setTitle("0", for: .normal)
            bt2prole2.setImage(nil, for: .normal)
            
        }else if bt2prole1.title(for: .normal) == String(cardNo){
            bt2prole1.setTitle("0", for: .normal)
            bt2prole1.setImage(nil, for: .normal)
            
        }else{
            bt2prole3.setTitle("0", for: .normal)
            bt2prole3.setImage(nil, for: .normal)
            
        }
    }
    func getsurrender(){
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(surrender(timer:)), userInfo: "info", repeats: true)
    }
    @objc func surrender(timer: Timer) {
        let db = Firestore.firestore()
        db.collection("surrender").getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                if querySnapshot.documents.first?.data()["surrender"] as! Bool {
                    let alertController = UIAlertController(title: "對方投降", message: "你贏了", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "確定", style: .default) { (alertaction) in
                        self.clearroom()
                        self.dismiss(animated: true, completion: nil)
                    }
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    func putsurrender(){ //投降
        let db = Firestore.firestore()
        db.collection("surrender").getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                let document = querySnapshot.documents.first
                document?.reference.updateData(["surrender": true], completion: { (error) in
                    guard error == nil else{
                        return
                    }
                })
            }
        }
    }
    @IBAction func clickGogame(_ sender: Any) {  //投降
        player1life = player1life - 9999
        putsurrender()
        iswin()
    }
    @IBAction func clickAdd(_ sender: Any) {
        collectionview.isHidden = false
        btstart.isHidden = false
        playerstart()
        btready.isEnabled = false
        
    }
    func exchangeatk(){
        for card in roleongames{
            card.attack = true
        }
    }
    
    func gamestart() {
        if playstatus == true {
            bt1prole2.isEnabled = true
            bt1prole1.isEnabled = true
            bt1prole3.isEnabled = true
            bt2prole1.isEnabled = true
            bt2prole2.isEnabled = true
            bt2prole3.isEnabled = true
            lbplaystatus.text = "回合開始"
            btstart.isEnabled = true
            role = 1
            exchangeatk()
            btstart.setTitle("start", for: .normal)
            print(mycards)
            getcard()
            self.collectionview.reloadData()
            a?.remove()
            b?.remove()
        }else{
            bt1prole2.isEnabled = false
            bt1prole1.isEnabled = false
            bt1prole3.isEnabled = false
            bt2prole1.isEnabled = false
            bt2prole2.isEnabled = false
            bt2prole3.isEnabled = false
            btstart.isEnabled = false
            lbplaystatus.text = "回合結束\n等待對手"
            
            btstart.setTitle("wait", for: .normal)
            getrole(player:player)
            getattack(player:player)
            catchtrue()
            print(mycards)
            
        }
    }
    
    func playerstart() {
        if player == 1 {
            attack = false
            playstatus = true
            gamestart()
        }else if player == 2 {
            
            playstatus = false
            gamestart()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CarddetailVC"{
            
            
            let carddetailVC = segue.destination as! CarddetailVC
            carddetailVC.carddetail = Int(btdetal.title(for: .normal)!)
        }
    }
}
