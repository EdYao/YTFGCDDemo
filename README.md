# YTFGCDDemo
想要了解多线程的运行机制就要弄清一些基本概念，概念搞清楚了，再把流程想一遍，多线程基本就掌握了。不推荐死记硬背，而是弄清楚多线程的设计思想和流程。

# 基本概念
1. 进程：进程（Process）是计算机中的程序关于某数据集合上的一次运行活动，在iOS系统中，开启一个应用就打开了一个进程。
2. 线程：线程（Thread）是进程中的一个实体，程序执行的基本单元。在iOS系统中，一个进程包含一个主线程，它的主要任务是处理UI事件，显示和刷新UI。
3. 同步：在当前线程依次执行，不开启新的线程。
4. 异步：多个任务情况下，一个任务A正在执行，同时可以执行另一个任务B。任务B不用等待任务A结束才执行。存在多条线程。
5. 队列：存放任务的结构
6. 串行：线程执行只能依次逐一先后有序的执行。
7. 并发：指两个或多个事件在同一时间间隔内发生。可以在某条线程和其他线程之间反复多次进行上下文切换，看上去就好像一个CPU能够并且执行多个线程一样。其实是伪异步。如下并发图，在同一线程，任务A先执行了20%，然后A停止，任务B重新开始接管线程开始执行。
8. 并行：指两个或多个时间在同一时刻发生。多核CUP同时开启多条线程供多个任务同时执行，互不干扰。

# 多线程中会出现的问题
1. 临界资源：多个线程共享各种资源，然而有很多资源一次只能供一线程使用。一次仅允许一个线程使用的资源称为临界资源。
2. 临界区：访问临界资源的代码区
3. 注意
 * 如果有若干线程要求进入空闲的临界区，一次仅允许一个线程进入。
 * 任何时候，处于临界区内的线程不可多于一个。如已有线程进入自己的临界区，则其它所有试图进入临界区的线程必须等待。
 * 进入临界区的线程要在有限时间内退出，以便其它线程能及时进入自己的临界区。
 * 如果线程不能进入自己的临界区，则应让出CPU，避免进程出现“忙等”现象。
4. 死锁：两个（多个）线程都要等待对方完成某个操作才能进行下一步，这时就会发生死锁。
5. 互斥锁：能够防止多线程抢夺造成的数据安全问题，但是需要消耗大量的资源
6. 原子属性：
 * atomic: 原子属性，为setter方法加锁，将属性以atomic的形式来声明，该属性变量就能支持互斥锁了。
 * nonatomic: 非原子属性，不会为setter方法加锁，声明为该属性的变量，客户端应尽量避免多线程争夺同一资源。
7. 上下文切换（Context Switch）：当一个进程中有多个线程来回切换时，context switch用来记录线程执行状态。从一个线程切换到另一个线程时需要保存当前进程的状态并恢复另一个进程的状态，当前运行任务转为就绪（或者挂起、删除）状态，另一个被选定的就绪任务成为当前任务。上下文切换包括保存当前任务的运行环境，恢复将要运行任务的运行环境。

# iOS中三种多线程编程技术
1. NSThread
优点：NSThread 比其他两个轻量级
缺点：需要自己管理线程的生命周期，线程同步。线程同步对数据的加锁会有一定的系统开销
2. NSOperation
优点：不需要关心线程管理，数据同步的事情，可以把精力放在自己需要执行的操作上。
3. GCD
是 Apple 开发的一个多核编程的解决方法，简单易用，效率高，速度快。通过 GCD，开发者只需要向队列中添加一段代码块(block或C函数指针)，而不需要直接和线程打交道。GCD在后端管理着一个线程池，它不仅决定着你的代码块将在哪个线程被执行，还根据可用的系统资源对这些线程进行管理。这样通过GCD来管理线程，从而解决线程被创建的问题。

#GCD中的队列类型
1. The main queue（主线程串行队列): 与主线程功能相同，提交至Main queue的任务会在主线程中执行
2. Global queue（全局并发队列): 全局并发队列由整个进程共享，有高、中（默认）、低、后台四个优先级别。
3. Custom queue (自定义队列): 可以为串行，也可以为并发。

##The main queue（主线程串行队列)
派发方式
1. 同步派发dispatch_sync，会造成死锁，没人会这么干。。

`dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"dispatch_sync main queue");
    });`
    
我们无法看到block中的打印
2. 异步派发dispatchAsync

`NSLog(@"current task");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"dispatch_async main queue");
    });
    NSLog(@"next task");`
    
打印内容

`2017-01-06 14:11:49.744 YTFGCDDemo[7773:166871] current task
2017-01-06 14:11:49.745 YTFGCDDemo[7773:166871] next task
2017-01-06 14:11:49.747 YTFGCDDemo[7773:166871] dispatch_async main queue`

3. 异步派发全局队列加载图片数据，再回到主线程显示图片

`dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
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
    });`
    
