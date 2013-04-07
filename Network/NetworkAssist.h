//
//  NetworkAssist.h
//  songguo
//
//  Created by songguo on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkAssist : NSObject {
    
}

/*-------------------------
 根据传入的参数返回包含api的url;
 参数:
 path:api去掉domain的部分，例如
 api为https://api.weibo.com/2/statuses/public_timeline.json，
 则path为：2/statuses/public_timeline.json
 params:参数字典
 ---------------------------*/
+ (NSURL *)getURL:(NSString *)path queryParameters:(NSMutableDictionary*)params;

@end
