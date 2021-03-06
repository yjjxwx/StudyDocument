### 用户控制
设备代表性的拥有一系列用户可设置的控制,如亮度,饱和度等等, 这些应当给用户呈现在图形界面上. 但是, 不同的设备会有不同的可控制项,
甚至是不同的可能值的范围, 以及不同的值. `ioctl` 提供了信息和机制来创建一个很好的用户接口使得在所有的设备都能正确的工作.

所有的控制使用一个标识ID值来访问. V4L2定义了几种标识ID用于特别的用途. 驱动也可以使用`V4L2_CID_PRIVATE_BASE`实现自定义的控制
和更高的取值. 预定义的控制标识ID都有一个前缀为`V4L2_CID_`, 在**表1.1. 控制标识**中列出. 这些标识用于查询控制属性, 获取和
设置当前值.

一般的应用程序应用向用户呈现控制选项,而不是有假设用户的目的. 每一个控制标识都使用一个用户可以理解的字符串来命名. 对于目的不是
很直观的应用程序,驱动编写都应当提供用户手册, 用户界面插件或是驱动特定面板. 预定义的控制标识ID被引入给一些控件编程, 例如在信道
切换的过程中静音一个设备.

驱动可能在切换当前视频输或输入,切换调谐器或是调制器, 音频输入或输出之后枚举不同的控制. 其他边界值, 另外的默认和当前值, 步长或是
其他的菜单选项的意义. 也可以使用一个确定的ID来改变一个控制的名字和类型.

如果一个控制对于当前设备的配置是不可用的, 驱动将会设置一个`V4L2_CTRL_FLAG_INACTIVE`的标记.

控制的值是作为一个全局值来存储, 这些值除非在允许的范围内切换,否则不会改变. 甚至在设备打开或是关闭, 或调谐器的频率改变
或是从来没有一个应用程序请求时,也不会改变.

V4L2定义了一套事件机制当控制的值发生改变时来通知应用程序, 面板应用程序可能会需要这种机制,为是能实时的显示正确的控制值.

所有的控制使用机器字节编码.

#### 表1.1 控制ID

