//
//  ViewController.h
//  ResignTool
//
//  Created by Injoy on 2017/9/7.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IDAppPackageHandler.h"

@interface ViewController : NSViewController

@property (weak) IBOutlet NSTextField   *ipaPathField;
@property (weak) IBOutlet NSButton      *browseIpaPathButton;
@property (weak) IBOutlet NSComboBox    *certificateComboBox;
@property (weak) IBOutlet NSComboBox    *provisioningComboBox;
@property (weak) IBOutlet NSTextField   *appNameField;
@property (weak) IBOutlet NSTextField   *destinationPathField;
@property (weak) IBOutlet NSButton      *browseDestinationPathButton;
@property (weak) IBOutlet NSTextField   *bundleIdField;
@property        IBOutlet NSTextView    *logField;
@property (weak) IBOutlet NSButton      *resignButton;
@property (weak) IBOutlet NSButton      *cleanButton;

@property (nonatomic)     IDAppPackageHandler *package;

@end

