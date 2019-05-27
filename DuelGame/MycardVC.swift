//
//  MycardVC.swift
//  DuelGame
//
//  Created by 黃德桑 on 2019/5/23.
//  Copyright © 2019 sun. All rights reserved.
//

import UIKit

class MycardVC: UIViewController ,UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.playcards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayGameCell", for: indexPath) as! PlayGameCell
        let card = user.playcards[indexPath.row]
        cell.ivImage.image = UIImage(named: "\(card)")
        
        return cell
    }
    

    @IBOutlet weak var collectionview: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
                self.collectionview.reloadData()
        
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
