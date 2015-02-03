//
//  BaseToolbar.h
//  K歌卡路里
//
//  Created by amber on 14-10-13.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicLoadModel : NSObject {
    NSString *name;
    NSString *type;
}
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *type;

- (id)initWithName:(NSString *)_name andType:(NSString *)_type;
@end