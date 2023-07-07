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
    //var championName = [[String]](repeating: [String](repeating: ".", count: 10), count: 5)
    var summonerNames = [[String]]()
    //var summonerNames = [[String]](repeating: [String](repeating: ".", count: 10), count: 5)
    //var SNpositionholder = [Int](repeating: 0, count:5)
    var SNpositionholder:[Int] = []
    //var WinOrLose2 = [Bool](repeating:true,count:5)
    var WinOrLose2:[Bool] = []
    var matchTimes:[Int] = []
    var WinOrLose = [[Bool]]()
    var summonerNames2:[String] = ["","","","","","","","","",""]
    var championName2:[String] = ["","","","","","","","","",""]
    var sort:[Int] = []
    var summonerName = ""
    var puuid = ""
    var matchId:[String] = [""]
    var RiotAPI = "RGAPI-2b026deb-443c-4fcd-bbab-364d3cf1eb18"
    var test:[String:Any] = [:]
}
