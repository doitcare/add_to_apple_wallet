#import "ExceptionHandler.h"

@implementation ExceptionHandler

+ (nullable PKAddPassesViewController *)safeAddPassesViewControllerWithIssuerData:(NSData *)issuerData signature:(NSData *)signature {
    @try {
        if (@available(iOS 16.4, *)) {
            NSError* error;
            PKAddPassesViewController* controller = [[PKAddPassesViewController alloc] initWithIssuerData:issuerData signature:signature error: &error];
            if (error != nil) {
                NSLog(@"Error happened: %@", error);
                return nil;
            }
            else {
                return controller;
            }
        } else {
            NSLog(@"ios version too old");
            return nil;
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
        return nil;
    }
}

@end
