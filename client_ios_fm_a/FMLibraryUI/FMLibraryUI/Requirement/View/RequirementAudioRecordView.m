//
//  RequirementAudioRecordView.m
//  client_ios_fm_a
//
//  Created by Master on 16/7/6.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "RequirementAudioRecordView.h"
#import "FMUtilsPackages.h"
#import "CellForAudioRecordView.h"

@interface RequirementAudioRecordView() <OnItemClickListener>

@property (nonatomic, strong) NSMutableArray *audioRecordArray;
@property (nonatomic, strong) NSMutableArray *durationTimesArray;

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat itemHeight;

@property (nonatomic, assign) BOOL isInited;

@property (nonatomic, assign) id<OnItemClickListener> clickListener;

@end


@implementation RequirementAudioRecordView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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
    if (!_isInited) {
        _isInited = YES;
        
        _itemHeight = 40;
        
        _audioRecordArray = [NSMutableArray new];
    }
}

- (void) setDurationTimesArray:(NSMutableArray<NSNumber *> *) durationArray{
    _count = durationArray.count;
    if (!_durationTimesArray) {
        _durationTimesArray = [NSMutableArray new];
    }
    _durationTimesArray = [durationArray copy];
    
    [self updateViews];
}


- (void) updateViews {
    CGFloat width = CGRectGetWidth(self.frame);
    
    CGFloat sepHeight = 5;
    CGFloat originY = 0;
    CGFloat originX = 0;
    for (NSInteger index = 0; index < _count; index ++) {
        CellForAudioRecordView *audioRecord;
        if (index < _audioRecordArray.count) {
            audioRecord = _audioRecordArray[index];
            [audioRecord setEditable:NO];
            audioRecord.hidden = NO;
        }
        else {
            audioRecord = [[CellForAudioRecordView alloc] init];
            [audioRecord setEditable:NO];
            [audioRecord setOnItemClickListener:self];
            [_audioRecordArray addObject:audioRecord];
            audioRecord.tag = index;
            [self addSubview:audioRecord];
        }
        
        [audioRecord setEditable:NO];
        [audioRecord setFrame:CGRectMake(originX, originY, width, _itemHeight)];
        originY += _itemHeight + sepHeight;
        
        
        NSNumber * time = _durationTimesArray[index];
        [audioRecord setDuriationTime:time];
    }
}

- (void)onItemClick:(UIView *)view subView:(UIView *)subView {
    if ([view isKindOfClass:[CellForAudioRecordView class]]) {
        NSLog(@"The tag is %ld",view.tag);
        [self notifyClickOnIndex:view.tag];
    }
}

- (void) notifyClickOnIndex:(NSInteger ) index {
    if (_clickListener) {
        [_clickListener onItemClick:self subView:_audioRecordArray[index]];
    }
}

- (void) setOnItemClickListener:(id<OnItemClickListener>)listener {
    _clickListener = listener;
}



+ (CGFloat) calculateAudioRecordViewHeightByCount:(NSInteger) count {
    CGFloat height = 0;
    CGFloat itemHeight = 40;
    CGFloat sepHeight = 5;
    
    height = itemHeight * count + sepHeight * count;
    
    return height;
}


@end






