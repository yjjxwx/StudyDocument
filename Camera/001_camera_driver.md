#Camera驱动部分学习记录#
摄像头驱动程序:通常基于Linux的Video for Linux 视频驱动框架.
有关该框架的详细描述请点击查看 [Video For Linux][1] 的官方描述.

![V4L2][p1]

目前的驱动头文件的存放目录是Android源码中:
>1. `/kernel/include/uapi/linux/v4l2-common.h`
>2. `/kernel/include/uapi/linux/v4l2-controls.h`
>3. `/kernel/include/uapi/linux/videodev2.h`
>4. `/kernel/include/media/v4l2-dev.h`

--------------------------------------------------

下面的章节会对这四个文件进行详细的描述:

* ##`v4l2-common.h`.这个文件里面定义了很多常量.##

|标志                    |值|定义|
|:---|:---|:---|
|V4L2_SEL_TGT_CROP        |0x0000|*真实的取样区域(左上角及源矩形区域的宽高)*|
|V4L2_SEL_TGT_CROP_DEFAULT|0x0001|*默认裁剪区域(左上角的坐标(0,0),区域的宽和高)*|
|V4L2_SEL_TGT_CROP_BOUNDS|0x0002|*裁剪区域(包括左上角的坐标,建议(0,0),区域的宽和高)*|
|V4L2_SEL_TGT_COMPOSE|0x0100|*控制缓冲部分插入硬件的哪一个图片中，矩形区域使用的坐标系统与边界矩形区域相同。组合矩形区域必须完全在辩解矩形区域内。驱动必须使组合矩形区域适应边界限制。另外，驱动还要根据硬件限制做出其他调整。应用程序同样可以通过constraint_flags进行舍入控制。*|
|V4L2_SEL_TGT_COMPOSE_DEFAULT|0x0101|*默认的组合矩形区域,通常它的值与边界区域相同*|
|V4L2_SEL_TGT_COMPOSE_BOUNDS|0x0102|*给出了组合坐标的限制。所有坐标都是以像素为单位的。矩形区域的左上角必须定位到位置(0,0)，宽高与VIDIOC_S_FMT设置的图片尺寸相同。*|
|V4L2_SEL_TGT_COMPOSE_PADDED|0x0103|*给出硬件会修改哪部分缓存，它包含了V4L2_SEL_TGT_COMPOSE的所有像素, 硬件会修改填充的数据，硬件不能对此矩形区域外的所有的像素进行任何改变。那些在活跃区域外却在填充区域内的像素内容是未定义的（不确定的）。应用程序可以检查填充和活跃矩形区域中哪里有垃圾像素，必要时可以删除他们。*|
|V4L2_SEL_TGT_CROP_ACTIVE | V4L2_SET_TGT_CROP|*待描述 已经过时*|
|V4L2_SEL_TGT_COMPOSE_ACTIVE |V4L2_SEL_TGT_COMPOSE|*待描述 已经过时*|
|V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL|V4L2_SEL_TGT_CROP|*待描述 已经过时*|
|V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL|V4L2_SEL_TGT_COMPOSE|*待描述 已经过时*|
|V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS|V4L2_SEL_TGT_CROP_BOUNDS|*待描述 已经过时*|
|V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS|V4L2_SEL_TGT_COMPOSE_BOUNDS|*待描述 已经过时*|
|V4L2_SEL_FLAG_GE|1 << 0|*建议驱动选择相对于请求尺寸更大或相等的矩形区域*|
|V4L2_SEL_FLAG_LE|1 << 1|*建议驱动选择相对于请求尺寸更小或相等的矩形区域*|
|V4L2_SEL_FLAG_KEEP_CONFIG|1 << 2|*此设置不能在之后的处理步骤中被传播。如果没有设置这个标签，设置可以在子设备之后的处理过程中被传播*|
|V4L2_SUBDEV_SEL_FLAG_SIZE_GE|V4L2_SEL_FLAG_GE|*待描述 已经过时*|
|V4L2_SUBDEV_SEL_FLAG_SIZE_LE|V4L2_SEL_FLAG_LE|*待描述 已经过时*|
|V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG|V4L2_SEL_FLAG_GE|*待描述 已经过时*|

