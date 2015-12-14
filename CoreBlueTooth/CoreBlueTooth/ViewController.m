//
//  ViewController.m
//  CoreBlueTooth
//
//  Created by mac on 15-11-22.
//  Copyright (c) 2015年 Lispeng. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface ViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>

//创建蓝牙中心设备
@property (strong,nonatomic) CBCentralManager *mgr;
//存放所有扫描到的外部设备
@property (strong,nonatomic) NSMutableArray *peripherals;
@end

@implementation ViewController

- (CBCentralManager *)mgr
{
    if (!_mgr) {
        _mgr = [[CBCentralManager alloc] init];
    }
    return _mgr;
}

- (NSMutableArray *)peripherals
{
    if (!_peripherals) {
        _peripherals = [NSMutableArray array];
    }
    return _peripherals;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置代理
    self.mgr.delegate = self;
    //扫描外围设备
    [self.mgr scanForPeripheralsWithServices:nil options:nil];
    
}

#pragma mark----CBCentralManagerDelegate
/**
 *  扫描到外围设备就会调用
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if ([self.peripherals containsObject:peripheral]) return;
    
    peripheral.delegate = self;
    
    [self.peripherals addObject:peripheral];
    
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
}
/**
 *  扫描失败就会调用
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
}

/**
 *  调用此方法连接所有的外部设备
 */
- (void)startConnectPeripheral
{
    for (CBPeripheral *peripheral in self.peripherals) {
        
        [self.mgr connectPeripheral:peripheral options:nil];
    }
}
#pragma mark---CBPeripheralDelegate
/**
 *  连接完外部设备就会调用的方法
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSArray *services = peripheral.services;
    for (CBService *service in services) {
        if([service.UUID.UUIDString isEqualToString:@"123"])
        {
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}
/**
 *  扫描到外部设备的特征后就会调用的方法
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSArray *characteristics = service.characteristics;
    for (CBCharacteristic *characteristic in characteristics) {
        
        if ([characteristic.UUID.UUIDString isEqualToString:@"clock"]) {
            NSLog(@"设置闹钟");
        }
    }
}
@end
