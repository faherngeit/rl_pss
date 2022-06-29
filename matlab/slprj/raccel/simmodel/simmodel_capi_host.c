#include "simmodel_capi_host.h"
static simmodel_host_DataMapInfo_T root;
static int initialized = 0;
rtwCAPI_ModelMappingInfo *getRootMappingInfo()
{
    if (initialized == 0) {
        initialized = 1;
        simmodel_host_InitializeDataMapInfo(&(root), "simmodel");
    }
    return &root.mmi;
}

rtwCAPI_ModelMappingInfo *mexFunction() {return(getRootMappingInfo());}
