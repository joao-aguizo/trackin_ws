# trackin_ws

A properly tracked development workspace. Originally designed to keep track ROS' catkin workspaces, as well as automatically deploy these.

## Introduction

This repository holds the version information of all the git repositories of every package that makes up the **trackin_ws**.

This workspace has a set of bash scripts that will aid, not only, the deployment of the system, but also the inspection of such. The aforementioned scripts require TMUX, a terminal multiplexer.

A Makefile was also included for convenience. **This is the recommended way to start the system.**

## Requirements

**Make, TMUX, wstool, catkin_tools:**

```bash
sudo apt install make                       # *if not already installed in your system*
sudo apt install tmux xclip                 # terminal multiplexer (alternative to GNU screen)
sudo apt install python-wstool              # workspace version control tool
sudo apt install python-catkin-tools        # catkin_tools to build the workspace
```

### Installation

To install the workspace,

```bash
make install-ws
```

The ``make install-ws`` command will:

1. Copy a friendlier TMUX configuration to your `${HOME}` folder. This is done interactively.
2. Add a source command to your `${HOME}/.bashrc` file. This will be sourcing useful commands for the setup to work smoothly.
3. Clone the tracked packages that will build the system.
4. Configure the workspace.
5. Build the catkin workspace.

## Launch the system

To launch the system,

```bash
make execute
```
