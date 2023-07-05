//
//  ViewController.swift
//  OriginApp
//
//  Created by naito.hiromu on 2023/06/23.
//

import UIKit

class ViewController: UIViewController{
    
    //let RiotAPI = "RGAPI-9ecfba04-7d95-4e01-9428-54520f109f6b"
    var test = ""
    let dataclass = DataClass.instance
    //let dataclass = DataClass()
    
    @IBOutlet weak var SummonerNameTextField: UITextField!
    @IBAction func searchButton(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MatchList") as! MatchListController
        var SummonerNameResult:[String:Any] = ["":""]
        var SummonerId:Int = 0
        self.dataclass.matchId = [""]
        var matchResult:[String:Any] = ["":""]
        if SummonerNameTextField.text != nil{
            self.dataclass.summonerName = SummonerNameTextField.text!
            self.dataclass.championName = [[String]]()
            self.dataclass.championName2 = ["","","","","","","","","",""]
            getpuuidFromAPI(SummonerName: self.dataclass.summonerName) { returnData in
                SummonerNameResult = returnData as! [String : Any] //<-実際のコードでは`String`型の変数に`data`なんて命名は避けましょう
                //print("\(SummonerNameResult["puuid"] as! String)")
                self.dataclass.puuid = SummonerNameResult["puuid"] as! String
                
                self.getmatchIdFromAPI(puuid: self.dataclass.puuid) { returnData in
                    self.dataclass.matchId = returnData as! [String]
                    
                    for j in 0..<5{
                    self.getmatchResultFromAPI(matchId: self.dataclass.matchId[j]){
                        returnData in
                        matchResult = returnData as! [String:Any]
                        
                        var metadata = matchResult["metadata"] as! [String:Any]
                        var participants = metadata["participants"] as! [String]
                        var uidIndex:Int = participants.firstIndex(of: SummonerNameResult["puuid"] as! String)!
                        
                        var info = matchResult["info"] as! [String:Any]
                        var i_participants = info["participants"] as! [[String:Any]]
                        var u_championName = i_participants[uidIndex]["championName"] as! String
                        for i in 0..<10{
                            self.dataclass.championName2[i].append(i_participants[i]["championName"] as! String)
                        }
                        self.dataclass.championName.append(self.dataclass.championName2)
                        //print("chanpionname:\(self.dataclass.championName)")
                        self.dataclass.championName2 = ["","","","","","","","","",""]
                        //DispatchQueue.main.async {
                        //    self.present(nextVC, animated: true, completion: nil)
                        //}
                        /*
                         for i in 0..<10{
                         self.dataclass.championName[i] = i_participants[i]["championName"] as! String
                         }
                         */
                        
                    }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
                        self.present(nextVC, animated: true, completion: nil)
                    }
                    //print(self.dataclass.championName)
                    //DispatchQueue.main.async {
                    //    self.present(nextVC, animated: true, completion: nil)
                    //}
                     
                    /*
                    self.getmatchResultFromAPI(matchId: matchId[0]){
                        returnData in
                        matchResult = returnData as! [String:Any]
                        
                        var metadata = matchResult["metadata"] as! [String:Any]
                        var participants = metadata["participants"] as! [String]
                        var uidIndex:Int = participants.firstIndex(of: SummonerNameResult["puuid"] as! String)!
                        
                        var info = matchResult["info"] as! [String:Any]
                        var i_participants = info["participants"] as! [[String:Any]]
                        var u_championName = i_participants[uidIndex]["championName"] as! String
                        for i in 0..<10{
                            self.dataclass.championName2[i].append(i_participants[i]["championName"] as! String)
                        }
                        self.dataclass.championName.append(self.dataclass.championName2)
                        print("chanpionname:\(self.dataclass.championName)")
                        self.dataclass.championName2 = ["","","","","","","","","",""]
                        DispatchQueue.main.async {
                            self.present(nextVC, animated: true, completion: nil)
                        }
                    }
                     */
                }
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func showImage(imageView: UIImageView, url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            let image = UIImage(data: data)
            imageView.image = image
        } catch let err {
            print("Error: \(err.localizedDescription)")
        }
    }
    
    func getpuuidFromAPI(SummonerName: String,completion: @escaping (_ String:Any)->Void){
        let semaphore = DispatchSemaphore(value: 0)
        let SummonerId = urlEncode(beforeText: SummonerName)
        //let RiotAPI = "RGAPI-e31c8d55-ee6a-4a91-95ea-1caab6e3a0a0"
        
        let SummonerNameUrl: URL = URL(string: "https://jp1.api.riotgames.com/lol/summoner/v4/summoners/by-name/"+SummonerId+"?api_key="+self.dataclass.RiotAPI)!
        let SummonerNametask: URLSessionTask = URLSession.shared.dataTask(with: SummonerNameUrl, completionHandler: {(data, response, error) in
            // コンソールに出力
            do{
                let SummonerNameResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                as! [String:Any]
                //print(type(of:SummonerNameResult))
                //print(SummonerNameResult)// Jsonの中身を表示
                completion(SummonerNameResult)
                semaphore.signal()
            }catch {
                print(error)
                completion("")
                semaphore.signal()
            }
        })
        SummonerNametask.resume()
    }
    
    func getmatchIdFromAPI(puuid: String,completion: @escaping (_ String:Any)->Void){
        let semaphore = DispatchSemaphore(value: 0)
        //let RiotAPI = "RGAPI-e31c8d55-ee6a-4a91-95ea-1caab6e3a0a0"
        let url: URL = URL(string: "https://asia.api.riotgames.com/lol/match/v5/matches/by-puuid/"+puuid+"/ids?queue=430&type=normal&start=0&count=100&api_key="+self.dataclass.RiotAPI)!
        let task: URLSessionTask = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            // コンソールに出力
            do{
                let matchId = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! Array<String>
                //print(matchId[0]) // Jsonの中身を表示
                completion(matchId)
                semaphore.signal()
                //print(type(of: couponData))
            }catch {
                print(error)
                completion("")
                semaphore.signal()
            }
        })
        task.resume()
    }
    
    func getmatchResultFromAPI(matchId: String,completion: @escaping (_ String:Any)->Void){
        let semaphore = DispatchSemaphore(value: 0)
        //let RiotAPI = "RGAPI-e31c8d55-ee6a-4a91-95ea-1caab6e3a0a0"
        let url: URL = URL(string: "https://asia.api.riotgames.com/lol/match/v5/matches/"+matchId+"?api_key="+self.dataclass.RiotAPI)!
        let task: URLSessionTask = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            // コンソールに出力
            do{
                let matchResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                //print(matchResult) // Jsonの中身を表示
                //completion((matchResult as AnyObject).data(using: .utf8))
                completion(matchResult)
                semaphore.signal()
                //print(type(of: couponData))
            }catch {
                print(error)
                completion("")
                semaphore.signal()
            }
        })
        task.resume()
        
    }
    func urlEncode(beforeText: String) -> String {
        // RFC3986 に準拠
        // 変換対象外とする文字列（英数字と-._~）
        let allowedCharacters = NSCharacterSet.alphanumerics.union(.init(charactersIn: "-._~"))
            
        if let encodedText = beforeText.addingPercentEncoding(withAllowedCharacters: allowedCharacters) {
            return encodedText
        }
        //alert(title: "エラー", message: "変換に失敗しました")
        return ""
    }
}
