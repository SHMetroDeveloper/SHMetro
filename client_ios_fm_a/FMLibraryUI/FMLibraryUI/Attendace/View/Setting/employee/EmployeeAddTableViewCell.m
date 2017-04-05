//
//  EmployeeAddTableViewCell.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/26/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "EmployeeAddTableViewCell.h"
#import "CheckItemView.h"
#import "SeperatorView.h"
#import "FMSize.h"

@interface EmployeeAddTableViewCell ()
    
    @property (readwrite, nonatomic, strong) CheckItemView * itemView;
    @property (readwrite, nonatomic, strong) SeperatorView * seperator;
    
    @property (readwrite, nonatomic, assign) CGFloat paddingLeft;
    @property (readwrite, nonatomic, assign) CGFloat paddingRight;
    @property (readwrite, nonatomic, assign) BOOL isLast;

@end

@implementation EmployeeAddTableViewCell
    
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _isLast = NO;
        _paddingLeft = 26;
        _paddingRight = [FMSize getInstance].defaultPadding;
        [self initViews];
    }
    return self;
}

- (void) initViews {
    if (!_itemView) {
        
        _itemView = [[CheckItemView alloc] init];
        _seperator = [[SeperatorView alloc] init];
        
        
        [self.contentView addSubview:_itemView];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat left = 50;
    
    [_itemView setFrame:CGRectMake(left - _paddingRight, 0, width - (left - _paddingRight), height)];
    
    if(!_isLast) {
        [_seperator setFrame:CGRectMake(_paddingLeft+_paddingRight, height-seperatorHeight, width-_paddingRight*2-_paddingLeft, seperatorHeight)];
    } else {
        [_seperator setFrame:CGRectMake(0, height-seperatorHeight, width-_paddingRight, seperatorHeight)];
    }
}



- (void) setEmployeeName:(NSString *) name {
    [_itemView setInfoWithName:name desc:nil];
}

- (void) setIsLast:(BOOL)isLast {
    _isLast = isLast;
    
    [self setNeedsLayout];
}

- (void) setChecked:(BOOL) checked {
    [_itemView setChecked:checked];
//    [self setNeedsLayout];
}

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    [_itemView setOnItemClickListener:listener];
}

@end
