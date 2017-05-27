//
//  GLKeyBoard.h
//  GLKeyBoard
//
//  Created by 高磊 on 2017/5/27.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import <UIKit/UIKit.h>

//屏幕适配
CG_INLINE CGFloat
GTReViewXFloat(CGFloat x) {
    CGRect sreenBounds = [UIScreen mainScreen].bounds;
    CGFloat scale  = sreenBounds.size.width/375;
    return scale*x;
}


/**
 键盘按钮类型
 
 - GuessBetListKeyBoardClearAll: 清除
 - GuessBetListKeyBoardDelete: 删除
 - GuessBetListKeyBoardOther: 0-9  千 万 十万 百万
 */
typedef NS_ENUM(NSInteger,GLKeyBoardType) {
    GLKeyBoardClearAll,
    GLKeyBoardDelete,
    GLKeyBoardOther
};


typedef void(^KeyBoardClickBlcok)(GLKeyBoardType keyBoardType, NSString *text);

@interface GLKeyBoard : UIView

@property (nonatomic,copy) KeyBoardClickBlcok keyBoardClickBlock;

@end
