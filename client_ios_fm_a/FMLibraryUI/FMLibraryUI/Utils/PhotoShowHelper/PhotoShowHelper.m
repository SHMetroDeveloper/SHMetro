//
//  PhotoShowHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/9.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "PhotoShowHelper.h"
#import "MWPhotoBrowser.h"
#import "FMUtils.h"
#import "PhotoItem.h"

@interface PhotoShowHelper () <MWPhotoBrowserDelegate>


@property (readwrite, nonatomic, strong) NSMutableArray * photos;

@property (readwrite, nonatomic, weak) BaseViewController * context;


@end

@implementation PhotoShowHelper

- (instancetype) initWithContext:(BaseViewController *) context {
    self = [super init];
    if(self) {
        _context = context;
    }
    return self;
}

//设置图片数据
- (void) setPhotos:(NSMutableArray *) photos {
    NSInteger count = [photos count];
    if(!_photos) {
        _photos = [[NSMutableArray alloc] init];
    } else {
        [_photos removeAllObjects];
    }
    for(NSInteger i = 0;i<count;i++) {
        id item = photos[i];
        if([item isKindOfClass:[NSURL class]]) {
            [_photos addObject:[MWPhoto photoWithURL:item]];
        } else if([item isKindOfClass:[NSString class]]) {
            UIImage * img = [FMUtils getImageWithName:item];
            [_photos addObject:[MWPhoto photoWithImage:img]];
        } else if([item isKindOfClass:[UIImage class]]) {
            [_photos addObject:[MWPhoto photoWithImage:item]];
        } else if([item isKindOfClass:[PhotoItem class]]) {
            PhotoItem * pItem = item;
            if([item isLocalPhoto]) {
                [_photos addObject:[MWPhoto photoWithImage:pItem.image]];
            } else {
                [_photos addObject:[MWPhoto photoWithURL:pItem.url]];
            }
        }
    }
}

//从 index 位置的图片开始展示
- (void) showPhotoWithIndex:(NSInteger) index {
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = YES;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:index];
    
    [_context gotoViewController:browser];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return NO;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    NSLog(@"Did finish modal presentation");
    [_context dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
    NSLog(@"action Button is clicked.");
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonAllPressed:(NSInteger) actionType {
    NSLog(@"action All Button is clicked.");
}

@end
