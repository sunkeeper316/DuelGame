//
//  ViewController.swift
//  DuelGame
//
//  Created by 黃德桑 on 2019/5/19.
//  Copyright © 2019 sun. All rights reserved.
//

import UIKit
import Firebase

class ShopcardVC: UIViewController {
    
    @IBOutlet weak var lbShow: UILabel!
    @IBOutlet weak var ivimage: UIImageView!
    var timer : Timer?
    var images = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 1...10 {
            let random = (Int)(arc4random()%200)+1
            images.append(UIImage(named:"\(card(random: random))")!)
            var count = 0
            for usercard in user.cards{
                if usercard == card(random: random){
                    count += 1
                }
            }
            user.cards.append(card(random: random))
            if count > 2 {
                user.cards.removeLast()
            }
        }
        user.cards.sort()
        updatecard()
        owncard()
        
        ivimage.animationImages = images
        let duration = Double(images.count)
        /* 設定動畫的總播放時間 */
        ivimage.animationDuration = duration
        /* 設定播放次數。預設為0代表無限重複播放 */
        ivimage.animationRepeatCount = 1
        ivimage.startAnimating()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Changed), userInfo: nil, repeats: true)
        print(user.money as Any)
        // Do any additional setup after loading the view.
    }
    
    
    var count = 9
    @objc func Changed() {
        
        lbShow.text = "第\(count)張"
        count -= 1
        if count == -1 {
            lbShow.text = ""
            timer?.invalidate()
            timer = nil
        }
        
        
    }
    func updatecard(){
        let db = Firestore.firestore()
        db.collection("User").document("1").collection("\(user.id!)").getDocuments{(querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                if querySnapshot.documents.first?.data() != nil {
                    
                    querySnapshot.documents.first?.reference.updateData(["card":user.cards])
                    
                    
                }
            }
        }
    }
    
    func card(random:Int) ->Int{
        switch random {
        case 200:
            return 20
        case 199:
            return 19
        case 197...198:
            return 18
        case 190...196:
            return 17
        case 185...189:
            return 16
        case 180...184:
            return 15
        case 177...179:
            return 14
        case 171...176:
            return 13
        case 161...170:
            return 12
        case 151...160:
            return 11
        case 141...150:
            return 10
        case 131...140:
            return 9
        case 121...130:
            return 8
        case 111...120:
            return 7
        case 101...110:
            return 6
        case 81...100:
            return 5
        case 61...80:
            return 4
        case 41...60:
            return 3
        case 21...40:
            return 2
        case 1...20:
            return 1
        default:
            return 0
        }
    }
    
    
}

