//
//  PhotoTakeAndDisplayView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/18.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PhotoTakeAndDisplayView.h"

#import "FMUtils.h"
#import "FMSize.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+BootStrap.h"
#import "PhotoItem.h"
#import "PhotoItemView.h"


@interface PhotoTakeAndDisplayView () <OnItemClickListener>

//@property (readwrite, nonatomic, strong) UIButton * cameraBtn;      //拍照按钮
@property (readwrite, nonatomic, strong) iCarousel * photosListView;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;

@property (readwrite, nonatomic, assign) CGFloat cameraWidth;       //拍照图片宽度

@property (readwrite, nonatomic, strong) NSMutableArray * photos;   //图片数组
@property (readwrite, nonatomic, strong) NSMutableArray * pathArray;//图片路径数组
@property (readwrite, atomic, strong) NSMutableArray * photoImageViewArray;   //图片数组

@property (readwrite, nonatomic, assign) CGFloat imgWidth;       //删除图片宽度

@property (readwrite, nonatomic, assign) CGFloat itemHeight;       //列表高度
@property (readwrite, nonatomic, assign) BOOL editable;       //是否可编辑

@property (readwrite, nonatomic, strong) NSCondition* mlock;       //异步锁

@property (readwrite, nonatomic, weak) id<OnPhotoItemClickListener> photoListener;
@property (readwrite, nonatomic, weak) id<OnItemClickListener> editListener;

@end

@implementation PhotoTakeAndDisplayView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initSettings];
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initSettings {
    _cameraWidth = 32;
    _imgWidth = 44;
    _paddingLeft = [FMSize getInstance].defaultPadding;
    _paddingRight = _paddingLeft;
    _paddingTop = [FMSize getInstance].defaultPadding;
    _paddingBottom = 0;
    _itemHeight = 100;
    
    _mlock = [[NSCondition alloc] init];
}

- (void) initViews {
    
    _photosListView = [[iCarousel alloc] init];
    _photosListView.type = iCarouselTypeLinear;
    _photosListView.vertical = NO;
    _photosListView.clipsToBounds = YES;
    
    _photosListView.dataSource = self;
    _photosListView.delegate = self;
    

    [self addSubview:_photosListView];
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat originY = _paddingTop;
    if(width == 0 || height == 0) {
        return;
    }
    [_photosListView setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft*2, _itemHeight)];
    [self updateInfo];
}

- (void) updateInfo {
    
}

//- (void) setInfoWithPhotos:(NSMutableArray *) photos {
//    _photos = [photos copy];
//    if([_photos count] > 3) {
//        [_photosListView setScrollEnabled:YES];
//    } else {
//        [_photosListView setScrollEnabled:NO];
//    }
//    if(_photos && [_photos count] > 0) {
//        if(!_photoImageViewArray) {
//            _photoImageViewArray = [[NSMutableArray alloc] init];
//        } else {
//            [_photoImageViewArray removeAllObjects];
//        }
//        NSInteger index = 0;
//        CGFloat itemWidth = _itemHeight*5/6;
//        for(UIImage * image in _photos) {
//            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, _itemHeight)];
//            imageView.backgroundColor = [FMColor getInstance].mainLightGray;
//            imageView.contentMode = UIViewContentModeScaleToFill;
//            imageView.bounds = CGRectMake(0, 0, itemWidth, _itemHeight);
//            imageView.userInteractionEnabled = YES;
//            [imageView setImage:image];
//            
//            if(_editable) {
//                UIButton * btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(0, _itemHeight*2/3, itemWidth, _itemHeight/3)];
//                [btnDelete setBackgroundColor:[FMColor getInstance].mainTransparentGray];
//                
//                UIImage * imgDelete = [UIImage imageNamed:@"icon_delete_red"];
//                UIImageView * imgDeleteView = [[UIImageView alloc] initWithFrame:CGRectMake((itemWidth - _imgWidth-_paddingRight), (_itemHeight/3 - _imgWidth)/2, _imgWidth, _imgWidth)];
//                [imgDeleteView setImage:imgDelete];
//                [btnDelete addSubview:imgDeleteView];
//                
//                btnDelete.tag = index;
//                [btnDelete addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//                [imageView addSubview:btnDelete];
//            }
//            index++;
//            [_photoImageViewArray addObject:imageView];
//        }
//    }
//    [self updatePhotos];
//}

- (void) setInfoWithPhotoPathArray:(NSMutableArray *) pathArray {
    _pathArray = pathArray;
    if([_pathArray count] > 3) {
        [_photosListView setScrollEnabled:YES];
    } else {
        [_photosListView setScrollEnabled:NO];
    }
    [self performSelectorInBackground:@selector(loadPhotoAsync) withObject:nil];
}

