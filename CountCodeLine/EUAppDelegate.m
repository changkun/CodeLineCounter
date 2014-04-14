//
//  EUAppDelegate.m
//  CountCodeLine
//
//  Created by 欧 长坤 on 14-4-14.
//  Copyright (c) 2014年 Euryugasaki. All rights reserved.
//

#import "EUAppDelegate.h"

@interface EUCounter : NSObject

//@property NSUInteger countAll;
@property NSUInteger countC;
@property NSUInteger countCPP;
@property NSUInteger countH;
@property NSUInteger countM;
@property NSUInteger countMM;
@property NSUInteger countJAVA;

+ (EUCounter *)new;

- (void)addEUCounter:(EUCounter *)counter;
- (NSString *)description;

@end

@implementation EUCounter

+ (EUCounter *)new
{
    EUCounter *newcounter = [super new];
    //newcounter.countAll = 0;
    newcounter.countC   = 0;
    newcounter.countCPP = 0;
    newcounter.countH   = 0;
    newcounter.countM   = 0;
    newcounter.countMM  = 0;
    newcounter.countJAVA= 0;
    return newcounter;
}

- (void)addEUCounter:(EUCounter *)counter
{
    //self.countAll = counter.countAll + counter.countC + counter.countCPP + counter.countH + counter.countMM + counter.countJAVA;
    self.countC   += counter.countC;
    self.countCPP += counter.countCPP;
    self.countH   += counter.countH;
    self.countM   += counter.countM;
    self.countMM  += counter.countMM;
    self.countJAVA  += counter.countJAVA;
}

- (NSString *)description
{
    //NSMutableString *string = [NSMutableString stringWithFormat:@"Total Line: %lu\n", self.countAll];
    NSMutableString *string = [NSMutableString stringWithFormat:@""];
    //[string appendString:@"----------\n"];
    [string appendFormat:@".c      code lines: %lu\n", self.countC];
    [string appendFormat:@".cpp  code lines: %lu\n", self.countCPP];
    [string appendFormat:@".h      code lines: %lu\n", self.countH];
    [string appendFormat:@".m     code lines: %lu\n", self.countM];
    [string appendFormat:@".mm  code lines: %lu\n", self.countMM];
    [string appendFormat:@".java  code lines: %lu\n", self.countJAVA];
    return string;
}
@end

// 计算单个文件的行数
EUCounter* countCodeLine(NSString *countFilesPath)
{
    EUCounter *counter = [EUCounter new];
    
    // 判断是否为文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL directory = NO;
    BOOL isPathExist = [fileManager fileExistsAtPath:countFilesPath isDirectory:&directory];
    
    // 如果路径不合法，则不统计
    if (!isPathExist) {
        return counter;
    }
    // 对文件和文件夹单独处理
    if (directory) {
        // 获得文件夹中所有文件名
        NSArray *array = [fileManager contentsOfDirectoryAtPath:countFilesPath error:nil];
        for (NSString *filename in array) {
            NSString *fullPath = [NSString stringWithFormat:@"%@/%@", countFilesPath, filename];
            [counter addEUCounter:countCodeLine(fullPath)];
        }
        return counter;
    } else {
        // 过滤掉其他文件
        NSString *pathExtension = [[countFilesPath pathExtension] uppercaseString];
        EUCounter *counter = [EUCounter new];
        // 读文件
        NSString *content = [NSString stringWithContentsOfFile:countFilesPath encoding:NSUTF8StringEncoding error:nil];
        // 切割每一行
        NSArray *array = [content componentsSeparatedByString:@"\n"];
        
        if ([pathExtension isEqualToString:@"H"]) {
            counter.countH = array.count;
        } else if ([pathExtension isEqualToString:@"M"]) {
            counter.countM = array.count;
        } else if ([pathExtension isEqualToString:@"MM"]) {
            counter.countMM = array.count;
        } else if ([pathExtension isEqualToString:@"C"]) {
            counter.countC = array.count;
        } else if ([pathExtension isEqualToString:@"CPP"]) {
            counter.countCPP = array.count;
        } else if ([pathExtension isEqualToString:@"JAVA"]) {
            counter.countJAVA = array.count;
        } else {
            ;
        }
        return counter;
    }
    
}

@implementation EUAppDelegate

- (IBAction)onStartCountCodeLine:(id)sender {
    EUCounter *counter = countCodeLine(self.countFilesPath);
    NSString *count_result = [NSString stringWithFormat:@"%@", counter];
    [_countResult setStringValue:count_result];
    [_countResult setEditable:NO];
}

- (IBAction)onSelectorClick:(id)sender {
    NSOpenPanel *openPannel = [NSOpenPanel openPanel];
    [openPannel setTitle:@"Choose a File or Folder"];
    [openPannel setCanChooseDirectories:YES];   // 可以选择文件夹
    [openPannel setCanChooseFiles:YES];         // 可以选择文件
    NSInteger i = [openPannel runModal];        // 显示openPannel
    if (i == NSOKButton) {
        NSURL *filePath = [openPannel URL];
        self.countFilesPath = [filePath path];// 获得路径
        [_filePathOutlet setStringValue:self.countFilesPath];
        [_filePathOutlet setEditable:NO];
        [self.startCountCodeLine setEnabled:YES];                       // 设置可以开始统计代码行数
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

@end
