//
//  AttachmentViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/8/8.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "AttachmentViewController.h"
#import "FMUtilsPackages.h"
#import "ImageItemView.h"
#import "FMUtils.h"
#import "FMTheme.h"
#import "BaseBundle.h"

@interface AttachmentViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (readwrite, nonatomic, strong) ImageItemView * noticeLbl;   //提示
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;   //提示高度

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSURL *attachmentURL;

@end

@implementation AttachmentViewController

- (instancetype)initWithAttachmentURL:(NSURL *) attachmentUrl {
    self = [super init];
    if (self) {
        _attachmentURL = attachmentUrl;
    }
    return self;
}

- (void)initNavigation {
    [self setTitleWith:_fileName];
    [self setBackAble:YES];
}

- (void) setTitleByFileName:(NSString *) fileName {
    _fileName = fileName;
    [self updateNavi];
}

- (void) updateNavi {
    [self initNavigation];
    [self updateNavigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)initLayout {
    CGRect frame = [self getContentFrame];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, frame.size.width, 0)];
    _progressView.tintColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
    _progressView.trackTintColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    
    
    _webView = [[WKWebView alloc] initWithFrame:frame];
    _webView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    _webView.navigationDelegate = self;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
   
    [self.view addSubview:_webView];
    [self.view addSubview:_progressView];
}

#pragma mark - LazyLoad
- (ImageItemView *)noticeLbl {
    if (!_noticeLbl) {
        CGFloat height = [FMSize getInstance].screenContentHeight;
        CGFloat width = [FMSize getInstance].screenContentWidth;
        _noticeHeight = [FMSize getInstance].noticeHeight;
        
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (height-_noticeHeight)/2, width, _noticeHeight)];
        [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"load_fail" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        
        [_noticeLbl setHidden:YES];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
        
        [self.view addSubview:_noticeLbl];
    }
    return _noticeLbl;
}

- (void) loadFile {
    NSURL *url = _attachmentURL;
    NSString * mimeType = [FMUtils getMimeTypeByFileName:_fileName];
    if([mimeType isEqualToString:@"text/plain"]) {
        NSData * data = [NSData dataWithContentsOfURL:url];
        [_webView loadData:data MIMEType:mimeType characterEncodingName:@"UTF-8" baseURL:url];
    } else {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    }
}

#pragma mark - WKNavigationDelegates
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
    if (newprogress == 1) {
        _progressView.hidden = YES;
        [_progressView setProgress:0 animated:NO];
    } else {
        _progressView.hidden = NO;
        [_progressView setProgress:newprogress animated:YES];
    }
}

// 1 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

// 2 页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSData *fileData = [NSData dataWithContentsOfURL:webView.URL];
    if (fileData.length == 0) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"tips_title" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"load_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DIALOG_ALIVE_TIME_SHORT*1.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.noticeLbl.hidden = NO;
        });
    } else {
        /**
         *  声明一些加载成功后的事情
         */
        NSLog(@"加载成功");
    }
}

// 3 页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"tips_title" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_material_no_data" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
}

//在请求URL之前 先判断是否需要跳转页面或者跳转到其他应用
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end


