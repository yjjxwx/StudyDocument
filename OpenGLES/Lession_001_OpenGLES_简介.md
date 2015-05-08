#初始 OpenGL ES 2.0#

## 1. OpenGL ES 2.0 概览##
### 1.1 OpenGL ES 2.0 简介 ###

OpenGL ES 专门为嵌入式设备（如掌上电脑，手机等）设计，从 OpenGL 裁剪而来，去除了一些不必存在的特性，去除了 OpenGL 原来的 GL_QUADS 和GL_PLONGONS 绘制方式，以及glBegin和glEnd等操作。

目前市场上主要面向 3D 图形的 API 主要有三个， 分别为 __DirectX__， __OpenGL__ 和 **OpenGL ES**。
+ **DirectX** 主要应用与 **Windows** 平台的游戏开发，在此领域可以说是一统天下。
+ **OpenGL** 的应用就比较广泛，适用于 **Unix**, **Linux**, **Mac Os** 和 **Microsoft** 等几乎所有的操作系统。可以开发游戏， 工业建模以及嵌入式设备。
+ **OpenGL ES**就如前面所说是 **OpenGL** 的一个子集。去除了一些不必要的特性。经过多年的发展 **OpenGL ES**现在发展为两个主要的版本。
+ 一个是 **OpenGL ES 1.x** （主要包括1.0与1.1），其采用的是固定渲染管线， 可以由硬件GPU支持或用软件模拟实现，渲染能力有限，在纯软件模拟情况下性能也比较弱。
+ 另一个是 **OpenGL ES 2.0**, 其采用的是可编程渲染管线， 渲染能力大大提高。**OpenGL ES 2.0**要求设备中必须有相应的GPU硬件支持， 目前不支持在设备上用软件模拟实现。不过几乎所有目前市场上流通的手机都支持 OpenGL ES 2.0， 最新手机甚至支持 OpenGL ES 3.0 比如 **Google** 最新推出的 **Nexus 6**。

### 1.2 初识 OpenGL ES 2.0应用程序 ###

前一小节简单地介绍了 OpenGL ES 2.0 与 OpenGL ES 1.x 的不同之处， 在本小节将通过一个旋转三角形的案例向读者介绍，如何使用 OpenGL ES 2.0 进行 3D 场景的开发。本博客所有的代码都可以在我个人的 **[Github]** 上进行下载，点击就可进入。
1. 在开发本案例的功能直接相关的各种类之前，首先需要开发一个本博客案例都需要用到的工具类--**ShaderUtil**,其功能是将着色器（Shader)脚本加载进显卡并编译。最先开发的是类中从着色器脚本中加载着色器内容的`loadFromAssetsFile` 方法和检查每一步操作是否有错误的`checkGLError`方法。

2. 实现`createShader`和`createProgram`方法。


[Github]:https://github.com/yjjxwx/OpenGLES "Github"
