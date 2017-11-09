//
//  ThreadSafetyViewController.m
//  YTFGCDDemo
//
//  Created by admin on 2017/11/9.
//  Copyright © 2017年 Charles Yao. All rights reserved.
//

#import "ThreadSafetyViewController.h"

@interface ThreadSafetyViewController (){
    dispatch_queue_t _serialQueue;
    NSString *_name;
}

@property (copy, nonatomic) NSString *name;
- (IBAction)btnClicked:(id)sender;

@end

@implementation ThreadSafetyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _serialQueue = dispatch_queue_create("com.effectiveObjectiveC.serialQueue", DISPATCH_QUEUE_SERIAL);
}

- (NSString *)name {
    __weak __block NSString *localSomeString;
    dispatch_sync(_serialQueue, ^{
        localSomeString = _name;
    });
    return localSomeString;
}

- (void)setName:(NSString *)name1 {
    dispatch_sync(_serialQueue, ^{
        _name = name1;
    });
}

- (IBAction)btnClicked:(id)sender {
    self.name = @"sss";
    NSLog(@"name = %@",self.name);
}


@end
