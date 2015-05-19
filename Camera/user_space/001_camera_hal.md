#Android Camera HAL部分学习记录#
摄像头驱动程序:通常基于Linux的Video for Linux 视频驱动框架.
有关该框架的详细描述请点击查看 [Video For Linux][1] 的官方描述.

![V4L2][p1]

Camera 的硬件抽象层的在 UI 库的头文件CameraHardwareInterface.h 文件定义。在这个接口中,包含了控制通道和数据通道,
控制通道用于处理预览和视频获取的开始 / 停止、拍摄照片、自动对焦等功能,数据通道通过回调函数来获得预览、视频录制、自动对焦等数据。
Camera 的硬件抽象层中还可以使用 Overlay 来实现预览功能。


































[p1]:V4L2.png
