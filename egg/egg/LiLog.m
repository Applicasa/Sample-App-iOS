//
//  LiLog.c
//  LiCore
//
//  Created by Applicasa
//  Copyright (c) 2012 LiCore All rights reserved.
//

#include <stdio.h>
#import <Foundation/Foundation.h>

static NSDateFormatter *logFormatter = nil;

void LiLogSampleApp(NSString *format, ...){
    va_list ap;
    va_start(ap, format);
    NSString *formattedString = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end(ap);
    if (!logFormatter){
        logFormatter = [[NSDateFormatter alloc] init];
        [logFormatter setDateFormat:@"HH:mm:ss.SSS"];
    }
    NSString *dateString = [logFormatter stringFromDate:[NSDate date]];
    printf("LiLog SampleApp %s: %s\n",[dateString UTF8String],[formattedString UTF8String]);
    formattedString = nil;
}