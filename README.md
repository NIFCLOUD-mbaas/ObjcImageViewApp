# 【iOS Objective-C】mBaaSにアップロードした画像をアプリに表示しよう！
*2020/10/05作成*
![画像1](/readme-img/001.png)

## 概要
* [ニフクラ mobile backend](https://mbaas.nifcloud.com/)(通称mBaaS)の『ファイルストア機能』を利用して、アップロードした画像をアプリ側で表示するサンプルプロジェクトです
* 簡単な操作ですぐに [ニフクラ mobile backend](https://mbaas.nifcloud.com/)の機能を体験いただけます★☆

## ニフクラ mobile backendって何？？
スマートフォンアプリのバックエンド機能（プッシュ通知・データストア・会員管理・ファイルストア・SNS連携・位置情報検索・スクリプト）が**開発不要**、しかも基本**無料**(注1)で使えるクラウドサービス！

注1：詳しくは[こちら](https://mbaas.nifcloud.com/price.htm)をご覧ください

![画像2](/readme-img/002.png)

## 動作環境

* Mac OS 10.15(Catalina)
* Xcode ver. 12.0
* Simulator ver.12.0
* iPhone11 (iOS14.0)

※上記内容で動作確認をしています。

## 手順
### 1. [ ニフクラ mobile backend ](https://mbaas.nifcloud.com/)の会員登録・ログインとアプリの新規作成
* 上記リンクから会員登録（無料）をします。登録ができたらログインをすると下図のように「アプリの新規作成」画面が出るのでアプリを作成します

![画像3](/readme-img/003.png)

* アプリ作成されると下図のような画面になります
* この２種類のAPIキー（アプリケーションキーとクライアントキー）はXcodeで作成するiOSアプリに[ニフクラ mobile backend](https://mbaas.nifcloud.com/)を紐付けるために使用します

![画像4](/readme-img/004.png)

### 2. GitHubからサンプルプロジェクトのダウンロード
* 下記リンクをクリックしてプロジェクトをMacにダウンロードします
 * __[ObjcImageViewApp](https://github.com/NIFCloud-mbaas/ObjcImageViewApp/archive/master.zip)__

 ※この中にはプロジェクトと別に、「setting」フォルダが入っています。この中にある画像を後ほどアップロードして使用します。

### 3. Xcodeでアプリを起動
* ダウンロードしたフォルダを開き、「`ObjcImageViewApp.xcodeproj`」をダブルクリックしてXcode開きます

![画像9](/readme-img/009.png)

![画像6](/readme-img/006.png)

* 「ObjcImageViewApp.workspace」（青い方）ではないので注意してください！

![画像8](/readme-img/008.png)

### 4. APIキーの設定
* `AppDelegate.m`を編集します
* 先程[ニフクラ mobile backend](https://mbaas.nifcloud.com/)のダッシュボード上で確認したAPIキーを貼り付けます

![画像7](/readme-img/007.png)

* それぞれ`YOUR_NCMB_APPLICATION_KEY`と`YOUR_NCMB_CLIENT_KEY`の部分を書き換えます
 * このとき、ダブルクォーテーション（`"`）を消さないように注意してください！
 * 書き換え終わったら`command + s`キーで保存をします

### 5. 画像ファイルのアップロード
* [ニフクラ mobile backend](https://mbaas.nifcloud.com/)のダッシュボードで、「ファイルストア」を開きます
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

<img src="/readme-img/010.png" alt="画像10" width="320"/>

* 画面右下の「Download」ボタンをタップします
* 先ほどアップロードした画像が表示されます

<img src="/readme-img/011.png" alt="画像11" width="320"/>

__画像が表示されない場合__
* ネットワークを確認してください
* 画面左下にエラーコードが出ている場合は[こちら](https://mbaas.nifcloud.com/doc/current/rest/common/error.html#REST%20API%E3%81%AE%E3%82%A8%E3%83%A9%E3%83%BC%E3%82%B3%E3%83%BC%E3%83%89%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6)から確認できます

## 解説
ここではサンプルアプリに実装済みの内容について紹介します

### SDKのインポートと初期設定
* ニフクラ mobile backend の[ドキュメント（クイックスタート）](https://mbaas.nifcloud.com/doc/current/introduction/quickstart_ios.html)をご活用ください

### ロジック
* `Main.storyboard`でデザインを作成し、`ViewController.m`にロジックを書いています

#### アップロードした画像ファイルのダウンロード
```objc
#import "ViewController.h"
#import "NCMB/NCMB.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
// 通信結果を表示するラベル
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // statusLabelの初期化
    self.statusLabel.text = @"";
}

// 「Download」ボタン押下時の処理
- (IBAction)download:(UIBarButtonItem *)sender {
    // 取得する画像ファイル名を設定
    NCMBFile *imageFile = [NCMBFile fileWithName:@"mBaaS_image.png" data:nil];
    // 画像ファイルを取得
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (error != nil) {
            // 取得失敗時の処理
            NSLog(@"画像ファイルの取得に失敗しました：%ld",(long)error.code);
            self.statusLabel.text = [NSString stringWithFormat:@"NG エラーコード：%ld",(long)error.code];
        } else {
            // 取得成功時の処理
            NSLog(@"画像ファイルの取得に成功しました");
            self.statusLabel.text = @"OK";
            // 画像を表示する処理
            self.imageView.image = [UIImage imageWithData:data];
        }
    } progressBlock:^(int percentDone) {
        self.statusLabel.text = [NSString stringWithFormat:@"%d %%",percentDone];
    }];
}

@end
```

## 参考
* 同じ内容の【Swift】版もご用意しています
 * https://github.com/NIFCloud-mbaas/SwiftImageViewApp
