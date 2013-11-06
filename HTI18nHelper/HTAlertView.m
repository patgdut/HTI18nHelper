//
//  HTAlertView.m
//
//
//  Created by 任健生 on 13-5-14.
//
//

#import "HTAlertView.h"

@implementation HTAlertView

- (void)setBlock:(AlertBlock)block {
    self.delegate = self;
    if (_block) {
        _block = nil;
    }
    _block = [block copy];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.block) {
        self.block(buttonIndex);
    }
}


@end
