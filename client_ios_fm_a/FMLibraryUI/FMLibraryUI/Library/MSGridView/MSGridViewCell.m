//
//  MSGridViewCell.m
//  Shareight
//
//  Created by Martin Saunders on 06/08/2013.
//  Copyright (c) 2013 TBC Digital. All rights reserved.
//

#import "MSGridViewCell.h"
#import "MSGridView.h"
#import "FMUtils.h"
#import "FMTheme.h"

@interface MSGridViewCell()
@property (readwrite, nonatomic, assign) BOOL clickAble;
@property (readwrite, nonatomic, assign) BOOL touching;
@end

@implementation MSGridViewCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)identifier
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.reuseIdentifier = identifier;
        self.contentView = [UIView new];
        _clickAble = YES;   //默认展示点击效果
        [self addSubview:self.contentView];
        
//        [self setBackgroundImage:[FMUtils buttonImageFromColor:[UIColor grayColor] width:1 height:1] forState:UIControlStateHighlighted];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView setFrame:CGRectMake(contentbuffer, contentbuffer, self.frame.size.width-contentbuffer*2, self.frame.size.height-contentbuffer*2)];
}

//设置是否显示点击效果
- (void) setClickAble:(BOOL) clickAble {
    _clickAble = clickAble;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _touching = YES;
    if (_clickAble) {
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L8];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_touching && [touches count] == 1) {
        UITouch *t = [touches anyObject];
        CGPoint p = [t locationInView:self];
        if(CGRectContainsPoint(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), p)) {
            
            
            NSIndexPath *ip = [(MSGridView *)self.superview indexPathForCell:self];
            
            if([[(MSGridView *)self.superview gridViewDelegate]respondsToSelector:@selector(didSelectCellWithIndexPath:)]) {
                
                [[(MSGridView *)self.superview gridViewDelegate] didSelectCellWithIndexPath:ip];
                
            }
        }
    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.backgroundColor = [UIColor whiteColor];
//    });
    if(_clickAble) {
        [UIView animateWithDuration:0.4 animations:^{
            self.backgroundColor = [UIColor whiteColor];
        }];
    }
    _touching = NO;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_clickAble) {
        [UIView animateWithDuration:0.4 animations:^{
            self.backgroundColor = [UIColor whiteColor];
        }];
    }
    _touching = NO;
}


@end
