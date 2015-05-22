### 调谐器和调节器
#### 调谐器
视频输入设备至少有一个调谐器来解调RF信号. 每一个调谐器至少与一个视频输入相关联, 这依赖于连接到调谐器上RF连线的数量.
通过调用`VIDIOC_ENUMINPUT` ioctl 返回的`v4l2_input`结构体中的`type`属性被设置为`V4l2_INPUT_TYPE_TUNER`,
`tuner`属性包含了调谐器的索引数.

无线输入设备必须有一个调谐器并且其索引为0, 而视频输入没有.

应用程序可以调用`VIDIOC_G_TUNER`和`VIDIOC_S_TUNER` ioctl 分别来查询和改变调谐器的属性. 当前通过`VIDIOC_G_TUNER`
ioctl 查询返回的`v4l2_tuner`结构体中包含了可用的信息状态信息. 注意, `VIDIOC_S_TUNER` 是不会切换当前调谐器的,
即使数量不止一个. 使用哪一个调谐器是由当前视频输入来独立决定的. 当设备有一个或是多个调谐器时,驱动必须要支持所有的`ioctl`
并且设置通过`VIDIOC_QUERYCAP`ioctl返回的`v4l2_capability`结构体中的`V4l2_CAP_TUNER`标记.

#### 调节器

视频输出设备至少要有一个调制器, 用来为辐射或是连接到电视或视频记录器的天线输入端调制视频信号.每一个调制器至少与一个视频输出
关联, 这依赖于连接到调制器上RF连线的数量. 通过调用`VIDIOC_ENUMOUTPUT` ioctl返回的`v4l2_output`结构体中的`type`属性被设置为`V4l2_OUTPUT_TYPE_MODULATOR`,
`modulator`属性包含了调制器的索引数.

无线输出设备必须有一个调制器并且其索引为0, 而视频输入没有.

一个视频或是音频设备不能同时支持调谐器和调制器. 两个不同的设备节点将不得不用于同一个硬件, 一个用于支持调谐器的功能,
一个用于支持调制器的功能.原因在于`VIDIOC_S_FREQUENCY` ioctl 的限制, 你不能去区分所设置的频率是为调谐器还是调制器.

应用程序可以调用`VIDIOC_G_MODULATOR`和`VIDIOC_S_MODULATOR` ioctl 分别来查询和改变调制器的属性.
注意, `VIDIOC_S_MODULATOR` 不会切换当前的调制器的, 即使数量不止一个. 使用哪一个调制器是由当前视频输出来独立决定的. 当设备有一个或是多个调制器时,驱动必须要支持所有的`ioctl`
并且设置通过`VIDIOC_QUERYCAP`ioctl返回的`v4l2_capability`结构体中的`V4l2_CAP_MODULATOR`标记.

#### 无线电频率

应用程序可以通过一个指向`v4l2_frequency`结构体的指针,使用`VIDIOC_G_FREQUENCY`和`VIDIOC_S_FREQUENCY` ioctl
来获取或是设置调谐器或是调制器的频率. 这些 ioctl 使用方式就像控制TV或无线电一样. 驱动必须支持这两种ioctl 当调谐器和
调制器同时被支持,或是设备是一个无线电设备.
