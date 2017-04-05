//
//  TestFirstViewController.m
//  client_ios_fm_a
//
//  Created by flynn.yang on 2017/2/22.
//  Copyright © 2017年 facilityone. All rights reserved.
//

#import "TestFirstViewController.h"

@interface TestFirstViewController ()

@property (readwrite, nonatomic, strong) UILabel * testLbl;

@end

@implementation TestFirstViewController

- (instancetype) init {
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (void) initViews {
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat itemHeight = 40;
    CGFloat originX = 100;
    
    _testLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, originX, width, itemHeight)];
    _testLbl.textAlignment = NSTextAlignmentCenter;
    _testLbl.textColor = [UIColor blackColor];
    _testLbl.text = NSStringFromClass([self class]);
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_testLbl];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
