//
//  ContractShowMoreTableViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/28.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "ContractShowMoreTableViewCell.h"
#import "FMUtilsPackages.h"
#import "SeperatorView.h"

@interface ContractShowMoreTableViewCell ()
@property (nonatomic, strong) UILabel *descLbl;
@property (nonatomic, strong) UIImageView *nextIconImgView;
@property (nonatomic, strong) SeperatorView *seperatorView;

@property (nonatomic, assign) BOOL isInited;
@end

@implementation ContractShowMoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    if (!_isInited) {
        _isInited = YES;
        
        _descLbl = [[UILabel alloc] init];
        _descLbl.text = [[BaseBundle getInstance] getStringByKey:@"cell_show_more_detail" inTable:nil];
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _descLbl.font = [FMFont setFontByPX:42];
        
        _nextIconImgView = [[UIImageView alloc] initWithImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
        
        _seperatorView = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_descLbl];
        [self.contentView addSubview:_nextIconImgView];
        [self.contentView addSubview:_seperatorView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat imageWidth = [FMSize getInstance].imgWidthLevel3;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    CGSize descSize = [FMUtils getLabelSizeByFont:[FMFont setFontByPX:42] andContent:[[BaseBundle getInstance] getStringByKey:@"cell_show_more_detail" inTable:nil] andMaxWidth:width];
    
    [_descLbl setFrame:CGRectMake(padding, (height-descSize.height)/2, descSize.width, descSize.height)];
    
    [_nextIconImgView setFrame:CGRectMake(width-padding-imageWidth, (height-imageWidth)/2, imageWidth, imageWidth)];
    
    [_seperatorView setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
}

+ (CGFloat)getItemHeight {
    CGFloat height = 0;
    height = 50;
    return height;
}

@end

