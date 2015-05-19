#1. API-1 和 API-2 (Camera 或 Camera2)
### **OneCameraManager**
- **OneCameraManager.java** 是一个 abstract class, 主要接口`open()`; 具体方法实现在 com.android.camera.one.**v1.OneCameraManagerImpl** 和 com.android.camera.one.**v2.OneCameraManagerImpl** 中，通过 `isCamera2Supported()` 方法判断是否支持 Camera2 API (Legancy的支持也不行)。

`CameraActivity.onCreate()` 中实例化: `mCameraManager = OneCameraManager.get(this);`

```java
private static OneCameraManager create(CameraActivity activity) {
    DisplayMetrics displayMetrics = getDisplayMetrics(activity);
    CameraManager cameraManager = (CameraManager) activity.getSystemService(Context.CAMERA_SERVICE);
    int maxMemoryMB = activity.getServices().getMemoryManager().getMaxAllowedNativeMemoryAllocation();
    if (cameraManager != null && isCamera2Supported(cameraManager)) {
        return new com.android.camera.one.v2.OneCameraManagerImpl(
                activity.getApplicationContext(), cameraManager, maxMemoryMB,
                displayMetrics, activity.getSoundPlayer());
    } else {
        return new com.android.camera.one.v1.OneCameraManagerImpl();
    }
}
```
>**v1.OneCameraManagerImpl** 没用..

>**v2.OneCameraManagerImpl** 用Camera2里的 CameraManager 管理

### CameraAgent
- **com.android.ex.camera2** 是在framework里的，主要是对`hardware.Camera`和`hardware.Camera2`的操作、状态、Callback进行封装，通过`CameraHandler` 和 `Camera2Handler`来处理。
- **com.android.ex.camera2.portability.CameraAgent** 是一个 abstract class, 具体方法实现在 com.android.ex.camera2.portability.**AndroidCameraAgentImpl** 和 com.android.ex.camera2.portability.**AndroidCamera2AgentImpl** 中
> 比如 `public void openCamera(final Handler handler, final int cameraId, final CameraOpenCallback callback)`方法，App里是PhotoModule的`requestCameraOpen()`调用到的。

### **CameraController**
- **CameraController** 里面包含了两个个**CameraAgent**的成员变量: `mCameraAgent`和`mCameraAgentNg`，`CameraActivity.onCreate()` 中指定是否需要新的API，如果可以支持新API，**则两个CameraAgent同时存在！**

```java
mCameraController = new CameraController(mAppContext, this, mMainHandler,
    CameraAgentFactory.getAndroidCameraAgent(this, CameraAgentFactory.CameraApi.API_1),
    CameraAgentFactory.getAndroidCameraAgent(this, CameraAgentFactory.CameraApi.AUTO));
```
`getAndroidCameraAgent()`方法判断当前SDK版本来确认能否支持到API_2(是否有Camera2这个包), 此类是framework中的，有个prop可以override这个值 `camera2.portability.force_api`，比如TCL evoque 这个值就是 1，强制使用api-1。

```java
private static final String API_LEVEL_OVERRIDE_KEY = "camera2.portability.force_api";

private static CameraApi validateApiChoice(CameraApi choice) {
    if (API_LEVEL_OVERRIDE_VALUE.equals(API_LEVEL_OVERRIDE_API1)) {
        Log.d(TAG, "API level overridden by system property: forced to 1");
        return CameraApi.API_1;
    } else if (API_LEVEL_OVERRIDE_VALUE.equals(API_LEVEL_OVERRIDE_API2)) {
        Log.d(TAG, "API level overridden by system property: forced to 2");
        return CameraApi.API_2;
    }

    if (choice == null) {
        Log.w(TAG, "null API level request, so assuming AUTO");
        choice = CameraApi.AUTO;
    }
    if (choice == CameraApi.AUTO) {
        choice = highestSupportedApi();
    }

    return choice;
}

private static CameraApi highestSupportedApi() {
    // TODO: Check SDK_INT instead of RELEASE before L launch
    if (Build.VERSION.SDK_INT >= FIRST_SDK_WITH_API_2 || Build.VERSION.CODENAME.equals("L")) {
        return CameraApi.API_2;
    } else {
        return CameraApi.API_1;
    }
}
```

基本关系

| Version | Hardward | API-2 | App Module   | OneCameraManager | CameraAgent |
| :----   | --------:|  :-:  | -----------: |     -----------: | -----------:|
| 5.0     |   FULL   |  YES  |CaptureModule?| v2               | Camera2AgentImpl
| 5.0     |  LIMIT   |  YES  |CaptureModule?| v2               | Camera2AgentImpl
| 5.0     | LEGACY   |  YES  | PhotoModule  | v1               | Camera2AgentImpl
| 4.4     |    N/A   |   NO  | PhotoModule  | v1               | CameraAgentImpl

>  - CameraActivity.onCreate() 中实例化 `OneCameraManager` 和 `mCameraController.CameraAgent`
>  - CameraAgentImpl 中getCamera()返回hardware.camera，
>  - Camera2AgentImpl 中getCamera()返回null， 如果使用这个则**不能使用`Camera`的实例来设置参数等！**
>  - 如果是 LEGACY 的 5.0 设备，支持`Camera2AgentImpl`，但是默认使用的是`PhotoModule`，如果通过`mCameraDevice.getCamera()`的方式操作`camera`的实例，会出现空指针。
>  - 可以通过修改`OneCameraManager`使LEGACY的设备使用`v2.OneCameraManagerImpl`，`DebugPropertyHelper`中指定使用`CaptureModule`，拍照尺寸改小，可以正常预览和拍照。

