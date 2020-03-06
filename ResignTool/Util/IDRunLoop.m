//
//  IDRunLoop.m
//  ResignTool
//
//  Created by Injoy on 2017/9/19.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "IDRunLoop.h"

@implementation IDRunLoop

- (instancetype)init {
    if (self = [super init]) {
        self.isSuspend = NO;
    }
    return self;
}

-(void)run:(void (^)(void))block {
    self.isSuspend = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_TIME_NOW, 0), ^{
        while (!self.isSuspend) {
            block();
            [[NSRunLoop currentRunLoop] runMode:NSRunLoopCommonModes beforeDate:[NSDate distantFuture]];
        }
    });
}

- (void)stop:(void (^)(void))complete {
    self.isSuspend = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        complete();
    });
}

@end
