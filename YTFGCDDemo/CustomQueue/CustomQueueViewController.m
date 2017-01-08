//
//  CustomQueueViewController.m
//  YTFGCDDemo
//
//  Created by Charles Yao on 2017/1/6.
//  Copyright © 2017年 Charles Yao. All rights reserved.
//

#import "CustomQueueViewController.h"
#import "SerialQueueViewController.h"
#import "ConcurrentQueueViewController.h"

@interface CustomQueueViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (copy, nonatomic) NSArray *cellTitles;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CustomQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"custom queue"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.cellTitles = @[@"DISPATCH_QUEUE_SERIAL",@"DISPATCH_QUEUE_CONCURRENT"];
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
            [self gotoSerialQueueViewController];
            break;
        case 1:
            [self gotoConcurrentQueueViewController];
            break;
        default:
            break;
    }
}

- (void)gotoSerialQueueViewController {
    SerialQueueViewController* vc = [[SerialQueueViewController alloc]initWithNibName:@"SerialQueueViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoConcurrentQueueViewController {
    ConcurrentQueueViewController *vc = [[ConcurrentQueueViewController alloc]initWithNibName:@"ConcurrentQueueViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
