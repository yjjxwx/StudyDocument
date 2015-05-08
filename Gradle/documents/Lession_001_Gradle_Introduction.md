#Use Gradle build the native library#
> The Gradle support for build native binaries is currently incubating.

The various native binary plugins add support for building native software components, such as executables or shared libraries, form code written in C++, C and other languages. While many excellent build tools exist for this space of software development, Gradle offers developers its trademark power and flexibility together with dependency management practices more traditionally found in the JVM development space.

## 1. Supported languages ##
The following source languages are currently supported:
* C
* C++
* Objective-C
* Objective-C++
* Assembly
* Windows resources

## 2. Tool chain support ##
Gradle offers the ability to execute the same build using different tools chains. When you build a native binary, Gradle will attempt to locate a tool chain installed on your machine that can build the binary. You can fine tune exactly how this works, see the Section 14, "Tool chains" for details.

The following tool chains are supported:

| Operating System | Tool Chain | Notes |
| -----------------|:----------:|:------|
| Linux | GCC | |
| Linux | Clang | |
| Mac OS X | XCode | Used the Clang tool chain bandled with XCode |
| Windows | Visual C++ | Windows XP and later, Visual C++ 2010 and later. |
| Windows | GCC with Cywin32 | Windows XP and later. |
| Windows | GCC with MinGW | Windows XP and later. Mingw-w64 is currently not supprted. |

The following tool chains are unofficially supported. The generally work fine, but are not tested continuously.

| Operating System | Tool Chain | Notes |
| ---------------- | :--------- | :---- |
| Mac OS X | GCC from Macports | |
| Mac OS X | Clang from Macports | |
| Windows | GCC with Cywin 64 | |
| UNIX-like | GCC | |
| UNIX-like | Glang | | |

## 3. Tool chain installation ##
> Note that if you are using GCC the you currently need to install support for C++, even if you ate not building from C++ source. This caveat will be removed in a future Gradle version.

To build native binaries, you will need to have a compatible tool chain installed:
### 3.1 Windows ###
To build on Windows,  install a compatible version of Visual Studio. The native plugins will discover the Visual Studio installations and select the latest version. There is no need to mess around with environment variables or batch scripts. This works fine from a Cygwin shell or the Windows command-line.

Alternatively, you can install Cygwin with GCC or MinGW. Clang is currently not supported.

### 3.2 OS X ###
To Build on OS X, you should install XCode. The native plugins will discover the XCode installation useing the system PATH.

The native plugins also work with GCC and Clang bundled with Macports. To use on of the Macports tool chains, you will need to make the tool chain the default using the **port select** command and add Macports to the system PATH.

### 3.3 Linux ###
To build on Linux, install a compatible version of GCC or Clang. The native plugins will discover GCC or Clang using the system PATH.

## 4. Component model ##
To build native binaries using Gradle, your project should define one or more <u>*native components*</u>. Each component represents either an executable or a library that Gradle should build. A project can define any number of components. Gradle does not define any components by default.

For each component, Gradle define a <u>*source set*</u> for each language that the component can be built from. A source set is essentially just a set of source directories containing source files. For example, when you apply the c plugin and define a library called **helloworld**, Gradle will define, by default, a source set containing the C source files in the **src/helloworld/c** directory. It will use these source files to build the **helloworld** library. This is described in more detail below.

For each component, Gradle defines one or more *binaries* as output. To build a binary, Gradle will take the source files defined for the component, compile them as appropriate for the source language, and link the result into a binary file. For an executable component, Gradle can produce executable binary files. For a library component, Gradle can produce both static and shared library binary files. For example, when you define a library called **helloworld** and build on Linux, Gradle will, by default, produce **libhelloworld.so** and **libhelloworld** binaries.

In many cases, more than one binary can be produced for a component. These binaries may vary based on the tool chain used to build, the compiler/linker flags supplied, the dependencies provided, or additional source files provided. Each native binary produced for a component is refered to as <u>*variant*</u>. Binary variants are discussed in detail below.

## 5. Building a library ##
To build either a static or shared native library, you define a library component in the libraries container.  The following sample defined a library called hello:

Example 1.1. Defining a library component.


