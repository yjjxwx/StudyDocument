###视频标准####
视频设备代表性的支持一个或是多个视频标准或是可变的标准格式. 每一个视频输入和输出可能支持另外的标准集合. 这种标准集合由通过
`VIDIOC_ENUMINPUT`和`vIDIOC_ENUMOUTPUT` ioctl返回的`v4l2_input`和`v4l2_output`结构体是的`std`属性分别来表示.

V4L2 目前在全球范围内定义了一个数据位来模拟第一个视频标准, 并预留了一些数据位来让驱动来定义标准. 例如, 混合标准上观看PAL电视,
反之也可以看NTSC制式录像带. 应用程序可以使用预定义的位来选择一个独有的标准, 但是提供一个可供用户选择的标准菜单是更好的选择.
应用程序可以使用`VIDIOC_ENUMSTD`来枚举和查询支持的属性.

很多已定义的标准只是很少主要标准的变种. 在实际中硬件也许不会区分它们, 或是在内部自动的切换它们. 因此列举的标准也包含了一个
或是多个标准的集合.

假设一个调谐器能够解调 B/PAL, G/PAL 和 I/PAL 制式的信号. 第一个枚举的标准是一组B和G/PAL制式的集合, 是否自动切换依赖于在
UHF或VHF频段中选择的无线电频率. 枚举将会给出一个 `PAL-G/B` 或是 `PAL-G` 选择. 类似于`PAL-B/G/H/I`, `NTSC-M` 和
`SECAM-D/K` 的一个混合输入, 将可能会导致标准崩溃.

应用程序可以调用 `VIDIOC_G_STD`和`VIDIOC_S_STD` ioctl 来分别查询和选择当前输入和输入使用的标准. 查询到的标准可以使用
`VIDIOC_QUERYSTD` ioctl来检测. 注意,这些 ioctl 的参数是一个指向 `v4l2_std_id` 类型的指针(一个标准的集合), 不是一个
指向枚举出来标准的索引. 当设备有一个或是多个视频输入输出时, 驱动必须实现所有视频标准的 ioctl 函数.

有一些特别规则适用于那些视频标准的概念没有什么意义的设备如USB摄像头. 多适用于任何捕获或输出设备如:

* 在名义上没有捕获属性或是帧的视频标准,或者
* 那些根本不支持视频标准格式.

在这种情况下驱动应该设置`v4l2_input`和`v4l2_output`结构体中的`std`属性值为0, 并且`VIDIOC_G_STD`,`VIDIOC_S_STD`,`VIDIOC_QUERYSTD`和'VIDIOC_ENUMSTD'应该返回一个`ENOTTY`或是`EINVAL`的错误代码.

应用程序可以在**表A.42. 输入能力** 和 **表A.45. 输出能力** 附录里面
查询更多的有用信息, 在当前给定的输入或是输出里,应当如何决定使用哪种视频标准.

####例.1.5. 查询当前视频标准的信息####

    v4l2_std_id std_id;
    struct v4l2_standard standard;

    if (-1 == ioctl(fd, VIDIOC_G_STD, &std_id)) {
        /* Note when VIDIOC_ENUMSTD always returns ENOTTY this
        is no video device of it falls under the USB exception,
        and VIDIOC_G_STD return ENOTTY is no error. */
        perror("VIDIOC_G_STD");
        exit(EXIT_FAILURE);
    }

    memset(&standard, 0, sizeof(standard));
    standard.index = 0;
    while (0 == ioctl(fd, VIDIOC_ENUMSTD, &standard)) {
        if (standard.id & std_id) {
            printf("Current video standard:%s\n", standard.name);
            exit(EXIT_SUCCESS);
        }
        standard.index++;
    }

    /*EINVAL indicates the end of the enumeration, which cannot be
    empty unless this device falls under the USB exception */

    if (errno == EINVAL || standard.index == 0) {
        perror("VIDIOC_ENUMSTD");
        exit(EXIT_FAILURE);
    }

####例1.6. 列出当前输入支持的所有视频格式####

    struct v4l2_input input;
    struct v4l2_standard standard;

    memset(&input, 0, sizeof(input));

    if (-1 == ioctl(fd, VIDIOC_G_INPUT, &input.index)) {
        perror("VIDIOC_G_INPUT");
        exit(EXIT_FAILURE);
    }

    if (-1 == ioctl(fd, VIDIOC_ENUMINPUT, &input)) {
        perror("VIDIOC_ENUMINPUT");
        exit(EXIT_FAILURE);
    }

    printf("Current input %s supports:\n", input.name);

    memset(&standard, 0, sizeof(standard));

    while(0 == ioctl(fd, VIDIOC_ENUMSTD, &standard)) {
        if (standard.id & input.std) {
            printf("%s\n", standard.name);
        }
        standard.index++;
    }

    /* EINVAL indicates the end of the enumeration, which cannot be
    empty unless this device falls under the USB exception*/
    if (errno != EINVAL || standard.index == 0) {
        perror("VIDIOC_ENUMSTD");
        exit(EXIT_FAILURE);
    }

####例1.7. 选择一个新的视频标准####

    struct v4l2_input input;
    v4l2_std_id std_id;
    memset(&input, 0, sizeof(input));
    if (-1 == ioctl(fd, VIDIOC_G_INPUT, &input.index)) {
        perror("VIDIOC_G_INPUT");
        exit(EXIT_FAILURE);
    }

    if (-1 == ioctl(fd, VIDIOC_ENUMINPUT, &input)) {
        perror("VIDIOC_ENUM_INPUT");
        exit(EXIT_FAILURE);
    }

    if (0 == (input.std & V4L2_STD_PAL_BG)) {
        fprintf(stderr, "Oops. B/G PAL is not supported.\n");
    }

    /* Note this is also supposed to work when only B or G/PAL is supported */

    std_id = V4L2_STD_PAL_BG;

    if (-1 == ioctl(fd, VIDIOC_S_STD, &std_id)) {
        perror("VIDIOC_S_STD");
        exit(EXIT_FAILURE);
    }
