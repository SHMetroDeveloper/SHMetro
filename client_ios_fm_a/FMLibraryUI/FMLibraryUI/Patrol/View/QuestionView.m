//
//  QuestionView.m
//  JieMianKuangJia
//
//  Created by 杨帆 on 28/4/14.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "QuestionView.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "SeperatorView.h"
#import "BaseTextField.h"
#import "BaseLabelView.h"
#import "MWPhotoBrowser.h"
#import "FMFont.h"
#import "FMSize.h"
#import "BasePhotoView.h"

#import "LineTextField.h"
#import "PhotoItem.h"


@interface QuestionView () <UITextViewDelegate,OnMessageHandleListener>

@property (readwrite, nonatomic, strong) UILabel * mTitleLbl;

@property (readwrite, nonatomic, strong) UIView * bottomContainerView;
@property (readwrite, nonatomic, strong) UIButton * editButton;
@property (readwrite, nonatomic, strong) UIButton * photoButton;

@property (readwrite, nonatomic, strong) BaseRadioBoxView * radioGroup;  //单选
@property (readwrite, nonatomic, strong) NSMutableArray * radioButtonArray ;

@property (readwrite, nonatomic, strong) LineTextField * inputTF; //输入
@property (readwrite, nonatomic, strong) UILabel * commentTv; //问题备注
@property (readwrite, nonatomic, strong) BasePhotoView * photoView;

@property (readwrite, nonatomic, strong) SeperatorView * seperator;
@property (readwrite, nonatomic, strong) SeperatorView * seperatorDot;


@property (readwrite, nonatomic, strong) UIFont* mFont;
@property (readwrite, nonatomic, strong) NSString* title;           //标题
@property (readwrite, nonatomic, assign) NSInteger valueType;       //值的类型，输入或者单选，默认为输入
@property (readwrite, nonatomic, strong) NSMutableArray* values;    //如果类型为单选的话，此项为可选的值
@property (readwrite, nonatomic, strong) NSString* content;         //内容
@property (readwrite, nonatomic, strong) NSString* desc;            //备注
@property (readwrite, nonatomic, strong) NSMutableArray* imagePathArray;    //图片

@property (readwrite, nonatomic, assign) CGFloat titleHeight;
@property (readwrite, nonatomic, assign) CGFloat radioItemHeight;
@property (readwrite, nonatomic, assign) CGFloat radioSepHeight;

@property (readwrite, nonatomic, assign) CGFloat itemHeight;
@property (readwrite, nonatomic, assign) CGFloat inputHeight;
@property (readwrite, nonatomic, assign) CGFloat minHeight;
@property (readwrite, nonatomic, assign) CGFloat defaultMinHeight;
@property (readwrite, nonatomic, assign) CGFloat photoItemHeight;   //图片高度



@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, weak) BaseViewController * photodelagete;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end


@implementation QuestionView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        [self initViews];
        
        [self updateViews];
    }
    return self;
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
    
        _radioItemHeight = 20;
        _radioSepHeight = [FMSize getInstance].padding40;
        _titleHeight = 30;
        
        _itemHeight = 20;
        _inputHeight = 40;
        _minHeight = 180;
        _defaultMinHeight = 180;
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = _paddingLeft;
        _photoItemHeight = 110;
        
        _mTitleLbl = [[UILabel alloc] init];
        _mTitleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _mTitleLbl.font = [FMFont getInstance].font42;
        _mTitleLbl.numberOfLines = 0;
        if(_title) {
            _mTitleLbl.text = _title;
        }
        
        _bottomContainerView = [[UIView alloc] init];
        
        _imagePathArray = [[NSMutableArray alloc] init];
        _radioButtonArray = [[NSMutableArray alloc] init];
        
        _editButton = [[UIButton alloc] init];
        _photoButton = [[UIButton alloc] init];
        
        _commentTv = [[UILabel alloc] init];
        _commentTv.font = [FMFont getInstance].font42;
        _commentTv.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _commentTv.numberOfLines = 0;
        
        
        _seperator = [[SeperatorView alloc] init];
        
        _seperatorDot = [[SeperatorView alloc] init];
        
        
        //照片显示View
        _photoView = [[BasePhotoView alloc] init];
        [_photoView setOnMessageHandleListener:self];
        [_photoView setPhotosWithArray:_imagePathArray];
        [_photoView setEditable:YES];
        [_photoView setEnableAdd:NO];
        [_photoView setShowType:PHOTO_SHOW_TYPE_ALL_LINES];
        _photoView.hidden = YES;
        
        
        _inputTF = [[LineTextField alloc] init];
        _inputTF.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _inputTF.font = [FMFont getInstance].font42;
        [_inputTF setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE]];
        [_inputTF setLineColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
        [_inputTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"input_here" inTable:nil]];
        [_inputTF addTarget:self action:@selector(onInputValueChanged) forControlEvents:UIControlEventEditingChanged];
        
        [_editButton setImage:[[FMTheme getInstance] getImageByName:@"patrol_edit"] forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(onEditButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_photoButton setImage:[[FMTheme getInstance] getImageByName:@"patrol_photo"] forState:UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(onPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_bottomContainerView addSubview:_editButton];
        [_bottomContainerView addSubview:_photoButton];
        
        _radioGroup = [[BaseRadioBoxView alloc] init];
        [_radioGroup setOnValueChangedListener:self];
        
        [self addSubview:_mTitleLbl];
        [self addSubview:_inputTF];
        [self addSubview:_radioGroup];
        [self addSubview:_bottomContainerView];
        [self addSubview:_commentTv];
        [self addSubview:_photoView];
        [self addSubview:_seperator];
        [self addSubview:_seperatorDot];
    }
}

