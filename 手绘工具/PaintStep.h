//
//  PaintStep.h
//  手绘工具
//
//  Created by adai on 2019/3/20.
//  Copyright © 2019 adai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaintStep : NSObject

@property (nonatomic, strong) NSMutableArray *steps;
@property (nonatomic, assign) CGFloat penWidth;
@property (nonatomic, assign) CGColorRef penColor;

@end

NS_ASSUME_NONNULL_END
