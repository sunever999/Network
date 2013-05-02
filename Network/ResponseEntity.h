//
//  ResponseEntity.h
//  Network
//
//  Created by Sam on 13-5-2.
//  Copyright (c) 2013年 Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseEntity : NSObject

@property (nonatomic) BOOL success;
@property (nonatomic) int responseHttpCode;
@property (nonatomic, retain) NSNumber *errorCode;
@property (nonatomic, copy) NSString *errorMsg;
@property (nonatomic, retain) NSData *responseData;

@end
