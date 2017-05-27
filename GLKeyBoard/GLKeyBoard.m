//
//  GLKeyBoard.m
//  GLKeyBoard
//
//  Created by 高磊 on 2017/5/27.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "GLKeyBoard.h"

#import <Masonry.h>

static CGFloat const kKeyBoardWidth = 33;
static CGFloat const kKeyBoardHeight = 35;

static CGFloat const kKeyBoardBigWidth = 41;


static CGFloat const kKeyBoardTopPadding = 5;
static CGFloat const kKeyBoardMiddlePadding = 35/9.0;
static CGFloat const kKeyBoardBottomMiddlePadding = 17/5.0;

static NSInteger const kKeyBoardTag = 1200;
static NSInteger const kKeyBoardNumber = 16;//键数量

/**
 *  颜色16进制
 */
#define UICOLOR_FROM_RGB_OxFF(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface GLKeyBoard ()
{
    UIButton *  _lastButton;//布局时保存按钮
}
@end

@implementation GLKeyBoard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeViewComponents];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initializeViewComponents];
    }
    return self;
}


#pragma mark == private method
- (void)initializeViewComponents
{
    self.backgroundColor =UICOLOR_FROM_RGB_OxFF(0xbfc5ca);
    
    NSArray *array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"千",@"万",@"十万",@"百万",@"Delete",@"清除",];
    
    for (int i = 0; i < kKeyBoardNumber; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = kKeyBoardTag + i;
        [button setBackgroundColor:UICOLOR_FROM_RGB_OxFF(0xfefefe)];
        if (i == kKeyBoardNumber-2) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:UICOLOR_FROM_RGB_OxFF(0xff4238)];
        }else{
            [button setTitleColor:UICOLOR_FROM_RGB_OxFF(0x303030) forState:UIControlStateNormal];
        }
        if (i > 9) {
            button.titleLabel.font = [UIFont systemFontOfSize:12];
        }else{
            button.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        
        button.layer.cornerRadius = 5;
        [button.layer setMasksToBounds:YES];
        
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(keyBoardClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        if (i == 0) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(GTReViewXFloat(kKeyBoardWidth), GTReViewXFloat(kKeyBoardHeight)));
                make.top.equalTo(@(GTReViewXFloat(kKeyBoardTopPadding)));
                make.left.equalTo(self.mas_left).offset(GTReViewXFloat(5));
            }];
            
            _lastButton = button;
        }else if(i < 10){
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(GTReViewXFloat(kKeyBoardWidth), GTReViewXFloat(kKeyBoardHeight)));
                make.top.equalTo(@(GTReViewXFloat(kKeyBoardTopPadding)));
                make.left.equalTo(_lastButton.mas_right).offset(GTReViewXFloat(kKeyBoardMiddlePadding));
            }];
            
            _lastButton = button;
        }else if(i == 10){
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(GTReViewXFloat(kKeyBoardBigWidth), GTReViewXFloat(kKeyBoardHeight)));
                make.top.equalTo(_lastButton.mas_bottom).offset((GTReViewXFloat(kKeyBoardTopPadding)));
                make.left.equalTo(self.mas_left).offset(GTReViewXFloat(5));
            }];
            _lastButton = button;
        }else if (i < 14 && i > 10){
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(GTReViewXFloat(kKeyBoardBigWidth), GTReViewXFloat(kKeyBoardHeight)));
                make.top.equalTo(_lastButton.mas_top);
                make.left.equalTo(_lastButton.mas_right).offset(GTReViewXFloat(kKeyBoardBottomMiddlePadding));
            }];
            _lastButton = button;
        }else if (i == 14){
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(GTReViewXFloat(100), GTReViewXFloat(kKeyBoardHeight)));
                make.top.equalTo(_lastButton.mas_top);
                make.left.equalTo(_lastButton.mas_right).offset(GTReViewXFloat(kKeyBoardBottomMiddlePadding));
            }];
            _lastButton = button;
            
        }else if (i == 15){
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(GTReViewXFloat(84), GTReViewXFloat(kKeyBoardHeight)));
                make.top.equalTo(_lastButton.mas_top);
                make.left.equalTo(_lastButton.mas_right).offset(GTReViewXFloat(kKeyBoardBottomMiddlePadding));
            }];
            _lastButton = button;
        }
    }
}

- (void)keyBoardClick:(UIButton *)sender
{
    NSInteger tag = sender.tag - kKeyBoardTag;
    switch (tag) {
        case 0:case 1:case 2:case 3:case 4:case 5:case 6:case 7:case 8:case 9:case 10:case 11:case 12:case 13:
        {
            if (self.keyBoardClickBlock) {
                self.keyBoardClickBlock(GLKeyBoardOther, sender.currentTitle);
            }
        }
            break;
        case 14:
        {
            if (self.keyBoardClickBlock) {
                self.keyBoardClickBlock(GLKeyBoardDelete, sender.currentTitle);
            }
        }
            break;
        case 15:{
            if (self.keyBoardClickBlock) {
                self.keyBoardClickBlock(GLKeyBoardClearAll, sender.currentTitle);
            }
        }
            break;
        default:
            break;
    }
}
@end
