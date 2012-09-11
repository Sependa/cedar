#import <Foundation/Foundation.h>

@protocol CDRExampleParent

- (BOOL)shouldRun;

- (void)setUp;
- (void)runAction;
- (void)tearDown;

@optional
- (BOOL)hasFullText;
- (NSString *)fullText;
- (NSMutableArray *)fullTextInPieces;

@end
