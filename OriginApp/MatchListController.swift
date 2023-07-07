//
//  MatchListController.swift
//  OriginApp
//
//  Created by naito.hiromu on 2023/06/29.
//

import UIKit

class MatchListController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    let dataclass = DataClass.instance
    
    //コレクションセルの数を指定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Section毎にCellの総数を変える.
        return 10
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 100
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader
        
        //print(indexPath.section)
        headerView?.sectionHeader.text = "\(self.dataclass.matchTimes[indexPath.section] / 60)分\(self.dataclass.matchTimes[indexPath.section] % 60)秒"
        //print(self.dataclass.championName)
        self.showImage(imageView: headerView!.sectionImage, imageUrl: "http://ddragon.leagueoflegends.com/cdn/13.11.1/img/champion/"+self.dataclass.championName[indexPath.section][self.dataclass.SNpositionholder[indexPath.section]]+".png")
        
        if(self.dataclass.WinOrLose2[indexPath.section]){
            headerView?.backgroundColor = UIColor.systemBlue
            headerView!.sectionWL.text = "Win"
        }else{
            headerView?.backgroundColor = UIColor.systemPink
            headerView!.sectionWL.text = "Lose"
        }
        return headerView!
    }
    
    //セルのサイズを指定する処理
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        // 横方向のスペース調整
        let horizontalSpace:CGFloat = 5

        //セルのサイズを指定。画面上にセルを3つ表示させたいのであれば、デバイスの横幅を3分割した横幅　- セル間のスペース*2（セル間のスペースが二つあるため）
        //let cellSize:CGFloat = self.view.bounds.width/5 - horizontalSpace*2

        let cellSize_width:CGFloat = self.view.bounds.width/5 - horizontalSpace*2
        let cellSize_height:CGFloat = self.view.bounds.height/7
        
        //print(self.view.bounds.width)
        //print(cellSize)
        //print(CGSize(width: cellSize_width, height: cellSize_height))
        // 正方形で返すためにwidth,heightを同じにする
        return CGSize(width: cellSize_width, height: cellSize_height)
        //return CGSize(width: CGFloat(78), height: CGFloat(140))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //storyboard上のセルを生成　storyboardのIdentifierで付けたものをここで設定する
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath)
        //print()
        //print("Num: \(indexPath.row)")
        //print("SectionNum:\(indexPath.section)")
        //print(self.dataclass.championName.count)
        if(self.dataclass.championName.count - indexPath.section <= 4 && self.dataclass.championName.count <= 100 && indexPath.row == 1){
            var SummonerNameResult:[String:Any] = ["":""]
            var SummonerId:Int = 0
            //var matchId:[String] = [""]
            var matchResult:[String:Any] = ["":""]
            //self.dataclass.championName = [[String]]()
            self.dataclass.championName2 = ["","","","","","","","","",""]

            self.getmatchResultFromAPI(matchId: self.dataclass.matchId[self.dataclass.championName.count]){
                returnData in
                matchResult = returnData as! [String:Any]
                
                var metadata = matchResult["metadata"] as! [String:Any]
                var participants = metadata["participants"] as! [String]
                var uidIndex:Int = participants.firstIndex(of: self.dataclass.puuid)!
                
                var info = matchResult["info"] as! [String:Any]
                var i_participants = info["participants"] as! [[String:Any]]
                var u_championName = i_participants[uidIndex]["championName"] as! String
                self.dataclass.matchTimes.append(info["gameDuration"] as! Int)
                for i in 0..<10{
                    self.dataclass.championName2[i].append(i_participants[i]["championName"] as! String)
                    self.dataclass.summonerNames2[i].append(i_participants[i]["summonerName"] as! String)
                }
                self.dataclass.SNpositionholder.append(uidIndex)
                self.dataclass.WinOrLose2.append(i_participants[uidIndex]["win"] as! Bool)
                self.dataclass.championName.append(self.dataclass.championName2)
                self.dataclass.summonerNames.append(self.dataclass.summonerNames2)
                //self.dataclass.WinOrLose.append(self.dataclass.WinOrLose2)
                //print("chanpionname:\(self.dataclass.championName)")
                self.dataclass.championName2 = ["","","","","","","","","",""]
                self.dataclass.summonerNames2 = ["","","","","","","","","",""]
            }
        }
        let championImage = cell.contentView.viewWithTag(1) as! UIImageView
        //let DsummonerspellImage = cell.contentView.viewWithTag(2) as! UIImageView
        //let FsummonerspellImage = cell.contentView.viewWithTag(3) as! UIImageView
        let championname = cell.contentView.viewWithTag(4) as! UILabel
        let summonername = cell.contentView.viewWithTag(5) as! UILabel
        
        self.showImage(imageView: championImage, imageUrl: "http://ddragon.leagueoflegends.com/cdn/13.11.1/img/champion/"+dataclass.championName[indexPath.section][indexPath.row]+".png")
        championname.text = self.dataclass.championName[indexPath.section][indexPath.row]
        summonername.text = self.dataclass.summonerNames[indexPath.section][indexPath.row]
        
        /*
        if(self.dataclass.WinOrLose[indexPath.section][indexPath.row]){
            cell.backgroundColor = UIColor.blue
        }else{
            cell.backgroundColor = UIColor.red
        }
         */
        return cell
    }
    
    private func showImage(imageView: UIImageView, imageUrl: String) {
        let url = URL(string: imageUrl)!
        var request = URLRequest(url: url)
        // ローカルキャッシュが使用可能か試し、使用不可能であればネットワークから取得
        request.cachePolicy = .returnCacheDataElseLoad
        
        // ディスクに保存されるキャッシュ、認証情報、クッキーを使用
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        session.dataTask(with: request) { data, responds, error in
            // リクエストに失敗
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data, let response = responds as? HTTPURLResponse else {
                return
            }
            
            // リクエスト成功
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            } else {
                // サーバー側でリクエストされたものが正常に返せていない
                print(response.statusCode)
            }
        }.resume()
    }
    
    private func scrollUpdate(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(dataclass.championName2)
        // Do any additional setup after loading the view.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scroll = scrollView.contentOffset.y
        //print("scroll: \(scroll)")
        //print("contents height:\(scrollView.contentSize.height)")
    }
    
    
    func getpuuidFromAPI(SummonerName: String,completion: @escaping (_ String:Any)->Void){
        let semaphore = DispatchSemaphore(value: 0)
        let SummonerId = self.dataclass.summonerName
        
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
     
}
