//
//  BaseToolbar.h
//  K歌卡路里
//
//  Created by amber on 14-10-13.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "MusicLoadModel.h"

@implementation MusicLoadModel
@synthesize name, type;

- (id)initWithName:(NSString *)_name andType:(NSString *)_type {
    if (self = [super init]) {
        self.name = _name;
        self.type = _type;
    }
    return self;
}

@end
