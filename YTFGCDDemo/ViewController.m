//
//  ViewController.m
//  YTFGCDDemo
//
//  Created by Charles Yao on 2016/12/29.
//  Copyright © 2016年 Charles Yao. All rights reserved.
//

#import "ViewController.h"
#import "MainQueueViewController.h"
#import "GlobalQueueViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSArray *titles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @[@"main queue",@"global queue"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}

- (IBAction)btnClicked:(id)sender {
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self dispatchSync];
            break;
            
        case 1:
            [self dispatchAsync];
            break;
            
        default:
            break;
    }
}

- (void)dispatchSync {
    UIViewController *vc = [[MainQueueViewController alloc]initWithNibName:@"MainQueueViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dispatchAsync {
    UIViewController *vc = [[GlobalQueueViewController alloc]initWithNibName:@"GlobalQueueViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
