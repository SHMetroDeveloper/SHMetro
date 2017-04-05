//
//  HBDrawingBoard.h
//  DemoAntiAliasing
//
//  Created by 伍宏彬 on 15/11/2.
//  Copyright (c) 2015年 HB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBDrawModel.h"

typedef NS_ENUM(NSInteger, HBDrawingStatus)
{
    HBDrawingStatusBegin,//准备绘制
    HBDrawingStatusMove,//正在绘制
    HBDrawingStatusEnd//结束绘制

};

typedef void(^drawStatusBlock)(HBDrawingStatus drawingStatus, HBDrawModel *model);
typedef void(^boardImageBlock)(UIImage *boardBackImage);

@interface HBDrawingBoard : UIView
/**
 *  画笔宽度
 */
@property (nonatomic, assign) CGFloat lineWidth;
/**
 *  画笔颜色
 */
@property (nonatomic, strong) UIColor *lineColor;
/**
 *  画板背景
 */
@property (nonatomic, strong) UIImage *boardBackImage;
/**
 *  清屏
 */
- (void)clearAll;
/**
 *  撤销
 */
- (void)backToLastDraw;
/**
 *  恢复
 */
- (void)regeneration;
/**
 *  橡皮檫
 */
- (void)eraser;
/**
 *  保存到相册
 */
- (void)saveCurrentImageToAlbum;
/**
 *  获得照片
 */
- (UIImage *) getScreenImg;
/**
 *  获得图片路径
 */
- (NSString *) getScreenImgPath;
/**
 *  获取绘制状态
 *
 *  @param stautsBlock 内含状态值
 */
- (void)drawingStatus:(drawStatusBlock)stautsBlock;
/**
 *  根据点的集合绘制      
 *
 *  @param points    ["{x,y}"...]
 *  @param lineColor 颜色
 *  @param lineWidth 线宽
 *
 *  @return YES -> 绘制完成  反之
 */
- (BOOL)drawWithPoints:(HBDrawModel *)model;
/**
 *  获取背景
 */
- (void)getChangeBoardImage:(boardImageBlock)boardImage;
+ (HBDrawModel *)objectWith:(NSDictionary *)dic;
@end

#pragma mark - HBPath
@interface HBPath : NSObject

@property (nonatomic, strong) UIColor *pathColor;//画笔颜色
@property (nonatomic, assign) BOOL isEraser;//橡皮擦

+ (instancetype)pathToPoint:(CGPoint)beginPoint pathWidth:(CGFloat)pathWidth;//初始化对象
- (void)pathLineToPoint:(CGPoint)movePoint;//画
- (void)drawPath;//绘制
@end