**build.gradle**

    libraries {
        hello {}
    }

A library component is represented using *NativeLibrarySpec*. Each library component can produce at least one shared library binary (*SharedLibraryBinarySpec*) and at least one static library binary (*StaticLibraryBinarySpec*).

## 6. Building an executable ##
To build a native executable, you define an executable component in the **executables** container. The following sample defines an executable called main:

Example 1.2. Defining executable components.

**build.gradle**

    executables {
        main {}
    }
An executable component is represented using **NativeExecutableSpec**. Each executable component can produce at least one executable binary (**NativeExecutableBinarySpec**).

For each component defined, Gradle adds a **FunctionalSourceSet** with the same name. Each of these functional source sets will contain a language-speciafic source set for each of the languages supported by the project.

## 7. Tasks ##
For each *NativeBinarySpec* that can be produced by a build, a single <u>lifecycle task</u> is constructed that can be used to create that binary, together with a set of other tasks that do the actual work of compiling, linking or assembling the binary.

| Component Type | Native Binary Type | Lifecycle task | Location of created binary|
| :---- | :---- | :---- | :--- |
| NativeExecutableSpec | NativeExecutableBinarySpec | ${component.name} Executable | ${project.build} |
| NativeLibrarySpec | SharedLibraryBinarySpec | ${component.name} SharedLibrary | ${project.build} |
| NativeLibrarySpec | SharedLibraryBinarySpec | ${component.name} SharedLibrary | ${project.build} |

### 7.1 Working with shared libraries
For each executable binary produced, the cpp plugin provies an install${binary.name} task, which creates a development install of the executable, along with shared libraries it requires. This allows you to run the executable without needing to install the shared libraries in their final locations.

## 8. Finding out more about your project ##
Gradle provides a report that you can run from the command-line that shows some details about the components and binaries that your project produces. To use this report, just run **gradle components**.

## 9. Language support ##
Presently, Gradle supports building native binaries from any combination of source languages listed below. A native binary project will contain one or more named `FunctionalSourceSet` instances (eg 'main', 'test', etc), each of which can containe `LanguageSourceSets` containing source files, one for each language.
* C
* C++
* Objective-C
* Ojbective-C++
* Assembly
* Windows resources

### 9.1. C++ sources ###
C++ language support is provided by means of the 'cpp' plugin.

Example 3. The 'cpp' plugin

**build.gradle**

    apply plugin:'cpp'

C++ sources to be included in a native binary are provided via a CppSourceSet, which defines a set of C++ source files and optionally a set of exported header files (for a library). By default, for any named component the CppSourceSet contains .cpp source files in `src/${name}/cpp`, and header file in `src/${name}/`.

While the cpp plugin defines these default locations for each `CppSourceSet`, it is possible to extend override these defaults to allow for a different project layout.

Example 4. C++ source set

    sources {
        main {
            cpp {
                source {
                    srcDis "src/source"
                    include "**/*.cpp"
                }
            }
        }
    }

For a library named 'main', header files in `src/main/headers` are considered the "public" or "exported" headers. Header files that should not be exported should be placed inside the `src/main/cpp` directory (though be aware that such header files should always be referenced in a manner relative to the file including them).

### 9.2 C sources ###
C language support is provided by means of the 'c' plugin.

Example 5. The 'c' plugin

** build.gradle **

    apply pugin: 'c'

C sources to be included in a native binary are provided via a `CsourceSet`, which defines a set of C source files and optionally a set of exported header file (for a library). By default, for any named component the `CSourceSet` containes `.c` source files in `src/${name}/c`, and header files in `src/${name}/headers`.

Whilc the c plugin defines these default locations for each `CSourceSet`, it is possible to extend or override these defaults to allow for a different project layout.

Example 6. C source set

**build.gradle**

    sources {
        hello {
            c {
                source {
                    srcDir "src/source"
                    include "**/*.c"
                }

                exportedHeaders {
                    srcDir "src/include"
                }
            }
        }
    }
For a library named 'main', header file in `src/main/headers` are considered the "public" or "exported" headers. Header files that should not be exported should be placed inside the `src/miain/c` directory (though be aware that such header files should always be referenced in a manner relative to the file including them).
