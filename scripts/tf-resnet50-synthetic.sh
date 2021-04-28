SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source ${SCRIPTPATH}/utils.sh

function check_env_available() {
  check_tools_available
  _num=$(get_dev_num)
  run_basic_device_tests $_num
}

function check_source_file() {
  _base=$1 
  _source_entry=$2
  if [ ! -f ${_base}/${_source_entry} ] ; then
    printf "${_base}/${_source_entry} does not exists\n"
    exit 1
  fi	  
}

if [ $# -ne 1 ];then
  printf "please provide the base source dir\n"
  exit 1
fi
	
_source_base_dir=$1
check_source_file $_source_base_dir applications/tensorflow/cnns/training/train.py
check_env_available

cd $_source_base_dir/applications/tensorflow/cnns/training
pip3 install -r requirements.txt
if [ $? -ne 0 ] ;then
  printf "Can't install python dependencise\n"
  exit 1
fi
python3 train.py --config mk2_resnet50_bn_16ipus --data-dir /data/datasets/imagenets/ --no-validation --synthetic-data
