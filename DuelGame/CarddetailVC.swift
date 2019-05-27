//
//  CarddetailVC.swift
//  DuelGame
//
//  Created by 黃德桑 on 2019/5/22.
//  Copyright © 2019 sun. All rights reserved.
//

import UIKit

class CarddetailVC: UIViewController {
    var carddetail : Int!
    @IBOutlet weak var ivImage: UIImageView!
    
    @IBOutlet weak var lbcardName: UILabel!
    @IBOutlet weak var lbcardNo: UILabel!
    @IBOutlet weak var lbcardskill: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ivImage.image = UIImage(named: "\(carddetail ?? 0)")
        lbcardNo.text = card(cardnumber: carddetail).Name
        lbcardskill.text = card(cardnumber: carddetail).skill
        lbcardName.text = "攻擊力："+String(card(cardnumber: carddetail).damage)

        // Do any additional setup after loading the view.
    }
    

    @IBAction func clickback(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
