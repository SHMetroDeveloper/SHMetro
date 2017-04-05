//
//  DesEncrypt.h
//  hello
//
//  Created by 杨帆 on 15/3/26.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesEncrypt : NSObject

+ (NSString *) getEncString:(NSString *) strMing key:(NSString *) key;
+ (NSString *) getDesString:(NSString *) strMi key:(NSString *) key;

@end
