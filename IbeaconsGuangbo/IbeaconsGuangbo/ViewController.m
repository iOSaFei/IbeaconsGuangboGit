//
//  ViewController.m
//  IbeaconsGuangbo
//
//  Created by iOS-aFei on 16/5/21.
//  Copyright © 2016年 iOS-aFei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, strong) UILabel *statusLabel;
@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
@property (strong, nonatomic) NSDictionary *myBeaconData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;

@end

@implementation ViewController

//E46BF871-CD99-4D5A-A60B-5875B1377296

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initBroadcastButton];
    [self initBroadcastLabel];
    //创建一个NSUUID对象,beacon会不断地广播该UUID
    //并且接收方app会用同样的UUID检测信号。
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"C71108DC-3639-4B98-BC24-367112F997E7"];
    /*如果你所处的位置内有一大堆数据，major number和minor number就是用来识别你的
     beacons。在上边梅西百货的例子中，每个department会有一个特定的major number--识别
     一组beacons，在店内，每个beacon会有一个特定的minor number。
     通过major number和minor number ，你将能精确识别哪个beacon被获取了。最后，标识符
     是该区域唯一的ID。*/
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                  major:1
                                                                  minor:1
                                                             identifier:@"com.appcoda"];
//    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"meijie"];
//
    
}

- (void)initBroadcastButton {
    UIButton *broadcastButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    broadcastButton.center = self.view.center;
    [broadcastButton addTarget:self action:@selector(beginBroadcast) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:broadcastButton];
}
- (void)initBroadcastLabel {
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, self.view.frame.size.width - 100, 50)];
    self.statusLabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.statusLabel];
}
- (void)beginBroadcast {
    //“peripheralDataWithMeasuredPower:” 给我们提供即将进行广播的beacon data。
    self.myBeaconData = [self.myBeaconRegion peripheralDataWithMeasuredPower:nil];
    //第二行代码启动了外围设备管理，并监控Bluetooth的状态更新。
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil
                                                                   options:nil];
}
//现在我们需要处理状态更新方法来检测Bluetooth何时打开和关闭。所以添加以下委托方法
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager*)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOn)
    {
        // Bluetooth is on
        // Update our status label
        self.statusLabel.text = @"Broadcasting...";
        // Start broadcasting
        NSLog(@"%@",self.myBeaconData);
        [self.peripheralManager startAdvertising:self.myBeaconData];
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff)
    {
        // Update our status label
        self.statusLabel.text = @"Stopped";
    }
}
/*当Bluetooth外围设备状态改变时会触发该方法。所以在该方法中，我们要检查当前设备处于什么状态。如果Bluetooth处于打开状态，我们将会更新我们的标签，调用“startAdvertising”方法，并把传递beacon data进行广播。相反，如果Bluetooth处于关闭状态，我们将会停止广播。
    现在把app部署至设备，打开Bluetooth并点击按钮，系统就会广播你的UUID！现在我们要创建一个接收方的app来检测和处理广播。
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