* ## `v4l2-controls.h`. 这个文件时定义了一系列的控制标志以及能力范围.下面会列出部分与Camera相关的控制标志以及能力范围 .##


    #define V4L2_CID_CAMERA_CLASS_BASE 	(V4L2_CTRL_CLASS_CAMERA | 0x900)
    #define V4L2_CID_CAMERA_CLASS 		(V4L2_CTRL_CLASS_CAMERA | 1)

    #define V4L2_CID_EXPOSURE_AUTO			(V4L2_CID_CAMERA_CLASS_BASE+1)
    enum  v4l2_exposure_auto_type {
        V4L2_EXPOSURE_AUTO = 0,
        V4L2_EXPOSURE_MANUAL = 1,
        V4L2_EXPOSURE_SHUTTER_PRIORITY = 2,
        V4L2_EXPOSURE_APERTURE_PRIORITY = 3
    };
    #define V4L2_CID_EXPOSURE_ABSOLUTE		(V4L2_CID_CAMERA_CLASS_BASE+2)
    #define V4L2_CID_EXPOSURE_AUTO_PRIORITY		(V4L2_CID_CAMERA_CLASS_BASE+3)

    #define V4L2_CID_PAN_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+4)
    #define V4L2_CID_TILT_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+5)
    #define V4L2_CID_PAN_RESET			(V4L2_CID_CAMERA_CLASS_BASE+6)
    #define V4L2_CID_TILT_RESET			(V4L2_CID_CAMERA_CLASS_BASE+7)

    #define V4L2_CID_PAN_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+8)
    #define V4L2_CID_TILT_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+9)

    #define V4L2_CID_FOCUS_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+10)
    #define V4L2_CID_FOCUS_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+11)
    #define V4L2_CID_FOCUS_AUTO			(V4L2_CID_CAMERA_CLASS_BASE+12)

    #define V4L2_CID_ZOOM_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+13)
    #define V4L2_CID_ZOOM_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+14)
    #define V4L2_CID_ZOOM_CONTINUOUS		(V4L2_CID_CAMERA_CLASS_BASE+15)

    #define V4L2_CID_PRIVACY			(V4L2_CID_CAMERA_CLASS_BASE+16)

    #define V4L2_CID_IRIS_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+17)
    #define V4L2_CID_IRIS_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+18)

    #define V4L2_CID_AUTO_EXPOSURE_BIAS		(V4L2_CID_CAMERA_CLASS_BASE+19)

    #define V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE	(V4L2_CID_CAMERA_CLASS_BASE+20)
    enum v4l2_auto_n_preset_white_balance {
        V4L2_WHITE_BALANCE_MANUAL		= 0,
        V4L2_WHITE_BALANCE_AUTO			= 1,
        V4L2_WHITE_BALANCE_INCANDESCENT		= 2,
        V4L2_WHITE_BALANCE_FLUORESCENT		= 3,
        V4L2_WHITE_BALANCE_FLUORESCENT_H	= 4,
        V4L2_WHITE_BALANCE_HORIZON		= 5,
        V4L2_WHITE_BALANCE_DAYLIGHT		= 6,
        V4L2_WHITE_BALANCE_FLASH		= 7,
        V4L2_WHITE_BALANCE_CLOUDY		= 8,
        V4L2_WHITE_BALANCE_SHADE		= 9,
    };

    #define V4L2_CID_WIDE_DYNAMIC_RANGE		(V4L2_CID_CAMERA_CLASS_BASE+21)
    #define V4L2_CID_IMAGE_STABILIZATION		(V4L2_CID_CAMERA_CLASS_BASE+22)

    #define V4L2_CID_ISO_SENSITIVITY		(V4L2_CID_CAMERA_CLASS_BASE+23)
    #define V4L2_CID_ISO_SENSITIVITY_AUTO		(V4L2_CID_CAMERA_CLASS_BASE+24)
    enum v4l2_iso_sensitivity_auto_type {
        V4L2_ISO_SENSITIVITY_MANUAL		= 0,
        V4L2_ISO_SENSITIVITY_AUTO		= 1,
    };

    #define V4L2_CID_EXPOSURE_METERING		(V4L2_CID_CAMERA_CLASS_BASE+25)
    enum v4l2_exposure_metering {
        V4L2_EXPOSURE_METERING_AVERAGE		= 0,
        V4L2_EXPOSURE_METERING_CENTER_WEIGHTED	= 1,
        V4L2_EXPOSURE_METERING_SPOT		= 2,
        V4L2_EXPOSURE_METERING_MATRIX		= 3,
    };

    #define V4L2_CID_SCENE_MODE			(V4L2_CID_CAMERA_CLASS_BASE+26)
    enum v4l2_scene_mode {
        V4L2_SCENE_MODE_NONE			= 0,
        V4L2_SCENE_MODE_BACKLIGHT		= 1,
        V4L2_SCENE_MODE_BEACH_SNOW		= 2,
        V4L2_SCENE_MODE_CANDLE_LIGHT		= 3,
        V4L2_SCENE_MODE_DAWN_DUSK		= 4,
        V4L2_SCENE_MODE_FALL_COLORS		= 5,
        V4L2_SCENE_MODE_FIREWORKS		= 6,
        V4L2_SCENE_MODE_LANDSCAPE		= 7,
        V4L2_SCENE_MODE_NIGHT			= 8,
        V4L2_SCENE_MODE_PARTY_INDOOR		= 9,
        V4L2_SCENE_MODE_PORTRAIT		= 10,
        V4L2_SCENE_MODE_SPORTS			= 11,
        V4L2_SCENE_MODE_SUNSET			= 12,
        V4L2_SCENE_MODE_TEXT			= 13,
    };

    #define V4L2_CID_3A_LOCK			(V4L2_CID_CAMERA_CLASS_BASE+27)
    #define V4L2_LOCK_EXPOSURE			(1 << 0)
    #define V4L2_LOCK_WHITE_BALANCE			(1 << 1)
    #define V4L2_LOCK_FOCUS				(1 << 2)

    #define V4L2_CID_AUTO_FOCUS_START		(V4L2_CID_CAMERA_CLASS_BASE+28)
    #define V4L2_CID_AUTO_FOCUS_STOP		(V4L2_CID_CAMERA_CLASS_BASE+29)
    #define V4L2_CID_AUTO_FOCUS_STATUS		(V4L2_CID_CAMERA_CLASS_BASE+30)
    #define V4L2_AUTO_FOCUS_STATUS_IDLE		(0 << 0)
    #define V4L2_AUTO_FOCUS_STATUS_BUSY		(1 << 0)
    #define V4L2_AUTO_FOCUS_STATUS_REACHED		(1 << 1)
    #define V4L2_AUTO_FOCUS_STATUS_FAILED		(1 << 2)

    #define V4L2_CID_AUTO_FOCUS_RANGE		(V4L2_CID_CAMERA_CLASS_BASE+31)
    enum v4l2_auto_focus_range {
        V4L2_AUTO_FOCUS_RANGE_AUTO		= 0,
        V4L2_AUTO_FOCUS_RANGE_NORMAL		= 1,
        V4L2_AUTO_FOCUS_RANGE_MACRO		= 2,
        V4L2_AUTO_FOCUS_RANGE_INFINITY		= 3,
    };

