# Tuya Smart Sweeper iOS SDK

## Features Overview

Tuya Smart Sweeper iOS SDK is based on the [Tuya Smart Home iOS SDK](https://github.com/TuyaInc/tuyasmart_home_ios_sdk)(The following introduction is: Home SDK), which expands the interface package for accessing the related functions of the sweeper device to speed up the development process. Mainly includes the following functions:

- Streaming media (for gyro or visual sweepers) universal data channel
- Data transmission channel of laser sweeper
- Laser sweeper real-time / historical sweep record
- Sweeper universal voice download service

> The laser sweeper data is divided into real-time data and historical record data. Both types of data include map data and path data, which are stored in the cloud in the form of files. Among them, the map and path of real-time data are stored in different files, and the map and path of historical data are stored in the same file. The map and path data are split and read according to the specified rules.
>
