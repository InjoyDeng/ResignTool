//
//  IDFileHpler.h
//  ResignTool
//
//  Created by Injoy on 2017/9/11.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TEMP_PATH [NSTemporaryDirectory() stringByAppendingPathComponent:@"resign"]

@interface IDFileHpler : NSObject

/**
 单例
 */
+ (instancetype)sharedInstance;

/**
 是否存在支持重签的工具

 @return 如果成功，为空字符串
 */
- (NSArray *)lackSupportUtility;

/**
 获取证书名

 @param successBlock 返回证书
 @param errorBlock 错误日志
 */
- (void)getCertificatesSuccess:(void (^)(NSArray *certificateNames))successBlock error:(void (^)(NSString *error))errorBlock;

/**
 获取配置文件

 @return 配置文件数组
 */
- (NSArray *)getProvisioningProfiles;


/**
 解压

 @param filePath 压缩包路径
 @param dstPath 解压路径
 @param completeBlock 结果
 */
- (void)unzip:(NSString *)filePath toPath:(NSString *)dstPath complete:(void(^)(BOOL result))completeBlock;


/**
 压缩

 @param srcPath 待压缩的路径
 @param dstFilePath 压缩包保存路径
 @param completeBlock 结果
 */
- (void)zip:(NSString *)srcPath toPath:(NSString *)dstFilePath complete:(void(^)(BOOL result))completeBlock;

@end
