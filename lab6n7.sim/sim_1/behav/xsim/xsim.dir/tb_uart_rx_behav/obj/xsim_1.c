/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2020 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

#if defined(_WIN32)
 #include "stdio.h"
 #define IKI_DLLESPEC __declspec(dllimport)
#else
 #define IKI_DLLESPEC
#endif
#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2020 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

#if defined(_WIN32)
 #include "stdio.h"
 #define IKI_DLLESPEC __declspec(dllimport)
#else
 #define IKI_DLLESPEC
#endif
#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
IKI_DLLESPEC extern void execute_2(char*, char *);
IKI_DLLESPEC extern void execute_10(char*, char *);
IKI_DLLESPEC extern void execute_13(char*, char *);
IKI_DLLESPEC extern void execute_15(char*, char *);
IKI_DLLESPEC extern void svlog_sampling_process_execute(char*, char*, char*);
IKI_DLLESPEC extern void sequence_expr_m_655e2f7c_2893d183_2(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_655e2f7c_2893d183_3(char*, char *);
IKI_DLLESPEC extern void vlog_sv_sequence_execute_0 (char*, char*, char*);
IKI_DLLESPEC extern void assertion_action_m_655e2f7c_2893d183_1(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_655e2f7c_2893d183_1(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_655e2f7c_2893d183_5(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_655e2f7c_2893d183_6(char*, char *);
IKI_DLLESPEC extern void assertion_action_m_655e2f7c_2893d183_2(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_655e2f7c_2893d183_4(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_655e2f7c_2893d183_8(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_655e2f7c_2893d183_9(char*, char *);
IKI_DLLESPEC extern void assertion_action_m_655e2f7c_2893d183_3(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_655e2f7c_2893d183_7(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_655e2f7c_2893d183_11(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_655e2f7c_2893d183_12(char*, char *);
IKI_DLLESPEC extern void assertion_action_m_655e2f7c_2893d183_4(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_655e2f7c_2893d183_10(char*, char *);
IKI_DLLESPEC extern void execute_55(char*, char *);
IKI_DLLESPEC extern void execute_56(char*, char *);
IKI_DLLESPEC extern void execute_57(char*, char *);
IKI_DLLESPEC extern void execute_58(char*, char *);
IKI_DLLESPEC extern void execute_59(char*, char *);
IKI_DLLESPEC extern void execute_60(char*, char *);
IKI_DLLESPEC extern void execute_4(char*, char *);
IKI_DLLESPEC extern void execute_6(char*, char *);
IKI_DLLESPEC extern void execute_7(char*, char *);
IKI_DLLESPEC extern void vlog_simple_process_execute_0_fast_for_reg(char*, char*, char*);
IKI_DLLESPEC extern void execute_18(char*, char *);
IKI_DLLESPEC extern void execute_19(char*, char *);
IKI_DLLESPEC extern void execute_20(char*, char *);
IKI_DLLESPEC extern void execute_21(char*, char *);
IKI_DLLESPEC extern void execute_61(char*, char *);
IKI_DLLESPEC extern void execute_62(char*, char *);
IKI_DLLESPEC extern void execute_63(char*, char *);
IKI_DLLESPEC extern void execute_64(char*, char *);
IKI_DLLESPEC extern void execute_65(char*, char *);
IKI_DLLESPEC extern void execute_66(char*, char *);
IKI_DLLESPEC extern void vlog_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
IKI_DLLESPEC extern void transaction_2(char*, char*, unsigned, unsigned, unsigned);
funcp funcTab[44] = {(funcp)execute_2, (funcp)execute_10, (funcp)execute_13, (funcp)execute_15, (funcp)svlog_sampling_process_execute, (funcp)sequence_expr_m_655e2f7c_2893d183_2, (funcp)sequence_expr_m_655e2f7c_2893d183_3, (funcp)vlog_sv_sequence_execute_0 , (funcp)assertion_action_m_655e2f7c_2893d183_1, (funcp)sequence_expr_m_655e2f7c_2893d183_1, (funcp)sequence_expr_m_655e2f7c_2893d183_5, (funcp)sequence_expr_m_655e2f7c_2893d183_6, (funcp)assertion_action_m_655e2f7c_2893d183_2, (funcp)sequence_expr_m_655e2f7c_2893d183_4, (funcp)sequence_expr_m_655e2f7c_2893d183_8, (funcp)sequence_expr_m_655e2f7c_2893d183_9, (funcp)assertion_action_m_655e2f7c_2893d183_3, (funcp)sequence_expr_m_655e2f7c_2893d183_7, (funcp)sequence_expr_m_655e2f7c_2893d183_11, (funcp)sequence_expr_m_655e2f7c_2893d183_12, (funcp)assertion_action_m_655e2f7c_2893d183_4, (funcp)sequence_expr_m_655e2f7c_2893d183_10, (funcp)execute_55, (funcp)execute_56, (funcp)execute_57, (funcp)execute_58, (funcp)execute_59, (funcp)execute_60, (funcp)execute_4, (funcp)execute_6, (funcp)execute_7, (funcp)vlog_simple_process_execute_0_fast_for_reg, (funcp)execute_18, (funcp)execute_19, (funcp)execute_20, (funcp)execute_21, (funcp)execute_61, (funcp)execute_62, (funcp)execute_63, (funcp)execute_64, (funcp)execute_65, (funcp)execute_66, (funcp)vlog_transfunc_eventcallback, (funcp)transaction_2};
const int NumRelocateId= 44;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/tb_uart_rx_behav/xsim.reloc",  (void **)funcTab, 44);

	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/tb_uart_rx_behav/xsim.reloc");
}

void simulate(char *dp)
{
		iki_schedule_processes_at_time_zero(dp, "xsim.dir/tb_uart_rx_behav/xsim.reloc");
	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net
	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

extern SYSTEMCLIB_IMP_DLLSPEC void local_register_implicit_channel(int, char*);
extern SYSTEMCLIB_IMP_DLLSPEC int xsim_argc_copy ;
extern SYSTEMCLIB_IMP_DLLSPEC char** xsim_argv_copy ;

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_xsimdir_location_if_remapped(argc, argv)  ;
    iki_set_sv_type_file_path_name("xsim.dir/tb_uart_rx_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/tb_uart_rx_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/tb_uart_rx_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, (void*)0, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