- (void) updateViews {
    
    CGRect frame = self.frame;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat imgWidth = 32;
    CGFloat imgHeight = 32;
    CGFloat seperatorheight = [FMSize getInstance].seperatorHeight;
    CGFloat sepHeight = [FMSize getInstance].defaultPadding;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat photoHeight = 0;
    
    CGFloat originX = padding;
    CGFloat originY = sepHeight;
    CGFloat titleHeight = 0;
    
    
    titleHeight = [FMUtils heightForStringWith:_mTitleLbl value:_title andWidth:width-padding*2];
    if(titleHeight < _titleHeight) {
        titleHeight = _titleHeight;
    }
    [_mTitleLbl setFrame:CGRectMake(originX, originY, width-padding*2, titleHeight)];
    originY += titleHeight + sepHeight;
    
    CGFloat groupHeight = 0;
    if(_valueType == QUESTION_VIEW_VALUE_TYPE_SINGLE_SELECT) {
        
        [_inputTF setHidden:YES];
        [_radioGroup setHidden:NO];
        for(NSString * radioLabel in _values) {
            if(![FMUtils isStringEmpty:radioLabel]) {
                if([_content isEqual:radioLabel]) {
                    [_radioGroup setSelectIndex:[_values indexOfObject:radioLabel]];
                    break;
                }
            }
        }
        groupHeight = [BaseRadioBoxView calculateHeightByCount:[_values count]];
        [_radioGroup setInfoWith:_values];
        [_radioGroup setFrame:CGRectMake(0, originY, width, groupHeight)];
        originY += groupHeight + [FMSize getInstance].padding80;
    } else {
        [_inputTF setHidden:NO];
        [_radioGroup setHidden:YES];
        if(!_inputTF) {
            _inputTF = [[LineTextField alloc] initWithFrame:CGRectMake(originX, originY, width-padding*2, _inputHeight)];
            [self addSubview:_inputTF];
        } else {
            [_inputTF setFrame:CGRectMake(originX, originY, width-padding*2, _inputHeight)];
            
        }
        originY += _inputHeight + [FMSize getInstance].padding80;
    }

    [_seperator setFrame:CGRectMake(0, originY, width, seperatorheight)];
    originY += seperatorheight;
    
    CGFloat bottomContainerHeight = imgHeight + [FMSize getInstance].padding60*2;
    [_bottomContainerView setFrame:CGRectMake(0, originY, width, bottomContainerHeight)];
    
    [_editButton setFrame:CGRectMake((width-imgWidth*2)/3, (bottomContainerHeight - imgHeight)/2, imgWidth, imgHeight)];
    
    [_photoButton setFrame:CGRectMake((width-imgWidth*2)/3*2+imgWidth, (bottomContainerHeight - imgHeight)/2, imgWidth, imgHeight)];
    
    originY += bottomContainerHeight;
    
    
    if(![FMUtils isStringEmpty:_desc]) {
        [_commentTv setHidden:NO];
        CGSize commentSize = [FMUtils getLabelSizeBy:_commentTv andContent:_desc andMaxLabelWidth:width-padding*2];
        [_commentTv setFrame:CGRectMake(originX, originY, width-padding*2, commentSize.height)];
        originY += commentSize.height + [FMSize getInstance].padding50;
    } else {
        [_commentTv setHidden:YES];
    }
    
    
    _photoView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
    if(_imagePathArray && [_imagePathArray count] > 0) {
        _seperatorDot.hidden = NO;
        [_seperatorDot setDotted:YES];
        [_seperatorDot setFrame:CGRectMake(padding, originY, width-padding*2, seperatorheight)];
        photoHeight = [BasePhotoView calculateHeightByCount:[_imagePathArray count] width:width-padding*2 addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
        _photoView.hidden = NO;
        
        [_photoView setPhotosWithArray:_imagePathArray];
        [_photoView setFrame:CGRectMake(originX, originY, width-padding*2, photoHeight)];
    } else {
        _seperatorDot.hidden = YES;
        photoHeight = 0;
        _photoView.hidden = YES;
    }
}

- (void)  setInfoWithtitle:(NSString*) title
                 valueType:(NSInteger) type
                   content:(NSString*) content
           valuesForSelect:(NSArray *) values
                      desc:(NSString*) desc
                 imageUrls:(NSMutableArray *) imagePathArray {
    _title = title;
    switch(type) {
        case QUESTION_VIEW_VALUE_TYPE_SINGLE_SELECT:
            _valueType = QUESTION_VIEW_VALUE_TYPE_SINGLE_SELECT;
            break;
        case QUESTION_VIEW_VALUE_TYPE_INPUT:
            _valueType = QUESTION_VIEW_VALUE_TYPE_INPUT;
            break;
        default:    //默认为输入类型
            _valueType = QUESTION_VIEW_VALUE_TYPE_INPUT;
            break;
    }
    if(_valueType == QUESTION_VIEW_VALUE_TYPE_SINGLE_SELECT) {
        _values = [NSMutableArray arrayWithArray:values];
    }
    _content = content;
    _desc = desc;
    
    
    if (!_imagePathArray) {
        _imagePathArray = [NSMutableArray new];
    } else {
        [_imagePathArray removeAllObjects];
    }
    if (imagePathArray.count > 0) {
        for (NSInteger count = 0 ; count < imagePathArray.count; count++) {
            UIImage * image = [FMUtils getImageWithName:imagePathArray[count]];
            if(image) {
                [_imagePathArray addObject:image];
            } else {
                PhotoItem * item = [[PhotoItem alloc] init];
                [item setImage:nil];
                [_imagePathArray addObject:item];
            }
        }
    }
//    _imagePathArray = imagePathArray;
    
    if(imagePathArray && [imagePathArray count] > 0) {
        [_photoView setPhotosWithArray:_imagePathArray];
    }
    
    [self updateInfo];
}


- (void) setShowBound:(BOOL) showBound {
    if(showBound) {
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        self.layer.cornerRadius = [FMSize getInstance].defaultBorderRadius;
    } else {
        self.layer.borderColor = [[UIColor clearColor] CGColor];
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        self.layer.cornerRadius = [FMSize getInstance].defaultBorderRadius;
    }
}

- (void) updateInfo {
    
    _mTitleLbl.text = _title;
    
    if(_valueType == QUESTION_VIEW_VALUE_TYPE_INPUT) {
        if(_content) {
            _inputTF.text = _content;
        }
    }
    if(![FMUtils isStringEmpty:_desc]) {
        [_commentTv setText:_desc];
    }
    
    [self updateViews];
}


#pragma - 点击事件
- (void) onEditButtonClick {
    [self notifyEnvent:QUESTION_VIEW_EVENT_EDIT data:nil];
}

- (void) onPhotoButtonClick {
    [self notifyEnvent:QUESTION_VIEW_EVENT_TAKE_PHOTO data:nil];
}


#pragma - 输入框输入事件

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@".0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    if(number.length > 1) {
       if([[number substringWithRange:NSMakeRange(0, 1)] isEqual:@"0"]) {
           if(![[number substringWithRange:NSMakeRange(1, 1)] isEqual:@"."]) {
               res = NO;
           }
       }
    }
    
    return res;
}

