** Imported from: E:\IDE\SIMetrix\support\Models\Infineon_Power_Mos.lb
.SUBCKT BSC057N08NS3_L0  drain  gate  source
Lg     gate  g1    3n
Ld     drain d1    1n
Ls     source s1   1n
Rs      s1    s2   404u
Rg     g1    g2     1.9
M1      d2    g2    s2    s2    DMOS    L=1u   W=1u
.MODEL DMOS NMOS ( KP= 129.7  VTO=3.9  THETA=0  VMAX=1.5e5  ETA=0.006  LEVEL=3)
Rd     d1    d2    2.96m TC=7m
Dbd     s2    d2    Dbt
.MODEL     Dbt    D(BV=92   M=0.27  CJO=2.57n  VJ=0.9V)
Dbody   s2   21    DBODY
.MODEL DBODY  D(IS=55.7p  N=1.16  RS=0.07u  EG=1.12  TT=40n)
Rdiode  d1  21    1.21m TC=5m
.MODEL   sw    NMOS(VTO=0  KP=10   LEVEL=1)
Maux      g2   c    a    a   sw
Maux2     b    d    g2    g2   sw
Eaux      c    a    d2    g2   1
Eaux2     d    g2   d2    g2   -1
Cox       b    d2   0.92n
.MODEL     DGD    D(M=0.7   CJO=0.92n   VJ=0.5)
Rpar      b    d2   1Meg
Dgd       a    d2   DGD
Rpar2     d2   a    10Meg
Cgs     g2    s2    2.86n
.ENDS  BSC057N08NS3_L0
******

** Imported from: E:\IDE\SIMetrix\support\Models\sources.lb
.SUBCKT PUL_SOURCE 1 2 params: _V1=0 _V2=1 _FREQ=100k _DELAY=0 _T_RISE=0 _T_FALL=0 _PWIDTH=5u _OFF_UNTIL_DELAY=0 _IDLE_IN_POP=0 _USEPHASE=0 _PHASE=0
V1 1 2 PWLS PUL
+ V1={_V1} 
+ V2={_V2} 
+ FREQ={_FREQ} 
+ RISE={_T_RISE} 
+ FALL={_T_FALL} 
+ WIDTH={_PWIDTH} 
+ DELAY={IFF(_USEPHASE, _PHASE/360/_FREQ, _DELAY)} 
+ OFF_UNTIL_DELAY={_OFF_UNTIL_DELAY} 
+ END
.ENDS

** Imported from: E:\IDE\SIMetrix\support\Models\diode.lb
.model d1n4006  D(IS=140f RS=39m IKF=7m CJO=52p M=0.27 VJ=0.75 ISR=16n 
+ BV=1000 IBV=100u TT=7.0u)

** Imported from: E:\IDE\SIMetrix\support\Models\diode.lb
.model D1n5408  D(IS=15f RS=8m CJO=150p M=0.3 VJ=0.75 ISR=120n 
+ BV=1200 Ibv=100u)
**************************************************************************
* jrw 17.2.94.
* Data from Motorola Rectifier device data DL151/D
* mr750 to mr760

** Imported from: E:\IDE\SIMetrix\support\Models\zmodels.lb
.MODEL ZHCS2000 D IS=5e-7 N=.59 RS=88e-3 IKF=5e-3 XTI=2
+EG=.58 CJO=370p M=.5231 VJ=.3905 Fc=.5 BV=60 IBV=300E-6
+ISR=10E-6 NR=1.8 
*
*$
*
*ZETEX ZXM61P03F Spice Model v1.0 Last Revised 23/2/04
*

