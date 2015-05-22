# Camera 的功能概览#

<table  style="text-align:vcenter;" class="table table-bordered table-striped table condensed">
    <tr>
        <th>中文名称</th>
        <th>English Name</th>
        <th>描述(Description)</th>
        <th>实现方式</th>
    </tr>
    <tr>
        <td>高动态范围图像</td>
        <td>HDR(High-Dynamic Range)</td>
        <td>不同曝光时间的LDR(Low-Dynamic)图像, 利用每个曝光时间相对应最佳细节的LDR图像来合成最终的HDR图像, 能够更好的反映出真实环境中的视觉效果. 在表现上可以使过暗的区域变亮,过亮的区域变暗,使得细节更加清晰.</td>
        <td>底层支持</td>
    </tr>

    <tr>
        <td>闪光灯模式调节</td>
        <td>Flash Mode</td>
        <td>闪光灯的模式调节, 在正常拍照模式下,可以支持: 开(on), 关(off), 自动(auto). 在视频录制模式下只支持: 开(on), 关(off). 闪光灯的支持实际有多种模式, 其在Android的Framework层有相关的描述.闪光灯总共支持5种模式:
        <table>
            <tr>
                <th>中文名称</th>
                <th>Paramater</th>
                <th>Value</th>
                <th>Destription</th>
            </tr>
            <tr>
                <td>自动</td>
                <td>FLASH\_MODE\_AUTO</td>
                <td>auto</td>
                <td>闪光灯根据环境光的明暗来自动决定闪光灯的模式</td>
            </tr>
            <tr>
                <td>开</td>
                <td>FLASH\_MODE\_ON</td>
                <td>on</td>
                <td>始终打开闪光灯</td>
            </tr>
            <tr>
                <td>关</td>
                <td>FLASH\_MODE\_OFF</td>
                <td>off</td>
                <td>始终关闭闪光灯</td>
            </tr>

            <tr>
                <td>消除红眼</td>
                <td>FLASH\_MODE\_RED\_EYE</td>
                <td>red-eye</td>
                <td>打开夜光灯的过程中消除红眼</td>
            </tr>
            <tr>
                <td>手电筒</td>
                <td>FLASH\_MODE\_TORCH</td>
                <td>Torch</td>
                <td>以手电筒的方式打开闪光灯.</td>
            </tr>
        </table></td>
        <td>底层支持</td>
    </tr>
    <tr>
        <td>摄像头切换</td>
        <td>Camera Switch</td>
        <td>设备有多个摄像头时,在不同摄像头之间的切换. 通过Camera.open 来打开一个摄像头.</td>
        <td>底层支持</td>
    </tr>
    <tr>
        <td>人脸检测</td>
        <td>Face Detect</td>
        <td>自动识别人脸, Android原生支持人脸信息检测, 但是支持功能比较少, 只支持检测到人脸的区域, 可靠度, 左眼的坐标, 右眼的坐标, 嘴部的坐标, 还有一些没有对上层开放的信息,如微笑角度, 微笑程度, 还有个 faceRecognised数据(不确定具体什么意思). 如果想实现更加详细的信息检测,只能依靠其他的方法来实现, 比如检测人的年龄信息, 等等.</td>
        <td>第三方支持</td>
    </tr>

    <tr>
        <td>连拍</td>
        <td>Continuous Picture</td>
        <td>连续拍照. 连续拍照在高通和MTK的实现机制是不一样的, 在MTK下 相机的 Paramater 通过设置一个参数 Continuous , 相机自动进入连续拍照模式. 这是MTK自己实现的, 在高通下,没有这样的参数, 高通实现连拍是连续调整takePicture实现的.</td>
        <td>高通或是MTK</td>
    </tr>
    <tr>
        <td>相机对焦模式</td>
        <td>Focus Mode</td>
        <td>在Camera的Framework层的代码中可以查到Camera的对焦方式可以分为以下的 9 种:
            <table>
                <tr>
                    <th>中文名称</th>
                    <th>English Name</th>
                    <th>Value</th>
                    <th>Destription</th>
                </tr>
                <tr>
                    <td>自动</td>
                    <td>FOCUS\_MODE\_AUTO</td>
                    <td>auto</td>    <td>自动对焦模式,在这种模式下应用程序应当调用`autoFocus(AutoFocusCallbace)`方法,来开启对焦</td>
                </tr>
                <tr>
                    <td>无限远</td>
                    <td>FOCUS\_MODE\_INFINITY</td>
                    <td>infinity</td>
                    <td>聚光区为无限远</td>
                </tr>
                <tr>
                    <td>大镜头</td>
                    <td>FOCUS\_MODE\_MACRO</td>
                    <td>macro</td>
                    <td>大镜头模式使得焦点处的图像清晰, 离焦点越远越模糊. 使得图像重点突出.在这种模式下,应用程序应该调用`autoFocus(AutoFocusCallback)` 方法开始聚焦.</td>
                </tr>
                <tr>
                    <td>固定焦点</td>
                    <td>FOCUS\_MODE\_FIXED</td>
                    <td>fixed</td>
                    <td>焦点是因定的. 当焦点不可调整的时候, Camera应当处于这种模式. 如果Camera有自动聚焦. 这个模式可以固定焦点, 经常用于超焦距.在这种模式下, 应用程序不应当调用`autoFocus(AutoFocusCallback)`.</td>
                </tr>
                <tr>
                    <td>正常模式</td>
                    <td>FOCUS\_MODE\_NORMAL</td>
                    <td>normal</td>
                    <td>正常模式,应用程序应当调用`autoFocus(AutoFocusCallback)`开始对焦</td>
                </tr>
                <tr>
                    <td>全幅聚焦</td>
                    <td>FOCUS\_MODE\_EDOF</td>
                    <td>EDOF(Extended depth of field)</td>
                    <td>数字化完成对焦,并且是待续的. 在这种模式下,应用程序不应当调用`autoFocus(AutoFocusCallback)`</td>
                </tr>
                <tr>
                    <td>视频连续对焦</td>
                    <td>FOCUS\_MODE\_CONTINUOUS\_VIDEO</td>
                    <td>continuous-video</td>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;视频录制连续对焦, Camera 持续性地尝试对焦. 这对于视频录视频是一种很好的选择, 因为焦点的变化是平滑的. 在这种模式下应用程序同时可以
                    调用`takePicture(Camera.ShutterCallback, Camera.PictureCallback, Camera.PictureCallback)`, 但是物体可以不在焦点上. 自动对焦在这个参数设置后立即生效.<br/>

                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   从 API 14 开始, 在这种模式下应用程序可以调用`autoFocus(AutoFocusCallback)`. 焦点的回调会立即返回一个`boolean`值, 来指明焦点是否清晰. 当`autoFocus`调用之后,焦点的位置被锁定. 如果应用程序想重新回到`continuous-video` 模式, 必须要调用`cancelAutoFocus`. 重启预览也不行. 要想停止持续对焦, 应用程序可以改变当前的聚焦模式到其他的模式.
                    </td>
                </tr>
                <tr>
                    <td>图像连续对焦</td>
                    <td>FOCUS\_MODE\_CONTINUOUS\_PICTURE</td>
                    <td>continuous-picture</td>
                    <td> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 拍照连续自动对焦. Camera连续的尝试对焦.焦点变化的速度比`continuous-picture` 更具有侵略性. 当参数设置之后立马生效.<br/>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在这种模式下, 应用程序可以调用`autoFocus(AutoFocusCallback)`. 如果自动对焦正在扫描, 焦点的回调会在对焦完成之后返回. 如果自动对焦没有扫描, 焦点的回调会立即返回一个
                    `boolean`值,指明焦点是否清晰. 应用程序可以根据这个信息,来决定是否立即拍摄一张图片, 或是改变聚焦模式到`AUTO`, 并且运行一个完整
                   的自动聚焦的周期. 在调用 `autoFocus` 之后,焦点被锁定. 如果应用程序想回到持续的对焦, 必须要调用`cancelAutoFocus`, 重启预览是没有效果的. 如果想要结束持续对焦, 应用程序可以改变当前聚焦模式到其他模式.
                    </td>
                </tr>
                <tr>
                    <td>手动</td>
                    <td>FOCUS\_MODE\_MANUAL\_POSITION</td>
                    <td>manual</td>
                    <td>这个参数目前在SDK中是被设为隐藏的</td>
                </tr>
            </table>
        </td>
        <td>底层支持</td>
    </tr>
    <tr>
        <td>场景模式</td>
        <td>Scene Mode</td>
        <td>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;在相机的Framework中定义的场景模式有以下几种.
            <table>
                <tr>
                    <th>中文名称</th>
                    <th>Paramater</th>
                    <th>Value</th>
                    <th>Description</th>
                </tr>
                <tr>
                    <td>自动检测</td>
                    <td>SCENE\_MODE\_ASD</td>
                    <td>asd</td>
                    <td>自动检测. 关闭场景模式</td>
                </tr>
                <tr>
                    <td>自动</td>
                    <td>SCENE\_MODE\_AUTO</td>
                    <td>auto</td>
                    <td>关闭场景模式</td>
                </tr>
                <tr>
                    <td>行为模式</td>
                    <td>SCENE\_MODE\_ACTION</td>
                    <td>action</td>
                    <td>为快速移动的物体拍照, 与`SCENE_MODE_SPORTS` 效果相同</td>
                </tr>
                <tr>
                    <td>肖像模式</td>
                    <td>SCENE\_MODE\_PORTRAIT</td>
                    <td>portrait</td>
                    <td>为人物拍摄肖像</td>
                </tr>
                <tr>
                    <td>远景模式</td>
                    <td>SCENE\_MODE\_LANDSCAPE</td>
                    <td>landscape</td>
                    <td>为远处的物体拍摄</td>
                </tr>
                <tr>
                    <td>夜景模式</td>
                    <td>SCENE\_MODE\_NIGHT</td>
                    <td>night</td>
                    <td>在夜里拍摄</td>
                </tr>
                <tr>
                    <td>夜肖像模式</td>
                    <td>SCENE\_MODE\_NIGHT\_PORTRAIT</td>
                    <td>night-portrait</td>
                    <td>在夜里拍摄人物</td>
                </tr>
                <tr>
                    <td>剧场模式</td>
                    <td>SCENE\_MODE\_THEATRE</td>
                    <td>theatre</td>
                    <td>在影院拍摄, 此时闪光灯是关闭的</td>
                </tr>
                <tr>
                    <td>海滩模式</td>
                    <td>SCENE\_MODE\_BEACH</td>
                    <td>beach</td>
                    <td>在海边拍摄</td>
                </tr>
                <tr>
                    <td>雪花模式</td>
                    <td>SCENE\_MODE\_SNOW</td>
                    <td>snow</td>
                    <td>在雪花中拍摄</td>
                </tr>
                <tr>
                    <td>日落模式</td>
                    <td>SCENE\_MODE\_SUNSET</td>
                    <td>sunset</td>
                    <td>拍摄日落图像</td>
                </tr>
                <tr>
                    <td>防抖模式</td>
                    <td>SCENE\_MODE\_STEADYPHOTO</td>
                    <td>steadyphoto</td>
                    <td>避免模糊的图片, 例如手部的抖动</td>
                </tr>
                <tr>
                    <td>烟花模式</td>
                    <td>SCENE\_MODE\_FIREWORKS</td>
                    <td>fireworks</td>
                    <td>拍摄烟火表演</td>
                </tr>
                <tr>
                    <td>运动模式</td>
                    <td>SCENE\_MODE\_SPORTS</td>
                    <td>sports</td>
                    <td>为快速移动物体拍摄, 与`SCENE_MODE_ACTION` 效果相同</td>
                </tr>
                <tr>
                    <td>聚会模式</td>
                    <td>SCENE\_MODE\_PARTY</td>
                    <td>party</td>
                    <td>在室内弱光下拍摄</td>
                </tr>
                <tr>
                    <td>暖光模式</td>
                    <td>SCENE\_MODE\_CANDLELIGHT</td>
                    <td>candlelight</td>
                    <td>拍摄由蜡烛产生的自然暖光</td>
                </tr>
                <tr>
                    <td>逆光模式</td>
                    <td>SCENE\_MODE\_BACKLIGHT</td>
                    <td>backlight</td>
                    <td>在逆光场景下拍摄, 该参数被设为隐藏, 不对外开放</td>
                </tr>
                <tr>
                    <td>鲜花模式</td>
                    <td>SCENE\_MODE\_FLOWERS</td>
                    <td>flowers</td>
                    <td>在鲜花中拍摄, 该参数被设为隐藏, 不对外开放</td>
                </tr>

                <tr>
                    <td>条形码模式</td>
                    <td>SCENE\_MODE\_BARCODE</td>
                    <td>barcode</td>
                    <td>扫描条形码. Camera驱动将会对读取条形码进行优化</td>
                </tr>
                <tr>
                    <td>HDR模式</td>
                    <td>SCENE\_MODE\_HDR</td>
                    <td>hdr</td>
                    <td>使用高动态范围成像技术的拍摄场景. Camera 会返回一张比普通图片具有扩展动态范围的图片. 拍摄这样一张图片, 将会花费比普通图片更加长的时间</td>
                </tr>
            </table>
        </td>
        <td>底层支持</td>
    </tr>
    <tr>
        <td>白平衡</td>
        <td>White Balance</td>
        <td>
            Camera在Framework中定义了如下几种白平衡模式:
            <table>
                <tr>
                    <th>中文名称</th>
                    <th>Paramater</th>
                    <th>Value</th>
                    <th>Description</th>
                </tr>
                <tr>
                    <td>自动</td>
                    <td>WHITE\_BALANCE\_AUTO</td>
                    <td>auto</td>
                    <td>自动模式,关闭白平衡</td>
                </tr>
                <tr>
                    <td>白炽光</td>
                    <td>WHITE\_BALANCE\_INCANDESCENT</td>
                    <td>incandescent</td>
                    <td>白炽光照</td>
                </tr>
                <tr>
                    <td>荧光灯</td>
                    <td>WHITE\_BALANCE\_FLUORESCENT</td>
                    <td>fluorescent</td>
                    <td>荧光灯</td>
                </tr>
                <tr>
                    <td>暖荧光</td>
                    <td>WHITE\_BALANCE\_WARM\_FLUORESCENT</td>
                    <td>warm-fluorescent</td>
                    <td>暖荧光</td>
                </tr>
                <tr>
                    <td>日光灯</td>
                    <td>WHITE\_BALANCE\_DAYLIGHT</td>
                    <td>daylight</td>
                    <td>日光灯</td>
                </tr>
                <tr>
                    <td>暮光</td>
                    <td>WHITE\_BALANCE\_TWILIGHT</td>
                    <td>twilight</td>
                    <td><<暮光之城>>多么经典的电影.......我就想到这个</td>
                </tr>
                <tr>
                    <td>遮光</td>
                    <td>WHITE\_BALANCE\_SHADE</td>
                    <td>shade</td>
                    <td>就是阴影啦</td>
                </tr>

                <tr>
                    <td>手动色温</td>
                    <td>WHITE\_BALANCE\_MANUAL\_CCT</td>
                    <td>manual-cct</td>
                    <td>这个参数被设为隐藏, 对上层不开放. 翻译为手动色温, 有可能不对</td>
                </tr>
            </table>
        </td>
        <td>底层支持</td>
    </tr>
    <tr>
        <td>滤镜</td>
        <td>Color Effect</td>
        <td>
            Camera 在 Framework 层的定义了一系列的滤镜效果, 不过这些效果在Camera5.0新的架构中被取消掉, 不建议使用.
            如果想继续用这些效果, 就必须使用老的接口才行. 如下列出了所有的滤镜效果.
            <table>
                <tr>
                    <th>中文名称</th>
                    <th>Parameter</th>
                    <th>Value</th>
                    <th>Description</th>
                </tr>
                <tr>
                    <td>无效果</td>
                    <td>EFFECT\_NONE</td>
                    <td>none</td>
                    <td>无滤镜效果</td>
                </tr>
                <tr>
                    <td>黑白效果</td>
                    <td>EFFECT\_MONO</td>
                    <td>mono</td>
                    <td>拍摄黑白照片</td>
                </tr>
                <tr>
                    <td>负片效果</td>
                    <td>EFFECT\_NEGATIVE</td>
                    <td>negative</td>
                    <td>像底版 ^\_^</td>
                </tr>
                <tr>
                    <td>曝光过度</td>
                    <td>EFFECT\_SOLARIZE</td>
                    <td>solarize</td>
                    <td>过度曝光, 照片会很亮很白</td>
                </tr>
                <tr>
                    <td>深褐色效果</td>
                    <td>EFFECT\_SEPIA</td>
                    <td>sepia</td>
                    <td>深褐色的效果</td>
                </tr>
                <tr>
                    <td>多色调分色印效果</td>
                    <td>EFFECT\_POSTERIZE</td>
                    <td>posterize</td>
                    <td>多色调分色印效果,这么专业的词, 我哪知道什么意思</td>
                </tr>
                <tr>
                    <td>白板效果</td>
                    <td>EFFECT\_WHITEBOARD</td>
                    <td>whiteboard</td>
                    <td>我该怎么说呢......</td>
                </tr>
                <tr>
                    <td>黑板效果</td>
                    <td>EFFECT\_BLACKBOARD</td>
                    <td>blackboard</td>
                    <td>我该怎么说呢......</td>
                </tr>
                <tr>
                    <td>浅绿色效果</td>
                    <td>EFFECT\_AQUA</td>
                    <td>aqua</td>
                    <td>就是这个颜色啦</td>
                </tr>
            </table>
        </td>
        <td>底层支持</td>
    </tr>
    <tr>
        <td>反冲带</td>
        <td>Antibanding</td>
        <td>
            反冲带功能应该会减少由光源振荡和曝光控制算法引起的亮度在帧或图像中的影响.
            如果光源的振荡是50Hz, 并且图像或是视频的曝光不是10的整数倍,
            就会在图像上看到比较亮的光带. 这是频率不匹配所表现出的效果.
            在实际的情况下, 你可以拿一部手机来拍显示器的屏幕, 如果频率不匹配,
            在图像上会出现白色的条纹. Camera在Framework 中定义了以下几种频率:
            <table>
                <tr>
                    <th>中文名称</th>
                    <th>Paramater</th>
                    <th>Value</th>
                    <th>Description</th>
                </tr>
                <tr>
                    <td>自动</td>
                    <td>ANTIBANDING\_AUTO</td>
                    <td>auto</td>
                    <td>自动调节反冲带的频率</td>
                </tr>
                <tr>
                    <td>50Hz</td>
                    <td>ANTIBANDING\_50HZ</td>
                    <td>50hz</td>
                    <td>设定频率为50hz</td>
                </tr>
                <tr>
                    <td>60Hz</td>
                    <td>ANTIBANDING\_60HZ</td>
                    <td>60hz</td>
                    <td>设定频率为60hz</td>
                </tr>
                <tr>
                    <td>关闭</td>
                    <td>ANTIBANDING\_OFF</td>
                    <td>off</td>
                    <td>不做处理</td>
                </tr>
            </table>
        </td>
        <td>底层支持</td>
    </tr>
