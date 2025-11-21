# FFmpeg Android Builder

A reusable GitHub Action for building **FFmpeg for Android** using  
[`ffmpeg-android-maker`](https://github.com/Javernaut/ffmpeg-android-maker) by **Javernaut**.  
This action makes it easy for any Android project to build and integrate   
native FFmpeg binaries directly from GitHub Actions CI.

> **Authors:**  
> - **Ishan09811** (Action wrapper implementation)  
> - **Javernaut** (Creator of the original FFmpeg build script)

---

## 🚀 Features

- Builds FFmpeg for Android using your chosen API level and ABIs  
- Fully customizable build flags (`extra-args`)  
- Outputs complete FFmpeg libraries + headers  
- Allows custom output directory  
- Works in any Android or C/C++ project  
- Simple, stable, and production-ready

---

## 📦 Usage

Add a step in your GitHub Actions workflow:

```yaml
- name: Build FFmpeg
  uses: Ishan09811/build-ffmpeg-android@v1
  with:
    android-api: 34
    abis: arm64-v8a
    output-dir: ./app/libraries/ffmpeg
    extra-args: "--disable-doc --disable-programs --enable-libx264"
```

After this step finishes, your project will contain:

```
<output-dir>/
 ├── include/
 └── lib/
      └── ABI eg. arm64v8a/
```

You can then link these in your CMakeLists.

#### Action Inputs
Input | Description | Default
|-|-|-|
| `android-api` | Android API level for NDK build | `34`
| `abis` | list of ABIs (arm64-v8a, armeabi-v7a, etc.) | `arm64-v8a`
| `output-dir` | Directory where built FFmpeg libraries and include files will be stored | `./output`
| `extra-args` | Additional FFmpeg configure flags | (empty)
