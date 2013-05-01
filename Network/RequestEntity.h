//
//  RequestEntity.h
//  Network
//
//  Created by Sam on 13-5-1.
//  Copyright (c) 2013年 Sam. All rights reserved.
//

#import "NetworkConstans.h"

//typedef enum
//{
//    Request_Token = 0,               // 获取Token
//    
//    Request_Hot_Cities,              // 获取热门城市
//    Request_Hot_Color,               // 获取城市的热门颜色
//    Request_Colors_List,             // 获取颜色列表
//    Request_App_Link,                // 获取App的App Store link
//    Request_Cities_List,             // 获取城市列表
//    
//}
//RequestTag;

#import <Foundation/Foundation.h>

@interface RequestEntity : NSObject
{
    void (^requestComplete)(BOOL, NSDictionary*);
}

@property (nonatomic) RequestTag requestTag;
@property (nonatomic, copy) NSString *requestPath;
@property (nonatomic, retain) NSMutableDictionary *requestParameters;
@property (nonatomic, copy) void (^requestComplete)(BOOL, NSDictionary*);

@end
