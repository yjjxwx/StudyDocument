## Camera 2 Package

 android.hardward.camera2 包提供了一套使得摄像设备与安卓设备之间的连接独立的接口．它替换了已经过时的
 android.hardware.Camera  类．

Camera2　package把摄像设备作为一个管道来构建，需要输入请求来捕获帧数据，每一
个输入请求只能捕获一帧的数据，　然后把输出结果打包为一个m metadata 的数据包，这个数据包
里面附加了输出图像缓冲区的集合．请求是按照顺序来处理的，多个请求可以一次性处理．由于摄像设备是拥有多
个状态的管道，一次性处理多个请求的时候就要求这些请求在大多数的安卓设备上保持完全一致的帧率．


正常情况下，可以获取一个 android.hardware.camera2.CameraManage 的实例来枚举，查询或是打开可用的摄像设备．


一个 android.hardware.camera2.CameraDevice  提供了一个静态属性信息的集合，用来描述当前设备的摄像设备以及摄像设备可用的设置
和输出参数．这个信息的获取是通过一个 android.hardware.camera2.CameraCharacteristics  的对象来得到的，　这个对象可以通过 android.hardware.camera2.CameraManager#getCameraCharacteristics 来得到．


为了从一个摄像设备捕获一张图片或是图片流，应用程序必须首先用一个 Surface 集合传入
 android.hardware.camera2.CameraDevice#createCaptureSession 来创建一个
 android.hardware.camera2.CameraCaptureSession  的摄像捕获会话．
每一个 Surface 必须要使用 android.hardware.camera2.params.StreamConfigurationMap 来配置大小和数据格式，这些大小和数据格式必须是被设备所支持的．
一个目标 Surface 对象可以从多个类来获取，包括 android.view.SurfaceView ,
 android.graphics.SurfaceTexture 通过 android.view.Surface#Surface(SurfaceTexture) 来创建，android.media.MediaCodec ,  android.media.MediaRecorder, android.renderscript.Allocation  和　android.media.ImageReader.


一般情况下，摄像的预览图像通过 android.graphics.SurfaceTexture 发送到 SurfaceView 或是 TextureView．为 android.hardware.camera2.DngCreator 捕获JPEG或是RAW缓冲格式的图像可以使用 android.graphics.ImageFormat#JPEG 和 android.graphics.ImageFormat#RAW_SENSOR 格式．应用程序处理图片数据最好在使用 RenderScript 和 OpenGL ES  或是直接在原生代码中，　分别在 android.renderscript.Allocation 用 android.renderscript.Type 的 YUV 格式或是 android.graphics.SurfaceTexture 中用 android.graphics.ImageFormat#YUV_420_888 格式．


应用程序需要构造一个 android.hardware.camera2.CaptureRequest 的对象，该对象包含了一个摄像设备去捕获一张单一图片所应有的所有拍照参数．这个请求对象同时也列出了本次拍摄应该
使用哪些已经配置好的目标Surface．CameraDevice 有一个工厂方法 android.hardware.camera2.CameraDevice#createCaptureRequest 用来创建一个 android.hardware.camera2.CaptureRequest.Builder 的构建器给用户使用，这是针对运行于Android设备上的应用程序而优化的．　


一旦请求被设置完成，就可以被当前活动的捕获会话所使用不管是 android.hardware.camera2.CameraCaptureSession#caputre 一次性的使用或是 android.hardware.camera2.CameraCaputreSession#setRepeatingRequest 无休止的使用．
两种方式都有一个变种用于接收一系列的请求来实现爆炸式拍照或是重复爆炸式拍照（连拍）．
Repeating request的优先级要比capture request的低，因此当通过capture提交请求的
同时之前也有一个repeating request在任何实例上被配置好，将会开始capture而不是repeating capture．


在处理完一个请求之后，摄像设备将会产生一个 android.hardware.camera2.TotalCaptureResult 对象，它包含了在拍照时摄像设备的状态和最后使用的设置信息．
如果有必要处理参数冲突或是舍入一些值时，这些设置可能会与原有的请求有所变化．
摄像设备也会向请求包含的所有Surface中发送一帧的图片数据．这些操作与CaptureResult
的输出都是异步处理的，有时比实际上要慢．
