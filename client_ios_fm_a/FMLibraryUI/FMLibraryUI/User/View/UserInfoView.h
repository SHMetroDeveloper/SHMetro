//
//  UserInfoView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  用户信息 view 最小高度为 100

#import <UIKit/UIKit.h>

@interface UserInfoView : UIButton

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect)frame;


- (void) setInfoWithName:(NSString *) name;
- (void) setInfoWithName:(NSString *) name andPhoto:(UIImage *) image;
- (void) setInfoWithName:(NSString *) name andPhoto:(UIImage *) image andDesc:(NSString *) desc;
- (void) setInfoWithName:(NSString *) name andPhotoUrl:(NSURL *) imageUrl andDesc:(NSString *) desc;
- (void) setInfoWithPhoto:(UIImage *) photo;

- (void) setShowBounds:(BOOL) showBound;

@end

