//
//  UIUtils.m
//  SinaWeiBo
//
//  Created by amber on 14-8-19.
//  Copyright (c) 2014年 amber. All rights reserved.
//
/*
#import "UIUtils.h"
#import <CommonCrypto/CommonDigest.h>
//#import "RegexKitLite.h"
//#import "NSString+URLEncoding.h"

@implementation UIUtils

+ (NSString *)getDocumentsPath:(NSString *)fileName {
    
    //两种获取document路径的方式
//    NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documents = [paths objectAtIndex:0];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    
    return path;
}

+ (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formate];
	NSString *str = [formatter stringFromDate:date];
	return str;
}

+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSDate *date = [formatter dateFromString:datestring];
    return date;
}

//Sat Jan 12 11:50:16 +0800 2013
+ (NSString *)fomateString:(NSString *)datestring {
    NSString *formate = @"E M d HH:mm:ss Z yyyy";
    NSDate *createDate = [UIUtils dateFromFomate:datestring formate:formate];
    NSString *text = [UIUtils stringFromFomate:createDate formate:@"MM-dd HH:mm"];
    return text;
}

//字符串链接等解析方法
+ (NSString *)parseLink:(NSString *)text
{
    NSString *regex = @"(@\\w+)|(#\\w+#)|(http(s)?://([a-zA-Z0-9._-]+(/)?)*)";
    NSArray *matchArray = [text componentsMatchedByRegex:regex];
    
    //区分3种不同形式的超链接。分别为:@用户、 http://  #话题#
    for (NSString *linkString in matchArray) {
        NSLog(@"-------------- \n %@",linkString);
        
        //区分3种不同形式的超链接
        //<a href='user'://@用户><a>  //@用户的http显示方式
        //<a href=http://www.sina.com>http://www.baidu.com</a>  //链接形式http表示
        //<a href=topic://#话题#>#话题#</a>   //话题超链接显示表示
        
        //替换的对象target
        NSString *replacing = [NSString new];
        
        //判断3种不同形式的超链接
        //hasPrefix:方法的功能是判断创建的字符串内容是否以某个字符开始
        if ([linkString hasPrefix:@"@"]) {
            //linkString = [linkString URLEncodedString];  //将文本转为链接,点击@的用户时，打印对应的链接
            replacing = [NSString stringWithFormat:@"<a href='user://%@'>%@</a>",[linkString URLEncodedString],linkString]; //@用户
        }else if ([linkString hasPrefix:@"http"]){
            //linkString = [linkString URLEncodedString];  //将文本转为链接
            replacing = [NSString stringWithFormat:@"<a href='%@'>%@</a>",linkString,linkString]; //http://
        }else if ([linkString hasPrefix:@"#"]){
            //linkString = [linkString URLEncodedString];  //将文本转为链接
            replacing = [NSString stringWithFormat:@"<a href='topic://%@'>%@</a>",[linkString URLEncodedString],linkString]; //#话题#
        }
        
        if (replacing != nil) {
            //替换方法,linkString表示被替换的字符串。替换为replacing
            text = [text stringByReplacingOccurrencesOfString:linkString withString:replacing];
        }
    }
    return text;
}

@end
 */
