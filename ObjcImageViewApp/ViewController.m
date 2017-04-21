//
//  ViewController.m
//  ObjcImageViewApp
//
//  Created by FJCT on 2016/11/18.
//  Copyright 2017 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
//

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
