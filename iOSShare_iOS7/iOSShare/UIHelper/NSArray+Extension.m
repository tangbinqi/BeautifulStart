//
//  NSArray+Extension.m
//  iTrends
//
//  Created by wujin on 13-1-9.
//
//

#import "NSArray+Extension.h"
#import "DDLog.h"

@implementation NSArray (Extension)
-(id)firstObject
{
    if (self.count==0) {
        return nil;
    }else{
        return [self objectAtIndex:0];
    }
}

-(BOOL)containsString:(NSString *)string
{
    for (NSString *str in self) {
        if ([str isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}
@end