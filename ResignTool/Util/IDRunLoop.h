//
//  IDRunLoop.h
//  ResignTool
//
//  Created by Injoy on 2017/9/19.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDRunLoop : NSObject

@property (nonatomic) BOOL isSuspend;

- (void)run:(void (^)(void))block;
- (void)stop:(void (^)(void))complete;

@end