4. 主线程串行队列无法调用dispatch_resume()和dispatch_suspend()来控制执行继续或中断。

## Global queue（全局并发队列)

在一些耗时相对较长的业务场景中，我们通常会另开一个线程来执行这些业务，然后再通知主线程更新界面，以免造成界面长时间的卡顿。这些场景包括网络请求，加载图片，数据库读取等。

1. 同步派发Global Queue
	`
dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"current task");
    dispatch_sync(globalQueue, ^{
        sleep(2.0);
        NSLog(@"sleep 2.0s");
    });
    NSLog(@"next task");
`
    打印如下
    `
2017-01-06 14:29:12.528 YTFGCDDemo[7773:166871] current task
2017-01-06 14:29:14.600 YTFGCDDemo[7773:166871] sleep 2.0s(可以看到时间比上一条打印滞后两秒)
2017-01-06 14:29:14.600 YTFGCDDemo[7773:166871] next task
`
解释
 1. 主线程进入代码区块，打印 ”current task“
 2. 主线程将block添加到全局队列中，主线程被挂起知道block完成；同时全局队列并发处理任务。
 3. block中的代码被执行，首先线程被阻塞两秒，然后打印“sleep 2.0s”
 4. block返回，主线程被恢复，打印“next task”。
2. 异步派发Global Queue
`
dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"current task");
    dispatch_async(globalQueue, ^{
        sleep(2.0);
        NSLog(@"sleep 2.0s");
    });
    NSLog(@"next task");
` 
打印如下
`
2017-01-06 14:31:28.163 YTFGCDDemo[7773:166871] current task
2017-01-06 14:31:28.163 YTFGCDDemo[7773:166871] next task
2017-01-06 14:31:30.238 YTFGCDDemo[7773:166936] sleep 2.0s
` 
解释：
 1. 主线程进入代码区块，打印“current task”。
 2. block被添加到一个全局并发队列中，将稍后执行。（主线程没有被挂起。）
 3. 主线程将注意力转向剩下的任务，打印“next task”。同时，全局队列的任务开始并发的执行未完成的任务。
 4. block开始被执行。
 5. 全局队列被阻塞2s，然后开始继续，打印“sleep 2.0s”。

3. 异步派发多个Global Queue
`
for(NSInteger i = 0; i<100; i++) {
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(globalQueue, ^{
            NSLog(@"%ld",i);//可以看到不是严格按照从小到大的顺序打印的。You can see it is not print strictly in accordance with the order from small to large
        });
     }
`
     
## Custom queue (自定义队列)
1. 自定义串行队列
 a. 同步派发
 `
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
`
    打印为：
    `
2017-01-08 00:14:42.694038 YTFGCDDemo[781:149124] 当前任务
2017-01-08 00:14:42.694178 YTFGCDDemo[781:149124] 最先加入自定义串行队列
2017-01-08 00:14:44.695284 YTFGCDDemo[781:149124] 次加入自定义串行队列
2017-01-08 00:14:44.695530 YTFGCDDemo[781:149124] 下一个任务
`
  b. 异步派发
	`
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
` 
2. 自定义并发队列

 a. 同步派发
` 
dispatch_queue_t conCurrentQueue = dispatch_queue_create("com.Charles.conCurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"current task");
    dispatch_sync(conCurrentQueue, ^{
        NSLog(@"先加入队列");
    });
    dispatch_sync(conCurrentQueue, ^{
        NSLog(@"次加入队列");
    });
    NSLog(@"next task");
`
打印：
`
2017-01-08 13:21:20.766763 YTFGCDDemo[1207:248050] current task
2017-01-08 13:21:20.767022 YTFGCDDemo[1207:248050] 先加入队列
2017-01-08 13:21:20.767216 YTFGCDDemo[1207:248050] 次加入队列
2017-01-08 13:21:20.767350 YTFGCDDemo[1207:248050] next task
`
 b. 异步派发
`
dispatch_queue_t serialQueue = dispatch_queue_create("com.Charles.serialQueue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"当前任务");
    dispatch_async(serialQueue, ^{
        NSLog(@"最先加入自定义串行队列");
        sleep(2);
    });
    dispatch_async(serialQueue, ^{
        NSLog(@"次加入自定义串行队列");
    });
    NSLog(@"下一个任务");
`
打印：
`
2017-01-08 13:28:06.228210 YTFGCDDemo[1207:248050] 当前任务
2017-01-08 13:28:06.228657 YTFGCDDemo[1207:248050] 下一个任务
2017-01-08 13:28:06.235947 YTFGCDDemo[1207:249420] 最先加入自定义串行队列
2017-01-08 13:28:06.236469 YTFGCDDemo[1207:249429] 次加入自定义串行队列
`

关于GCD的更多知识点：使用 dispatch_after 延后工作，让你的单例线程安全，处理读者与写者问题等，将在后面的博客中提到。
博客地址：[简书](http://www.jianshu.com/p/434436aca674)


