//
//  PaintView.h
//  手绘工具
//
//  Created by adai on 2019/3/20.
//  Copyright © 2019 adai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaintView : UIView

- (void)backToLast;

- (void)clearAll;

- (UIImage *)renderToImage;

@end

NS_ASSUME_NONNULL_END
