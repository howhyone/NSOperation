//
//  HYOOperation.m
//  NSOperation
//
//  Created by mob on 2019/5/14.
//  Copyright © 2019 mob. All rights reserved.
//

#import "HYOOperation.h"

@implementation HYOOperation

-(void)main{
    for (int i = 0; i < 3; i++) {
        NSLog(@"NSOperation 的子类 NSThraed is %@",[NSThread currentThread]);
    }
}

@end
