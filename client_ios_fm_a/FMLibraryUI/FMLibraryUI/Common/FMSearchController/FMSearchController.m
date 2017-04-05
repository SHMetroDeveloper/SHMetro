//
//  FMSearchController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/7.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "FMSearchController.h"
#import "FMUtilsPackages.h"
#import "SeperatorView.h"
#import "FMTheme.h"

@implementation SearchStoreEntity
@end


@interface FMSearchController () <UISearchResultsUpdating, UISearchBarDelegate,UITextFieldDelegate>
@property (nonatomic, strong) SeperatorView *seperator;
@property (nonatomic, strong) UITextField *searchTextField;
@end

@implementation FMSearchController

- (instancetype)initWithSearchResultsController:(nullable UIViewController *)searchResultsController {
    self = [super initWithSearchResultsController:searchResultsController];
    if (self) {
        
        self.searchResultsUpdater = self;
        self.dimsBackgroundDuringPresentation = NO;
        self.hidesNavigationBarDuringPresentation = NO;
        
        
        [self.searchBar sizeToFit];
        self.searchBar.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        self.searchBar.delegate = self;
        
        _searchTextField = [self.searchBar valueForKey:@"searchField"];
        if (_searchTextField) {
            [_searchTextField addTarget:self action:@selector(onSearchTextChanged) forControlEvents:UIControlEventEditingChanged];
        }
        
        _seperator = [[SeperatorView alloc] init];
        [_seperator setFrame:CGRectMake(0, self.searchBar.frame.size.height-[FMSize getInstance].seperatorHeight, self.searchBar.frame.size.width, [FMSize getInstance].seperatorHeight)];
        [self.searchBar addSubview:_seperator];
    }
    return self;
}



#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    _textChangeBlock([searchController.searchBar text]);
}


#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _actionBlock(FUZZY_SEARCH_ACTION_TYPE_DONE);
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _actionBlock(FUZZY_SEARCH_ACTION_TYPE_CANCEL);
}

#pragma mark - UITextFieldDelegate

- (void) onSearchTextChanged {
    if ([FMUtils isStringEmpty:_searchTextField.text]) {
//在清空所有的输入内容以后会取消self.searchBar的第一响应，慎用！！！
//        if (self.active) {
//            self.active = NO;
//            [self.searchBar removeFromSuperview];
//        }
//        _actionBlock(FUZZY_SEARCH_ACTION_TYPE_CANCEL);
    }
}

- (void)dealloc {
    if (self.active) {
        self.active = NO;
        [self.searchBar removeFromSuperview];
    }
}

@end

