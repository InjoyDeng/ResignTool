//
//  IDProvisioningProfile.m
//  ResignTool
//
//  Created by Injoy on 2017/9/11.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "IDProvisioningProfile.h"

@interface IDProvisioningProfile ()

@property (nonatomic, strong) NSDictionary *profileDictionary;
@property (readwrite) NSString  *name;
@property (readwrite) NSString  *teamName;
@property (readwrite) NSString  *valid;
@property (readwrite) NSString  *debug;
@property (readwrite) NSDate    *creationDate;
@property (readwrite) NSDate    *expirationDate;
@property (readwrite) NSString  *UUID;
@property (readwrite) NSArray   *devices;
@property (readwrite) NSInteger timeToLive;
@property (readwrite) NSString  *applicationIdentifier;
@property (readwrite) NSString  *bundleIdentifier;
@property (readwrite) NSArray   *certificates;
@property (readwrite) NSInteger version;
@property (readwrite) NSArray   *prefixes;
@property (readwrite) NSString  *appIdName;
@property (readwrite) NSString  *teamIdentifier;
@property (readwrite) NSString  *path;

@end

@implementation IDProvisioningProfile

- (id)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        self.path = path;
        self.profileDictionary = [self provisioningProfileAtPath:path];
        [self processDictionary];
    }
    return self;
}

- (void)processDictionary
{
    self.appIdName = self.profileDictionary[@"AppIDName"];
    self.teamIdentifier = self.profileDictionary[@"Entitlements"][@"com.apple.developer.team-identifier"];
    self.name = self.profileDictionary[@"Name"];
    self.teamName = self.profileDictionary[@"TeamName"];
    self.debug = [self.profileDictionary[@"Entitlements"][@"get-task-allow"] isEqualToNumber:@(1)] ? @"YES" : @"NO";
    self.creationDate = self.profileDictionary[@"CreationDate"];
    self.expirationDate = self.profileDictionary[@"ExpirationDate"];
    self.devices = self.profileDictionary[@"ProvisionedDevices"];
    self.timeToLive = [self.profileDictionary[@"TimeToLive"] integerValue];
    self.applicationIdentifier = self.profileDictionary[@"Entitlements"][@"application-identifier"];
    self.certificates = self.profileDictionary[@"DeveloperCertificates"];
    self.valid = ([[NSDate date] timeIntervalSinceDate:self.expirationDate] > 0) ? @"NO" : @"YES";
    self.version = [self.profileDictionary[@"Version"] integerValue];
    self.bundleIdentifier = self.applicationIdentifier;
    self.UUID = self.profileDictionary[@"UUID"];
    self.prefixes = self.profileDictionary[@"ApplicationIdentifierPrefix"];
    
    for (NSString *prefix in self.prefixes) {
        NSRange range = [self.bundleIdentifier rangeOfString:prefix];
        if (range.location != NSNotFound)
        {
            self.bundleIdentifier = [self.bundleIdentifier stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@.", prefix] withString:@""];
        }
    }
    
}

- (NSDictionary *)provisioningProfileAtPath:(NSString *)path {
    CMSDecoderRef decoder = NULL;
    CFDataRef dataRef = NULL;
    NSString *plistString = nil;
    NSDictionary *plist = nil;
    
    @try {
        CMSDecoderCreate(&decoder);
        NSData *fileData = [NSData dataWithContentsOfFile:path];
        CMSDecoderUpdateMessage(decoder, fileData.bytes, fileData.length);
        CMSDecoderFinalizeMessage(decoder);
        CMSDecoderCopyContent(decoder, &dataRef);
        plistString = [[NSString alloc] initWithData:(__bridge NSData *)dataRef encoding:NSUTF8StringEncoding];
        NSData *plistData = [plistString dataUsingEncoding:NSUTF8StringEncoding];
        
        plist = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:nil error:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"Could not decode file.\n");
    }
    @finally {
        if (decoder) CFRelease(decoder);
        if (dataRef) CFRelease(dataRef);
    }
    
    return plist;
}

@end
