//
//  DispatchAsyncViewController.m
//  YTFGCDDemo
//
//  Created by Charles Yao on 2017/1/4.
//  Copyright © 2017年 Charles Yao. All rights reserved.
//

#import "MainQueueViewController.h"

@interface MainQueueViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSArray * cellTitles;

@end

@implementation MainQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Main Queue"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.cellTitles = @[@"dispatch_sync",@"dispatch_async",@"downdload img"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.cellTitles[indexPath.row];
    return cell;
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
            [self downLoadImg];
            break;
            
        default:
            break;
    }
}

- (void)dispatchSync {
    //this code is going to crash,no one will use like this
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"dispatch_sync main queue");
    });
}

- (void)dispatchAsync {
    NSLog(@"current task");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"dispatch_async main queue");
    });
    NSLog(@"next task");
}

- (void)downLoadImg {
    //异步派发全局队列，加载图片数据，再回到主线程队列，加载图片，这是所有图片加载的库常用的套路
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://7xp4uf.com1.z0.glb.clouddn.com/thumb_IMG_0908_1024.jpg"]];
        UIImage *image = [UIImage imageWithData:imgData];
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
            [imgView setFrame:CGRectMake(0, 0, 200, 200)];
            [imgView setCenter:self.view.center];
            [self.view addSubview:imgView];
        });
    });
}

@end
