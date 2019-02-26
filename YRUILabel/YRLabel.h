//
//  YRLabel.h
//  BothJustifiedLabel
//
//  Created by Ariel on 2019/2/26.
//  Copyright © 2019 yr.demo.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YRLabel : UILabel

@property(nonatomic,assign) CGFloat characterSpacing;//字间距
@property(nonatomic,assign) CGFloat paragraphSpacing;//行间距
@property(nonatomic,assign) long    linesSpacing;//段间距

/*
 *绘制前获取label高度
 */
- (int)getAttributedStringHeightWidthValue:(int)width;
@end

NS_ASSUME_NONNULL_END