#pragma - textView

- (void) onValueChanged:(UIView *)view type:(NSInteger)valueType value:(id)value {
    if(view == _radioGroup) {
        NSNumber * selectedIndex = value;
        NSString * selectedValue = _values[selectedIndex.integerValue];
        [self notifyEnvent:QUESTION_VIEW_EVENT_VALUE_CHANGE_SINGLE_SELECT data:selectedValue];
    }
}


- (void) onInputValueChanged {
    NSString * value = _inputTF.text;
    [self notifyEnvent:QUESTION_VIEW_EVENT_VALUE_CHANGE_INPUT data:value];
    
}

- (void) onCommentValueChanged {
//    QuestionViewValueType valueType = QUESTION_VIEW_VALUE_TYPE_COMMENT;
//    NSString * value = [_commentTv setContent:<#(NSString *)#>];
//    if(_valueListener) {
//        [_valueListener onValueChanged:self type:valueType value:value];
//    }
}


//解析从BasePhotoView发送过来的点击图片位置信息
- (void)handleMessage:(id)msg {
    if (msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([BasePhotoView class])]) {
            NSNumber * tmpNumber = [msg valueForKeyPath:@"msgType"];
            PhotoActionType type = [tmpNumber integerValue];
            
            switch (type) {
                case PHOTO_ACTION_SHOW_DETAIL:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    [self notifyShowPhoto:tmpNumber.integerValue];
                    break;
                case PHOTO_ACTION_DELETE:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    [self notifyDeletePhoto:tmpNumber.integerValue];
                    break;
                case PHOTO_ACTION_TAKE_PHOTO:
                    NSLog(@"照片添加");
                    break;
            }
        }
    }
}
//由此View向外发送点击图片的位置信息和数组信息
- (void) setOnMessageHandleListener:(id)handler {
    _handler = handler;
}

