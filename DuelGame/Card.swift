//
//  Card.swift
//  DuelGame
//
//  Created by 黃德桑 on 2019/5/22.
//  Copyright © 2019 sun. All rights reserved.
//

import Foundation
class Card {
    var cardNo : Int!
    var Name : String!
    var damage : Int!
    var defence : Int!
    var skill : String!
    var attack = true
    init(cardNo :Int ,Name :String ,damage :Int,defence : Int,skill : String) {
        self.cardNo = cardNo
        self.damage = damage
        self.defence = defence
        self.Name = Name
        self.skill = skill
        self.attack = true
        
    }
    
}

var card1 = Card(cardNo: 1, Name: "邪惡小小兵", damage: 200, defence: 200, skill: "")
var card2 = Card(cardNo: 2, Name: "小小兵", damage: 200, defence: 200, skill: "被破壞後所有陷阱被破壞")
var card3 = Card(cardNo: 3, Name: "小白貓", damage: 200, defence: 400, skill: "")
var card4 = Card(cardNo: 4, Name: "亞馬遜賢者", damage: 900, defence: 200, skill: "")
var card5 = Card(cardNo: 5, Name: "可達鴨", damage: 500, defence: 200, skill: "")
var card6 = Card(cardNo: 6, Name: "亞馬遜女劍士", damage: 1200, defence: 200, skill: "反彈傷害")
var card7 = Card(cardNo: 7, Name: "神力女超人", damage: 2800, defence: 3200, skill: "")
var card8 = Card(cardNo: 8, Name: "美國隊長", damage: 2000, defence: 200, skill: "")
var card9 = Card(cardNo: 9, Name: "小魯夫", damage: 2000, defence: 200, skill: "可以直接攻擊")
var card10 = Card(cardNo: 10, Name: "黑魔導", damage: 2500, defence: 200, skill: "")
var card11 = Card(cardNo: 11, Name: "黑魔導女孩", damage: 1800, defence: 200, skill: "場上攻擊角色加1000")
var card12 = Card(cardNo: 12, Name: "龍貓", damage: 400, defence: 200, skill: "")
var card13 = Card(cardNo: 13, Name: "小火龍", damage: 1200, defence: 200, skill: "")
var card14 = Card(cardNo: 14, Name: "妙蛙種子", damage: 1200, defence: 200, skill: "")
var card15 = Card(cardNo: 15, Name: "傑尼龜", damage: 1200, defence: 200, skill: "")
var card16 = Card(cardNo: 16, Name: "鋼鐵人", damage: 2400, defence: 3000, skill: "破壞所有陷阱")
var card17 = Card(cardNo: 17, Name: "卡比獸", damage: 2000, defence: 2000, skill: "效果無效")
var card18 = Card(cardNo: 18, Name: "青眼白龍", damage: 3000, defence: 1200, skill: "破壞場上所有怪獸")
var card19 = Card(cardNo: 19, Name: "武藤遊戲", damage: 5000, defence: 5000, skill: "直接勝利")
var card20 = Card(cardNo: 20, Name: "皮卡丘", damage: 3500, defence: 500, skill: "陷阱無效")
var cards = [card1,card2,card3,card4,card5,card6,card7,card8,card9,card10,card11,card12,card13,card14,card15,card16,card17,card18,card19,card20]
func card(cardnumber: Int)-> Card{
    return cards[cardnumber - 1]
}
func owncard() {
    var cards = [Int]()
    user.owncards.removeAll()
    for usercard in user.cards{
        for card in cards{
            if card == usercard{
                cards.removeLast()
            }
        }
        cards.append(usercard)
    }
    for card in cards{
        var count = 0
        for usercard in user.cards{
            if card == usercard{
                count += 1
            }
        }
        user.owncards.append(Owncard(carno: card, count: count))
    }
}
func addplaycard(){
    for playcard in user.playcards{
        for owncard in user.owncards{
            if owncard.carno == playcard{
                
                owncard.count -= 1
                break
            }
        }
    }
}

