#!/bin/bash
set +x
echo "##################################################################i"
echo "#                     DUT ANALYSIS STARTS                        #"
echo "##################################################################"
rm -rf work
mkdir -p work
vhdlan -nc -full64 -kdb=common_elab ${WORKSPACE_ROOT}/dut/regbank.vhd


echo "##################################################################"
echo "#                     DUT ANALYSIS FINISHED                      #"
echo "##################################################################"


echo "##################################################################"
echo "#                      TB ANALYSIS STARTS                        #"
echo "##################################################################"

export SEQ_SRC_DIR=${WORKSPACE_ROOT}/tb/seq
export ENV_SRC_DIR=${WORKSPACE_ROOT}/tb/env
export TB_SRC_DIR=${WORKSPACE_ROOT}/tb
export TC_SRC_DIR=${WORKSPACE_ROOT}/tests
export TB_VLOGAN_OPTS="-nc -sverilog -full64 -kdb=common_elab -lca +warn=all -ntb_opts uvm-1.2 -timescale=1ps/1ps"

vlogan ${TB_VLOGAN_OPTS}
vlogan ${TB_VLOGAN_OPTS} +incdir+${TB_SRC_DIR} +incdir+${ENV_SRC_DIR} +incdir+${SEQ_SRC_DIR}  +incdir+${TC_SRC_DIR} ${TB_SRC_DIR}/tb_package.svh
vlogan ${TB_VLOGAN_OPTS} +incdir+${TC_SRC_DIR} ${TC_SRC_DIR}/test_package.svh
vlogan ${TB_VLOGAN_OPTS} ${TB_SRC_DIR}/reg_bank_if.sv
vlogan ${TB_VLOGAN_OPTS} +incdir+${TB_SRC_DIR} +incdir+${ENV_SRC_DIR} +incdir+${SEQ_SRC_DIR}  +incdir+${TC_SRC_DIR}  ${TB_SRC_DIR}/tb_top.sv

echo "##################################################################"
echo "#                      TB ANALYSIS FINISHED                      #"
echo "##################################################################"

echo "##################################################################"
echo "#                      ELABORATION STARTED                       #"
echo "##################################################################"

vcs -nc -full64 -kdb=common_elab  -ntb_opts uvm-1.2 -debug_access+all tb_top
echo "##################################################################"
echo "#                      ELABORATION FINISHED                      #"
echo "##################################################################"



set -x
