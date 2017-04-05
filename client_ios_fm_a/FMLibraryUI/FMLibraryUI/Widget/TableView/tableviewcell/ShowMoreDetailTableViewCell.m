//
//  ShowMoreDetailTableViewCell.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/3/28.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "ShowMoreDetailTableViewCell.h"
#import "SeperatorView.h"
#import "FMUtils.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMSize.h"

@interface ShowMoreDetailTableViewCell()

@property (nonatomic,assign) CGFloat seperatorHeight;
@property (nonatomic,assign) CGFloat showMoreHeight;
@property (nonatomic,strong) UIView * showMoreDetailView;
@property (nonatomic,strong) UILabel * descLbl;
@property (nonatomic,strong) UIImageView * showMoreImgView;
@property (nonatomic,strong) SeperatorView * seperatorView;
@end

@implementation ShowMoreDetailTableViewCell

- (void)setFrame:(CGRect)frame {
    frame.size.height -= _seperatorHeight;
    [super setFrame:frame];
    [self updateViews];
}

- (void) updateViews {
    CGRect frame = self.frame;
    if (!_showMoreDetailView) {
        _showMoreDetailView = [[UIView alloc] init];
        
        _descLbl = [[UILabel alloc] init];
        _descLbl.text = [[BaseBundle getInstance] getStringByKey:@"cell_show_more_detail" inTable:nil];
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _descLbl.font = [FMFont getInstance].defaultFontLevel2;
        _showMoreImgView = [[UIImageView alloc] initWithImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
        _seperatorView = [[SeperatorView alloc] init];
        
        [_showMoreDetailView addSubview:_descLbl];
        [_showMoreDetailView addSubview:_showMoreImgView];
        [_showMoreDetailView addSubview:_seperatorView];
        
        [self addSubview:_showMoreDetailView];
        
    } else {
        CGFloat padding = [FMSize getInstance].defaultPadding;
        CGFloat imageWidth = [FMSize getInstance].imgWidthLevel3;
        CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
        [_showMoreDetailView setFrame:CGRectMake(0, frame.size.height-_showMoreHeight, frame.size.width, _showMoreHeight)];
        
        CGSize lblSize = [FMUtils getLabelSizeBy:_descLbl andContent:[[BaseBundle getInstance] getStringByKey:@"cell_show_more_detail" inTable:nil] andMaxLabelWidth:frame.size.width];
        [_descLbl setFrame:CGRectMake(padding, (_showMoreHeight - lblSize.height)/2, lblSize.width, lblSize.height)];
        [_showMoreImgView setFrame:CGRectMake(frame.size.width - imageWidth - padding, (_showMoreHeight - imageWidth)/2, imageWidth, imageWidth)];
        [_seperatorView setFrame:CGRectMake(0, _showMoreHeight - seperatorHeight, frame.size.width, seperatorHeight)];
    }
    
    if(_showMoreHeight > 0) {
        [_showMoreDetailView setHidden:NO];
    } else {
        [_showMoreDetailView setHidden:YES];
    }
    
    if(_seperatorHeight > 0) {
        [_seperatorView setHidden:NO];
    } else {
        [_seperatorView setHidden:YES];
    }
}

- (void)setSeperatorHeight:(CGFloat)seperatorHeight andShowMoreHeight:(CGFloat) showMoreHeight {
    _seperatorHeight = seperatorHeight;
    _showMoreHeight = showMoreHeight;
}

- (void) onShowMoreBtnClick {
    NSLog(@"go to detailVC to show more detail ");
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
