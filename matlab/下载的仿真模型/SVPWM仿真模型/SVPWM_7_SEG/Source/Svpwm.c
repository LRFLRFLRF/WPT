// ============================================================================
// File name   : Svpwm.c
// Description : 
// Author      : Lei Y. Z.
// Vision      : 1.0.1
// Date        : 2017-01-08
// ------------------------------------------------------
// History     : V1.0.0 - Initial establishment (2016-12-19)
//               V1.0.1 - Add "default" to switch (2017-01-08)
// 
// ============================================================================

#include "Svpwm.h"
//#include "math.h"

// --------------------------------------------------------
// Function name   : SvpwmGen
// Description     : 
// Parameters list : Var - SVPWM struct variable
// Return values   : void
// --------------------------------------------------------
void SvpwmGen(SVPWM *Var)
{
    // Temporary variables
    float TempT1, TempT2;
	
    if(Var->Input.Ubeta > 0)
    {
        Var->Temp.A = 1;
    }
    else
    {
        Var->Temp.A = 0;
    }

    if((1.732 * Var->Input.Ualpha - Var->Input.Ubeta) > 0)
    {
        Var->Temp.B = 1;
    }
    else
    {
        Var->Temp.B = 0;
    }

    if((1.732 * Var->Input.Ualpha + Var->Input.Ubeta) < 0)
    {
        Var->Temp.C = 1;
    }
    else
    {
        Var->Temp.C = 0;
    }

    Var->Temp.Sector = Var->Temp.A + 2 * Var->Temp.B + 4 * Var->Temp.C;    

    Var->Temp.X = 1.732 * Var->Input.Ubeta * Var->Input.Tcnt / Var->Input.Udc;
    Var->Temp.Y = (1.5 * Var->Input.Ualpha + 0.866 * Var->Input.Ubeta) \
                * Var->Input.Tcnt / Var->Input.Udc;
    Var->Temp.Z = (-1.5 * Var->Input.Ualpha + 0.866 * Var->Input.Ubeta) \
                * Var->Input.Tcnt / Var->Input.Udc;

    switch(Var->Temp.Sector)
    {	
        case 1:
            Var->Temp.T1 = Var->Temp.Z;
            Var->Temp.T2 = Var->Temp.Y;
            break;
        case 2:
            Var->Temp.T1 = Var->Temp.Y;
            Var->Temp.T2 = -Var->Temp.X;
            break;	  
        case 3:
            Var->Temp.T1 = -Var->Temp.Z;
            Var->Temp.T2 = Var->Temp.X;
            break;
        case 4:
            Var->Temp.T1 = -Var->Temp.X;
            Var->Temp.T2 = Var->Temp.Z;
            break;		
        case 5:
            Var->Temp.T1 = Var->Temp.X;
            Var->Temp.T2 = -Var->Temp.Y;
            break;
        case 6:
            Var->Temp.T1 = -Var->Temp.Y;
            Var->Temp.T2 = -Var->Temp.Z;
            break;
        default:
            break;
    }
    if((Var->Temp.T1+Var->Temp.T2) > Var->Input.Tcnt)
    {
        TempT1 = Var->Temp.T1;
        TempT2 = Var->Temp.T2;
        Var->Temp.T1 = (TempT1 / (TempT1 + TempT2)) * Var->Input.Tcnt;
        Var->Temp.T2 = (TempT2 / (TempT1 + TempT2)) * Var->Input.Tcnt;
    }

    Var->Temp.Ta = (Var->Input.Tcnt - Var->Temp.T1 - Var->Temp.T2) * 0.25;
    Var->Temp.Tb = Var->Temp.Ta + Var->Temp.T1 * 0.5;
    Var->Temp.Tc = Var->Temp.Tb + Var->Temp.T2 * 0.5;

    switch(Var->Temp.Sector)
    {
        case 1:
            Var->Output.Tcm1 = Var->Temp.Tb;
            Var->Output.Tcm2 = Var->Temp.Ta;
            Var->Output.Tcm3 = Var->Temp.Tc;
            break;
        case 2:
            Var->Output.Tcm1 = Var->Temp.Ta;
            Var->Output.Tcm2 = Var->Temp.Tc;
            Var->Output.Tcm3 = Var->Temp.Tb;
            break;
        case 3:
            Var->Output.Tcm1 = Var->Temp.Ta;
            Var->Output.Tcm2 = Var->Temp.Tb;
            Var->Output.Tcm3 = Var->Temp.Tc;
            break;
        case 4:
            Var->Output.Tcm1 = Var->Temp.Tc;
            Var->Output.Tcm2 = Var->Temp.Tb;
            Var->Output.Tcm3 = Var->Temp.Ta;
            break;
        case 5:
            Var->Output.Tcm1 = Var->Temp.Tc;
            Var->Output.Tcm2 = Var->Temp.Ta;
            Var->Output.Tcm3 = Var->Temp.Tb;
            break;
        case 6:
            Var->Output.Tcm1 = Var->Temp.Tb;
            Var->Output.Tcm2 = Var->Temp.Tc;
            Var->Output.Tcm3 = Var->Temp.Ta;
            break;
        default:
            break;
    }
	
	// Modulation depth
	//Var->Temp.M = sqrt(Var->Input.Ualpha * Var->Input.Ualpha + Var->Input.Ubeta * Var->Input.Ubeta) / \
	              Var->Input.Udc * 1.732;
}

