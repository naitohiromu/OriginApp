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
        return 2
    }

    
    //セルのサイズを指定する処理
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        // 横方向のスペース調整
        let horizontalSpace:CGFloat = 5

        //セルのサイズを指定。画面上にセルを3つ表示させたいのであれば、デバイスの横幅を3分割した横幅　- セル間のスペース*2（セル間のスペースが二つあるため）
        //let cellSize:CGFloat = self.view.bounds.width/5 - horizontalSpace*2

        let cellSize:CGFloat = self.view.bounds.width/5

        //print(self.view.bounds.width)
        print(cellSize)
        
        // 正方形で返すためにwidth,heightを同じにする
        return CGSize(width: cellSize, height: 139.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //storyboard上のセルを生成　storyboardのIdentifierで付けたものをここで設定する
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath)
        let championImage = cell.contentView.viewWithTag(1) as! UIImageView
        let DsummonerspellImage = cell.contentView.viewWithTag(2) as! UIImageView
        let FsummonerspellImage = cell.contentView.viewWithTag(3) as! UIImageView
        let championname = cell.contentView.viewWithTag(4) as! UILabel
        
        self.showImage(imageView: championImage, imageUrl: "http://ddragon.leagueoflegends.com/cdn/13.11.1/img/champion/"+dataclass.championName[indexPath.row]+".png")
        
        championname.text = dataclass.championName[indexPath.row]
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataclass.championName)
        // Do any additional setup after loading the view.
    }

}
