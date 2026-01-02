#!/bin/bash
set -euo pipefail
echo "PX4 + ROS 2 TEST"
export PX4_SIM_SPEED_FACTOR=2
export ROS_DOMAIN_ID=0
# export PX4_GZ_MODEL=x500
export HEADLESS=1
export QT_QPA_PLATFORM=offscreen

PX4_DIR=~/workspace/PX4-Autopilot
ROS_WS=~/workspace/ros2_ws

# build PX4
echo "Building PX4..."
cd "$PX4_DIR"
make px4_sitl gz_x500
#build ROS
echo "Building ROS..."
source /opt/ros/humble/setup.bash
cd "$ROS_WS"
colcon build --symlink-install
source install/setup.bash
#start microxrcedds
echo "Starting microxrce agent..."
MicroXRCEAgent udp4 -p 8888 &
DDS_PID=$!
#start PX4 Simulation
echo "Starting PX4 Simulation..."
cd "$PX4_DIR"
source /opt/ros/humble/setup.bash
source "$ROS_WS/install/setup.bash"
make px4_sitl gz_x500 &
PX4_PID=$!
#debug
timeout 60 bash -c '
until ros2 topic list | tee /tmp/topics.txt | grep -q "/fmu/out/sensor_combined"; do
  sleep 2
done
'

timeout 10 ros2 topic echo /fmu/out/sensor_combined --once
echo "Cleaning up..."
kill -- -$$ || true

echo "Basic PX4 + ROS 2 test ran succesfully"