- (void) notifyEnvent:(QuestionViewEventType) type data:(id) data {
    if (_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
        [msg setValue:[NSNumber numberWithInteger:type] forKeyPath:@"msgType"];
        [msg setValue:[NSNumber numberWithInteger:self.tag] forKeyPath:@"tag"];
        [msg setValue:data forKeyPath:@"result"];
        [_handler handleMessage:msg];
    }
}

//通知显示大图
- (void) notifyShowPhoto:(NSInteger) position {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSNumber numberWithInteger:position] forKeyPath:@"position"];
    [dict setValue:_imagePathArray forKeyPath:@"photosArray"];
    [self notifyEnvent:QUESTION_VIEW_EVENT_SHOW_PHOTO data:dict];
}

//通知删除图片
- (void) notifyDeletePhoto:(NSInteger) position {
    [self notifyEnvent:QUESTION_VIEW_EVENT_DELETE_PHOTO data:[NSNumber numberWithInteger:position]];
}


//计算高度
+ (CGFloat) getMinHeightByTitle:(NSString *) title andDesc:(NSString *) desc andWidth:(CGFloat) width photoCount:(NSInteger) photoCount andSelectValueCount:(NSInteger) count {
    CGFloat height = 0;
    CGFloat photoHeight = 0;
    CGFloat inputHeight = 40;
    CGFloat sepHeight = [FMSize getInstance].defaultPadding;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat titleHeight = 0;
    CGFloat imgHeight = 31;
    CGFloat defaultTitleHeight = 30;
    CGFloat bottomContainerHeight = imgHeight + [FMSize getInstance].padding60*2;
    UIFont * font = [FMFont getInstance].font42;
    
    if(![FMUtils isStringEmpty:title]) {
        UILabel * tmpLbl = [[UILabel alloc] init];
        tmpLbl.font = font;
        tmpLbl.numberOfLines = 0;
        titleHeight = [FMUtils heightForStringWith:tmpLbl value:title andWidth:width-padding*2];
    }
    if(titleHeight < defaultTitleHeight) {
        titleHeight = defaultTitleHeight;
    }
    
    height = sepHeight + titleHeight + [FMSize getInstance].padding80*2 + bottomContainerHeight;
    
    if(count > 0) {
        height += [BaseRadioBoxView calculateHeightByCount:count];
    } else {
        height += inputHeight;
    }
    
    if(![FMUtils isStringEmpty:desc]) {
        UILabel * commentTv = [[UILabel alloc] init];
        commentTv.font = font;
        commentTv.numberOfLines = 0;
        commentTv.text = desc;
        
        CGSize commentSize = [FMUtils getLabelSizeBy:commentTv andContent:commentTv.text andMaxLabelWidth:width-padding*2];
        
        height += commentSize.height;
    }
    
    if (photoCount > 0) {
        photoHeight = [BasePhotoView calculateHeightByCount:photoCount width:width-padding*2 addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
        height += photoHeight + [FMSize getInstance].padding50;
    }
    
    return height;
    
}




@end
