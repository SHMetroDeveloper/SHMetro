//
//  LegalWebViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/6/21.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "LegalWebViewController.h"
#import "BaseBundle.h"

@interface LegalWebViewController () <UIWebViewDelegate>

@property (readwrite, nonatomic, strong) UIWebView * mainContentView;
@property (readwrite, nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation LegalWebViewController

- (instancetype) init {
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_setting_legal" inTable:nil]];
    [self setBackAble:YES];
}

- (void) initLayout {
    CGRect frame = [self getContentFrame];
    _mainContentView = [[UIWebView alloc] initWithFrame:frame];
    [_mainContentView setDelegate:self];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [_activityIndicator setCenter:self.view.center];
    [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [_activityIndicator setHidden:YES];
    
    [self.view addSubview:_mainContentView];
//    [self.view addSubview:_activityIndicator];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self gotoUrl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//开始加载数据
- (void)webViewDidStartLoad:(UIWebView *)webView {
//    [activityIndicator startAnimating];
    NSLog(@"页面开始加载。");
    [_activityIndicator setHidden:YES];
}

//数据加载完
- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    [activityIndicator stopAnimating];
//    UIView *view = (UIView *)[self.view viewWithTag:103];
//    [view removeFromSuperview];
    NSLog(@"页面加载完成。");
    [_activityIndicator setHidden:NO];
}

- (void) gotoUrl {
//    NSString * strurl = @"http://m.daz.la/";
//    NSString * strPath = [self getPathOfLegal];
    NSURL * url = [self getPathOfLegal];
    
    [_mainContentView loadRequest:[NSURLRequest requestWithURL:url]];
//     [_mainContentView loadHTMLString:strPath baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

- (NSURL *) getPathOfLegal {
//    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
//    
//    NSString *filePath =[resourcePath stringByAppendingPathComponent:@"web/legal.html"];
//    
//    //encoding:NSUTF8StringEncoding error:nil 这一段一定要加，不然中文字会乱码
//    
//    NSString* htmlstring = [[NSString alloc] initWithContentsOfFile:filePath  encoding:NSUTF8StringEncoding error:nil];
//    return htmlstring;
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"legal" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    return url;
    
}

@end
