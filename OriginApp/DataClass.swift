//
//  DataClass.swift
//  OriginApp
//
//  Created by naito.hiromu on 2023/06/28.
//

import Foundation

class DataClass : NSObject {
    
    static let instance = DataClass()
    //var puuid:[String] = ["","","","","","","","","",""]
    //var championName:[String] = ["","","","","","","","","",""]
    var championName = [[String]]()
    var summonerNames = [[String]]()
    var matchTimes:[Int] = []
    var WinOrLose = [[Bool]]()
    var WinOrLose2:[Bool] = []
    var summonerNames2:[String] = ["","","","","","","","","",""]
    var championName2:[String] = ["","","","","","","","","",""]
    var sort:[Int] = []
    var summonerName = ""
    var puuid = ""
    var SNpositionholder:[Int] = []
    var matchId:[String] = [""]
    var RiotAPI = ""
    var test:[String:Any] = [:]
}
