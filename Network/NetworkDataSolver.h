//
//  NetworkDataSolver.h
//  songguo
//
//  Created by songguo on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkConstans.h"

@interface NetworkDataSolver : NSObject {
    // 解析结束回调
	id delegate;
	SEL onSuccess;
    SEL onFail;

    void (^requestComplete)(BOOL);
}

@property(nonatomic,assign)id delegate;

// remove later
//- (void)analysisNetworkData:(NSString *)data interactiveTag:(NWITag)iTag delegate:(id)aDelegate onSuccess:(SEL)aSuccess;

// new for dongge
- (void)parseData:(NSData *)data requestTag:(RequestTag)iTag delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;

- (void)parseData:(NSData *)data requestTag:(RequestTag)iTag complete:(void(^)(BOOL))requestFinished;

@end
