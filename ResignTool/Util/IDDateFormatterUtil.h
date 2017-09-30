//
//  IDDateFormatterUtil.h
//  ResignTool
//
//  Created by Injoy on 2017/9/19.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDDateFormatterUtil : NSObject

@property (strong, nonatomic, readonly) NSDateFormatter *dateFormatter;

+ (instancetype)sharedFormatter;

- (NSString *)timestampForDate:(NSDate *)date;

- (NSString *)MMddHHmmssSSSForDate:(NSDate *)date;

@end