#2.相机界面：
###0>. PreviewOverlay的touch事件
PreviewOverlay有一个OnTouchListener，在onTouchEvent中也会处理一些附加的touchListener；
CameraAppUI`prepareModuleUI`中设置了PreviewOverlay的OnTouchListener `mPreviewOverlay.setOnTouchListener(new MyTouchListener())`
```java
    private class MyTouchListener implements View.OnTouchListener {
        private boolean mScaleStarted = false;
        @Override
        public boolean onTouch(View v, MotionEvent event) {
            if (event.getActionMasked() == MotionEvent.ACTION_DOWN) {
                mScaleStarted = false;
            } else if (event.getActionMasked() == MotionEvent.ACTION_POINTER_DOWN) {
                mScaleStarted = true;
            }
            return (!mScaleStarted) && mGestureDetector.onTouchEvent(event);
        }
    }
```
这里会拦截事件（mScaleStarted 和 mGestureDetector 的状态），使其是否能进入onTouchEvent；

###1>. 滑动进出图库
`MainActivityLayout` 的 `onInterceptTouchEvent` 中分发touch事件给 mModeList 或 mFilmstripLayout
FilmstripLayout 中的 MyGestureListener 处理滑动的操作

//CameraAppUI.java 中的 MyGestureListener 检测出 SWIPE_RIGHT or SWIPE_LEFT
//执行 onSwipeDetected 作对应的操作
mFilmstripLayout onSwipeOut showFilmstrip

###2>.手势左滑 滑出模式切换按钮 右滑 隐藏
ModeListView.java中的
mOnGestureListener

mOnGestureListener 的
onScroll

ScrollingState 的 onTouchEvent中
snapBack
snapToFullScreen

###3>.点击对焦
CameraAppUI.onPreviewListenerChanged()(`PreviewOverlay.setGestureListener`)
-->PhotoUI.getGestureListener()-->PhotoModule`onSingleTapUp()`-->FocusOverlayManager`onSingleTapUp()`

PhotoUI.java中的 mPreviewGestureListener
PhotoModule.java 实现了 onSingleTapUp

CaptureModuleUI.java中的 mPreviewGestureListener
CaptureModule.java 实现了 onSingleTapUp

DebugPropertyHelper.isCaptureModuleEnabled() 决定使用哪个Module

###4>.双指缩放变焦
PreviewOverlay.java 中的 ZoomGestureDetector mScaleDetector
> - QuickScale功能：快速双击后立刻滑动，会触发Scale事件，`setQuickScaleEnabled(false)`可禁用；

###5>. 拍照动画
- **闪一下的动画**
photoModule `animateFlash` --> photoModule `startPreCaptureAnimation` --> CameraActivity `startPreCaptureAnimation` --> CameraAppUI `startPreCaptureAnimation` --> CaptureAnimationOverlay `startFlashAnimation`
- **进图库的动画**
photoModule `onMediaSaved` --> CameraActivity `notifyNewMedia` --> `startPeekAnimation` --> CameraAppUI `startPeekAnimation`
- **这个动画貌似没用？**
photoModule JpegPictureCallback --> saveFinalPhoto --> mUI.animateCapture

###6>.预览区域
CaptureLayoutHelper.java 中
mPreviewRect 预览区域 使用 `getPreviewRect()`得到
mBottomBarRect 底部快门按钮区域 使用 `getBottomBarRect()`得到

```xml
<dimen name="bottom_bar_height_min">84dp</dimen>
<dimen name="bottom_bar_height_max">120dp</dimen>
<dimen name="bottom_bar_height_optimal">96dp</dimen>
```

###7>.图库中的滑动
FilmstripView.java 中的
mGestureListener
mGestureRecognizer
performAccessibilityAction

控件：
底部操作栏（快门等）：
BottomBar.java 继承自 FrameLayout， 包含 mShutterButton 等控件
布局关系 mode_options_bottombar.xml --> bottom_bar_contents.xml

设置栏的开关（点击后出现设置栏）
mode_options_bottombar.xml --> mode_options_overlay.xml --> indicators.xml 中的 mode_options_toggle
操作栏上面的设置栏（闪光灯等）
ModeOptions.java 继承自 FrameLayout，包含 TopRightWeightedLayout RadioOptions 等类型控件
布局关系 mode_options_bottombar.xml --> mode_options_overlay.xml --> mode_options.xml

mode_options_bottombar.xml BottomBarModeOptionsWrapper 控件是全屏的；
onLayout 中 控制 mModeOptionsOverlay 和 mBottomBar 的 布局；

#3.设置项：
摄像尺寸
SettingsUtil.java 中有个数组 sVideoQualities，
通过getSelectedVideoQualities得到三个能支持的尺寸，large medium samll;
CameraSettingActivity.java 中将array中的字串 和这个对比过滤；
拍照尺寸
CameraSettingsFragment 中 loadSizes(), 调用到 CameraPictureSizesCacher 中的 getSizesForCamera，会通过openCamera得到相机的拍照尺寸；
尺寸筛选时用到 ResolutionUtil.sDesiredAspectRatios 过滤掉不用的比例；
每个比例最多留三个尺寸 large medium small
mOldPictureSizesBack 是根据最大尺寸的比例 选出的三个值
mPictureSizesBack 是根据sDesiredAspectRatios的比例选出的
第一次开相机时，会先执行 AppUpgrader-->upgradeCameraSizeSetting 设置一个pictureSize的默认值；

#4.各种模式：
CameraActivity.`OnCreate` --> ModulesInfo.`setupModules` --> ModuleManager.`registerModule`

过滤不支持尺寸：
1.ModulesInfo.`setupModules`中用判断条件不去注册Module；
2.CameraActivity.`onCameraOpened`中通过Camera的Parameter来判断，然后通过 ModuleManager.`unregisterModule`来注销一些模式； （未验证）
