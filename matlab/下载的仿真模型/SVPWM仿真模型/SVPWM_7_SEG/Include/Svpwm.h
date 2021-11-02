// ============================================================================
// File name   : Svpwm.h
// Description : 
// Author      : Lei Y. Z.
// Vision      : 1.0.0z
// Date        : 2016-12-19
// ------------------------------------------------------
// History     : V1.0.0 - Initial establishment   
// 
// ============================================================================

#ifndef __SVPWM_H__
#define __SVPWM_H__

// Input interface
typedef struct { float Ualpha;             // Stator voltage at alpha axis
                 float Ubeta;              // Stator voltage at beta axis
                 float Udc;                // DC voltage
                 unsigned int Tcnt;        // Interrupt period count    
} SVPWM_INPUT;

#define SVPWM_INPUT_DEFAULTS { 0,\
                               0,\
                               0,\
                               1 \
}

// Output interface
typedef struct { float Tcm1;               // Arm 1 compare value
                 float Tcm2;               // Arm 2 compare value
                 float Tcm3;               // Arm 3 compare value
} SVPWM_OUTPUT;

#define SVPWM_OUTPUT_DEFAULTS { 0,\
                                0,\
                                0 \
}

// Temporary variables
typedef struct { unsigned int A;
                 unsigned int B;
                 unsigned int C; 
                 unsigned int Sector;      // Sector
                 float X;
                 float Y;
                 float Z;
                 float T1;
                 float T2;
                 float T3;
                 float Ta;
                 float Tb;
                 float Tc;
                 float M;                  // Modulation deptn
} SVPWM_TEMP;

#define SVPWM_TEMP_DEFAULTS {  0,\
                               0,\
                               0,\
                               0,\
                               0,\
                               0,\
                               0,\
                               0,\
                               0,\
                               0,\
                               0,\
                               0,\
                               0,\
                               0 \
}

// Struct of space vector PWM 
typedef struct { SVPWM_INPUT  Input;       // Input interface
                 SVPWM_OUTPUT Output;      // Output interface
                 SVPWM_TEMP   Temp;        // Temporary variables    
             
                 void   (*Calc)();         // Core function
} SVPWM;

#define SVPWM_DEFAULTS { SVPWM_INPUT_DEFAULTS,\
                         SVPWM_OUTPUT_DEFAULTS,\
                         SVPWM_TEMP_DEFAULTS,\
                         (void (*)(long))SvpwmGen \
}

// Function declaration
void SvpwmGen(SVPWM *);

#endif

