//
//  BulletinReadStateCollectionView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/10.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "BulletinReadStateCollectionView.h"
#import "BulletinReaderCollectionViewCell.h"
#import "FMUtilsPackages.h"

@interface BulletinReadStateCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat itemWidth;

@end

@implementation BulletinReadStateCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        _dataArray = [NSMutableArray new];
        _page = [[NetPage alloc] init];
        _page.pageSize = [NSNumber numberWithInteger:20];
        _dataType = BULLETIN_READ_STATE_DATA_TYPE_UNREAD;
        
        _realWidth = CGRectGetWidth(frame);
        _itemWidth = 50;
        
        self.delegate = self;
        self.dataSource = self;
        self.alwaysBounceVertical = YES;
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        [self registerClass:[BulletinReaderCollectionViewCell class] forCellWithReuseIdentifier:@"cellIndentifier"];
        
        self.mj_footer = [FMLoadMoreFooterView footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreToTableView)];
        self.mj_footer.automaticallyChangeAlpha = YES;
        
        
    }
    
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = [NSMutableArray arrayWithArray:dataArray];
    [self reloadData];
}


#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = [_dataArray count];
    
    return count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = (self.frame.size.width)/4;
    CGFloat itemHeight = itemWidth + 20 + 19;
    
    return CGSizeMake(itemWidth, itemHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIndentifier";
    BulletinReaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[BulletinReaderCollectionViewCell alloc] init];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (cell && [cell isKindOfClass:[BulletinReaderCollectionViewCell class]]) {
        NSInteger position = indexPath.row;
        BulletinReceiver *reader = _dataArray[position];
        BulletinReaderCollectionViewCell *consumerCell = (BulletinReaderCollectionViewCell *)cell;
        
        //每个cell的padding_total = 20+2 + 15+2
        if (position%4 == 0) {  //每行第一个
            [consumerCell setPaddingLeft:20+2];
            [consumerCell setPaddingRight:15+2];
        } else if (position%4 == 1){
            [consumerCell setPaddingLeft:18.33+2];
            [consumerCell setPaddingRight:16.67+2];
        } else if (position%4 == 2){
            [consumerCell setPaddingLeft:16.67+2];
            [consumerCell setPaddingRight:18.33+2];
        } else if (position%4 == 3) {  //每行最后一个
            [consumerCell setPaddingLeft:15+2];
            [consumerCell setPaddingRight:20+2];
        }

        consumerCell.imageId = reader.photoId;
        consumerCell.name = reader.name;
        consumerCell.projectName = reader.projectName;
    }
}

//每个section的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    //    return [FMSize getInstance].seperatorHeight;
    return 0;
}

//行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    //    return [FMSize getInstance].seperatorHeight;
    return 0;
}



#pragma mark - UICollectionView 点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}

- (void) LoadMoreToTableView {
    _loadMoreBlock();
}

@end
