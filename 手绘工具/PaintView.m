//
//  PaintView.m
//  手绘工具
//
//  Created by adai on 2019/3/20.
//  Copyright © 2019 adai. All rights reserved.
//

#import "PaintView.h"
#import "PaintStep.h"

#define swidth  [UIScreen mainScreen].bounds.size.width
#define sheight [UIScreen mainScreen].bounds.size.height

@interface PaintView ()

@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic, assign) CGFloat penWidth;

@end

@implementation PaintView

- (instancetype)init {
    if (self = [super init]) {
        [self paintSetup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self paintSetup];
    }
    return self;
}

- (void)paintSetup {
    self.backgroundColor = [UIColor whiteColor];
    self.lines = [NSMutableArray array];
    
    [self createColorBoard];
    [self createSlider];
}

- (void)createColorBoard {
    self.currentColor = [UIColor blackColor];
    
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, swidth, 20)];
    colorView.layer.borderWidth = 1.0;
    colorView.layer.borderColor = [UIColor blackColor].CGColor;
    colorView.backgroundColor = [UIColor whiteColor];
    [self addSubview:colorView];
    
    NSArray *colors = @[[UIColor whiteColor], [UIColor blackColor], [UIColor lightGrayColor],
                        [UIColor redColor], [UIColor greenColor], [UIColor blueColor],
                        [UIColor yellowColor], [UIColor magentaColor], [UIColor cyanColor],
                        [UIColor purpleColor], [UIColor brownColor], [UIColor orangeColor]];
    for (int i = 0; i < colors.count; i++) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        CGFloat btnW = swidth/colors.count;
        CGFloat btnH = 20;
        btn.frame = CGRectMake(i * btnW, 0, btnW, btnH);
        btn.backgroundColor = colors[i];
        [btn addTarget:self action:@selector(changeColor:) forControlEvents:(UIControlEventTouchUpInside)];
        [colorView addSubview:btn];
    }
    self.colorView = colorView;
}

- (void)createSlider {
    self.penWidth = 1;
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.colorView.frame) + 15, swidth, 20)];
    slider.maximumValue = 20;
    slider.minimumValue = 1;
    slider.backgroundColor = [UIColor whiteColor];
    [self addSubview:slider];
    [slider addTarget:self action:@selector(changeSlider:) forControlEvents:(UIControlEventValueChanged)];
    self.slider = slider;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 绘制路径
    for (int i = 0; i < self.lines.count; i++) {
        PaintStep *step = self.lines[i];
    
        CGMutablePathRef path = CGPathCreateMutable();
        
        for (int j = 0; j < step.steps.count; j++) {
            CGPoint point = [step.steps[j] CGPointValue];
            if (j == 0) {
                CGPathMoveToPoint(path, &CGAffineTransformIdentity, point.x, point.y);
            } else {
                CGPathAddLineToPoint(path, &CGAffineTransformIdentity, point.x, point.y);
            }
        }
        
        // 绘制颜色
        CGContextSetStrokeColorWithColor(ctx, step.penColor);
        // 绘制宽度
        CGContextSetLineWidth(ctx, step.penWidth);
        // 添加路径
        CGContextAddPath(ctx, path);
        // 描边
        CGContextStrokePath(ctx);
        // 释放
        CGPathRelease(path);
    }
}

#pragma mark - private method
- (void)changeColor:(UIButton *)button {
    self.currentColor = button.backgroundColor;
    self.slider.thumbTintColor = self.currentColor;
    self.slider.minimumTrackTintColor = self.currentColor;
}

- (void)changeSlider:(UISlider *)slider {
    self.penWidth = slider.value;
}

#pragma mark - public method
// 删除最后一步
- (void)backToLast {
    if (self.lines.count == 0) {
        return;
    }
    [self.lines removeLastObject];
    if (self.lines.count == 0) {
        [self clearPaintView];
    }
    [self setNeedsDisplay];
}

// 生成图片
- (UIImage *)renderToImage {
    if (self.lines.count == 0) {
        return nil;
    }
    
    // 图片size
    CGFloat y = CGRectGetMaxY(self.slider.frame) + 10;
    CGSize size = CGSizeMake(swidth, self.frame.size.height - y);
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 将多余部分截取
    CGRect rect = CGRectMake(0, y, size.width, size.height);
    CGContextClipToRect(ctx, rect);
    [self.layer renderInContext:ctx];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)clearAll {
    [self clearPaintView];
    if (self.lines.count == 0) {
        return;
    }
    [self.lines removeAllObjects];
    [self setNeedsDisplay];
}

- (void)clearPaintView {
    self.currentColor = [UIColor blackColor];
    
    [self.slider removeFromSuperview];
    [self createSlider];
    
    [self.slider setValue:1.0 animated:YES];
    self.penWidth = self.slider.value;
    //    self.slider.thumbTintColor = [UIColor whiteColor];
    //    self.slider.minimumTrackTintColor = [UIColor blueColor];
}

#pragma mark - touch process
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    PaintStep *step = [[PaintStep alloc] init];
    step.penColor = self.currentColor.CGColor;
    step.penWidth = self.penWidth;
    [self.lines addObject:step];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    PaintStep *step = self.lines.lastObject;
    // 获取点
    CGPoint point = [[touches anyObject] locationInView:self];
    
    [step.steps addObject:[NSValue valueWithCGPoint:point]];
    
    [self setNeedsDisplay];
}

@end
