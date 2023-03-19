mount_abs_dir := $(shell cd ./singularity/mount; pwd)

build:
	bash -c "catkin config --extend /opt/ros/${ROS_DISTRO} && catkin build"

execute:
	./scripts/tmux/start_example.sh

install-ws:
	cp -i ./scripts/tmux/config/tmux.conf ${HOME}/.tmux.conf
	echo 'source ${mount_abs_dir}/addons.sh' >> ${HOME}/.bashrc
	wstool update -t src/

install-deps:
	bash -c "./scripts/install/install_example.sh"
