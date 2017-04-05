//
//  ResizeableLabelView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/17.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "ResizeableLabelView.h"
#import "FMUtils.h"
#import "FMTheme.h"


@interface ResizeableLabelView ()
@property (readwrite, nonatomic, strong) UIView * leftView;     //标签

@property (readwrite, nonatomic, strong) UILabel * contentView;  //信息

@property (readwrite, nonatomic, assign) CGFloat labelWidth;    //标签宽度
@property (readwrite, nonatomic, strong) UIFont * labelFont;
@property (readwrite, nonatomic, assign) CGFloat defaultLabelHeight;    //默认的标签高度
@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, strong) id<OnClickListener> clickListener;

@end

@implementation ResizeableLabelView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
        [self updateSubviews];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateSubviews];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        _paddingLeft = 10;       //默认左边距为 5
        _paddingRight = 10;      //默认右边距为 5
        _paddingTop = 5;        //默认上边距
        _paddingBottom = 5;     //默认下边距
        _sepWidth = 5;
        
        _labelWidth = 0;
        
        _contentView = [[UILabel alloc] init];
        
        _contentView.font = [UIFont fontWithName:@"Helvetica" size:14];    //默认字体
        _contentView.textColor = [UIColor blackColor];                 //默认字体颜色
        
        _leftView = nil;        //默认不显示标签
        _labelFont = [UIFont fontWithName:@"Helvetica" size:14];
        
        _contentView.numberOfLines = 0;
        [self addSubview:_contentView];
    }
}

- (void) updateSubviews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat originX = _paddingLeft;
    CGFloat originY = _paddingTop;
    if(width == 0 || height == 0) {
        return;
    }
    if(_leftView) {
        CGRect leftViewRect = _leftView.frame;
        CGFloat leftViewHeight = CGRectGetHeight(leftViewRect);
        leftViewRect.origin.x = _paddingLeft;
        if (leftViewHeight > height - _paddingTop - _paddingBottom) {
            height = (leftViewHeight + _paddingTop + _paddingBottom);
            CGSize newSize = CGSizeMake(width, height);
            [self notifyViewNeedResized:newSize];
            return;
        }
        leftViewRect.origin.y = (height-leftViewRect.size.height)/2;
        _leftView.frame = leftViewRect;
        
        originX += leftViewRect.size.width+_sepWidth;
        [_leftView setHidden:NO];
    }
    
    
    CGRect inputFrame = CGRectMake(originX, originY, width - _paddingRight - originX, height-originY-_paddingBottom);
    _contentView.frame = inputFrame;
    
}

- (NSString *) getContent {
    return _contentView.text;
}

- (void) setContent:(NSString *) content {
    
    if(content && ![content isEqualToString:_contentView.text]) {
        _contentView.text = content;
        [self checkInputAndUpdateTextView];
    }
}

- (void) setFont:(UIFont*) textFont {
    _contentView.font = textFont;
    [self checkInputAndUpdateTextView];
}

- (void) setPaddingLeft:(CGFloat) left top:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom {
    _paddingLeft = left;
    _paddingRight = right;
    _paddingTop = top;
    _paddingBottom = bottom;
    [self updateSubviews];
}

- (void) setLabel:(UIView *) leftView andLabelWidth:(CGFloat) labelWidth{
    _leftView = leftView;
    _labelWidth = labelWidth;
    [self addSubview:_leftView];
    
    [self updateSubviews];
}

- (void) setLabelWithText:(NSString *) labelText andLabelWidth:(CGFloat) labelWidth {
//    _leftView = leftView;
    CGFloat height = CGRectGetHeight(self.frame);
    UILabel * label = nil;
    if(!_leftView || ![_leftView isKindOfClass:[UILabel class]]) {
        if(height == 0) {
            UILabel * testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, _defaultLabelHeight)];
            testLabel.numberOfLines = 0;
            testLabel.font = _labelFont;
            height = [FMUtils heightForStringWith:testLabel value:labelText andWidth:labelWidth];
        }
        label = [[UILabel alloc] initWithFrame:CGRectMake(_paddingLeft, _paddingTop, labelWidth, height)];
        label.font = _labelFont;
        label.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        label.numberOfLines = 0;
        [self addSubview:label];
    } else {
        [_leftView setFrame:CGRectMake(_paddingLeft, _paddingTop, labelWidth, height)];
        label = (UILabel *)_leftView;
    }
    label.text = labelText;
    _leftView = label;
    _labelWidth = labelWidth;
    [self updateSubviews];
}

- (CGFloat) getCurrentHeight {
    CGFloat msgHeight = self.defaultHeight;
    NSString * text = _contentView.text;
    CGFloat width = CGRectGetWidth(self.frame);
    width -= _paddingLeft + _paddingRight + _labelWidth;
    if(![FMUtils isStringEmpty:text]) {
        msgHeight = [FMUtils heightForStringWith:_contentView value:_contentView.text andWidth:width];
        msgHeight += _paddingTop + _paddingBottom;
    }
    return msgHeight;
}

- (void) checkInputAndUpdateTextView {
    CGFloat height = [self getCurrentHeight];
    if(height != CGRectGetHeight(_contentView.frame)) {
        CGFloat width = CGRectGetWidth(self.frame);
        CGSize newSize = CGSizeMake(width, height);
        [self notifyViewNeedResized:newSize];
    }
}

#pragma - onclick 事件

- (void) actiondo:(UIView *) v {
    NSLog(@"view 被点击了");
    [self notifyViewClicked];
}

- (void) notifyViewClicked {
    if(_clickListener) {
        [_clickListener onClick:self];
    }
}

- (void) setOnClickedListener:(id<OnClickListener>) listener {
    _clickListener = listener;
    if(listener) {
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actiondo:)];
        [self addGestureRecognizer:tapGesture];
    }
}

+ (CGFloat) calculateHeightByContent:(NSString *) content andWidth:(CGFloat) width {
    CGFloat res = 0;
    CGFloat paddingTop = 5;
    CGFloat paddingBottom = 5;
    CGFloat defaultHeight = 30;
    if(![FMUtils isStringEmpty:content] && width!=0) {
        UILabel * testLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width-20, defaultHeight)];
        testLbl.text = content;
        testLbl.font = [UIFont fontWithName:@"Helvetica" size:14];
        testLbl.numberOfLines = 0;
        res = [FMUtils heightForStringWith:testLbl value:content andWidth:width-20];
        res += paddingTop + paddingBottom;
    }
    
    return res;
}

@end


