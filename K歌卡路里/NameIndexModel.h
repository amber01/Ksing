//
//  NameIndexModel.h
//  K歌卡路里
//
//  Created by amber on 15/1/27.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NameIndexModel : NSObject
{
    NSString *_lastName;
    NSString *_firstName;
    NSInteger _sectionNum;
    NSInteger _originIndex;
}

@property (nonatomic, retain) NSString *_lastName;
@property (nonatomic, retain) NSString *_firstName;
@property (nonatomic) NSInteger _sectionNum;
@property (nonatomic) NSInteger _originIndex;
- (NSString *) getFirstName;
- (NSString *) getLastName;

@end
