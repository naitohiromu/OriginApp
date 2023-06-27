//
//  ViewController.swift
//  OriginApp
//
//  Created by naito.hiromu on 2023/06/23.
//

import UIKit

class ViewController: UIViewController {
    
    let RiotAPI = "RGAPI-0e5284f9-1316-4c40-b620-48d2604f81f3"
    
    @IBOutlet weak var SummonerNameTextField: UITextField!
    @IBAction func searchButton(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultList") as! ResultListViewController
        var SummonerNameResult:[String:Any] = ["":""]
        var SummonerId:Int = 0
        var matchId:[String] = [""]
        var matchResult:[String:Any] = ["":""]
        if SummonerNameTextField.text != nil{
            getpuuidFromAPI(SummonerName: SummonerNameTextField.text!) { returnData in
                SummonerNameResult = returnData as! [String : Any] //<-実際のコードでは`String`型の変数に`data`なんて命名は避けましょう
                //print("\(SummonerNameResult["puuid"] as! String)")
                
                self.getmatchIdFromAPI(puuid: SummonerNameResult["puuid"] as! String) { returnData in
                    matchId = returnData as! [String]
                    self.getmatchResultFromAPI(matchId: matchId[0]){
                        returnData in
                        matchResult = returnData as! [String:Any]
                        nextVC.imagename = "ttest"
                        let metadata = matchResult["metadata"] as! [String:Any]
                        let participants = metadata["participants"] as! [String]
                        let uidIndex:Int = participants.firstIndex(of: SummonerNameResult["puuid"] as! String)!
                        print(uidIndex)
                        
                        let info = matchResult["info"] as! [String:Any]
                        let i_participants = info["participants"]
                        print(matchResult)
                        /*
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "moveChampionImage", sender: self)
                        }
                         */
                    }
                }
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func getpuuidFromAPI(SummonerName: String,completion: @escaping (_ String:Any)->Void){
        let semaphore = DispatchSemaphore(value: 0)
        let SummonerId = urlEncode(beforeText: SummonerName)
        //let RiotAPI = "RGAPI-e31c8d55-ee6a-4a91-95ea-1caab6e3a0a0"
        
        let SummonerNameUrl: URL = URL(string: "https://jp1.api.riotgames.com/lol/summoner/v4/summoners/by-name/"+SummonerId+"?api_key="+RiotAPI)!
        let SummonerNametask: URLSessionTask = URLSession.shared.dataTask(with: SummonerNameUrl, completionHandler: {(data, response, error) in
            // コンソールに出力
            do{
                let SummonerNameResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                as! [String:Any]
                print(type(of:SummonerNameResult))
                print(SummonerNameResult)// Jsonの中身を表示
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
        let url: URL = URL(string: "https://asia.api.riotgames.com/lol/match/v5/matches/by-puuid/"+puuid+"/ids?queue=430&type=normal&start=0&count=100&api_key="+RiotAPI)!
        let task: URLSessionTask = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            // コンソールに出力
            do{
                let matchId = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! Array<String>
                print(matchId[0]) // Jsonの中身を表示
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
        let url: URL = URL(string: "https://asia.api.riotgames.com/lol/match/v5/matches/"+matchId+"?api_key="+RiotAPI)!
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
