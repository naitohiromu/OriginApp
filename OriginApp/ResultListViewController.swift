//
//  ResultListViewController.swift
//  OriginApp
//
//  Created by naito.hiromu on 2023/06/27.
//

import UIKit

class ResultListViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    let dataclass = DataClass.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataclass.championName)
        //self.showImage(imageView: imageView, imageUrl: "http://ddragon.leagueoflegends.com/cdn/13.11.1/img/champion/"+dataclass.championName[3]+".png")
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
}
