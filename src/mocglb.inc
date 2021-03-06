const

  MaxAxes = 9;                   // max number of axes, default 9 XYZABCUVW
  MaxJogIncs = 8;                // max number of joc-increments
  NumButtons = 10;               // Number of User-Defined Buttons

const
  CoordMask = 'XYZABCUVW';

type
  TDROLayoutStyle = (dlsVertical,dlsHorizontal);

type
  TButtonDef = record
    T: integer;
    G: integer;
    S: string;
  end;

  PButtonArray = ^TButtonArray;
  TButtonArray = Array[0..NumButtons-1] of TButtonDef;

// these are the commands send by Buttonclick or Keyboard
// values > 100 define the button as a std button
// values < 100 define the button as a state- showing button
// they are used in TMocButton.Tag

const
  cmABORT     = 0;
  cmESTOP     = 1;
  cmMACHINE   = 2;
  cmJOG       = 3;
  cmAUTO      = 4;
  cmMDI       = 5;
  cmSPMINUS   = 201;
  cmSPPLUS    = 202;
  cmSPCW      = 11;
  cmSPCCW     = 12;
  cmSPBRAKE   = 13;
  cmFLOOD     = 15;
  cmMIST      = 16;
  cmREF       = 220;
  cmREFX      = 221;
  cmREFY      = 222;
  cmREFZ      = 223;
  cmREFA      = 224;
  cmREFB      = 225;
  cmREFC      = 226;
  cmUNREF     = 227;
  cmREFALL    = 228;
  cmUNREFALL  = 229;
  cmTOOLS     = 230;
  cmTOOLEDT   = 231;
  cmTOOLCHG   = 232;
  cmTOOLCL    = 233;
  cmTOOLUNCL  = 234;
  cmTOOLPAR   = 235;
  cmTOOLMSR   = 236;
  cmTOUCHOFF  = 240;
  cmTOUCHX    = 241;
  cmTOUCHY    = 242;
  cmTOUCHZ    = 243;
  cmTOUCHA    = 244;
  cmTOUCHB    = 245;
  cmTOUCHC    = 246;
  cmZEROALL   = 247;
  cmOFFSDLG   = 248;
  cmTOUCHWIZ  = 249;
  cmSETUP     = 250;
  cmLIMITS    = 260;
  cmOPEN      = 270;
  cmRUN       = 20;
  cmRUNLINE   = 21;
  cmSTOP      = 22;
  cmSTEP      = 271;
  cmPAUSE     = 23;
  cmOPTSTOP   = 24;
  cmBLOCKDEL  = 25;
  cmRELOAD    = 272;
  cmMDIEXEC   = 280;
  cmMDIHIST   = 281;
  cmEDITOR    = 290;
  cmINCRDN     = 320;
  cmINCRUP     = 321;
  cmSHIFTUP    = 330;
  cmSHIFTDN    = 331;
  cmCOORDROT   = 340;
  cmUNITS      = 350;
  cmVIEWREL    = 351;
  cmVIEWDIA    = 352;
  cmVIEWDTG    = 353;
  cmBACK       = 999;
  cmSCRIPTBASE = 1000;
  cmSCRIPTS    = 1099;
  cmCLOSE      = 360;
  cmFEEDRESET  = 400;
  cmONANDREF   = 410;

type
  TCmdNames = record
    S: string;
    i: integer;
  end;

const
  CmdNamesMax = 68;

