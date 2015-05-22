### 音频输入输出
音频的输入输出是一个设备的物理连线. 视频拍摄设备有输入, 输出设备有输出, 每个有0个或多个. Radio无线通讯设备没有输入也没有输出. 必须明确的有一个调谐器
作为实际上的音频源, 但是V4L2 的API仅仅使用视频的输入输出关联调谐器, Radio 无线设备也没有这样. 一个TV卡的连线循环接收音频信号并发送到音频卡不能认为是
一种音频输出.

音频和视频的输入和输出是相互关联的. 选择一个视频源的同时也选择了一个音频源, 当视频源和音频源是同一个调谐器的时候,这是很明显的. 更进一步, 音频连线
可以混合多个输入或是输出. 假设两个视频输入和音频输入存在, 将有可能组合成四个有效的组合结果. 视频和音频的连线的关系被定义在`v4l2_input`和`v4l2_output`
结构体中的`audioset`属性里面, 从0开始,每一位代表音频输入输出的索引.

应用程序可以分别使用`VIDIOC_ENUMAUDIO`和`VIDICO_ENUMAUDOUT` ioctl来枚举当前可用的输入输出的数量和属性.通过`VIDIOC_ENUMAUDIO`ioctl查询返回的
`v4l2_audio`结构体中同时包含了当前可用的单一个状态信息.

`VIDIOC_G_AUDIO`和`VIDIOC_G_AUDOUT` ioctl 用来分别获取当前的输入和输出. 注意, 不像`VIDIOC_G_INPUT`和`VIDIOC_G_OUTPUT` ioctl 一样仅仅返回一个索引, 而是和`VIDIOC_ENUMAUDIO`和`VIDIOC_ENUMAUDOUT`同样返回一个结构体.

应用程序可以通过调用`VIDICO_S_AUDIO` ioctl 来选择一个音频输入并更改他的属性. 应用程序通过调用`VIDIOC_S_AUDOUT` ioctl来选择一个音频输出(目前
    还有没可以更改的属性)

当设备拥用多个可用的音频输入输出时,驱动程序必须实现所有的 ioctl 输入或是输出函数. 当设备有一个或是多个音频输入或是输出时,
驱动必须要在通过`VIDIOC_QUERYCAP` ioctl 返回的`v4l2_capability`的结构体中设置`V4L2_CAP_AUDIO`的标记.

####例1.3. 当前可用的音频输入信息####

    struct v4l2_audio audio;

    memset(&audio, 0, sizeof(audio));

    if (-1 == ioctl(fd, VIDIOC_G_AUDIO, &audio)) {
        perror("VIDIOC_G_AUDIO");
    }

    printf("Current input: %s\n", audio.name);

####例1.4. 切换到第一个音频输入####

    struct v4l2_audio audio;

    memset(&audio, 0, sizeof(audio));

    audio.index = 0;

    if (-1 == ioctl(fd, VIDIOC_S_AUDIO, &audio)) {
        perror("VIDIOC_S_AUDIO");
        exit(EXIT_FAILURE);
    }
