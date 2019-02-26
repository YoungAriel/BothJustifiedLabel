//
//  YRLabel.m
//  BothJustifiedLabel
//
//  Created by Ariel on 2019/2/26.
//  Copyright © 2019 yr.demo.com. All rights reserved.
//

#import "YRLabel.h"
#import <CoreText/CoreText.h>

@interface YRLabel (){
@private
    NSMutableAttributedString *attributedString;
}
@end

@implementation YRLabel

- (id)initWithFrame:(CGRect)frame{
    //初始化字间距、行间距、段间距
    if(self =[super initWithFrame:frame]) {
        self.characterSpacing = 1.5f;
        self.linesSpacing = 4.0f;
        self.paragraphSpacing = 10.0f;
    }
    return self;
}

//外部调用设置字间距
- (void)setCharacterSpacing:(CGFloat)characterSpacing{
    _characterSpacing = characterSpacing;
    [self setNeedsDisplay];
}

- (void)setParagraphSpacing:(CGFloat)paragraphSpacing{
    _paragraphSpacing = paragraphSpacing;
    [self setNeedsDisplay];
    
}
//外部调用设置行间距
- (void)setLinesSpacing:(long)linesSpacing{
    _linesSpacing = linesSpacing;
    [self setNeedsDisplay];
}

/*
 *初始化AttributedString并进行相应设置
 */
- (void) initAttributedString{
    if(self.text){
        NSString *labelString = self.text;
        
        //创建AttributeString
        attributedString =[[NSMutableAttributedString alloc]initWithString:labelString];
        
        //设置字体及大小
        CTFontRef helveticaBold = CTFontCreateWithName((CFStringRef)self.font.fontName,self.font.pointSize,NULL);
        [attributedString addAttribute:(id)kCTFontAttributeName value:(__bridge id)helveticaBold range:NSMakeRange(0,[attributedString length])];
        
        CTTextAlignment alignment = kCTTextAlignmentJustified;
        CGFloat paragraphSpacing = 0.0;
        CGFloat paragraphSpacingBefore = 0.0;
        CGFloat firstLineHeadIndent = 0.0;
        CGFloat headIndent = 0.0;
        CGFloat SpecifierLineSpacing= self.linesSpacing;
        
        CTParagraphStyleSetting settings[] =
        {
            {kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &alignment},
            {kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &firstLineHeadIndent},
            {kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &headIndent},
            {kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing},
            {kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore},
            {kCTParagraphStyleSpecifierLineSpacingAdjustment,sizeof(CGFloat),&SpecifierLineSpacing}
            
        };
        
        CTParagraphStyleRef style = CTParagraphStyleCreate(settings ,8);
        
        //给文本添加设置
        [attributedString addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id)style range:NSMakeRange(0 , [attributedString length])];
        CFRelease(helveticaBold);
        CFRelease(style);
        //设置字体颜色
        [attributedString addAttribute:(id)kCTForegroundColorAttributeName value:(id)(self.textColor) range:NSMakeRange(0,[attributedString length])];
    }
}

/*
 *覆写setText方法
 */
- (void) setText:(NSString *)text
{
    [super setText:text];
}

/*
 *绘制
 */
- (void) drawTextInRect:(CGRect)requestedRect{
    [self initAttributedString];
    
    //排版
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    
    CGMutablePathRef leftColumnPath = CGPathCreateMutable();
    
    CGPathAddRect(leftColumnPath, NULL ,CGRectMake(0 , 0 ,self.bounds.size.width , self.bounds.size.height));
    
    CTFrameRef leftFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, 0), leftColumnPath , NULL);
    
    
    //翻转坐标系统（文本原来是倒的要翻转下）
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context , CGAffineTransformIdentity);
    
    CGContextTranslateCTM(context , 0 ,self.bounds.size.height);
    
    CGContextScaleCTM(context, 1.0 ,-1.0);
    
    //画出文本
    
    CTFrameDraw(leftFrame,context);
    
    //释放
    
    CGPathRelease(leftColumnPath);
    
    CFRelease(framesetter);
    
    UIGraphicsPushContext(context);
    CFRelease(leftFrame);
}

/*
 *绘制前获取label高度
 */
- (int)getAttributedStringHeightWidthValue:(int)width{
    [self initAttributedString];
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, width, 100000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    if (linesArray.count) {
        CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        
        total_height = 100000 - line_y + (int) descent +1;//+1为了纠正descent转换成int小数点后舍去的值
        
        CFRelease(textFrame);
        
        return total_height;
    }else
        return 0;
    
}

@end
