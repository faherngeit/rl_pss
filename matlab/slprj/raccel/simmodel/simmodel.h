#ifndef RTW_HEADER_simmodel_h_
#define RTW_HEADER_simmodel_h_
#include <stddef.h>
#include <string.h>
#include "rtw_modelmap_simtarget.h"
#ifndef simmodel_COMMON_INCLUDES_
#define simmodel_COMMON_INCLUDES_
#include <stdlib.h>
#include "rtwtypes.h"
#include "sigstream_rtw.h"
#include "simtarget/slSimTgtSigstreamRTW.h"
#include "simtarget/slSimTgtSlioCoreRTW.h"
#include "simtarget/slSimTgtSlioClientsRTW.h"
#include "simtarget/slSimTgtSlioSdiRTW.h"
#include "simstruc.h"
#include "fixedpoint.h"
#include "raccel.h"
#include "slsv_diagnostic_codegen_c_api.h"
#include "rt_logging_simtarget.h"
#include "dt_info.h"
#include "ext_work.h"
#endif
#include "simmodel_types.h"
#include "multiword_types.h"
#include "rt_defines.h"
#include "rtGetInf.h"
#include "rt_nonfinite.h"
#define MODEL_NAME simmodel
#define NSAMPLE_TIMES (3) 
#define NINPUTS (1)       
#define NOUTPUTS (1)     
#define NBLOCKIO (1) 
#define NUM_ZC_EVENTS (0) 
#ifndef NCSTATES
#define NCSTATES (1)   
#elif NCSTATES != 1
#error Invalid specification of NCSTATES defined in compiler command
#endif
#ifndef rtmGetDataMapInfo
#define rtmGetDataMapInfo(rtm) (*rt_dataMapInfoPtr)
#endif
#ifndef rtmSetDataMapInfo
#define rtmSetDataMapInfo(rtm, val) (rt_dataMapInfoPtr = &val)
#endif
#ifndef IN_RACCEL_MAIN
#endif
typedef struct { real_T c20upl5nx1 ; } B ; typedef struct { real_T mv1q4vict2
; } X ; typedef struct { real_T mv1q4vict2 ; } XDot ; typedef struct {
boolean_T mv1q4vict2 ; } XDis ; typedef struct { real_T enmafccd00 ; } ExtU ;
typedef struct { real_T gwdso2cedz ; } ExtY ; typedef struct {
rtwCAPI_ModelMappingInfo mmi ; } DataMapInfo ; struct P_ { real_T
Integrator_IC ; real_T Gain_Gain ; real_T Constant_Value ; } ; extern const
char * RT_MEMORY_ALLOCATION_ERROR ; extern B rtB ; extern X rtX ; extern ExtU
rtU ; extern ExtY rtY ; extern P rtP ; extern mxArray * mr_simmodel_GetDWork
( ) ; extern void mr_simmodel_SetDWork ( const mxArray * ssDW ) ; extern
mxArray * mr_simmodel_GetSimStateDisallowedBlocks ( ) ; extern const
rtwCAPI_ModelMappingStaticInfo * simmodel_GetCAPIStaticMap ( void ) ; extern
SimStruct * const rtS ; extern const int_T gblNumToFiles ; extern const int_T
gblNumFrFiles ; extern const int_T gblNumFrWksBlocks ; extern rtInportTUtable
* gblInportTUtables ; extern const char * gblInportFileName ; extern const
int_T gblNumRootInportBlks ; extern const int_T gblNumModelInputs ; extern
const int_T gblInportDataTypeIdx [ ] ; extern const int_T gblInportDims [ ] ;
extern const int_T gblInportComplex [ ] ; extern const int_T
gblInportInterpoFlag [ ] ; extern const int_T gblInportContinuous [ ] ;
extern const int_T gblParameterTuningTid ; extern DataMapInfo *
rt_dataMapInfoPtr ; extern rtwCAPI_ModelMappingInfo * rt_modelMapInfoPtr ;
void MdlOutputs ( int_T tid ) ; void MdlOutputsParameterSampleTime ( int_T
tid ) ; void MdlUpdate ( int_T tid ) ; void MdlTerminate ( void ) ; void
MdlInitializeSizes ( void ) ; void MdlInitializeSampleTimes ( void ) ;
SimStruct * raccel_register_model ( ssExecutionInfo * executionInfo ) ;
#endif
