tmux_abs_dir := $(shell cd ./scripts/tmux; pwd)

exec-multi:
	./scripts/tmux/start_multi_master.sh

exec-single:
	./scripts/tmux/start_single_master.sh

install-ws:
	cp -i ./scripts/tmux/config/tmux.conf ${HOME}/.tmux.conf
	echo 'source ${tmux_abs_dir}/addons.sh' >> ${HOME}/.bashrc
	wstool update -t src/
	catkin config --extend /opt/ros/${ROS_DISTRO}
	catkin build

install-deps:
	bash -c "./scripts/shell/example-install"
