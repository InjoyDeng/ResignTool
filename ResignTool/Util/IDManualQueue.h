//
//  IDManualQueue.h
//  ResignTool
//
//  Created by Injoy on 2017/9/25.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDManualQueue : NSObject

- (void)addOperation:(NSOperation *)operation;

- (void)next;
- (void)cancelAll;

@property (nonatomic, copy) void(^noOperationPerform)(void);

@end
