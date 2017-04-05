//
//  ClearableEditText.m
//  JieMianKuangJia
//
//  Created by admin on 15/4/8.
//  Copyright (c) 2015年 bill zhu. All rights reserved.
//

#import "ClearableEditText.h"
#import "FMImage.h"
#import "FMTheme.h"


@interface ClearableEditText()

@property(readwrite,nonatomic,strong) UITextField* contentTF;



@end

@implementation ClearableEditText


#pragma mark init
- (instancetype) init {
    self = [super init];
    if (self) {
        self.contentTF = [[UITextField alloc] init];
        
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self.contentTF setFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
    [self.contentTF setBackground:[[FMImage getInstance].textFieldBackgroundImg getImage]];
    
    UIButton*rightIcon = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    [rightIcon setBackgroundImage:[[FMTheme getInstance] getImageByName:@"delete1"] forState:UIControlStateNormal];
    [rightIcon addTarget:self
                  action:@selector(delete)
        forControlEvents:UIControlEventTouchUpInside];
    self.contentTF.rightView = rightIcon;
    
    self.contentTF.rightViewMode = UITextFieldViewModeWhileEditing;
    self.contentTF.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.contentTF.keyboardType = UIKeyboardTypeDefault;
    self.contentTF.secureTextEntry = NO;
    self.contentTF.keyboardType = UIKeyboardTypeDefault;
    [self addSubview:self.contentTF];

}


#pragma mark initWithFrame
- (instancetype) initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (self) {
        self.contentTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height)];
        [self.contentTF setBackground:[[FMTheme getInstance] getImageByName:@"background"]];
        
        UIButton*rightIcon = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
        [rightIcon setBackgroundImage:[[FMTheme getInstance] getImageByName:@"delete1"] forState:UIControlStateNormal];
        [rightIcon addTarget:self
                      action:@selector(delete)
            forControlEvents:UIControlEventTouchUpInside];
        self.contentTF.rightView = rightIcon;
        
        self.contentTF.rightViewMode = UITextFieldViewModeWhileEditing;
        self.contentTF.keyboardAppearance = UIKeyboardAppearanceAlert;
        self.contentTF.keyboardType = UIKeyboardTypeDefault;
        self.contentTF.secureTextEntry = NO;
        self.contentTF.keyboardType = UIKeyboardTypeDefault;
        [self addSubview:self.contentTF];
    }
    return self;
}

- (void) delete {
    self.contentTF.text = nil;
}

- (void) setPlaceHoler:(NSString *)str {
    [self.contentTF setPlaceholder:str];
}

- (void) setbackgroundimage:(UIImage *)image {
    [self.contentTF setBackground:image];
}

- (void) secureTextEntry:(BOOL)secure {
    [self.contentTF setSecureTextEntry:(BOOL )secure];
}

- (void) setKeyboard:(UIKeyboardType)keyboardType {
    [self.contentTF setKeyboardType:(UIKeyboardType )keyboardType];
}

- (void) setValue:(NSString *)value {
    self.contentTF.text = value;
}


- (NSString *) getValue {
    return self.contentTF.text;
}





@end