|ID|类型|描述|
|:---|---:---|:---|
|V4L2_CID_BASE|   |第一个预定义的控制ID, 与 `V4L2_CID_BRIGHTINESS` 相等|
|V4L2_CID_USER_BASE|   |与`V4L2_CID_BASE`同义|
|V4L2_CID_BRIGHTNESS|Integer|画面的亮度,或是更加专业的说,黑度级别|
|V4L2_CID_CONTRAST|Integer|画面对比度或是亮度增益|
|V4L2_CID_SATURATION|Integer|画面的饱和度或是色彩增益|
|V4L2_CID_HUE|Integer|色调或是色彩平衡|
|V4L2_CID_AUDIO_VOLUME|Integer|最大音量. 注意, 有的驱动同时提供了OSS或是ALSA混合音接口|
|V4L2_CID_AUDIO_BALANCE|Integer|音频立体音平衡.低是相当于左,高相当于右|
|V4L2_CID_AUDIO_BASS|Integer|音频低音调节|
|V4L2_CID_AUDIO_TREBLE|Integer|音频高音调节|
|V4L2_CID_AUDIO_MUTE|boolean|静音, 例如,设置音量为0, 但是不影响`V4L2_CID_AUDIO_VOLUME`. 就像 ALSA 驱动, V4L2驱动必须在加载的时候使设备静音,为了避免噪音. 事实上,整个设备应当重置为低功耗状态|
|V4L2_CID_AUDIO_LOUDNESS|boolean|响度模式(低间增强)|
|V4L2_CID_BLACK_LEVEL|integer|亮度的另一个名称(但不是`V4L2_CID_BRIGHTNESS`的同义词). 这个控制是过时的, 在新的驱动和应用程序中不应该再使用|
|V4L2_CID_AUTO_WHITE_BALANCE|boolean|自动白平衡(摄像机)|
|V4L2_CID_DO_WHITE_BALANCE|button|这是一个行为控制. 当这个选项被设置后, 设备将会执行一次白平衡并且一直保持当前的设置值. 与`V4L2_CID_AUTO_WHITE_BALANCE`形成对比.|
|V4L2_CID_RED_BALANCE|Integer|红色色度平衡|
|V4L2_CID_BLUE_BALANCE|Integer|绿色色度平衡|
|V4L2_CID_GAMMA|Integer|伽玛调整|
|V4L2_CID_WHITENESS|Integer|为灰色设备调整亮度. 这与`V4L2_CID_GAMMA`不是同义词. 这个控制是过时的,在新的驱动和应用程序中不应当使用|
|V4L2_CID_EXPOSURE|integer|调整曝光(摄像机)|
|V4L2_CID_AUTOGAIN|boolean|自动曝光控制|
|V4L2_CID_GAIN|integer|增益控制(具体不清楚)|
|V4L2_CID_HFLIP|boolean|界面水平方向镜像|
|V4L2_CID_VFLIP|boolean|界面垂直方向镜像|
|V4L2_CID_POWER_LINE_FREQUENCY|enum|使用电源频率滤波器避免闪烁. 可能的枚举值为:`V4L2_CID_POWER_LINE_FREQUENCY_DISABLE`,`V4L2_CID_POWER_LINE_FREQUENCY_50HZ`,`V4L2_CID_POWER_LINE_FREQUENCY_60HZ`,`V4L2_CID_POWER_LINE_FRQUENCY_AUTO`|
|V4L2_CID_HUE_AUTO|boolean|允许设备自动色调控制, 在自动色调控制打开后,设置`V4L2_CID_HUE`是没有定义的,驱动应该忽略这样的请求.|
|V4L2_CID_WHITE_BALANCE_TIMPERATURE|integer|这个控制指定白平衡为开尔文色温,驱动应该有一个最低的值2800(白炽光) 到 一个最大的值 6500 (日光). 可以通过[Wikipedia](url_kelvin_color_temperature) 来查看详细的信息.|
|V4L2_CID_SHARPNESS|integer|在摄像机中调整锐度过滤器. 最小值表示关闭过滤器,更大的值将返回一个带有锐度的图片|
|V4L2_CID_BACKLIGHT_COMPENSATION|integer|调整摄像机的背光补偿.最小的值表示关闭背光补偿.|
|V4L2_CID_CHROMA_AGC|boolean|色度自动增益控制|
|V4L2_CID_CHROMA_GAIN|integer|调整色度增益控制(当AGC不可用时有效)|
|V4L2_CID_COLOR_KILLER|boolean|开启消色(在微弱的视频信号下强制拍摄黑白图像)|
|V4L2_CID_COLORFX|enum|选择一个颜色滤镜.以下的是被预定义的值. `V4L2_COLORFX_NONE` 颜色滤镜不可用.  `V4L2_COLORFX_ANITIQUE` 老龄化效果(老照片)效果.  `V4L2_COLORFX_ART_FREEZE` 霜效果.   `V4L2_COLORFX_AQUA` 水效果.  `V4L2_COLORFX_BW` 黑白效果.  `V4L2_COLORFX_EMBOSS` 浮雕, 高亮和阴影替换过亮或是过暗的边界并且低对比度的区域被设置为灰色.  `V4L2_COLORFX_GRASS_GREEN` 草绿色.    `V4L2_COLORFX_NEGATIVE` 负片效果(底片).  `V4L2_COLORFX_SEPIA` 深褐色调.  `V4L2_COLORFX_SKETCH`  素描效果.    `V4L2_COLORFX_SKIN_WHITEN` 美白动画.  `V4L2_COLORFX_SKY_BLUE` 蓝色开空.  `V4L2_COLORFX_SOLARIZATION` 负感作用, 图像中的部分色调逆转, 只一高于或是低于某一个确定的阈值才会被逆转.  `V4L2_COLORFX_SILHOUETTE` 剪影.  `V4L2_COLORFX_VIVID`  生动.  `V4L2_COLORFX_SET_CBCR`  CB和CR的色度分量是`V4L2_CID_COLORFX_CBCR` 控制所决定的固定系数代替. |
|V4L2_CID_COLORFX_CBCR|integer|定义Cb和Cr的替代系数. 32位的值[7:0]位被解释为Cr分量, [15:8]位被解释为Cb分量, [31:16]位必须为零.|
|V4L2_CID_AUTOBRIGHTNESS|boolean|开启自动亮度|
|V4L2_CID_ROTATE|integer|给定一个角度旋转图片. 统一的角度是90, 270, 180. 旋转图片90和270将会反转显示器的高度和宽度. 没有必要来跟据旋转角度通过`VIDIOC_S_FMT`来重新设定一个图片新的高度和宽度.|
|V4L2_CID_BG_COLOR|integer|为当前的输出设备设置一个背景颜色. 背景颜色需要指定为RGB24的格式. 给定的32位值的0~7位被解释为红色分量, 8~15位被解释为绿色分量, 16~23 被解释为蓝色分量, 24~31被必须为0.|
|V4L2_CID_ILLUMINATORS_1|boolean|开关照明器1(常用于显微镜)|
|V4L2_CID_ILLUMINATORS_2|boolean|开关照明器2(常用于显微镜)|
|V4L2_CID_MIN_BUFFERS_FOR_CAPTURE|integer|这是一个应用程序可读取的只读控制, 被用于提示设置到`REQBUFS`中拍摄缓冲区的数量. 这个值是保证硬件能够正常工作的最小的拍照缓冲区数量值|
|V4L2_CID_MIN_BUFFERS_FOR_OUTPUT|integer| 这是一个应用程序可读取的只读控制, 被用于提示设置到`REQBUFS`中输出缓冲区的数量. 这个值是保证硬件能够正常工作的最小的输出缓冲区数量值|
|V4L2_CID_ALPHA_COMPONENT|integer|设置颜色的Alpha分量. 当一个捕获设备(或是一个mem-to-mem的设备捕获队列)产生一帧的数据格式包含了一个Alpah的颜色分量(例如 RGB图像格式的打包) 并且Alpha的值没有被设备(或是mem-to-mem设备)所定义, 这个控制将会为所有的像素填充Alpha分量值. 当输出设备接收一帧的数据并且这些数据没有包含Alpha分量, 并且设备支持Alpha通道处理, 这个控制会为所有的输出像素填充Alpha分量值.|
|V4L2_CID_LASTP1|  |预定义控制ID的结束(与V4L2_CID_ALPHA_COMPONENT + 1的值相等).|
|V4L2_CID_PRIVATE_BASE| |第一个自定义的控制ID. 应用程序应该检查驱动程序的名称和版本来具体实现控制,详情请查看**查询功能**章节.|

