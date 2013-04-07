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
    void (^requestComplete)(BOOL);
}

- (void)parseData:(NSData *)data requestTag:(RequestTag)iTag complete:(void(^)(BOOL))requestFinished;

@end
