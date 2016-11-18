# 【iOS Swift】mBaaSにアップロードした画像をアプリに表示しよう！
![画像1](/readme-img/001.png)

## 概要
* [ニフティクラウドmobile backend](http://mb.cloud.nifty.com/)(通称mBaaS)の『ファイルストア機能』を利用して、アップロードした画像をアプリ側で表示するサンプルプロジェクトです
* 簡単な操作ですぐに [ニフティクラウドmobile backend](http://mb.cloud.nifty.com/)の機能を体験いただけます★☆

## ニフティクラウドmobile backendって何？？
スマートフォンアプリのバックエンド機能（プッシュ通知・データストア・会員管理・ファイルストア・SNS連携・位置情報検索・スクリプト）が**開発不要**、しかも基本**無料**(注1)で使えるクラウドサービス！

注1：詳しくは[こちら](http://mb.cloud.nifty.com/price.htm)をご覧ください

![画像2](/readme-img/002.png)

## 動作環境
* Mac OS X 10.12(Sierra)
* Xcode ver. 8.0
* Simulator ver. 10.0
 * iPhone7

※上記内容で動作確認をしています。

## 手順
### 1. [ ニフティクラウドmobile backend ](http://mb.cloud.nifty.com/)の会員登録・ログインとアプリの新規作成
* 上記リンクから会員登録（無料）をします。登録ができたらログインをすると下図のように「アプリの新規作成」画面が出るのでアプリを作成します

![画像3](/readme-img/003.png)

* アプリ作成されると下図のような画面になります
* この２種類のAPIキー（アプリケーションキーとクライアントキー）はXcodeで作成するiOSアプリに[ニフティクラウドmobile backend](http://mb.cloud.nifty.com/)を紐付けるために使用します

![画像4](/readme-img/004.png)

### 2. GitHubからサンプルプロジェクトのダウンロード
* 下記リンクをクリックしてプロジェクトをMacにダウンロードします
 * __[SwiftImageViewApp](https://github.com/natsumo/SwiftImageViewApp/archive/master.zip)__

 ※この中にはプロジェクトと別に、「setting」フォルダが入っています。この中にある画像を後ほどアップロードして使用します。

### 3. Xcodeでアプリを起動
* ダウンロードしたフォルダを開き、「`SwiftImageViewApp.xcodeproj`」をダブルクリックしてXcode開きます

![画像9](/readme-img/009.png)

![画像6](/readme-img/006.png)

* 「SwiftImageViewApp.xcodeproj」（青い方）ではないので注意してください！

![画像8](/readme-img/008.png)

### 4. APIキーの設定
* `AppDelegate.swift`を編集します
* 先程[ニフティクラウドmobile backend](http://mb.cloud.nifty.com/)のダッシュボード上で確認したAPIキーを貼り付けます

![画像7](/readme-img/007.png)

* それぞれ`YOUR_NCMB_APPLICATION_KEY`と`YOUR_NCMB_CLIENT_KEY`の部分を書き換えます
 * このとき、ダブルクォーテーション（`"`）を消さないように注意してください！
 * 書き換え終わったら`command + s`キーで保存をします

### 5. 画像ファイルのアップロード
* [ニフティクラウドmobile backend](http://mb.cloud.nifty.com/)のダッシュボードで、「ファイルストア」を開きます
* 「↑アップロード」をクリックします

![画像12](/readme-img/012.png)

* 画像を選択します
 * ここでアップロードする画像はダウンロードしたプロジェクトにある「setting」フォルダ内の「__mBaaS_image.png__」ファイルです。

![画像15](/readme-img/015.png)

* 選択したら「アップロードする」をクリックします

![画像13](/readme-img/013.png)

* 画像がアップロードされました

![画像14](/readme-img/014.png)

### 6. 動作確認と解説
* Xcode画面の左上、適当なSimulatorを選択します
 * iPhone7の場合は以下のようになります
* 実行ボタン（さんかくの再生マーク）をクリックします
* アプリが起動します

![画像10](/readme-img/010.png)

* 画面右下の「Download」ボタンをタップします
* 先ほどアップロードした画像が表示されます

![画像11](/readme-img/011.png)

__画像が表示されない場合__
* ネットワークを確認してください
* 画面左下にエラーコードが出ている場合は[こちら](http://mb.cloud.nifty.com/doc/current/rest/common/error.html#REST%20API%E3%81%AE%E3%82%A8%E3%83%A9%E3%83%BC%E3%82%B3%E3%83%BC%E3%83%89%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6)から確認できます

## 解説
ここではサンプルアプリに実装済みの内容について紹介します

### SDKのインポートと初期設定
* ニフティクラウドmobile backend のドキュメント（クイックスタート）をSwift版に書き換えたドキュメントをご用意していますので、ご活用ください
 * [SwiftでmBaaSを始めよう！(＜CocoaPods＞でuse_framewoks!を有効にした方法)](http://qiita.com/natsumo/items/57d3a4d9be16b0490965)

### ロジック
* `Main.storyboard`でデザインを作成し、`ViewController.swift`にロジックを書いています

#### アップロードした画像ファイルのダウンロード
```swift
//
//  ViewController.swift
//  SwiftImageViewApp
//
//  Created by Natsumo Ikeda on 2016/10/25.
//  Copyright © 2016年 NIFTY Corporation. All rights reserved.
//
import UIKit
import NCMB

class ViewController: UIViewController {
    // imageView
    @IBOutlet weak var imageView: UIImageView!
    // label
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // labelの初期化
        label.text = ""

    }

    // 「Download」ボタン押下時の処理
    @IBAction func download(_ sender: UIBarButtonItem) {
        // 取得する画像ファイル名を設定
        let imageFile = NCMBFile.file(withName: "mBaaS_image.png", data: nil) as! NCMBFile
        // 画像ファイルを取得
        imageFile.getDataInBackground({ (data, error) in
            if error != nil {
                // 取得失敗時の処理
                let err = error as! NSError
                print("画像ファイルの取得に失敗しました：\(err.code)")
                self.label.text = "NG エラーコード：\(err.code)"
            } else {
                // 取得成功時の処理
                print("画像ファイルの取得に成功しました")
                self.label.text = "OK"
                // 画像を表示する処理
                self.imageView.image = UIImage(data: data!)

            }

        }) { (num) in
                self.label.text = "\(num)%"
        }
    }
}
```

## 参考
* 同じ内容の【Objective-C】版もご用意しています
 * https://github.com/NIFTYCloud-mbaas/ObjcImageViewApp