应用程序可以使用`VIDIOC_QUERYCTRL`和`VIDIOC_QUERYMENU` ioctl 来枚举可用的控制, 使用`VIDIOC_G_CTRL`和`VIDIOC_S_CTRL`来查询和设置相应控制的值.
当设备有一个或是多个控制时, 驱动必须实现`VIDIOC_QUERYCTRL`,`VIDIOC_G_CTRL`,'VIDIOC_S_CTRL' ioctl, 当设备有一个或是多个菜单类型时,驱动必须实现
`VIDIOC_QUERYMENU` ioctl.

#### 例 1.8. 枚举所有的用户控制选项 

```c
struct v4l2_queryctrl queryctrl;
struct v4l2_querymenu querymenu;

static void enumerate_menu(void)
{
    printf(" Menu items: \n");
    memset(&querymenu, 0, sizeof(querymenu));
    querymenu.id = queryctrl.id;

    for (querymenu.index = querymenu.mininum;
            querymenu.index <= queryctrl.maximum; querymenu.index++) {
        if (0 == ioctl(fd, VIDIOC_QUERYMENU, &querymenu)) {
            printf(" %sn", querymenu.name);
        }
    }
}

memset(&queryctrl, 0, sizeof(queryctrl));

for (queryctrl.id = V4L2_CID_BASE;
        queryctrl.id < V4L2_CID_LASTP1;
        queryctrl.id++) {

    if (0 == ioctl(fd, VIDIOC_QUERYCTRL,
        &queryctrl)) {
            if (queryctrl.flags & V4L2_CTRL_FLAG_DISABLED) {
                continue;
            }
            printf("Control %s\n", queryctrl.name);

            if (queryctrl.type == V4L2_CTRL_TYPE_MENU) {
                enumerate_menu();
            }
    } else {
        if (errno == EINVAL) {
            continue;
        }
        perror("VIDIOC_QUERYCTRL");
        exit(EXIT_FAILURE);
    }
}

for (queryctrl.id = V4L2_CID_PRIVATE_BASE;;
        queryctrl.id++) {
    if (0 == ioctl(fd, VIDIOC_QUERYCTRL, &queryctrl)) {
        if (queryctrl.flag & V4L2_CTRL_FLAG_DISABLED) {
            continue;
        }

        printf("Control %s\n", queryctrl.name);

        if (queryctrl.type == V4L2_CTRL_TYPE_MENU) {
            enumerate_menu();
        }
    }
}

```
####例 1.9. 枚举所有的用户控制选项(可选)####
```c
memset(&queryctrl, 0, sizeof(queryctrl));

queryctrl.id = V4L2_CTRL_CLASS_USER | V4L2_CTRL_NEXT_CTRL;
while (0 == ioctl(fd, VIDIOC_QUERCTRL, &queryctrl)) {
    if (V4L2_CTRLID2CLASS(queryctrl.id) != V4L2_CTRL_CLASS_USER) {
        break;
    }

    if (queryctrl.flag & V4L2_CTRL_FLAG_DISABLED) {
        continue;
    }
    printf("Control %s\n", queryctrl.name);

    if (queryctrl.type == V4L2_CTRL_TYPE_MENU) {
        enumerate_menu();
    }

    queryctrl.id |= V4L2_CTRL_FLAG_NEXT_CTRL;
}

if (errno != EINVAL) {
    perror("VIDIOC_QUERYCTRL");
    exit(EXIT_FAILURE);
}

```
####例 1.10 改变控制####
```C
struct v4l2_queryctrl queryctrl;
struct v4l2_control control;

memset(&queryctrl, 0, sizeof(queryctrl));
queryctrl.id = V4L2_CID_BRIGHTNESS;

if (-1 == ioctl(fd, VIDIOC_QUERYCTRL, &queryctrl)) {

    if (errno != EINVAL) {
        perror("VIDIOC_QUERYCTRL");
        exit(EXIT_FAILURE);
    } else {
        printf("V4L2_CID_BRIGHTNESS is not supported\n");

    } else if (queryctrl.flag & V4L2_CTRL_FLAG_DISABLED) {
        printf("V4L2_CID_BRIGHTNESS is not supported\n");
    } else {
        memset(&control, 0, sizeof(control));
        control.id = V4L2_CID_BRIGHTNESS;
        control.value = queryctrl.default_value;
        if (-1 == ioctl(fd, VIDIOC_S_CTRL, &control)) {
            perror("VIDIOC_S_CTRL");
            exit(EXIT_FAILURE);
        }
    }
}

memset(&control, 0, sizeof(control));
control.id = V4L2_CID_CONTRAST;

if (0 == ioctl(fd, VIDIOC_G_CTRL, &control)) {
    control.value += 1;
    /*The driver may clamp the value of return ERANGE, ignored here*/
    if (-1 == ioctl(fd, VIDIOC_S_CTRL, &control
            && errno != ENAME) {
        perror("VIDIOC_S_CTRL");
        exit(EXIT_FAILURE);
    }
    /* Ignore if V4L2_CID_CONTRAST is unsupported */
} else if (errno != EINVAL) {
    perror("VIDIOC_G_CTRL");
    prror("VIDIOC_G_CTRL");
    exit(EXIT_FAILURE);
}

control.id = V4L2_CID_AUDIO_MUTE;
control.value = 1;

/* Errors ignored */
ioctl(fd,VIDIOC_S_CTRL, &control);

```


[url_kelvin_color_temperature]:http://en.wikipedia.org/wiki/Color_temperature "Color Temperature"
