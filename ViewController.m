//
//  ViewController.m
//  BothJustifiedLabel
//
//  Created by Ariel on 2017/6/27.
//  Copyright © 2017年 yr.demo.com. All rights reserved.
//

#import "ViewController.h"
#import "YRLabel.h"
#define SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define width SCREEN_WIDTH -20
@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YRLabel *label = [[YRLabel alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    label.linesSpacing= 2;
    [label setText:@"区块链的定义     区块链是一种“具有共享状态的加密安全的交易单例机。”让我们拆解一下。“加密安全”是指所创建的数字货币由复杂的数学算法来保证它的安全，这个算法很难被破解。想一下各种防火墙。他们几乎不可能欺骗系统，例如创造虚假交易、删除交易记录等。 “交易的单例机”是指有单个规范实例机负责所有在系统中创建的交易。换句话说，这里有一个所有人都相信的单一全球事实。“具有共享状态”是指存储在这个机器上的状态是共享的，向每个人公开。以太坊实现的是这种区块链的范式。"];
    label.font=[UIFont fontWithName:@"Heiti SC" size:16];
    CGFloat labelHeight = [label getAttributedStringHeightWidthValue:(SCREEN_WIDTH-20)];
//    label.textColor = [UIColor redColor];
    label.frame = CGRectMake(10, 100, width, labelHeight);
    [self.view addSubview:label];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
