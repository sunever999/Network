//
//  NetworkHttpClient.h
//  songguo
//
//  Created by songguo on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkConstans.h"
#import "ResponseEntity.h"

@interface NetworkHttpClient : NSObject {
    //异步请求时使用的成员
	NSURLConnection *connection;
	int statusCode;
	NSMutableData* buf;
	id delegate;
    
    RequestTag rTag;
    
    void (^requestComplete)(ResponseEntity*);
}

@property(nonatomic,retain)NSURLConnection *connection;
@property(nonatomic,retain)NSMutableData* buf;
@property(nonatomic,assign)id delegate;

/*-------------------------
 异步http请求;
 参数:
 aRequest:包含url的request
 iTag:该交互的标签，用于交互结束数据解析
 aHttpMedthod:http方法，"POST"或"GET"
 aDelegate:传入的代理对象，用来响应请求成功或失败的动作
 aSuccess:请求成功时的selector，参数格式为 onSuccess:(NSNumber *)statusCode responseText:(NSString *)dataStr
 aFail:请求失败时的selector，参数格式为 onFail:(NSNumber *)statusCode error:(NSString *)dataStr
 ---------------------------*/
//-(void)asynchRequest:(NSMutableURLRequest *)aRequest interactiveTag:(RequestTag)iTag httpMethod:(NSString *)aHttpMedthod delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;

/*-------------------------
 终止交互;
 ---------------------------*/
- (void)cancelLoading;


- (void)asynchRequest:(NSMutableURLRequest *)aRequest requestTag:(RequestTag)iTag httpMethod:(NSString *)
    aHttpMedthod complete:(void(^)(ResponseEntity*))requestFinished;

@end
