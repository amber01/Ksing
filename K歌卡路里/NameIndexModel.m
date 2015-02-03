//
//  NameIndexModel.m
//  K歌卡路里
//
//  Created by amber on 15/1/27.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "NameIndexModel.h"

@implementation NameIndexModel
@synthesize _firstName, _lastName;
@synthesize _sectionNum, _originIndex;

- (NSString *) getFirstName {
    if ([_firstName canBeConvertedToEncoding: NSASCIIStringEncoding]) {//如果是英文
        return _firstName;
    }
    else { //如果是非英文
        return [NSString stringWithFormat:@"%c",pinyinFirstLetter([_firstName characterAtIndex:0])];
    }
    
}
- (NSString *) getLastName {
    if ([_lastName canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        return _lastName;
    }
    else {
        return [NSString stringWithFormat:@"%c",pinyinFirstLetter([_lastName characterAtIndex:0])];
    }
    
}
@end
