#!/bin/bash
#
#set -e
#set -o pipefail
#
media_cmd="media-ctl -d platform:rkisp1"
v4l2_cmd="v4l2-ctl -z platform:rkisp1 -d rkisp1_mainpath"
NAME=$(date +"%Y%m%dT%H%M%S")

#reset
$media_cmd "-r"

# set links
$media_cmd "-l" "'imx258 1-001a':0 -> 'rkisp1_csi':0 [1]"
$media_cmd "-l" "'rkisp1_csi':1 -> 'rkisp1_isp':0 [1]"
$media_cmd "-l" "'rkisp1_isp':2 -> 'rkisp1_resizer_mainpath':0 [1]"
# ignoring selfpath
#$media_cmd "-l" "'rkisp1_isp':2 -> 'rkisp1_resizer_selfpath':0 [0]"

$media_cmd "--set-v4l2" '"imx258 1-001a":0 [fmt:SRGGB10_1X10/4208x3120@1/6]' 

$media_cmd "--set-v4l2" '"rkisp1_csi":0 [fmt:SRGGB10_1X10/4208x3120@1/6]'

$media_cmd "--set-v4l2" '"rkisp1_isp":0 [fmt:SRGGB10_1X10/4208x3120@1/6 crop:(0,0)/4208x3120]'
$media_cmd "--set-v4l2" '"rkisp1_isp":2 [fmt:SRGGB10_1X10/4208x3120@1/6 crop:(0,0)/4208x3120]'

$media_cmd "--set-v4l2" '"rkisp1_resizer_mainpath":0 [fmt:SRGGB10_1X10/4208x3120 crop:(0,0)/4208x3120]'
$media_cmd "--set-v4l2" '"rkisp1_resizer_mainpath":1 [fmt:SRGGB10_1X10/4208x3120]'

# ignoring selfpath
#$media_cmd "--set-v4l2" '"rkisp1_resizer_selfpath":0 [fmt:YUYV8_2X8/4208x3120@1/6 crop:(1048,780)/2096x1560]'
#$media_cmd "--set-v4l2" '"rkisp1_resizer_selfpath":1 [fmt:YUYV8_2X8/1048x780]'

$v4l2_cmd  "-v" "width=4208,height=3120,pixelformat=RG10" # 

### different v4l2 node for camera controls

v4l2-ctl -z platform:rkisp1 -d "imx258 1-001a" -c exposure=10000
v4l2-ctl -z platform:rkisp1 -d "imx258 1-001a" -c analogue_gain=100
v4l2-ctl -z platform:rkisp1 -d "imx258 1-001a" -c digital_gain=1024
v4l2-ctl -z platform:rkisp1 -d "imx258 1-001a" -c wide_dynamic_range=0
v4l2-ctl -z platform:rkisp1 -d "imx258 1-001a" -c test_pattern=0

### yet another for focus
v4l2-ctl -z platform:rkisp1 -d "dw9714 1-000c" -c focus_absolute=0

# mainpath stream to file
$v4l2_cmd  "--stream-mmap" "--stream-count" "1" "--stream-to=frame.raw"

# ignore selfpath
#v4l2-ctl -z platform:rkisp1 -d "rkisp1_selfpath" "-v" "width=1048,height=780,pixelformat=422P"
#v4l2-ctl -z platform:rkisp1 -d "rkisp1_selfpath" --stream-mmap --stream-count 3 --stream-to=frames.raw

# convert to jpeg in background

( ffmpeg -y -hide_banner -loglevel error -s:v 4208x3120 -pix_fmt bayer_rggb16be -i frame.raw ~/Pictures/CLI_${NAME}_bayer_rggb16be_f_%03d.jpg ; \
	convert ~/Pictures/CLI_${NAME}_bayer_rggb16be_f_001.jpg \( +clone -channel RGB -equalize \) -average ~/Pictures/CLI_${NAME}_bayer_rggb16be_f_001_equal.jpg )&

# keep copy of raw file
cp frame.raw ~/Pictures/CLI_${NAME}.raw &

# cleanup with numpy
( python3 ~/bin/fixbits2.py ; \
ffmpeg -y -hide_banner -loglevel error -s:v 4208x3120 -pix_fmt bayer_rggb16be -i numpy.raw ~/Pictures/CLI_${NAME}_f_numpy.jpg ;\
convert ~/Pictures/CLI_${NAME}_f_numpy.jpg \( +clone -channel RGB -equalize \) -average ~/Pictures/CLI_${NAME}_f_numpy_equal.jpg)&

