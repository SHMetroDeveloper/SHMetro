//
//  PatrolHistoryQuestionAlertContentView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/30.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolHistoryQuestionAlertContentView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "UIButton+Bootstrap.h"
#import "BaseBundle.h"

@interface PatrolHistoryQuestionAlertContentView ()


@property (readwrite, nonatomic, strong) PatrolTaskItemDetail * item;

@property (readwrite, nonatomic, strong) UILabel * questionHeaderLbl;
@property (readwrite, nonatomic, strong) UILabel * titleLbl;
@property (readwrite, nonatomic, strong) UIButton * exceptionBtn;
@property (readwrite, nonatomic, strong) UILabel * resultLbl;
@property (readwrite, nonatomic, strong) UILabel * descLbl;


@property (readwrite, nonatomic, strong) UILabel * pictureHeaderLbl;

@property (readwrite, nonatomic, strong) UILabel * indicatorQuestion;
@property (readwrite, nonatomic, strong) UILabel * indicatorPicture;

@property (readwrite, nonatomic, strong) UIFont * mFont;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@end

@implementation PatrolHistoryQuestionAlertContentView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        _questionHeaderLbl = [[UILabel alloc] init];
        _titleLbl = [[UILabel alloc] init];
        _exceptionBtn = [[UIButton alloc] init];
        _resultLbl = [[UILabel alloc] init];
        _descLbl = [[UILabel alloc] init];
        
        _pictureHeaderLbl = [[UILabel alloc] init];
        
        _indicatorQuestion = [[UILabel alloc] init];
        _indicatorPicture = [[UILabel alloc] init];
        
        _indicatorQuestion.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        _indicatorPicture.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        
        [_questionHeaderLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLACK]];
        [_indicatorPicture setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLACK]];
        
        [self updateSubViews];
        
        
        [self addSubview:_questionHeaderLbl];
        [self addSubview:_indicatorQuestion];
        [self addSubview:_titleLbl];
        [self addSubview:_exceptionBtn];
        [self addSubview:_resultLbl];
        [self addSubview:_descLbl];
        [self addSubview:_pictureHeaderLbl];
        [self addSubview:_indicatorPicture];
    }
    return self;
}

- (void) updateSubViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    
    UIFont * nameFont = [UIFont fontWithName:@"Helvetica" size:20];
    UIFont * msgFont = [UIFont fontWithName:@"Helvetica" size:14];
    
    CGFloat itemHeight = 40;
    CGFloat originY = 0;
    CGFloat stateWidth = 50;
    
    [_questionHeaderLbl setFrame:CGRectMake(_paddingLeft, originY, (width - _paddingLeft - _paddingRight), itemHeight)];
    originY += itemHeight;
    [_indicatorQuestion setFrame:CGRectMake(_paddingLeft, originY, (width - _paddingLeft - _paddingRight), 1)];
    
    originY += 1;
    [_titleLbl setFrame:CGRectMake(_paddingLeft, originY, (width - _paddingLeft - _paddingRight-stateWidth), itemHeight)];
    
    [_exceptionBtn setFrame:CGRectMake(width - _paddingRight-stateWidth, originY + 5, stateWidth, itemHeight-5*2)];
    
    originY += itemHeight;
    [_resultLbl setFrame:CGRectMake(_paddingLeft, originY, (width - _paddingLeft - _paddingRight), itemHeight)];
    
    originY += itemHeight;
    [_descLbl setFrame:CGRectMake(_paddingLeft, originY, (width - _paddingLeft - _paddingRight), itemHeight)];
    
    originY += itemHeight;
    [_pictureHeaderLbl setFrame:CGRectMake(_paddingLeft, originY, (width - _paddingLeft - _paddingRight), itemHeight)];
    originY += itemHeight;
    [_indicatorPicture setFrame:CGRectMake(_paddingLeft, originY, (width - _paddingLeft - _paddingRight), 1)];
    
    [_exceptionBtn defaultStyle];
    
    [_questionHeaderLbl setFont:nameFont];
    [_titleLbl setFont:nameFont];
    [_resultLbl setFont:msgFont];
    [_descLbl setFont:msgFont];
    [_pictureHeaderLbl setFont:nameFont];
    [_exceptionBtn.titleLabel setFont:msgFont];
    
    
    [self updateInfo];
    
}

- (void) setInfoWith:(PatrolTaskItemDetail*) item {
    _item = item;
    [self updateSubViews];
}

- (void) updateInfo {
    _questionHeaderLbl.text = [[BaseBundle getInstance] getStringByKey:@"patrol_question_desc" inTable:nil];
    _titleLbl.text = [_item content];
    _resultLbl.text = [[NSString alloc] initWithFormat:@"%@:%@", [[BaseBundle getInstance] getStringByKey:@"patrol_check_result" inTable:nil], [_item getResultStr]];
    if(_item.comment) {
        _descLbl.text = [[NSString alloc] initWithFormat:@"%@:%@", [[BaseBundle getInstance] getStringByKey:@"patrol_content_desc" inTable:nil], _item.comment];
    } else {
        _descLbl.text = [[NSString alloc] initWithFormat:[[BaseBundle getInstance] getStringByKey:@"patrol_content_desc" inTable:nil]];
    }
    if([_item isException]) {
        [_exceptionBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"patrol_status_exception" inTable:nil] forState:UIControlStateNormal];
        [_exceptionBtn setHidden:NO];
    } else {
        [_exceptionBtn setHidden:YES];
    }
    _pictureHeaderLbl.text = [[BaseBundle getInstance] getStringByKey:@"patrol_relation_photos" inTable:nil];
    
}



- (void) setFont:(UIFont*) font {
    _mFont = font;
    _resultLbl.font = _mFont;
    _descLbl.font = _mFont;
}

- (void) setPaddingLeft:(CGFloat) left right:(CGFloat) right {
    _paddingLeft = left;
    _paddingRight = right;
    [self updateSubViews];
}

@end


