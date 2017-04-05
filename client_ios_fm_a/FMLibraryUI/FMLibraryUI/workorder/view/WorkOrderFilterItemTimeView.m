//
//  WorkOrderFilterItemTimeView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/8/31.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WorkOrderFilterItemTimeView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "BaseTextField.h"

@interface WorkOrderFilterItemTimeView ()

@property (readwrite, nonatomic, strong) NSString * timeStart;  //开始时间
@property (readwrite, nonatomic, strong) NSString * timeEnd;    //结束时间
@property (readwrite, nonatomic, strong) NSString * timeUsed;   //耗时


@property (readwrite, nonatomic, strong) UIButton * timeStartBtn;
@property (readwrite, nonatomic, strong) UIButton * timeEndBtn;
@property (readwrite, nonatomic, strong) BaseTextField * timeUsedBaseTF;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;   //
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, strong) id<OnClickListener> clickListener;
@end

@implementation WorkOrderFilterItemTimeView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        UIFont * nameFont  = [FMFont getInstance].defaultFontLevel2;
        
        _timeStartBtn = [[UIButton alloc] init];
        _timeEndBtn = [[UIButton alloc] init];
        _timeUsedBaseTF = [[BaseTextField alloc] init];
        
        
        [_timeStartBtn.titleLabel setFont:nameFont];
        [_timeEndBtn.titleLabel setFont:nameFont];
        
        
        [_timeStartBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLACK] forState:UIControlStateNormal];
        [_timeEndBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLACK] forState:UIControlStateNormal];
        
        _timeStartBtn.tag = ORDER_FILTER_ITEM_VIEW_TAG_START;
        _timeEndBtn.tag = ORDER_FILTER_ITEM_VIEW_TAG_END;
        _timeUsedBaseTF.tag = ORDER_FILTER_ITEM_VIEW_TAG_USED;
        
        _timeStartBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _timeEndBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        
        [_timeStartBtn addTarget:self action:@selector(onTimeStartClicked) forControlEvents:UIControlEventTouchUpInside];
        [_timeEndBtn addTarget:self action:@selector(onTimeEndClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [_timeUsedBaseTF setLabelWithText:[[BaseBundle getInstance] getStringByKey:@"order_filter_time_used" inTable:nil]];
        [_timeUsedBaseTF addTarget:self action:@selector(onTimeUsedChanged:) forControlEvents:UIControlEventValueChanged];
        
        _timeUsedBaseTF.delegate = self;
        
        [self addSubview:_timeStartBtn];
        [self addSubview:_timeEndBtn];
        [self addSubview:_timeUsedBaseTF];
        
        [self updateViews];
    }
    return self;
}

- (void) updateViews {
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGFloat itemHeight = (height-sepHeight*4)/3;
    CGFloat originY = sepHeight;
    
    [_timeStartBtn setFrame:CGRectMake(_paddingLeft, originY, width - _paddingLeft*2, itemHeight)];
    originY += itemHeight + sepHeight;
    [_timeEndBtn setFrame:CGRectMake(_paddingLeft, originY , width - _paddingLeft*2, itemHeight)];
    originY += itemHeight + sepHeight;
    [_timeUsedBaseTF setFrame:CGRectMake(_paddingLeft, originY, width - _paddingLeft*2, itemHeight)];
    
    [self updateInfo];
}

- (void) setInfoWithTimeStart:(NSString*) startTime
                          end:(NSString*) endTime
                         used:(NSString *) usedTime{
    
    _timeStart = startTime;
    _timeEnd = endTime;
    _timeUsed = usedTime;
    [self updateInfo];
}

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    [self updateViews];
}

- (void) onTimeUsedChanged:(NSNotification *)notification {
    UITextField *textfield=[notification object];
    _timeUsed = textfield.text;
}

- (void) updateInfo {
    [_timeStartBtn setTitle:[[NSString alloc] initWithFormat:@"%@: %@",[[BaseBundle getInstance] getStringByKey:@"time_start" inTable:nil], _timeStart] forState:UIControlStateNormal];
    [_timeEndBtn setTitle:[[NSString alloc] initWithFormat:@"%@: %@", [[BaseBundle getInstance] getStringByKey:@"time_end" inTable:nil], _timeEnd] forState:UIControlStateNormal];
    if(_timeUsed) {
        [_timeUsedBaseTF setText:_timeUsed];
    }
    
    
}

- (void) setOnClickListener:(id<OnClickListener>) listener {
    _clickListener = listener;
}

- (void) onTimeStartClicked {
    if(_clickListener) {
        [_clickListener onClick:_timeStartBtn];
    }
}

- (void) onTimeEndClicked {
    if(_clickListener) {
        [_clickListener onClick:_timeEndBtn];
    }
}

- (NSNumber *) getTimeUsed {
    NSNumber * res;
    NSString * tmpTimeUsed = _timeUsedBaseTF.text;
    if(![FMUtils isStringEmpty:tmpTimeUsed]) {
        res = [FMUtils stringToNumber:tmpTimeUsed];
    }
    return res;
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textField endEditing:YES];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(_clickListener) {
        [_clickListener onClick:_timeUsedBaseTF];
    }
}
@end


