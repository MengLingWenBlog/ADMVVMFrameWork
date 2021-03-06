//
//  ADNetWorkTools.m
//  WantToBorrowMoney
//
//  Created by Adam的Apple on 2017/12/25.
//  Copyright © 2017年 Adam的Apple. All rights reserved.
//

#import "ADNetWorkTools.h"

@implementation ADNetWorkTools

#pragma mark 单例
+ (instancetype)shareNetworkTools{
    static dispatch_once_t _once;
    static ADNetWorkTools *sharedInstance;
    dispatch_once(&_once, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.requestSerializer.timeoutInterval = 8.f;
        sharedInstance.responseSerializer = [AFJSONResponseSerializer serializer];
        sharedInstance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/plain", @"text/json", @"text/javascript", nil];
    });
    return sharedInstance;
}

#pragma mark 网络请求方法
- (void)requestData:(requestMethod)methodType urlStr:(NSString *)url params:(id)params completion:(completionCallBack)completion{
    
    NSString *linkUrl=[NSString stringWithFormat:@"%@%@",[self baseUrl],url];
    //成功的block
    void(^successCallBack)(NSURLSessionDataTask * dataTask, id responseaobject) = ^(NSURLSessionDataTask *dataTask, id responseObject)
    {
        if (responseObject){
            completion(responseObject, nil);
        }
        else{
            //NSLog(@"错误发送到服务器");
            completion(responseObject ,nil);
        }
    };
    
    // 失败的Block
    void(^failedCallBack)(NSURLSessionDataTask * dataTask, NSError * error) = ^(NSURLSessionDataTask * dataTask, NSError * error)
    {
        //*********处理没网状态**********//
        completion(nil, error);
        //NSLog(@"%@",error);
    };
    
    if(methodType==ADRequestMethodGET){
        [self GET:linkUrl parameters:params success:successCallBack failure:failedCallBack];
   
    }else if(methodType==ADRequestMethodPOST){
        [self POST:linkUrl parameters:params success:successCallBack failure:failedCallBack];
    }
}

- (NSString *)baseUrl{
    return BASEURL;
}
@end
