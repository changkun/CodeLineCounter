//
//  EUAppDelegate.h
//  CountCodeLine
//
//  Created by 欧 长坤 on 14-4-14.
//  Copyright (c) 2014年 Euryugasaki. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface EUAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *filePathOutlet;
@property (weak) IBOutlet NSButton *startCountCodeLine;
@property (weak) IBOutlet NSTextField *countResult;

@property NSString *countFilesPath;


@end
