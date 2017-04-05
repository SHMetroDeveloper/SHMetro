//
//  BasePhotoView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/1.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BasePhotoView.h"
#import "BasePhotoCell.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "PhotoItemView.h"
#import "PhotoItem.h"
#import "HorizontalFlowLayout.h"
#import "BaseBundle.h"


@interface BasePhotoView () <UICollectionViewDelegate, UICollectionViewDataSource, OnItemClickListener>

@property (readwrite, nonatomic, strong) UICollectionView * photoCollectionView;

@property (readwrite, nonatomic, strong) HorizontalFlowLayout * horizontalLayout;
@property (readwrite, nonatomic, strong) UICollectionViewFlowLayout * flowLayout;

@property (readwrite, nonatomic, strong) NSMutableArray * photos;

@property (readwrite, nonatomic, strong) UIImage * editImg;
@property (readwrite, nonatomic, strong) UIImage * editImgHighlight;

@property (readwrite, nonatomic, assign) BOOL editable;
@property (readwrite, nonatomic, assign) BOOL enableAdd;
//@property (readwrite, nonatomic, assign) BOOL showAll;

@property (readwrite, nonatomic, assign) PhotoShowType showType;

@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, assign) NSInteger column;


@end

@implementation BasePhotoView

- (instancetype) init {
    self = [super init];
    if(self) {
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

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if(!_isInited) {
        
        _isInited = YES;
        
        _enableAdd = YES;   //
        _showType = PHOTO_SHOW_TYPE_ALL_LINES;
        
        _editImg = [[FMTheme getInstance] getImageByName:@"pick_img"];
        _editImgHighlight = [[FMTheme getInstance] getImageByName:@"pick_img_highlight"];
        
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _horizontalLayout = [[HorizontalFlowLayout alloc] init];
        _photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:_horizontalLayout];
        
        
        _photoCollectionView.delaysContentTouches = NO;
        _photoCollectionView.delegate = self;
        _photoCollectionView.dataSource = self;
        _photoCollectionView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
//        _photoCollectionView.showsVerticalScrollIndicator = NO;
//        _photoCollectionView.scrollEnabled = NO;
        
        [_photoCollectionView registerClass:[BasePhotoCell class] forCellWithReuseIdentifier:@"PhotoCell"];
        
        
        [self addSubview:_photoCollectionView];
        [self updateScrollStyle];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    [_photoCollectionView setFrame:CGRectMake(0, 0, width, height)];
}

- (void) updateInfo {
    [_photoCollectionView reloadData];
}

//更新滚动方式
- (void) updateScrollStyle {
    switch(_showType) {
        case PHOTO_SHOW_TYPE_ALL_LINES:
//            _photoCollectionView.showsHorizontalScrollIndicator = NO;
//            _photoCollectionView.scrollEnabled = NO;
            [_photoCollectionView setCollectionViewLayout:_flowLayout animated:NO];
            break;
        case PHOTO_SHOW_TYPE_ALL_ONE_LINE:
//            _photoCollectionView.showsHorizontalScrollIndicator = YES;
//            _photoCollectionView.scrollEnabled = YES;
            [_photoCollectionView setCollectionViewLayout:_horizontalLayout animated:NO];
            break;
        case PHOTO_SHOW_TYPE_SOME_ONE_LINE:
//            _photoCollectionView.showsHorizontalScrollIndicator = NO;
//            _photoCollectionView.scrollEnabled = NO;
            [_photoCollectionView setCollectionViewLayout:_flowLayout animated:NO];
            break;
    }
}


//设置图片数组
- (void) setPhotosWithArray:(NSMutableArray *) array {
    if(!_photos) {
        _photos = [[NSMutableArray alloc] init];
    } else {
        [_photos removeAllObjects];
    }
    _photos = [NSMutableArray arrayWithArray:array];
    [self updateInfo];
}

//添加图片
- (void) addPhoto:(UIImage *) img {
    if(!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    [_photos addObject:img];
}

//设置是否可编辑
- (void) setEditable:(BOOL) editable {
    _editable = editable;
    if(_editable) {
//        _showAll = YES;
//        _showType = PHOTO_SHOW_TYPE_ALL_LINES;  //显示所有图片，多行显示
//        [self updateScrollStyle];
    }
}

//设置是否允许拍照
- (void) setEnableAdd:(BOOL)enableAdd {
    _enableAdd = enableAdd;
}

//设置展示方式
- (void) setShowType:(PhotoShowType) type {
    _showType = type;
    [self updateScrollStyle];
    [self updateInfo];
}

//设置是否显示边框
- (void) setShowBound:(BOOL) show {
    if(show) {
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
    } else {
        self.layer.borderWidth = 0;
    }
}

//设置上下边距
- (void) setPaddingTop:(CGFloat) paddingTop paddingBottom:(CGFloat) paddingBottom {
    _paddingTop = paddingTop;
    _paddingBottom = paddingBottom;
}


- (void) notifyMessageWithType:(PhotoActionType) type data:(id) data {
    if(_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
        [msg setValue:[NSNumber numberWithInteger:type] forKeyPath:@"msgType"];
        [msg setValue:[NSNumber numberWithInteger:self.tag] forKeyPath:@"tag"];
        if(data) {
            [msg setValue:data forKeyPath:@"result"];
        }
        [_handler handleMessage:msg];
    }
};

- (void) notifyPhotoItemClicked:(NSInteger) position {
    PhotoActionType type = PHOTO_ACTION_SHOW_DETAIL;
    NSNumber * data = [NSNumber numberWithInteger:position];
    [self notifyMessageWithType:type data:data];
}

- (void) notifyPhotoItemDeleted:(NSInteger) position {
    PhotoActionType type = PHOTO_ACTION_DELETE;
    NSNumber * data = [NSNumber numberWithInteger:position];
    [self notifyMessageWithType:type data:data];
}

- (void) notifyTakePhoto {
    PhotoActionType type = PHOTO_ACTION_TAKE_PHOTO;
    [self notifyMessageWithType:type data:nil];
}

//
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

//获取要展示的数据项个数
- (NSInteger) getShowCount:(CGFloat) width {
    NSInteger count = [_photos count];
    if (_enableAdd) {    //如果可拍照的话最后一张显示选择图片的按钮
        count += 1;
    }
    if(_showType == PHOTO_SHOW_TYPE_SOME_ONE_LINE) { //只显示一行
        NSInteger maxCount = [BasePhotoView getColumnCountWith:width];
        if(count > maxCount) {
            count = maxCount;
        }
    }
    return count;
}

#pragma mark - delegate, datasource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger count = 1;
    return count;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    CGFloat width = CGRectGetWidth(collectionView.frame);
    NSInteger count = [self getShowCount:width];
    return count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BasePhotoCell * cell;
    NSString * cellIdentity = @"PhotoCell";
    NSInteger position = indexPath.row;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentity forIndexPath:indexPath];
    UIImage * img;
    UIImage * imgHighlight;
    CGFloat width = CGRectGetWidth(collectionView.frame);
    NSInteger column  = [BasePhotoView getColumnCountWith:width];
    CGFloat paddingLeft = 15;
    id item;
    BOOL isCamera = NO;  //是否为拍照按钮
    [cell setCelltype:BASE_PHOTO_CELL_TYPE_IMAGE];
    if(_showType == PHOTO_SHOW_TYPE_ALL_LINES || _showType == PHOTO_SHOW_TYPE_ALL_ONE_LINE) {
        if(position < [_photos count]) {
            item = _photos[position];
            [cell setEditable:_editable];
        } else if(_enableAdd){
            img = _editImg;
            imgHighlight = _editImgHighlight;
            isCamera = YES;
            [cell setCelltype:BASE_PHOTO_CELL_TYPE_BUTTON];
            [cell setEditable:NO];
        }
        [cell setOnItemClickListener:self];
    } else if(_showType == PHOTO_SHOW_TYPE_SOME_ONE_LINE){
        NSInteger maxCount = [BasePhotoView getColumnCountWith:width];
        if(_enableAdd) {
            maxCount -= 1;
        }
        if([_photos count] > maxCount-1 && position == maxCount - 1) {    //显示数量
            id fitem = _photos[0];
            NSString * strCount = [[NSString alloc] initWithFormat:[[BaseBundle getInstance] getStringByKey:@"photo_count_format" inTable:nil], [_photos count]];
            if(fitem && [fitem isKindOfClass:[PhotoItem class]]) {
                PhotoItem * tmp = fitem;
                if(tmp.origin == PHOTO_ORIGIN_AUDIO || tmp.origin == PHOTO_ORIGIN_VIDEO) {
                    strCount = [[NSString alloc] initWithFormat:[[BaseBundle getInstance] getStringByKey:@"audio_count_format" inTable:nil], [_photos count]];
                }
            }
            [cell setText:strCount];
            [cell setEditable:NO];
        } else {
            if(position < maxCount - 1) {   //图片
                item = _photos[position];
                [cell setEditable:_editable];
            } else {                        //添加按钮
                [cell setEditable:NO];
            }
        }
        [cell setOnItemClickListener:self];
    }
    
    [cell setTag:position];
    if(!img) {
        if(item) {
            if([item isKindOfClass:[UIImage class]]) {
                img = item;
            } else if([item isKindOfClass:[PhotoItem class]]) {
                [cell setPhotoItem:item];
            } else if ([item isKindOfClass:[NSURL class]]) {
                [cell setPhotoUrl:item];
            }
        }
    }
    if(img) {
        [cell setPhoto:img];
    }
    if(imgHighlight) {
        [cell setPhotoHighlight:imgHighlight];
    }
    if(position % column == 0) {
        [cell setPaddingLeft:paddingLeft paddingRight:0];
    }else {
        [cell setPaddingLeft:0 paddingRight:0];
    }
    return cell;
}


- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    if (_editable) {
        if(position < [_photos count]) {
            [self notifyPhotoItemClicked:position];
        } else if(_enableAdd){
            [self notifyTakePhoto];
        }
    } else {
        [self notifyPhotoItemClicked:position];
    }
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = CGRectGetWidth(collectionView.frame);
    NSInteger position = indexPath.row;
    CGFloat itemWidth = [BasePhotoView getItemWidthWith:width index:position];
    CGFloat itemHeight = [BasePhotoView getItemWidthWith:width index:0];
    CGSize size = CGSizeMake(itemWidth, itemHeight);
    
    return size;
}

//设定指定区内Cell的最小行距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat spaceHeight = 0;
    return spaceHeight;
}

//设定指定区内Cell的最小间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat spaceHeight = 0;
    return spaceHeight;
}

#pragma mark - 点击事件
- (void)onItemClick:(UIView *)view subView:(UIView *)subView {
    if([view isKindOfClass:[PhotoItemView class]] || [view isKindOfClass:[UIButton class]]) {
        NSInteger position = view.tag;
        if(subView) {
            PhotoItemViewType type = subView.tag;
            if(type == PHOTO_ITEM_VIEW_TYPE_DELETE) {
                [self notifyPhotoItemDeleted:position];
            } else {
                [self notifyPhotoItemClicked:position];
            }
        } else {
            if(_editable && _enableAdd && position == [_photos count]) {
                [self notifyTakePhoto];
            } else if(position < [_photos count]){
                [self notifyPhotoItemClicked:position];
            }
        }
    }
}

