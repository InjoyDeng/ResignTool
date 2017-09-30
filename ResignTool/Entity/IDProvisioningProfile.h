//
//  IDProvisioningProfile.h
//  ResignTool
//
//  Created by Injoy on 2017/9/11.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDProvisioningProfile : NSObject

- (id)initWithPath:(NSString *)path;

@property (nonatomic, strong, readonly) NSString    *name;
@property (nonatomic, strong, readonly) NSString    *teamName;
@property (nonatomic, strong, readonly) NSString    *valid;
@property (nonatomic, assign, readonly) NSString    *debug;
@property (nonatomic, strong, readonly) NSDate      *creationDate;
@property (nonatomic, strong, readonly) NSDate      *expirationDate;
@property (nonatomic, strong, readonly) NSString    *UUID;
@property (nonatomic, strong, readonly) NSArray     *devices;
@property (nonatomic, assign, readonly) NSInteger   timeToLive;
@property (nonatomic, strong, readonly) NSString    *applicationIdentifier;
@property (nonatomic, strong, readonly) NSString    *bundleIdentifier;
@property (nonatomic, strong, readonly) NSArray     *certificates;
@property (nonatomic, assign, readonly) NSInteger   version;
@property (nonatomic, assign, readonly) NSArray     *prefixes;
@property (nonatomic, strong, readonly) NSString    *appIdName;
@property (nonatomic, strong, readonly) NSString    *teamIdentifier;
@property (nonatomic, strong, readonly) NSString    *path;

@end
