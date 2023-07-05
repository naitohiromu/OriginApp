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
    var championName2:[String] = ["","","","","","","","","",""]
    var summonerName = ""
    var puuid = ""
    var matchId:[String] = [""]
    var RiotAPI = ""
}