const
  CmdNames: Array[0..CmdNamesMax] of TCmdNames = (
  (S:'cmABORT'     ; i:0),
  (S:'cmESTOP'     ; i:1),
  (S:'cmMACHINE'   ; i:2),
  (S:'cmJOG'       ; i:3),
  (S:'cmAUTO'      ; i:4),
  (S:'cmMDI'       ; i:5),
  (S:'cmSPMINUS'   ; i:201),
  (S:'cmSPPLUS'    ; i:202),
  (S:'cmSPCW'      ; i:11),
  (S:'cmSPCCW'     ; i:12),
  (S:'cmSPBRAKE'   ; i:13),
  (S:'cmFLOOD'     ; i:15),
  (S:'cmMIST'      ; i:16),
  (S:'cmREF'       ; i:220),
  (S:'cmREFX'      ; i:221),
  (S:'cmREFY'      ; i:222),
  (S:'cmREFZ'      ; i:223),
  (S:'cmREFA'      ; i:224),
  (S:'cmREFB'      ; i:225),
  (S:'cmREFC'      ; i:226),
  (S:'cmUNREF'     ; i:227),
  (S:'cmREFALL'    ; i:228),
  (S:'cmUNREFALL'  ; i:229),
  (S:'cmTOOLS'     ; i:230),
  (S:'cmTOOLEDT'   ; i:231),
  (S:'cmTOOLCHG'   ; i:232),
  (S:'cmTOOLCL'    ; i:233),
  (S:'cmTOOLUNCL'  ; i:234),
  (S:'cmTOOLPAR'   ; i:235),
  (S:'cmTOOLMSR'   ; i:236),
  (S:'cmTOUCHOFF'  ; i:240),
  (S:'cmTOUCHX'    ; i:241),
  (S:'cmTOUCHY'    ; i:242),
  (S:'cmTOUCHZ'    ; i:243),
  (S:'cmTOUCHA'    ; i:244),
  (S:'cmTOUCHB'    ; i:245),
  (S:'cmTOUCHC'    ; i:246),
  (S:'cmZEROALL'   ; i:247),
  (S:'cmOFFSDLG'   ; i:248),
  (S:'cmTOUCHWIZ'  ; i: cmTOUCHWIZ),
  (S:'cmSETUP'     ; i:250),
  (S:'cmLIMITS'    ; i:260),
  (S:'cmOPEN'      ; i:270),
  (S:'cmRUN'       ; i:20),
  (S:'cmRUNLINE'   ; i:21),
  (S:'cmSTOP'      ; i:22),
  (S:'cmSTEP'      ; i:271),
  (S:'cmPAUSE'     ; i:23),
  (S:'cmOPTSTOP'   ; i:24),
  (S:'cmBLOCKDEL'  ; i:25),
  (S:'cmRELOAD'    ; i:272),
  (S:'cmMDIEXEC'   ; i:280),
  (S:'cmMDIHIST'   ; i:281),
  (S:'cmEDITOR'    ; i:290),
  (S:'cmINCRDN'    ; i:320),
  (S:'cmINCRUP'    ; i:321),
  (S:'cmSHIFTUP'   ; i:330),
  (S:'cmSHIFTDN'   ; i:331),
  (S:'cmCOORDROT'  ; i:340),
  (S:'cmUNITS'     ; i:cmUNITS),
  (S:'cmVIEWREL'   ; i:cmVIEWREL),
  (S:'cmVIEWDIA'   ; i:cmVIEWDIA),
  (S:'cmVIEWDTG'   ; i:cmVIEWDTG),
  (S:'cmCLOSE'     ; i:360),
  (S:'cmONANDREF'  ; i:410),
  (S:'cmBACK'      ; i:999),
  (S:'cmSCRIPTBASE'; i:1000),
  (S:'cmSCRIPTS'   ; i:1099),
  (S:'cmFEEDRESET' ; i:cmFEEDRESET));

var
  BtnDefJog: TButtonArray;
  BtnDefJogRef: TButtonArray;
  BtnDefJogTouch: TButtonArray;
  BtnDefJogTool: TButtonArray;
  BtnDefMDI: TButtonArray;
  BtnDefRun: TButtonArray;

const
   {$ifndef VER_23}
   MaxToolColumns = 15;
   {$endif}
   {$ifdef VER_23}
   MaxToolColumns = 8;
   {$endif}

const
  ToolColTitles : Array[0..MaxToolColumns] of string =
    ('POC','TNR','X-Offset',{$ifndef VER_23}'Y-Offset',{$endif}
     'Z-Offset',{$ifndef VER_23}'A-Offset','B-Offset','C-Offset',
     'U-Offset','V-Offset','W-Offset',{$endif}
     'Dia.','Frontang.','Backang.','Orient.','Name');

  ToolColWidths : Array[0..MaxToolColumns] of integer =
    (30,30,60,{$ifndef VER_23}60,{$endif}
     60,{$ifndef VER_23}60,60,60,60,60,60,{$endif}
     100,60,60,30,200);

  const
  {$ifndef VER_23}
  ToolColMap = 'PTXZYABCUVWDFKOQ';
  {$else}
  ToolColMap = 'PTXZDFKOQ';
  {$endif}

const
  CoordSysMax = 8;
  CoordSys: Array[0..CoordSysMax] of string =
    ('G54','G55','G56','G57','G58','G59','G59.1','G59.2','G59.3');

  CoordSysVar = '5221';
  CoordSysInc = 10;

