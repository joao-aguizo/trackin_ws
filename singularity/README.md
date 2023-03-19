# Simulation

1. Build the desired Singularity's recipe:

| **build script**                                        | **contains**                                       |
| ------------------------------------------------------------- | -------------------------------------------------------- |
| [recipes/01_minimal/build.sh](recipes/01_minimal/build.sh)       | ROS Noetic w/ Simulation                                 |
| [recipes/02_with_husky/build.sh](recipes/02_with_husky/build.sh) | ROS Noetic w/ Simulation +[husky](https://github.com/husky) |

2. Copy the [example_wrapper.sh](./example_wrapper.sh) (versioned example) into `wrapper.sh` (.gitignored). It will allow you to configure the wrapper for yourself.
3. Run the Singularity container by issuing:

```bash
./wrapper.sh
```

Now, you should see the terminal prompt of the singularity image, similar to this:

```bash
[Singularity] user@hostname:~$
```

4. To compile your software with the base dependencies, start by placing your packages into the `<singularity_images>/simulation/user_ros_workspace/src` folder of this repository.
   As an example, let's clone the [clearpathrobotics/cpr_gazebo](https://github.com/clearpathrobotics/cpr_gazebo):

```bash
cd user_ros_workspace/src
git clone https://github.com/clearpathrobotics/cpr_gazebo.git
```

This host's computer folder is mounted into the container as `~/user_ros_workspace`.
You can then run the singularity image, init the workspace, and build the packages by:

```bash
[Singularity]$ cd ~/user_ros_workspace/
[Singularity]$ catkin init
[Singularity]$ catkin build
```

Although the workspace resides on your host computer, the software cannot be run by the host system.
The container fulfills the dependencies.
To run the software, go into the singularity container (`./wrapper.sh`) and run the software through there. Assumes ROS Noetic w/ Simulation + husky:

```bash
./wrapper.sh
[Singularity] user@hostname:~$ source ~/user_ros_workspace/devel/setup.bash
[Singularity] user@hostname:~$ roslaunch cpr_agriculture_gazebo agriculture_world.launch platform:=husky
```

## Default behavior

* The container is run **without** mounting the host's `$HOME`.
* The container's `/tmp` is mounted into host's `/tmp/singularity/tmp`.

## Enabling nVidia graphics`

Edit the parameter (false -> true)

```bash
USE_NVIDIA
```

in the `wrapper.sh` script to enable nVidia graphics integration.
Beware, it is not guaranteed to work on all systems.
Typical issues revolve around the `version 'GLIBC_2.34' not found` error.

## Mounting host's $HOME

The host's `$HOME` directory is not mounted by default.
To mount the host's `$HOME` into the container, run the `./wrapper.sh` with `CONTAINED=false`.
However, this will make the container's shells to source your shell RC file.
To make the container run with the internal ROS environment, put the following code snippet into your `.bashrc` and/or `.zshrc`.
`<singularity_images>` stands for the path to where you have cloned this repository.

**BASH**:

```bash
if [ -n "$SINGULARITY_NAME" ]; then
  source <singularity_images>/simulation/mount/singularity_bashrc.sh
fi
```

**ZSH**:

```bash
if [ -n "$SINGULARITY_NAME" ]; then
  source <singularity_images>/simulation/mount/singularity_zshrc.sh
fi
```

## Installing additional stuff to a container

There are several ways to alter the provided container.

### Creating persistent overlay (preferred)

A persistent overlay is an additional image that is dynamically loaded and _attached_ to the provided container.
Using an overlay is the most straightforward way to store changes to the container, e.g., additional installed software and libraries.

1. Create the overlay image using the provided script: [./scripts/create_overlay.sh](./scripts/create_overlay.sh) (choose the overlay size in the script)
2. Start `wrapper.sh` with `OVERLAY=TRUE`.
3. Run `sudo ./wrapper` to install additional stuff. Remember not to put stuff in `$HOME`.

Optinally, the overlay can be embedded into the provided image by running [./scripts/embed_overlay.sh](./scripts/embed_overlay.sh).
Embedding an overlay might be helpful, e.g., when providing the altered image to a third party.

### Bootstrapping into a new container (preferred in later stages)

Although overlays are great, they pose disadvantages: they cannot be versioned, documented, and automated.
That can be overcome by bootstrapping the provided image into a new Singularity image using a custom Singularity recipe.

**PROS**:

The preferred way is to bootstrap the existing container into a new container with a custom recipe file.
Creating a customized image allows you to be independent on the input container, receive updates and be compatible with the provided container.

**CONS:**

Building a new container takes longer.
Therefore, finding out what you need to do is tedious.
However, finding what actions you need to take can be done by using an overlay or modifying the container directly.
See the manual down below.

User modifications can also be added directly by modifying one of the main recipes.
However, creating a custom recipe for modifying an already existing image is a more future-proof solution.

### Modifying an existing container (possible but not recommended)

If you need to change the container (even removing files), you can do that by following these steps:

1. convert it to the _sandbox_ container ([./scripts/convert_sandbox.sh](./scripts/convert_sandbox.sh), `TO_SANBOX=true`):

```bash
sudo singularity build --sandbox <final-container-directory> <input-file.sif>
```

3. run `./wrapper.sh` with `WRITABLE=true` and `FAKEROOT=true`,
4. modify the container, install stuff, etc.,
5. convert back to `.sif`, ([./scripts/convert_sandbox.sh](./scripts/convert_sandbox.sh), `TO_SANBOX=false`):

```bash
sudo singularity build <output-file.sif> <input-container-directory/>
```