- (void) updatePhotos {
    [_photosListView reloadData];
    [self update];
}

//异步加载图片
- (void) loadPhotoAsync {
    if(_pathArray && _pathArray) {
        [_mlock lock];
        if(!_photos) {
            _photos = [[NSMutableArray alloc] init];
        } else {
            [_photos removeAllObjects];
        }
        if(!_photoImageViewArray) {
            _photoImageViewArray = [[NSMutableArray alloc] init];
        } else {
            [_photoImageViewArray removeAllObjects];
        }
        CGFloat itemWidth = _itemHeight*5/6;
        CGSize size = CGSizeMake(itemWidth, _itemHeight);
        NSInteger index = 0;
        for(id item in _pathArray) {
            PhotoItemView * imageView = [[PhotoItemView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, _itemHeight)];
            [imageView setOnItemClickListener:self];
            if([item isKindOfClass:[PhotoItem class]]) {
                [imageView setInfoWithPhotoItem:item];
            } else if([item isKindOfClass:[NSString class]]) {
                NSString * path = (NSString *) item;
                UIImage * image = [FMUtils getImageWithName:path];
                if(image) {
                    [imageView setInfoWithImage:[FMUtils thumbnailWithImage:image size:size]];
                    [_photos addObject:image];
                }
            } else if([item isKindOfClass:[UIImage class]]) {
                UIImage * image = (UIImage *) item;
                if(image) {
                    [_photos addObject:image];
                    [imageView setInfoWithImage:image];
                }
            } else if([item isKindOfClass:[NSURL class]]) {
                NSURL * url = (NSURL *) item;
                [imageView setInfoWithUrl:url];
            }
            [imageView setEditable:_editable];
            
            imageView.tag = index;
            [_photoImageViewArray addObject:imageView];
            index++;
        }
        [_mlock unlock];
        [self performSelectorOnMainThread:@selector(updatePhotos) withObject:nil waitUntilDone:NO];
    }
}

- (void) update {
    _photosListView.currentItemIndex = 1;
}

- (void) setPaddingLeft:(CGFloat)paddingLeft paddingRight:(CGFloat) paddingRight paddingTop:(CGFloat) paddingTop paddingBottom:(CGFloat) paddingBottom {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    _paddingTop = paddingTop;
    _paddingBottom = paddingBottom;
    [self updateViews];
}
- (void) setEditable:(BOOL) editable {
    _editable = editable;
    [self updateViews];
}
- (NSMutableArray *) getPhotos {
    return _photos;
}

- (void) setOnPhotoItemClickListener:(id<OnPhotoItemClickListener>) listener {
    _photoListener = listener;
}

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    _editListener = listener;
}


-(void)deleteButtonClicked:(id )sender {
    UIButton * btnDelete = sender;
    if(_editable && _editListener) {
        [_editListener onItemClick:self subView:btnDelete];
    }
}

- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if([view isKindOfClass:[PhotoItemView class]]) {
        NSInteger position = view.tag;
        if(subView) {
            PhotoItemViewType type = subView.tag;
            switch (type) {
                case PHOTO_ITEM_VIEW_TYPE_DELETE:
                    if(_editable && _editListener) {
                        [_editListener onItemClick:self subView:view];
                    }
                    break;
                    
                default:
                    if(_photoListener) {
                        [_photoListener onPhotoItemClick:self position:position];
                    }
                    break;
            }
        } else {
            if(_photoListener) {
                [_photoListener onPhotoItemClick:self position:position];
            }
        }
    }
}


#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    NSInteger count = (NSInteger)[_photoImageViewArray count];
    if(count > 0 && count < 3) {
        count = 3;
    }
    return count;
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if(index >= 0 && index < [_photoImageViewArray count]) {
        view = _photoImageViewArray[index];
    }
    return view;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 0;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _itemHeight, _itemHeight)];
        //        ((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
        view.backgroundColor = [UIColor grayColor];
        view.contentMode = UIViewContentModeCenter;
        
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50.0f];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = (index == 0)? @"[": @"]";
    
    return view;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * _photosListView.itemWidth);
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (_photosListView.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        {
            return value;
        }
        case iCarouselOptionVisibleItems:
        {//iCarouselOptionVisibleItems
            return value;
        }
    }
}

//- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
//    return 80;
//}

#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if(_photoListener) {
        [_photoListener onPhotoItemClick:self position:index];
    }
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    NSLog(@"Index: %@", @(_photosListView.currentItemIndex));
}



@end
