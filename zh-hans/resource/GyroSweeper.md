## 流数据接口

### 数据流程

![MediaCleanRecord](./imgs/MediaCleanRecord.png)

### 功能简介

涂鸦陀螺仪型或视觉型的扫地机是使用流通道来传输地图数据，实现 `TuyaSmartSweeperDeviceDelegate` 代理协议接收用来接收地图流数据回调。

| 类名                 | 说明                   |
| -------------------- | ---------------------- |
| TuyaSmartSweepDevice | 涂鸦扫地机设备相关的类 |

### 订阅地图流数据

**接口说明**

订阅设备的地图流数据

```objective-c
- (void)subscribeDeviceDataTransfer;
```

**示例代码**

Objc:

```objective-c
- (void)subscribeDevice {
    
    [self.sweeperDevice subscribeDeviceDataTransfer];
}
```

Swift:

```swift
func subscribeDevice() {
    sweeperDevice?.subscribeDeviceDataTransfer()
}
```



### 取消订阅地图流数据

**接口说明**

取消订阅设备的地图流数据

```objective-c
- (void)unsubscribeDeviceDataTransfer;
```

**示例代码**

Objc:

```objective-c
- (void)unsubscribeDevice {
    
    [self.sweeperDevice unsubscribeDeviceDataTransfer];
}
```

Swift:

```swift
func unsubscribeDevice() {
    sweeperDevice?.unsubscribeDeviceDataTransfer()
}
```



### 流数据回调

**接口说明**

设备上报的流数据实时回调

```objective-c
- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice didReceiveStreamData:(NSData *)data;
```

**参数说明**

| 参数          | 说明                              |
| ------------- | --------------------------------- |
| sweeperDevice | `TuyaSmartSweeperDevice` 实例对象 |
| data          | 流数据（ `NSData` 类型）          |

**示例代码**

Objc:

```objective-c
self.sweeperDevice = [TuyaSmartSweeperDevice deviceWithDeviceId:<#devId#>];
self.sweeperDevice.delegate = self;

// 实现代理方法
- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice didReceiveStreamData:(NSData *)data {
  
}
```

Swift:

```swift
sweeperDevice = TuyaSmartSweeperDevice.init(deviceId: "your_devId")
sweeperDevice?.delegate = self

func sweeperDevice(_ sweeperDevice: TuyaSmartSweeperDevice, didReceiveStreamData data: Data) {
        
}
```

