//
//  ViewController.swift
//  OriginApp
//
//  Created by naito.hiromu on 2023/06/23.
//

import UIKit

class ViewController: UIViewController {
    

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

        // アプリがロードされた時に実行させたい処理を書きます
        var SummonerId = urlEncode(beforeText: "多摩川のOner")
        let RiotAPI = "RGAPI-e31c8d55-ee6a-4a91-95ea-1caab6e3a0a0"
        
        let SummonerNameUrl: URL = URL(string: "https://jp1.api.riotgames.com/lol/summoner/v4/summoners/by-name/"+SummonerId+"?api_key="+RiotAPI)!
        let SummonerNametask: URLSessionTask = URLSession.shared.dataTask(with: SummonerNameUrl, completionHandler: {(data, response, error) in
            // コンソールに出力
            do{
                //let SummonerNameResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                //    as! NSDictionary
                let SummonerNameResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
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
    func getpuuidFromAPI(completion: @escaping (String)->Void){
        var SummonerId = urlEncode(beforeText: "多摩川のOner")
        let RiotAPI = "RGAPI-e31c8d55-ee6a-4a91-95ea-1caab6e3a0a0"
        
        let SummonerNameUrl: URL = URL(string: "https://jp1.api.riotgames.com/lol/summoner/v4/summoners/by-name/"+SummonerId+"?api_key="+RiotAPI)!
        let SummonerNametask: URLSessionTask = URLSession.shared.dataTask(with: SummonerNameUrl, completionHandler: {(data, response, error) in
            // コンソールに出力
            do{
                let SummonerNameResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                as! [String:Any]
                print(type(of:SummonerNameResult))
                //SummonerNameId = SummonerNameResult
                print(SummonerNameResult)// Jsonの中身を表示
                //print(SummonerNameId(SummonerNameResult))
            }catch {
                print(error)
            }
        })
        SummonerNametask.resume()
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
