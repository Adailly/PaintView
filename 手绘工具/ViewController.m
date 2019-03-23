//
//  ViewController.m
//  手绘工具
//
//  Created by adai on 2019/3/20.
//  Copyright © 2019 adai. All rights reserved.
//

#import "ViewController.h"
#import "PaintView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *lastStep;
@property (nonatomic, strong) PaintView *paint01;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat y = CGRectGetMaxY(self.lastStep.frame);
    CGFloat h = self.view.frame.size.height - y;
    self.paint01 = [[PaintView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, h)];
    [self.view addSubview:self.paint01];
}

- (IBAction)lastStep:(UIButton *)button {
    [self.paint01 backToLast];
}

- (IBAction)saveImage:(UIButton *)button {
    UIImage *image = [self.paint01 renderToImage];
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image: didFinishSavingWithError: contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        NSLog(@"保存成功");
    } else {
        NSLog(@"error: %@", error);
    }
}

- (IBAction)clearPaint:(UIButton *)button {
    [self.paint01 clearAll];
}

@end
