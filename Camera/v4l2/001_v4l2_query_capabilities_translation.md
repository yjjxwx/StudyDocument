###查询功能###
由于V4L2涵盖了多种设备,API并不能应用于这些设备的各个方面. 此外,相同类型的设备拥有不同的能力,这个文档允许省略了一些使用不到的并且复杂的API.

如果内核设备对于本文档是兼容, `VIDICO_QUERYCAP` ioctl 可用于查询该内核设备所支持的函数和IO方法.

内核版本从3.1开始, `VIDIOC_QUERYCAP` 将会返回被当前驱动使用与内核版本兼容的V4L2版本的API . 没有必要使用`VIDIOC_QUERYCAP`来检查一个特别的 ioctl 是否被支持,
如果驱动不支持一个ioctl操作,V4L2现在会返回一个`ENOTTY`的错误代码.

其他的功能可以调整相应的 ioctl 函数进行查询, 如可以通过`VIDIOC_ENUMINPUT`来获取连接到当前设备的视频连接器的数量,类型,名称等等.
尽管此API的设计目标是抽象, `VIDIOC_QUERYCAP` ioctl 也允许驱动指定应用程序来可靠的识别当前的驱动.

所有的V4L2驱动必须支持`VIDICO_QUERYCAP` ioctl. 应用程序应当在打开设备之后调用该 ioctl.
