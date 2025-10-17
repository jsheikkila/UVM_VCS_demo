#!/bin/bash
set +x

ENABLE_IDE=$1

export SEQ_SRC_DIR=${WORKSPACE_ROOT}/tb/seq
export ENV_SRC_DIR=${WORKSPACE_ROOT}/tb/env
export TB_SRC_DIR=${WORKSPACE_ROOT}/tb
export TC_SRC_DIR=${WORKSPACE_ROOT}/tests
export TB_VLOGAN_OPTS="-nc -sverilog -full64 -kdb=common_elab -lca +warn=all -ntb_opts uvm-1.2 -timescale=1ps/1ps"
export DUT_VHDLAN_OPTS="-nc -full64 -kdb=common_elab"


# cleaning compilation dirs
if [ ! -z ${ENABLE_IDE} ]; then
  echo "Clean IDE compilation"
  rm -rf EUAN.list euclide_workspace EUELAB.DB euclide_project
fi 
rm -rf work 
mkdir -p work

echo "##################################################################i"
echo "#                     DUT ANALYSIS STARTS                        #"
echo "##################################################################"
vhdlan ${DUT_VHDLAN_OPTS} ${ENABLE_IDE} ${WORKSPACE_ROOT}/dut/regbank.vhd

echo "##################################################################"
echo "#                     DUT ANALYSIS FINISHED                      #"
echo "##################################################################"


echo "##################################################################"
echo "#                      TB ANALYSIS STARTS                        #"
echo "##################################################################"

vlogan ${TB_VLOGAN_OPTS} ${ENABLE_IDE}
vlogan ${TB_VLOGAN_OPTS} ${ENABLE_IDE} +incdir+${TB_SRC_DIR} +incdir+${ENV_SRC_DIR} +incdir+${SEQ_SRC_DIR}  +incdir+${TC_SRC_DIR} ${TB_SRC_DIR}/tb_package.svh
vlogan ${TB_VLOGAN_OPTS} ${ENABLE_IDE} +incdir+${TC_SRC_DIR} ${TC_SRC_DIR}/test_package.svh
vlogan ${TB_VLOGAN_OPTS} ${ENABLE_IDE} ${TB_SRC_DIR}/reg_bank_if.sv
vlogan ${TB_VLOGAN_OPTS} ${ENABLE_IDE} +incdir+${TB_SRC_DIR} +incdir+${ENV_SRC_DIR} +incdir+${SEQ_SRC_DIR}  +incdir+${TC_SRC_DIR}  ${TB_SRC_DIR}/tb_top.sv

echo "##################################################################"
echo "#                      TB ANALYSIS FINISHED                      #"
echo "##################################################################"

echo "##################################################################"
echo "#                      ELABORATION STARTED                       #"
echo "##################################################################"

vcs -nc -full64 -kdb=common_elab  -ntb_opts uvm-1.2 -debug_access+all ${ENABLE_IDE} tb_top
echo "##################################################################"
echo "#                      ELABORATION FINISHED                      #"
echo "##################################################################"



set -x