#pragma mark - 高度计算
//显示列数
+ (NSInteger) getColumnCountWith:(CGFloat) width {
    NSInteger column = 0;
    if(width > 320) {
        column = 4;
    } else {
        column = 3;
    }
    return column;
}

//计算每一项的宽度
+ (CGFloat) getItemWidthWith:(CGFloat) width index:(NSInteger) index {
    CGFloat itemWidth = 0;
    CGFloat padding = 0;
    CGFloat paddingLeft = 15;
    NSInteger column = [self getColumnCountWith:width];
    itemWidth = (width-paddingLeft - padding * (column + 1))/column;
    itemWidth = (NSInteger) itemWidth;
    if(index % column == 0) {
        itemWidth += paddingLeft;
    }
    return itemWidth;
}

//计算图片展示所需要的高度
+ (CGFloat) calculateHeightByCount:(NSInteger) count width:(CGFloat) width addAble:(BOOL)enableAdd showType:(PhotoShowType)type {
    CGFloat height = 0;
    if(enableAdd) {
        count += 1;
    }
    NSInteger column = [BasePhotoView getColumnCountWith:width];
    NSInteger row = (count + (column - 1)) / column;//向上取整
    if(type == PHOTO_SHOW_TYPE_SOME_ONE_LINE || type == PHOTO_SHOW_TYPE_SOME_ONE_LINE) {
        row = 1;
    }
    if(row > 0) {
        CGFloat itemWidth = [BasePhotoView getItemWidthWith:width index:0];
        height = itemWidth * row;
    }
    return height;
}

@end
