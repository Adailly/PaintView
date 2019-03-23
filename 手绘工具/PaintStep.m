//
//  PaintStep.m
//  手绘工具
//
//  Created by adai on 2019/3/20.
//  Copyright © 2019 adai. All rights reserved.
//

#import "PaintStep.h"

@implementation PaintStep

- (NSMutableArray *)steps {
    if (_steps == nil) {
        _steps = [NSMutableArray array];
    }
    return _steps;
}

@end