上面的代码列出了V4L2框架对于Camera所支持的基本能力.其中包括了(曝光,聚焦,白平衡,调整焦距,虹膜识别(IRIS),
HDR(4L2_CID_WIDE_DYNAMIC_RANGE), 防抖(STABILIZATION),ISO, 测光方式, 场景模式)

* ##`videodev2.h`.
楼主只能说,这里面定义了太多的数据结构和常量, 作为首次看的我, 表示已经被吓死啦啦啦....
这个我处理不了了..看下个文件吧亲们..


* ##`v4l2-dev.h`. 文件定义了视频设备的数据结构以及所支持的操作.

以下是视频设备的数据类型.##
其实现文件存放位置是:`/kernel/drivers/media/v4l2-core/v4l2-dev.c`


    /*
    * Newer version of video_device, handled by videodev2.c
    * 	This version moves redundant code from video device code to
    *	the common handler
    */

    struct video_device
    {
        #if defined(CONFIG_MEDIA_CONTROLLER)
        struct media_entity entity;
        #endif
        /* device ops */
        const struct v4l2_file_operations *fops;

        /* sysfs */
        struct device dev;		/* v4l device */
        struct cdev *cdev;		/* character device */

        /* Set either parent or v4l2_dev if your driver uses v4l2_device */
        struct device *parent;		/* device parent */
        struct v4l2_device *v4l2_dev;	/* v4l2_device parent */

        /* Control handler associated with this device node. May be NULL. */
        struct v4l2_ctrl_handler *ctrl_handler;

        /* vb2_queue associated with this device node. May be NULL. */
        struct vb2_queue *queue;

        /* Priority state. If NULL, then v4l2_dev->prio will be used. */
        struct v4l2_prio_state *prio;

        /* device info */
        char name[32];
        int vfl_type;	/* device type */
        int vfl_dir;	/* receiver, transmitter or m2m */
        /* 'minor' is set to -1 if the registration failed */
        int minor;
        u16 num;
        /* use bitops to set/clear/test flags */
        unsigned long flags;
        /* attribute to differentiate multiple indices on one physical device */
        int index;

        /* V4L2 file handles */
        spinlock_t		fh_lock; /* Lock for all v4l2_fhs */
        struct list_head	fh_list; /* List of struct v4l2_fh */

        int debug;			/* Activates debug level*/

        /* Video standard vars */
        v4l2_std_id tvnorms;		/* Supported tv norms */
        v4l2_std_id current_norm;	/* Current tvnorm */

        /* callbacks */
        void (*release)(struct video_device *vdev);

        /* ioctl callbacks */
        const struct v4l2_ioctl_ops *ioctl_ops;
        DECLARE_BITMAP(valid_ioctls, BASE_VIDIOC_PRIVATE);

        /* serialization lock */
        DECLARE_BITMAP(disable_locking, BASE_VIDIOC_PRIVATE);
        struct mutex *lock;
    };


