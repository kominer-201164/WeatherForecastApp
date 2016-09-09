//
//  APICommunication.m
//  WeatherForecastApp
//
//  Created by PCK-135-089 on 2016/09/09.
//  Copyright © 2016年 PCK-135-089. All rights reserved.
//

#import "APICommunication.h"



@implementation APICommunication {
    NSDictionary *jsonData;
    BOOL networkOfflineFlag;
    BOOL apiRegulationsFlag;
}

// 初期化メソッド
- (instancetype)init {
    self = [super init];
    return self;
}

- (void)startAPICommunication:(NSString *)resource :(double)latitude :(double)longitude :(CallBackHandler)handler{
    // URLの設定
    NSString *urlString = @"http://kominer:enimokR0150@api.openweathermap.org/data/2.5/";
    NSString *apiKey = @"54d51f13da00bdabafdee82cdee866ea";
    NSString *param = [NSString stringWithFormat:@"lat=%3.6lf&lon=%3.6lf&units=metric&appid=%@", latitude, longitude, apiKey];
    NSString *test = [NSString stringWithFormat:@"%@%@?%@", urlString, resource, param];
    NSURL *url = [NSURL URLWithString:[test stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    // Requestの設定
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    // DataTaskの生成
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        
        // エラー処理
        if(error) {
            networkOfflineFlag = YES;
        } else {
            networkOfflineFlag = NO;
            NSError *jsonError;
            jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        
            if([jsonData objectForKey:@"cod"] == [NSNumber numberWithInteger:401]) {
                apiRegulationsFlag = YES;
            } else {
                apiRegulationsFlag = NO;
            }
        }
        
        if(handler) {
            handler(jsonData, networkOfflineFlag, apiRegulationsFlag);
        }
    }];
    // タスクの実行
    [dataTask resume];
}

@end