</table>


##Camera 的设置有很多, 有的值是开关, 有的值是枚举. 但都是以 Key-Value 的方式来设置. 以下列出Camera相关的设置kEY,及描述.

> Notice: 通过以下机制来设置Camera属性的方法, 在Android5.0及以上版本
>中不再建议使用, 推荐Android Camera2的接口. 但作为学习之用,这一套接口
>更加简单,同时也更好理解.
>关于Android Camera2的接口的解释, 会以后再给出.
>其相关的源代码是放在:`frameworks/base/core/java/android/hardware/camera2/` 下.




<table  style="text-align:vcenter;" class="table table-bordered table-striped table condensed">
    <tr>
        <th>Key</th>
        <th>Value-type</td>
        <th>Desciption</th>
    </tr>
    <tr>
        <td>KEY\_PREVIEW\_SIZE</td>
        <td>enum</td>
        <td>
            设置Camera的预览大小. 可以通过`getSupportedPreviewSizes()`
方法来获取设备所支持的所有预览大小的集合, 不同的摄像设备支持不同的预览大小, 在设置预览大小的时候,必须要设置设备支持的大小.否则可以会导致摄像头无法拍摄.
通过`setPreviewSize(int width, int height)`来设置预览大小.
        </td>
    </tr>

    <tr>
        <td>KEY\_PREVIEW\_FORMAT</td>
        <td>enum</td>
        <td>
            设置预览数据的格式. 可以通过`getSupportedPreviewFormats()` 来获取设备所支持的预览格式的集合.
            通过`setPreviewFormat(int pixed_formal)` 来设置当前的预览格式. 在设置预览数据格式的时候,必须要设置设备支持的格式.
        </td>
    </tr>
    <tr>
        <td>KEY\_PREVIEW\_FRAME\_RATE</td>
        <td>enum</td>
        <td>设置预览帧率. 可以通过`getSupportedPreviewFrameRates()` 来获取设备所支持的预览帧率的集合.
        通过`setPreviewFrameRate(int fps)` 来设置当前的预览帧率.  在设置预览帧率的时候,必须要设置设备支持的预览帧率</td>
    </tr>
    <tr>
        <td>KEY\_PREVIEW\_FPS\_RANGE</td>
        <td>enum</td>
        <td>设置FPS的范围. 可以通过`getSupportedPreviewFpsRange()` 来获取设备所支持的FPS范围的集合,
        每个元素是两个值构成, 一个最小的FPS, 一个最大的FPS, 通过`setPreviewFpsRange(int min, int max)` 来设置当前的预览帧率.
        在设置预览FPS范围时,必须要设置设备支持的值.
        </td>
    </tr>
    <tr>
        <td>KEY\_PICTURE\_SIZE</td>
        <td>enum</td>
        <td>
        设置Camera的图片大小. 可以通过`getSupportedPictureSizes()`
        方法来获取设备所支持的所有图片大小的集合, 不同的摄像设备支持不同的图片大小, 在设置图片大小的时候,必须要设置设备支持的大小.否则可以会导致摄像头无法拍摄.
        通过`setPictureSize(int width, int height)`来设置图片大小.
        </td>
    </tr>
    <tr>
        <td>KEY\_PICTURE\_FORMAT</td>
        <td>enum</td>
        <td>
        设置预览数据的格式. 可以通过`getSupportedPictureFormats()` 来获取设备所支持的预览格式的集合.
        通过`setPictureFormat(int pixed_formal)` 来设置当前的图片格式. 在设置图片数据格式的时候,必须要设置设备支持的大小
        </td>
    </tr>

    <tr>
        <th colspan="3">不行了,这种参数太多, 我一时半会写不完了, 我要换个方式来描述了</th>
    </tr>
    <tr>
        <td colspan="3">在Camera中, 要设置Camera的参数,首先要获取当前设备所支持的值, 才能对其进行设置, 获取设备的支持的集合用方法`getSupportedXXX()`来获取.<br/>
        通过方法`setXXX()`来设置值.<br/>
        通过方法`getXXX()`来获取当前的值.<br/>

        支持这种机制的参数有以下列出:

            <table>
                <tr>
                    <td>反冲带</td>
                    <td>Antibanding</td>
                </tr>
                <tr>
                    <td>自动曝光</td>
                    <td>Autoexposure</td>
                </tr>
                <tr>
                    <td>零延时拍照模式</td>
                    <td>ZSLModes</td>
                </tr>

                <tr>
                    <td>预览大小</td>
                    <td>PreviewSizes</td>
                </tr>

                <tr>
                    <td>视频大小</td>
                    <td>VideoSizes</td>
                </tr>

                <tr>
                    <td>预览格式</td>
                    <td>PreviewFormats</td>
                </tr>

                <tr>
                    <td>图片大小</td>
                    <td>PicutreSizes</td>
                </tr>

                <tr>
                    <td>图片格式</td>
                    <td>PictureSizes</td>
                </tr>

                <tr>
                    <td>白平衡</td>
                    <td>WhiteBanlance</td>
                </tr>

                <tr>
                    <td>滤镜</td>
                    <td>ColorEffects</td>
                </tr>
                <tr>
                    <td>场景模式</td>
                    <td>SceneModes</td>
                </tr>
                <tr>
                    <td>闪光灯模式</td>
                    <td>FlashModes</td>
                </tr>
                <tr>
                    <td>聚焦模式</td>
                    <td>FocusModes</td>
                </tr>
                <tr>
                    <td>HFR</td>
                    <td>HfrSizes</td>
                </tr>
                <tr>
                    <td>感光度</td>
                    <td>IsoValues</td>
                </tr>
                <tr>
                    <td>具体不清楚</td>
                    <td>HistogramModes</td>
                    <td>用来检测`startPreview`方法是否被调用. </td>
                </tr>
                <tr>
                    <td>视频HDR</td>
                    <td>VideoHDRModes</td>
                </tr>
                <tr>
                    <td>降噪模式</td>
                    <td>DenoiseModes</td>
                </tr>
                <tr>
                    <td>Jpeg缩略图大小</td>
                    <td>JpegThumbnailSizes</td>
                </tr>
                <tr>
                    <td>预览帧率</td>
                    <td>PreviewFrameRates</td>
                </tr>
                <tr>
                    <td>预览帧率的范围</td>
                    <td>PreviewFpsRange</td>
                </tr>
                <tr>
                    <td>触摸AF/AEC</td>
                    <td>TouchAfAec</td>
                </tr>

                <tr>
                    <td>场景检测</td>
                    <td>SceneDetectModes</td>
                </tr>
                <tr>
                    <td>镜头遮光</td>
                    <td>LensShadeModes</td>
                </tr>
                <tr>
                    <td>连续自动聚焦</td>
                    <td>ContinuousAfModes</td>
                </tr>

                <tr>
                    <td>可选区域的自动对焦</td>
                    <td>SelectableZoneAf</td>
                </tr>

                <tr>
                    <td>人脸检测模式</td>
                    <td>FaceDetectionModes</td>
                </tr>

                <tr>
                    <td>红眼处理</td>
                    <td>RedeyeReductionMode</td>
                </tr>

                <tr>
                    <td>视频旋转模式</td>
                    <td>VideoRotationValues</td>
                </tr>

                <tr>
                    <td>预览帧模式</td>
                    <td>PreviewFrameRateModes</td>
                </tr>
            </table>
            还有一些其他的数据如: 设置曝光度，锐度，设置GPS位置信息数据, 调整镜头远近，等等
            就列出这么多吧. 剩的请查看源码`/frameworks/base/core/java/android/hardware/Camera.java`.
        </td>
    </tr>
</table>
