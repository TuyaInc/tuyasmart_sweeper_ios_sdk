## Data Transfer Subscribe

### Data flow

![MediaCleanRecord](./imgs/MediaCleanRecord.png)

### Function Introduction

The graffiti gyroscope or visual sweeper uses a stream channel to transmit map data and implements the `TuyaSmartSweeperDeviceDelegate` proxy protocol to receive callbacks for receiving map stream data.

| Class                | Description                          |
| -------------------- | ------------------------------------ |
| TuyaSmartSweepDevice | Tuya sweeper device management class |



### Subscribe Data Stream

**Declaration**

Subscribe to the device's map streaming data

```objective-c
- (void)subscribeDeviceDataTransfer;
```

**Example**

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



### Unsubscribe Data Stream

**Declaration**

Unsubscribe map stream data from device

```objective-c
- (void)unsubscribeDeviceDataTransfer;
```

**Example**

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



### Data Stream Callback

**Declaration**

Real-time callback of streaming data reported by the device

```objective-c
- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice didReceiveStreamData:(NSData *)data;
```

**Parameters**

| Parameter     | Description                              |
| ------------- | ---------------------------------------- |
| sweeperDevice | `TuyaSmartSweeperDevice` Instance object |
| data          | Streaming data（ `NSData`）              |

**Example**

Objc:

```objective-c
self.sweeperDevice = [TuyaSmartSweeperDevice deviceWithDeviceId:<#devId#>];
self.sweeperDevice.delegate = self;

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

