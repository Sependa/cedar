#import "CDRJUnitXMLReporter.h"
#import "CDRExample.h"

@implementation CDRJUnitXMLReporter

#pragma mark - Memory
- (id)init {
    if (self = [super init]) {
        successMessages_ = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [successMessages_ release];
    [super dealloc];
}

#pragma mark - Private

- (NSString *)escape:(NSString *)s {
    NSMutableString *escaped = [NSMutableString stringWithString:s];
    
    [escaped setString:[escaped stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
    [escaped setString:[escaped stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"]];
    [escaped setString:[escaped stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"]];
    [escaped setString:[escaped stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"]];
    [escaped setString:[escaped stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"]];
    
    return escaped;
}

- (void)writeXmlToFile:(NSString *)xml {
    char *xmlFile = getenv("CEDAR_JUNIT_XML_FILE");
    if (!xmlFile) {
        xmlFile = "build/TEST-Cedar.xml";
    }
    
    NSError *error;
    [xml writeToFile:[NSString stringWithUTF8String:xmlFile] atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

#pragma mark - Overriden Methods

- (NSString *)failureMessageForExample:(CDRExample *)example {
    return [NSString stringWithFormat:@"%@\n%@\n",[example fullText], example.failure];
}

- (void)reportOnExample:(CDRExample *)example {
    switch (example.state) {
        case CDRExampleStatePassed:
            [successMessages_ addObject:example.fullText];
            break;
        case CDRExampleStateSkipped:
            [skippedMessages_ addObject:example.fullText];
            break;
        case CDRExampleStateFailed:
        case CDRExampleStateError:
            [failureMessages_ addObject:[self failureMessageForExample:example]];
            break;
        default:
            break;
    }
}

- (void)appendXMLForTestcaseWithName:(NSString *)name body:(NSString *)body toString:(NSMutableString *)xml {
    NSUInteger firstWordEndIndex = [name rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]].location;
    if (firstWordEndIndex != NSNotFound) {
        [xml appendFormat:@"\t<testcase classname=\"%@\" name=\"%@\">\n", [name substringToIndex:firstWordEndIndex], [self escape:name]];
    } else {
        [xml appendFormat:@"\t<testcase name=\"%@\">\n", [self escape:name]];
    }
    
    if (body) {
        [xml appendFormat:@"\t\t%@\n", body];
    }
    [xml appendString:@"\t</testcase>\n"];
}

- (void)runDidComplete {
    NSTimeInterval time = [startTime_ timeIntervalSinceNow] * (-1);
    
    NSMutableString *xml = [NSMutableString string];
    [xml appendString:@"<?xml version=\"1.0\"?>\n"];
    [xml appendFormat:@"<testsuite time=\"%.4f\">\n", time];
    
    for (NSString *spec in successMessages_) {
        [self appendXMLForTestcaseWithName:spec body:nil toString:xml];
    }
    
    for (NSString *spec in failureMessages_) {
        NSArray *parts = [spec componentsSeparatedByString:@"\n"];
        
        NSString *name = [parts objectAtIndex:0];
        NSString *message = [parts objectAtIndex:1];
        
        NSString *body = [NSString stringWithFormat:@"<failure>%@</failure>", [self escape:message]];
        
        [self appendXMLForTestcaseWithName:name body:body toString:xml];
    }
    
    for (NSString *spec in skippedMessages_) {
        [self appendXMLForTestcaseWithName:spec body:@"<skipped/>" toString:xml];
    }
    
    [xml appendString:@"</testsuite>\n"];
    
    [self writeXmlToFile:xml];
}

@end
