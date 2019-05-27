//
//  User.swift
//  DuelGame
//
//  Created by 黃德桑 on 2019/5/22.
//  Copyright © 2019 sun. All rights reserved.
//

import Foundation
class User {
    var id : String!
    var password : String!
    var cards = [Int]()
    var owncards = [Owncard]()
    var playcards = [Int]()
    var money : Int!
    init(id : String,password : String,cards : [Int],playcards : [Int],money : Int!) {
        self.id = id
        self.password = password
        self.cards = cards
        self.playcards = playcards
        self.money = money
    }
    convenience init(){
        self.init(id : "0" , password:"0",cards:[],playcards:[],money:10)
    }
}
