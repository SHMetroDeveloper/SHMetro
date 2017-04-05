//
//  FMTheme.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 8/29/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FMResourceTable.h"

@interface FMTheme : NSObject
+ (instancetype) getInstance;

- (void) setCurrentThemeType:(FMThemeType) type;

- (UIImage *) getImageByName:(NSString *) name;
- (UIColor *) getColorByResource:(FMResourceType) type ;
- (UIFont *) getFontByResource:(FMResourceType) type;

@end
