//
//  ViewController.m
//  NSOperation
//
//  Created by mob on 2018/6/22.
//  Copyright © 2018年 mob. All rights reserved.
// 参考文档：https://www.jianshu.com/p/7649fad15cdb

#import "ViewController.h"
#import "HYOOperation.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"git hub");
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self testNSInvocatiinOperation];
//    [self testNSBlockOperation];
//    [self testHYOOperation];
//    [self testNSOperationQueue];
//    [self testmaxConcurrentOperationCount];
    [self testAddDependency];
}

#pragma mark --------- NSInvocationOperation
-(NSInvocationOperation *)testNSInvocatiinOperation
{
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperation) object:nil];

//    [invocationOperation start];
    return invocationOperation;
}
-(void)invocationOperation
{
    NSLog(@"start  -----  invocationOperation currentQueue is %@",[NSOperationQueue currentQueue]);
}

#pragma mark ----------- NSBlockOperation
-(NSBlockOperation *)testNSBlockOperation
{
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"blockOperation queue is %@\n",[NSOperationQueue currentQueue]);
        NSLog(@"NSThread  is %@",[NSThread currentThread]);
    }];
    [blockOperation addExecutionBlock:^{
        NSLog(@"addExecutionBlock111 queue is %@\n",[NSOperationQueue currentQueue]);
        NSLog(@"NSThread111  is %@",[NSThread currentThread]);
    }];
    [blockOperation addExecutionBlock:^{
        NSLog(@"addExecutionBlock222 queue is %@\n",[NSOperationQueue currentQueue]);
        NSLog(@"NSThread222  is %@",[NSThread currentThread]);
    }];
//    [blockOperation start];
    [blockOperation cancel]; // operation 取消
    return blockOperation;
}

#pragma mark -------自定义NSOperation 的子类
-(HYOOperation *)testHYOOperation
{
    HYOOperation *hyoOperation = [[HYOOperation alloc] init];
//    [hyoOperation start];
    
    return hyoOperation;
}

#pragma mark -------- NSOperationQueue
-(void)testNSOperationQueue
{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperationWithBlock:^{
        NSLog(@"直接添加在block 中 NSThread si %@",[NSThread currentThread]);
    }];
  
    [operationQueue addOperation:[self testNSInvocatiinOperation]];
    
    [operationQueue addOperation:[self testNSBlockOperation]];
    
    [operationQueue addOperation:[self testHYOOperation]];
    
    
}
#pragma mark ------- maxConcurrentOperationCount
-(void)testmaxConcurrentOperationCount
{
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    operationQueue.maxConcurrentOperationCount = 2; //设置为1也会开辟新线程
    [operationQueue addOperationWithBlock:^{
        NSLog(@"NSThread111 = %@",[NSThread currentThread]);
    }];
//    [operationQueue cancelAllOperations]; //取消方法调用前的所有operation
    [operationQueue addOperationWithBlock:^{
        NSLog(@"NSThread222 ======%@",[NSThread currentThread]);
    }];
    [operationQueue setSuspended:YES];
    [operationQueue addOperationWithBlock:^{
        NSLog(@"NSThread333 ======%@",[NSThread currentThread]);
    }];
    [operationQueue addOperationWithBlock:^{
        NSLog(@"NSThread444 ======%@",[NSThread currentThread]);
    }];
    
}
#pragma mark --------- 对NSOperation设置依赖
-(void)testAddDependency
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *blockOpearation1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"operation111 ======= %@",[NSThread currentThread]);
        }
    }];
    NSBlockOperation *blockOpearation2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"operation222 ======= %@",[NSThread currentThread]);
        }
    }];
    [blockOpearation1 addDependency:blockOpearation2]; // blockOpearation1 在 blockOpearation2 之后执行
    [queue addOperation:blockOpearation1];
    [queue addOperation:blockOpearation2];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
