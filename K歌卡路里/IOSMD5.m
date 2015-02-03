//
//  IOSMD5.m
//  K歌卡路里
//
//  Created by amber on 14/11/24.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "IOSMD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation IOSMD5

+ (NSString *) md5:(NSString *)inPutText
{
    const char *cStr = [inPutText UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15] ]
            
            lowercaseString];
}

@end
