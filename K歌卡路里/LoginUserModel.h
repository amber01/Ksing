//
//  LoginUserModel.h
//  K歌卡路里
//
//  Created by amber on 15/1/25.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginUserModel : NSObject

@property (nonatomic,copy) NSString *openid;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic,copy) NSString *figureurl;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *age;

@end
