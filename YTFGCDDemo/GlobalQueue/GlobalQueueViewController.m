//
//  GlobalQueueViewController.m
//  YTFGCDDemo
//
//  Created by Charles Yao on 2017/1/5.
//  Copyright © 2017年 Charles Yao. All rights reserved.
//

#import "GlobalQueueViewController.h"

@interface GlobalQueueViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSArray *cellTitles;

@end

@implementation GlobalQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"gloabal queue"];
    self.cellTitles = @[@"dispatch_sync",@"dispatch_async",@"multiple dispatch_async"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.textLabel setText:self.cellTitles[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self dispatchSync];
            break;
            
        case 1:
            [self dispatchAsync];
            break;
            
        case 2:
            [self multipleDispatchAsync];
            break;
        default:
            break;
    }
}

- (void)dispatchSync {
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"current task");
    dispatch_sync(globalQueue, ^{
        sleep(2.0);
        NSLog(@"sleep 2.0s");
    });
    NSLog(@"next task");
}

- (void)dispatchAsync {
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"current task");
    dispatch_async(globalQueue, ^{
        sleep(2.0);
        NSLog(@"sleep 2.0s");
    });
    NSLog(@"next task");
}

- (void)multipleDispatchAsync {
    for(NSInteger i = 0; i<100; i++) {
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(globalQueue, ^{
            NSLog(@"%ld",i);//可以看到不是严格按照从小到大的顺序打印的。You can see it is not print strictly in accordance with the order from small to large
        });
     }
}

@end
