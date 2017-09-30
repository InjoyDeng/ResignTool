//
//  IDFileHpler.m
//  ResignTool
//
//  Created by Injoy on 2017/9/11.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "IDFileHpler.h"
#import "IDProvisioningProfile.h"
#import "IDRunLoop.h"

static const NSString *kMobileprovisionDirName = @"Library/MobileDevice/Provisioning Profiles";

@implementation IDFileHpler {
    // 全局文件管理
    NSFileManager *manager;
    // provisionprofile 的扩展名
    NSArray *provisionExtensions;
}

static IDFileHpler *istance;

+ (instancetype)sharedInstance {
    @synchronized(self) {
        if(istance == nil) {
            istance = [[IDFileHpler alloc] init];
            return istance;
        }
    }
    return istance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        manager = [NSFileManager defaultManager];
        provisionExtensions = @[@"mobileprovision", @"provisionprofile"];
        
    }
    return self;
}

- (NSArray *)lackSupportUtility {
    NSMutableArray *result = @[].mutableCopy;
    
    if (![manager fileExistsAtPath:@"/usr/bin/zip"])
        [result addObject:@"/usr/bin/zip"];
    
    if (![manager fileExistsAtPath:@"/usr/bin/unzip"])
        [result addObject:@"/usr/bin/unzip"];
    
    if (![manager fileExistsAtPath:@"/usr/bin/codesign"])
        [result addObject:@"/usr/bin/codesign"];
    
    return result.copy;
}

#pragma mark - Certificates
- (void)getCertificatesSuccess:(void (^)(NSArray *))successBlock error:(void (^)(NSString *error))errorBlock {
    NSTask *certTask = [[NSTask alloc] init];
    [certTask setLaunchPath:@"/usr/bin/security"];
    [certTask setArguments:[NSArray arrayWithObjects:@"find-identity", @"-v", @"-p", @"codesigning", nil]];
    NSPipe *pipe = [NSPipe pipe];
    [certTask setStandardOutput:pipe];
    [certTask setStandardError:pipe];
    NSFileHandle *handle = [pipe fileHandleForReading];
    [certTask launch];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 检查 KeyChain 中是否有证书，然后把证书保存到 self.certificatesArray
        NSString *securityResult = [[NSString alloc] initWithData:[handle readDataToEndOfFile] encoding:NSASCIIStringEncoding];
        if (securityResult == nil || securityResult.length < 1) return;
        NSArray *rawResult = [securityResult componentsSeparatedByString:@"\""];
        NSMutableArray *tempGetCertsResult = [NSMutableArray arrayWithCapacity:20];
        for (int i = 0; i <= [rawResult count] - 2; i += 2) {
            if (!(rawResult.count - 1 < i + 1)) {
                // 有效的
                [tempGetCertsResult addObject:[rawResult objectAtIndex:i+1]];
            }
        }
        
        __block NSMutableArray *certificatesArray = [NSMutableArray arrayWithArray:tempGetCertsResult];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (certificatesArray.count > 0) {
                if (successBlock != nil)
                    successBlock(certificatesArray.copy);
            } else {
                if (errorBlock != nil)
                    errorBlock(@"There aren't Signign Certificates");
            }
        });
    });
}

#pragma mark - ProvisioningProfile
- (NSArray *)getProvisioningProfiles
{
    NSArray *provisioningProfiles = [manager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), kMobileprovisionDirName] error:nil];
    provisioningProfiles = [provisioningProfiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@", provisionExtensions]];
    
    NSMutableArray *provisioningArray = @[].mutableCopy;
    [provisioningProfiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *path = (NSString*)obj;
        BOOL isDirectory;
        if ([manager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), kMobileprovisionDirName, path] isDirectory:&isDirectory]) {
            IDProvisioningProfile *profile = [[IDProvisioningProfile alloc] initWithPath:[NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), kMobileprovisionDirName, path]];
            if ([profile.debug isEqualToString:@"NO"])
                [provisioningArray addObject:profile];
        }
    }];
    
    provisioningArray = [[provisioningArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [((IDProvisioningProfile *)obj1).name compare:((IDProvisioningProfile *)obj2).name];
    }] mutableCopy];
    
    return provisioningArray.copy;
}

#pragma mark - Unzip
- (void)unzip:(NSString *)filePath toPath:(NSString *)dstPath complete:(void (^)(BOOL))completeBlock {
    if (![manager fileExistsAtPath:filePath]) completeBlock(NO);
    
    NSTask *unzipTask = [[NSTask alloc] init];
    [unzipTask setLaunchPath:@"/usr/bin/unzip"];
    [unzipTask setArguments:[NSArray arrayWithObjects:@"-q", filePath, @"-d", dstPath, nil]];
    [unzipTask launch];
    
    IDRunLoop *runloop = [IDRunLoop new];
    [runloop run:^{
        if ([unzipTask isRunning] == 0) {
            [runloop stop:^{
                int terminationStatus = unzipTask.terminationStatus;
                if (terminationStatus == 0) {
                    if ([manager fileExistsAtPath:dstPath]) {
                        completeBlock(YES);
                    }
                } else {
                    completeBlock(NO);
                }
            }];
        }
    }];
}

#pragma mark - zip
- (void)zip:(NSString *)srcPath toPath:(NSString *)dstFilePath complete:(void (^)(BOOL))completeBlock {
    NSTask *zipTask = [[NSTask alloc] init];
    [zipTask setLaunchPath:@"/usr/bin/zip"];
    [zipTask setCurrentDirectoryPath:srcPath];
    [zipTask setArguments:@[@"-qry", dstFilePath, @"."]];
    [zipTask launch];

    IDRunLoop *runloop = [IDRunLoop new];
    [runloop run:^{
        if ([zipTask isRunning] == 0) {
            [runloop stop:^{
                int terminationStatus = zipTask.terminationStatus;
                if (terminationStatus == 0) {
                    if ([manager fileExistsAtPath:dstFilePath]) {
                        completeBlock(YES);
                    } else {
                        completeBlock(NO);
                    }
                } else {
                    completeBlock(NO);
                }
            }];
        }
    }];
}

@end
