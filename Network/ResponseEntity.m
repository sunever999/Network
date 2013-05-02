//
//  ResponseEntity.m
//  Network
//
//  Created by Sam on 13-5-2.
//  Copyright (c) 2013年 Sam. All rights reserved.
//

#import "ResponseEntity.h"

@implementation ResponseEntity

- (id)init
{
    if (self = [super init]) {
        _errorCode = [[NSNumber alloc] init];
        _errorMsg = [[NSString alloc] init];
        _responseData = [[NSData alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [_errorCode release];
    [_errorMsg release];
    [_responseData release];
    
    [super dealloc];
}

@end
