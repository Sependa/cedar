//
//  CDRJenkinsReporter.m
//  Cedar
//
//  Created by Ian Fisher on 9/13/11.
//  Copyright 2011 iFisher. All rights reserved.
//

#import "CDRJenkinsReporter.h"

@implementation CDRJenkinsReporter

- (NSString *)escapeAttribute:(NSString *)s {
    NSMutableString *escaped = [NSMutableString stringWithString:s];
    
    [escaped setString:[escaped stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"]];
    [escaped setString:[escaped stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"]];
    
    return escaped;
}

- (NSString *)escape:(NSString *)s {
    NSMutableString *escaped = [NSMutableString stringWithString:s];
    
    [escaped setString:[escaped stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
    [escaped setString:[escaped stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"]];
    [escaped setString:[escaped stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"]];
    
    return escaped;
}

- (void)runDidComplete {
    [super runDidComplete];
    
    NSMutableString *xml = [NSMutableString string];
    [xml appendString:@"<?xml version=\"1.0\"?>\n"];
    [xml appendString:@"<testsuite>\n"];
    
    for (NSString *spec in successMessages_) {
        [xml appendFormat:@"\t<testcase classname=\"Cedar\" name=\"%@\" />\n", [self escapeAttribute:spec]];
    }
    
    for (NSString *spec in pendingMessages_) {
        [xml appendFormat:@"\t<testcase classname=\"Cedar\" name=\"%@\" />\n", [self escapeAttribute:spec]];
    }
    
    for (NSString *spec in failureMessages_) {
        NSArray *parts = [spec componentsSeparatedByString:@"\n"];
        NSString *name = [parts objectAtIndex:0];
        NSString *message = [parts objectAtIndex:1];
        
        [xml appendFormat:@"\t<testcase classname=\"Cedar\" name=\"%@\">\n", [self escapeAttribute:name]];
        [xml appendFormat:@"\t\t<failure type=\"Failure\">%@</failure>\n", [self escape:message]];
        [xml appendString:@"\t</testcase>\n"];
    }
    
    [xml appendString:@"</testsuite>\n"];
    
    NSError *error;
    [xml writeToFile:@"build/TEST-Cedar.xml" atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

@end
