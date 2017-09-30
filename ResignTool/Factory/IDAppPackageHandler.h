//
//  IDAppPackageHandler.h
//  ResignTool
//
//  Created by Injoy on 2017/9/19.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDProvisioningProfile.h"

static NSString *kKeyBundleIDChange             = @"keyBundleIDChange";
static NSString *kCFBundleIdentifier            = @"CFBundleIdentifier";
static NSString *kCFBundleDisplayName           = @"CFBundleDisplayName";
static NSString *kCFBundleName                  = @"CFBundleName";
static NSString *kCFBundleShortVersionString    = @"CFBundleShortVersionString";
static NSString *kCFBundleVersion               = @"CFBundleVersion";
static NSString *kCFBundleIcons                 = @"CFBundleIcons";
static NSString *kCFBundlePrimaryIcon           = @"CFBundlePrimaryIcon";
static NSString *kCFBundleIconFiles             = @"CFBundleIconFiles";
static NSString *kCFBundleIconsipad             = @"CFBundleIcons~ipad";
static NSString *kMinimumOSVersion              = @"MinimumOSVersion";
static NSString *kPayloadDirName                = @"Payload";
static NSString *kInfoPlistFilename             = @"Info.plist";
static NSString *kEntitlementsPlistFilename     = @"Entitlements.plist";
static NSString *kCodeSignatureDirectory        = @"_CodeSignature";
static NSString *kEmbeddedProvisioningFilename  = @"embedded";
static NSString *kAppIdentifier                 = @"application-identifier";
static NSString *kTeamIdentifier                = @"com.apple.developer.team-identifier";
static NSString *kKeychainAccessGroups          = @"keychain-access-groups";
static NSString *kIconNormal                    = @"iconNormal";
static NSString *kIconRetina                    = @"iconRetina";

typedef void(^SuccessBlock)(id);
typedef void(^ErrorBlock)(NSString *errorString);
typedef void(^LogBlock)(NSString *logString);

@interface IDAppPackageHandler : NSObject

@property (strong, readonly) NSString *bundleDisplayName;
@property (strong, readonly) NSString *bundleID;
@property (strong, readonly) IDProvisioningProfile *embeddedMobileprovision;

/// 包的路径
@property (strong) NSString* packagePath;
/// 包解压的路径
@property (strong) NSString* workPath;
/// xxx.app 路径
@property (strong) NSString* appPath;

- (instancetype)initWithPackagePath:(NSString *)path;

/**
 解压
 
 @param success 成功
 @param error 失败
 */
- (void)unzipIpa:(void (^)(void))success error:(void (^)(NSString *error))error;

- (BOOL)removeCodeSignatureDirectory;


/**
 封装好的重签方法
 
 @param provisioningprofile 顾名思义
 @param certificateName 顾名思义
 @param bundleIdentifier 顾名思义
 @param displayName 顾名思义
 @param destinationPath 顾名思义
 @param logBlock 顾名思义
 @param errorBlock 顾名思义
 @param successBlock 顾名思义
 */
- (void)resignWithProvisioningProfile:(IDProvisioningProfile *)provisioningprofile
                          certificate:(NSString *)certificateName
                     bundleIdentifier:(NSString *)bundleIdentifier
                          displayName:(NSString *)displayName
                      destinationPath:(NSString *)destinationPath
                                  log:(LogBlock)logBlock
                                error:(ErrorBlock)errorBlock
                              success:(SuccessBlock)successBlock;

#pragma mark - 签名流程
- (void)createEntitlementsWithProvisioning:(IDProvisioningProfile *)provisioningprofile log:(LogBlock)logBlock error:(ErrorBlock)errorBlock success:(SuccessBlock)successBlock;

- (void)editInfoPlistWithIdentifier:(NSString *)bundleIdentifier displayName:(NSString *)displayName log:(LogBlock)logBlock error:(ErrorBlock)errorBlock success:(SuccessBlock)successBlock;

- (void)editEmbeddedProvision:(IDProvisioningProfile *)provisioningprofile log:(LogBlock)logBlock error:(ErrorBlock)errorBlock success:(SuccessBlock)successBlock;

- (void)doCodesign:(NSString *)certificateName log:(LogBlock)logBlock error:(ErrorBlock)errorBlock success:(SuccessBlock)successBlock;

- (void)zipPackageToDirPath:(NSString *)zipDirPath log:(LogBlock)logBlock error:(ErrorBlock)errorBlock success:(SuccessBlock)successBlock;

@end
