//
//  ViewController.swift
//  OriginApp
//
//  Created by naito.hiromu on 2023/06/23.
//

import UIKit

class ViewController: UIViewController {
    
    let RiotAPI = "RGAPI-e31c8d55-ee6a-4a91-95ea-1caab6e3a0a0"
    
    @IBOutlet weak var SummonerNameTextField: UITextField!
    @IBAction func searchButton(_ sender: Any) {
        performSegue(withIdentifier: "moveChampionImage", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        struct SummonerNameId{
            var accountId:String;
            var name:String;
            var profileIconId:Int;
            var puuid:String;
            var revisionDate:Int;
            var summonerLevel:Int
        }
        //var test = ""
        var SummonerNameResult:[String:Any] = ["":""]
        var matchId:[String] = [""]
        getpuuidFromAPI(SummonerName: "多摩川のOner") { returnData in
            SummonerNameResult = returnData as! [String : Any] //<-実際のコードでは`String`型の変数に`data`なんて命名は避けましょう
            //print("\(SummonerNameResult["puuid"] as! String)")
            
            self.getmatchIdFromAPI(puuid: SummonerNameResult["puuid"] as! String) { returnData in
                matchId = returnData as! [String]
                //print(matchId[0])
                self.getmatchResultFromAPI(matchId: matchId[0]){
                    returnData in
                    print(returnData)
                }
                
            }
             
        }
        //print("data:\(SummonerNameResult)")
        
        //print(test)
        /*
        // アプリがロードされた時に実行させたい処理を書きます
        var SummonerId = urlEncode(beforeText: "多摩川のOner")
        let RiotAPI = "RGAPI-e31c8d55-ee6a-4a91-95ea-1caab6e3a0a0"
        
        var SummonerNameResult:[String:Any] = ["":""]
        let SummonerNameUrl: URL = URL(string: "https://jp1.api.riotgames.com/lol/summoner/v4/summoners/by-name/"+SummonerId+"?api_key="+RiotAPI)!
        let SummonerNametask: URLSessionTask = URLSession.shared.dataTask(with: SummonerNameUrl, completionHandler: {(data, response, error) in
            // コンソールに出力
            do{
                //let SummonerNameResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                //    as! NSDictionary
                SummonerNameResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                as! [String:Any]
                print(type(of:SummonerNameResult))
                //SummonerNameId = SummonerNameResult
                print(SummonerNameResult)// Jsonの中身を表示
                //print(SummonerNameId(SummonerNameResult))
            }catch {
                print(error)
            }
            //print("data: \(String(describing: data))")
            //print("response: \(String(describing: response))")
            //print("error: \(String(describing: error))")
        })
        SummonerNametask.resume()
        print(SummonerNameResult)
         */
        /*
        let url: URL = URL(string: "https://asia.api.riotgames.com/lol/match/v5/matches/by-puuid/"+SummonerNameResult["puuid"]+"/ids?queue=430&type=normal&start=0&count=100&api_key="+RiotAPI)!
        let task: URLSessionTask = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            // コンソールに出力
            do{
                let matchId = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! Array<String>
                print(matchId[0]) // Jsonの中身を表示
                //print(type(of: couponData))
            }catch {
                print(error)
            }
            //print("data: \(String(describing: data))")
            //print("response: \(String(describing: response))")
            //print("error: \(String(describing: error))")
        })
        task.resume()
        */
    }
    
    func getpuuidFromAPI(SummonerName: String,completion: @escaping (_ String:Any)->Void){
        let semaphore = DispatchSemaphore(value: 0)
        var SummonerId = urlEncode(beforeText: SummonerName)
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
            //print("data: \(String(describing: data))")
            //print("response: \(String(describing: response))")
            //print("error: \(String(describing: error))")
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
                print(matchResult) // Jsonの中身を表示
                completion((matchResult as AnyObject).data(using: .utf8))
                semaphore.signal()
                //print(type(of: couponData))
            }catch {
                print(error)
                completion("")
                semaphore.signal()
            }
            //print("data: \(String(describing: data))")
            //print("response: \(String(describing: response))")
            //print("error: \(String(describing: error))")
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
