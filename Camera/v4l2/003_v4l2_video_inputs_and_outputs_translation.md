### 视频输入和输出
视频的输入输出是一个设备的物理连线. 就比如RF, CVBS, 混合视像,超级视频或是VGA端子. 视频和VBI拍摄设备有输入. 视频和VBI输出设备有输出,至少各有一个.音频设备
既没有输入也没有输出.

应用程序可以分别使用`VIDIOC_ENUMINPUT`和`VIDICO_ENUMOUTPUT` ioctl来枚举当前可用的输入输出的数量和属性. 通过`VIDIOC_ENUMINPUT`ioctl查询返回的
`v4l2_input`结构体中同时包含了当前可用的单一个状态信息.

`VIDICO_G_INPUT`和`VIDIOC_G_OUTPUT` ioctl返回当前视频输入或是输出的索引位置. 应用程序可以通过调用`VIDICO_S_INPUT`和`VIDIOC_S_INPUT` ioctl 来选择一个不同的输入或是输出.当设备拥有一个或是多个输入或是输入时, 驱动必须实现所有的输入或是输出icotl.

####例1.1. 当前可用的视频输入的信息####

    struct v4l2_input input;
    int index;
    if (-1 == ioctl(fd, VIDIOC_G_INPUT, &index)) {
        perror("VIDIOC_G_INPUT");
        exit(EXIT_FAILURE);
    }

    memset(&input, 0, sizeof(input));
    input.index = index;

    if (-1 == ioctl(fd, VIDIOC_ENUMINPUT, &input)) {
        perror("VIDIOC_ENUMINPUT");
        exit(EXIT_FAILURE);
    }

    print("Current input:%s\n", input.name);

####例1.2. 切换至第一个视频输入####

    int index;
    index = 0;
    if (-1 == ioctl(fd, VIDIOC_S_INPUT, &index)) {
        perror("VIDIOC_S_INPUT");
        exit(EXIT_FAILURE);
    }
