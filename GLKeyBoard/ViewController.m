//
//  ViewController.m
//  GLKeyBoard
//
//  Created by 高磊 on 2017/5/27.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "ViewController.h"

#import "GLKeyBoard.h"
#import "UITextField+GLKeyBoard.h"
#import <Masonry.h>
#import <IQKeyboardManager.h>

@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *textFiled;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    GLKeyBoard *keyBoard = [[GLKeyBoard alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, GTReViewXFloat(85))];
    
    _textFiled = [[UITextField alloc] init];
    _textFiled.delegate = (id)self;
    _textFiled.textColor = [UIColor orangeColor];
    _textFiled.borderStyle = UITextBorderStyleRoundedRect;
    _textFiled.placeholder = @"随便输...";
    _textFiled.inputView = keyBoard;
    [self.view addSubview:_textFiled];

    [_textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    //如果不需要
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    keyBoard.keyBoardClickBlock = ^(GLKeyBoardType keyBoardType, NSString *text) {
        switch (keyBoardType) {
            case GLKeyBoardOther:
            {
                [_textFiled updateText:text];
            }
                break;
            case GLKeyBoardDelete:
            {
                [_textFiled updateText:@""];
            }
                break;
            case GLKeyBoardClearAll:
            {
                _textFiled.text = @"";
            }
                break;
            default:
                break;
        }
    };
}
#pragma mark == UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //注册键盘出现与隐藏时候的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboadWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
}

#pragma mark == Nsnotication
//键盘出现时候调用的事件
-(void) keyboadWillShow:(NSNotification *)note{
    NSDictionary *info = [note userInfo];
    CGRect keyboardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];//键盘的frame

    keyboardFrame.origin.y = CGRectGetMaxY(_textFiled.frame) + 4.5;
    UIView *keyBoardView = [self findKeyboard];
    
    
    [UIView animateWithDuration:0.2 animations:^{
        [keyBoardView setFrame:keyboardFrame];
    }];
}


#pragma mark == private method

- (UIView *)findKeyboard
{
    UIView *keyboardView = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in [windows reverseObjectEnumerator])//逆序效率更高，因为键盘总在上方
    {
        keyboardView = [self findKeyboardInView:window];
        if (keyboardView)
        {
            return keyboardView;
        }
    }
    return nil;
}

- (UIView *)findKeyboardInView:(UIView *)view
{
    for (UIView *subView in [view subviews])
    {
        NSLog(@" 打印信息:%s",object_getClassName(subView));
        if (strstr(object_getClassName(subView), "UIInputSetHostView"))
        {
            return subView;
        }
        else
        {
            UIView *tempView = [self findKeyboardInView:subView];
            if (tempView)
            {
                return tempView;
            }
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