以下为V4L2框架定义视频设备所支持的操作:


    #define media_entity_to_video_device(__e) \
        container_of(__e, struct video_device, entity)
    /* dev to video-device */
    #define to_video_device(cd) container_of(cd, struct video_device, dev)

    int __must_check __video_register_device(struct video_device *vdev, int type,
        int nr, int warn_if_nr_in_use, struct module *owner);

    /* Register video devices. Note that if video_register_device fails,
    the release() callback of the video_device structure is *not* called, so
    the caller is responsible for freeing any data. Usually that means that
    you call video_device_release() on failure. */
    static inline int __must_check video_register_device(struct video_device *vdev,
        int type, int nr)
    {
            return __video_register_device(vdev, type, nr, 1, vdev->fops->owner);
    }

    /* Same as video_register_device, but no warning is issued if the desired
    device node number was already in use. */
    static inline int __must_check video_register_device_no_warn(
        struct video_device *vdev, int type, int nr)
    {
            return __video_register_device(vdev, type, nr, 0, vdev->fops->owner);
    }

    /* Unregister video devices. Will do nothing if vdev == NULL or
    video_is_registered() returns false. */
    void video_unregister_device(struct video_device *vdev);

    /* helper functions to alloc/release struct video_device, the
    latter can also be used for video_device->release(). */
    struct video_device * __must_check video_device_alloc(void);

    /* this release function frees the vdev pointer */
    void video_device_release(struct video_device *vdev);

    /* this release function does nothing, use when the video_device is a
    static global struct. Note that having a static video_device is
    a dubious construction at best. */
    void video_device_release_empty(struct video_device *vdev);

    /* returns true if cmd is a known V4L2 ioctl */
    bool v4l2_is_known_ioctl(unsigned int cmd);

    /* mark that this command shouldn't use core locking */
    static inline void v4l2_disable_ioctl_locking(struct video_device *vdev, unsigned int cmd)
    {
        if (_IOC_NR(cmd) < BASE_VIDIOC_PRIVATE)
        set_bit(_IOC_NR(cmd), vdev->disable_locking);
    }

    /* Mark that this command isn't implemented. This must be called before
    video_device_register. See also the comments in determine_valid_ioctls().
    This function allows drivers to provide just one v4l2_ioctl_ops struct, but
    disable ioctls based on the specific card that is actually found. */
    static inline void v4l2_disable_ioctl(struct video_device *vdev, unsigned int cmd)
    {
        if (_IOC_NR(cmd) < BASE_VIDIOC_PRIVATE)
        set_bit(_IOC_NR(cmd), vdev->valid_ioctls);
    }

    /* helper functions to access driver private data. */
    static inline void *video_get_drvdata(struct video_device *vdev)
    {
        return dev_get_drvdata(&vdev->dev);
    }

    static inline void video_set_drvdata(struct video_device *vdev, void *data)
    {
        dev_set_drvdata(&vdev->dev, data);
    }

    struct video_device *video_devdata(struct file *file);

    /* Combine video_get_drvdata and video_devdata as this is
    used very often. */
    static inline void *video_drvdata(struct file *file)
    {
        return video_get_drvdata(video_devdata(file));
    }

    static inline const char *video_device_node_name(struct video_device *vdev)
    {
        return dev_name(&vdev->dev);
    }

    static inline int video_is_registered(struct video_device *vdev)
    {
        return test_bit(V4L2_FL_REGISTERED, &vdev->flags);
    }









[1]:http://www.linuxtv.org/downloads/legacy/video4linux/API/V4L2_API/spec-single/v4l2.html
[2]:http://linuxtv.org/downloads/v4l-dvb-apis/

[p1]:V4L2.png
