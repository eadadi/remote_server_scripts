#!/bin/bash

# The purpose of the file is to make additional remote server setups

# Adjust ipython to defaultly load_ext tensorboard and
# tensorboard --logdir $TB_RUNS_PATH --host $TB_HOST --port $TB_PORT
# this is done by editting $IPYTHON_PROFILE_NAME following lines:
#
# c.InteractiveShellApp.extensions = [anything] 
#   -> c.InteractiveShellApp.extensions = [anything, 'tensorboard']
# c.InteractiveShellApp.exec_lines = [anything]
#   -> c.InteractiveShellApp.exec_lines = [anything,
#               'tensorboard --logdir $TB_RUNS_PATH --host $TB_HOST --port $TB_PORT']

# First get parameters or default values
TB_RUNS_PATH=${TB_RUNS_PATH:-./runs}
TB_HOST=${TB_HOST:-127.0.0.1}
TB_PORT=${TB_PORT:-8080}
IPYTHON_PROFILE_NAME=${IPYTHON_PROFILE_NAME:-default}

# Adjust ipython
CMD='ipython_profile_modifier.py'
LOAD_EXT_PARAM='tensorboard'
EXEC_LINE_PARAM="tensorboard --logdir $TB_RUNS_PATH --host $TB_HOST --port $TB_PORT"
python $CMD setup $LOAD_EXT_PARAM "$EXEC_LINE_PARAM" --profile $IPYTHON_PROFILE_NAME
