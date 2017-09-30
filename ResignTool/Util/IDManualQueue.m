//
//  IDManualQueue.m
//  ResignTool
//
//  Created by Injoy on 2017/9/25.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "IDManualQueue.h"

@implementation IDManualQueue {
    NSMutableArray *operations;
}

- (instancetype)init {
    if (self = [super init]) {
        operations = @[].mutableCopy;
    }
    return self;
}

- (void)addOperation:(NSOperation *)operation {
    [operations addObject:operation];
}

- (void)next {
    if (operations.count > 0) {
        NSOperation *operation = [operations objectAtIndex:0];
        operation.completionBlock = ^{
            [operations removeObjectAtIndex:0];
        };
        
        [operation start];
    } else {
        if (self.noOperationPerform) {
            self.noOperationPerform();
        };
    }
}

- (void)cancelAll {
    [operations removeAllObjects];
}

@end
