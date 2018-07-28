# JetBrains CLion Working with WSL Environment

REF: https://www.jetbrains.com/help/clion/how-to-use-wsl-development-environment-in-clion.html

Suppose you need to use Linux toolchain to build a project on your Windows machine. You can use Cygwin for that, but now you can try another solution - [Microsoft Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/about) (WSL). WSL is a compatibility layer for running Linux binary executables natively on Windows 10; for now it supports Ubuntu, OpenSUSE and SLES distributions.

With WSL deployed on your system, you are able to use CMake, C and C++ compilers from Linux in CLion running on your Windows machine.

## Getting Started

Let’s start with the simple instruction on how to set up the WSL environment in CLion: 

1. Download and install WSL distribution (for instance, Ubuntu) from [Microsoft Store.](https://www.microsoft.com/store/productId/9NBLGGH4MSV6)

2. Run Ubuntu. **Note:** upon the first lunch of Ubuntu the system may prompt you to enable the Windows optional feature. In this case, you need to: 

   * Open Windows Power Shell as Administrator and run the following: 

     ```powershell
     Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
     ```

   * Restart your computer.

3. Create a new user and specify your user name and password.

4. Set up WSL Ubuntu environment: 

   * Install cmake, gcc, or/and clang (and optionally `build-essentials` package), as follows: 

     ```
     sudo apt-get install cmake gcc gdb build-essential
     ```

     

   * Configure and run open ssh-server.

