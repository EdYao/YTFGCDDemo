//
//  SerialQueueViewController.m
//  YTFGCDDemo
//
//  Created by Charles Yao on 2017/1/6.
//  Copyright © 2017年 Charles Yao. All rights reserved.
//

#import "SerialQueueViewController.h"

@interface SerialQueueViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (copy, nonatomic) NSArray *cellTitles;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SerialQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"serial queue"];
    self.cellTitles = @[@"Sync dispatch custom Serial Queue",@"Async dispatch custom Serial Queue"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.cellTitles[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self syncDispatch];
            break;
            
        case 1:
            [self asyncDyspatch];
            break;
        default:
            break;
    }
}

- (void)syncDispatch {
    dispatch_queue_t serialQueue = dispatch_queue_create("com.Charles.serialQueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"当前任务");
    dispatch_sync(serialQueue, ^{
        NSLog(@"最先加入自定义串行队列");
        sleep(2);
    });
    dispatch_sync(serialQueue, ^{
        NSLog(@"次加入自定义串行队列");
    });
    NSLog(@"下一个任务");
}

- (void)asyncDyspatch {
    dispatch_queue_t serialQueue = dispatch_queue_create("com.Charles.serialQueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"当前任务");
    dispatch_async(serialQueue, ^{
        NSLog(@"最先加入自定义串行队列");
        sleep(2);
    });
    dispatch_async(serialQueue, ^{
        NSLog(@"次加入自定义串行队列");
    });
    NSLog(@"下一个任务");
}


@end