type
  TJogIncrement = record
    Value: Double;
    Text: string;
  end;

  TExtents = record
    MinX,MaxX: double;
    MinY,MaxY: double;
    MinZ,MaxZ: double;
  end;

  Tlo = packed record
    x,y,z,a,b,c,u,v,w: double;
  end;

  TSkewCoord = record
    x,y,z: double;
    IsSet: boolean;
  end;

  TAxisDef = record
    AxisChar: Char;
    IsLinear: Boolean;
    Geometry: integer; // 0 = no geometry 1 = positive -1 = negative
  end;

  TAxisDefs = Array[0..MaxAxes - 1] of TAxisDef;

  TScriptDef = record
    Name: string;
    Script: string;
  end;

  TEmcVars = record
    AxisMask: Word;
    IniFile: string;              // inifile set by paramstr(1)
    IniPath: string;
    NMLFile: string;              // the NML-file read from ini
    ProgramPrefix: string;        // program_prefix from ini
    ProgramFile: string;
    Machine: string;              // the machine as defined in inifile
    IsLathe: Boolean;
    PostGuiHalfile: string;
    GladeVCP: string;
    ToolFile: string;
    ParamFile: string;
    Extensions: string;
    NumAxes: Integer;             // number of axes in ini
    Axis: TAxisDefs;
    CoordNames: string;           // the given coordinates (XYZ...)
    CoordMap: string;             // coordinates mapped to a string
    Geometry: string;             // Geometry of coordinates
    CycleTime: Double;            // as defined in [DISPLAY], in seconds
    CycleDelay: Longint;          // cycletime / 1000 in msec
    MaxFeedOverride: integer;     // maximum feed override
    MaxSpORide: integer;          // maximum spindle override
    MinSpORide: integer;
    LinearJogSpeed: double;
    AngularJogSpeed: double;
    MaxLinearVel: double;
    MaxAngularVel: double;
    ShowMetric: Boolean;
    UnitVelStr: string;           // linear velocitystr i.e. "inch/min"
    UnitStr: string;              // linear units i.e. inch "in","mm"
    UnitRotStr: string;           // rotation velocity untits i.e. rpm or u/min
    ShowActual: Boolean;          // actual or cmd position
    ShowRelative: Boolean;        // relative or absolute position
    HomingOrderDefined: Boolean;  // check if can do a "home all"
    NoForceHoming: Boolean;
    JogPolarity: Array[0..MaxAxes] of integer;
    JogIncrements: Array[0..MaxJogIncs-1] of TJogIncrement; // 0 = continous
    JogIncMax: integer;
    JogIncrement: Double;
    JogContinous: Boolean;
    ActiveAxis: integer;
    StartLine: integer;
    MLimits: TExtents;            // machine limits
    // ScriptDir: string;
    Editor: string;
    InitCode: string;             // RS274 startup code
  end;

  TEmcState = record
    Mode: Integer;
    State: integer;
    SpDir: integer;
    SpInc: integer;
    SpBrake: Boolean;
    SpSpeed: Double;
    SpEnabled: Boolean;
    SpIncreasing: Integer;
    Flood: Boolean;
    Mist: Boolean;
    Lube: Boolean;
    LubeLevel: integer;
    Probing: Boolean;
    InterpState: integer;
    OptStop: Boolean;
    BlockDel: Boolean;
    ReadLn: integer;
    CurrentLn: integer;
    MotionLn: integer;
    ProgUnits: integer;
    LinearUnits: double;
    AngularUnits: double;	
    ProgramUnits: integer;
    ORideLimits: boolean;
    CurrentTool: integer;
    ToolPrepared: boolean;
    ToolOffset: double;
    TloAlongW: Boolean;
    Dtg: double;
    Vel: double;
    CurrentVel: double;
    Acc: double;
    ActVel: Integer;
    MaxVel: integer;
    ActFeed: Integer;
    MaxFeed: integer;
    ActJogVel: integer;
    MaxJogVel: Integer;
    ActSpORide: integer;
    UnitsChanged: Boolean;
    SpindleORideEnabled: Boolean;
    FeedORideEnabled: Boolean;
    JointsMode: Boolean;
    ExecState: integer;
  end;

  TGlColorItem = record
    r,g,b,a: single;
  end;

  TGlColors = record
    bg: TGlColorItem;
    table: TGlColorItem;
    limits: TGlColorItem;
    cone: TGlColorItem;
    traverse: TGlColorItem;
    feed: TGlColorItem;
    toolpath: TGlColorItem;
    dim1: TGlColorItem;
    dim2: TGlColorItem;
  end;

  TGlSettings = record
    UseDirect: Boolean;
    UseRGBA: Boolean;
    UseDoubleBuffered: Boolean;
    UseStipple: Boolean;
  end;

  TOnClick = procedure(Sender: TObject) of object;
