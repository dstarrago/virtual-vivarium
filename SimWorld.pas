unit SimWorld;

interface

uses Windows, Classes, Graphics, Forms, Extctrls, SimTools, Controls, TypInfo;

type
  TPercent = 0..100;

  TSimWorld = class;

  TComposition =
    record
      Nutritious: TPercent;
      Innocuous:  TPercent;
      Toxic:      TPercent;
    end;

  TMatter =
    class
      private
        FComposition: TComposition;
        FSmell: longint;
        procedure SetComposition(const Value: TComposition);
        procedure ComputeSmell;
      public
        property Composition: TComposition read FComposition write SetComposition;
        property Smell:       longint read FSmell;
    end;

  TPosition =
    record
      X: Longint;      Y: Longint;    end;

  TSize =
    record
      Width:  longint;      Height: longint;
    end;
  TSimObject =
    class(TMatter)
      private
        FSurmountable: boolean;
        procedure SetSurmountable(const Value: boolean);
        procedure SetBitmap(const index: integer; Bitmap: TBitmap);
      public
        Position: TPosition;
        Size:     TSize;
        Image:    TMosaic;
        World:    TSimWorld;
        constructor Create(const X, Y, W, H: longint; aWorld: TSimWorld; anImage: TMosaic = nil);
        destructor  Destroy;  override;
        property Surmountable: boolean read FSurmountable write SetSurmountable;
        procedure SetImage(const ImageID: integer);
    end;

  TBrick =
    class(TSimObject)
      public
        constructor Create(const X, Y, W, H: longint; aWorld: TSimWorld; anImage: TMosaic = nil);
    end;

  CQuarry = class of TQuarry;

  TQuarry =
    class(TSimObject)
      private
        FCapacity:        longint;
        FQuarryType:      integer;
        StartCapacity:    longint;
        procedure SetCapacity(const Value: longint);
        function GetCapacityPercent: TPercent;
      public
        constructor Create(const X, Y, W, H, aStartCap: longint; aWorld: TSimWorld; anImage: TMosaic = nil);  virtual;
        property Capacity: longint read FCapacity write SetCapacity;
        property CapacityPercent: TPercent read GetCapacityPercent;
        property QuarryType: integer read FQuarryType;
        procedure CheckSate;
    end;

  TYellowQuarry =
    class(TQuarry)
      public
        constructor Create(const X, Y, W, H, aStartCap: longint;  aWorld: TSimWorld; anImage: TMosaic = nil);  override;
    end;

  TRedQuarry =
    class(TQuarry)
      public
        constructor Create(const X, Y, W, H, aStartCap: longint;  aWorld: TSimWorld; anImage: TMosaic = nil);  override;
    end;

  TGreenQuarry =
    class(TQuarry)
      public
        constructor Create(const X, Y, W, H, aStartCap: longint;  aWorld: TSimWorld; anImage: TMosaic = nil);  override;
    end;

  TBlueQuarry =
    class(TQuarry)
      public
        constructor Create(const X, Y, W, H, aStartCap: longint;  aWorld: TSimWorld; anImage: TMosaic = nil);  override;
    end;

  TACreature = class;

  TSingleDir = -1..1;
  TSpaceDir =
    record
      X: TSingleDir;
      Y: TSingleDir;
    end;

  TAngle = (anRight, anLeft);

  TSegment =
    class(TSimObject)
      private
        FACreature: TACreature;
        FNext: TSegment;
        FPrevious: TSegment;
        procedure SetLeft(const Value: integer);
        procedure SetTop(const Value: integer);
        function GetBottom: integer;
        function GetRight: integer;
        procedure SetWidth(const Value: integer);
        procedure SetACreature(const Value: TACreature);
        procedure OnClick(Sender: TObject);
        function GetLeft: integer;
        function GetTop: integer;
        function GetWidth: integer;
        procedure SetNext(const Value: TSegment);
        function GetCenterX: integer;
        function GetCenterY: integer;
        procedure SetCenterX(const Value: integer);
        procedure SetCenterY(const Value: integer);
        procedure SetPrev(const Value: TSegment);
      public
        property Left: integer read GetLeft write SetLeft;
        property Top: integer read GetTop write SetTop;
        property Width: integer read GetWidth write SetWidth;
        property Right: integer read GetRight;
        property Bottom: integer read GetBottom;
        property ACreature: TACreature read FACreature write SetACreature;
        property Next: TSegment read FNext write SetNext;
        property Previous: TSegment read FPrevious write SetPrev;
        property CenterX: integer read GetCenterX write SetCenterX;
        property CenterY: integer read GetCenterY write SetCenterY;
      public
        constructor Create(aACreature: TACreature; Previous: TSegment; anImage: TMosaic = nil;
                    const X: longint = 0; const Y: longint = 0; const W: longint = 0);
        procedure MoveSegment(const Step: integer);
    end;

  TNervousSys =
    class
      private
        Owner: TACreature;
      public
        constructor Create(aOwner: TACreature);
        procedure Performance;
    end;

  TDigestiveSys =
    class
      private
        Owner: TACreature;
        FBiteSize: integer;
        FStomachCapacity: integer;
        FDrainCapacity: integer;
        FPoisonousCapacity: integer;
        procedure SetBiteSize(const Value: integer);
        procedure SetStomachCapacity(const Value: integer);
        procedure SetDrainCapacity(const Value: integer);
        procedure SetPoisonousCapacity(const Value: integer);
      public
        constructor Create(aOwner: TACreature);
        procedure Performance;
        function Bite: boolean;
        function  CanEat: boolean;
        property BiteSize: integer read FBiteSize write SetBiteSize;
        property StomachCapacity: integer read FStomachCapacity write SetStomachCapacity;
        property DrainCapacity: integer read FDrainCapacity write SetDrainCapacity;
        property PoisonousCapacity: integer read FPoisonousCapacity write SetPoisonousCapacity;
    end;


{$TYPEINFO ON}

  TTypeValue = (tvUnknown, tvInteger, tvFloat);
  TGenes =
    class
      private
        PropList: PPropList;
        FFertilityHealth: longint;
        FIncubationTime: longint;
        function GetGenesCount: integer;
        function GetIntValue(const index: integer): longint;
        procedure SetIntValue(const index: integer; const Value: longint);
        function GetFloatValue(const index: integer): single;
        procedure SetFloatValue(const index: integer; const Value: single);
        function GetTypeValue(const index: integer): TTypeValue;
        function MutateFlt(const BaseGen: single): single;
        function MutateOrd(const BaseGen: Integer): longint;
        function GetGenName(const index: integer): ShortString;
        procedure SetFertilityHealth(const Value: longint);
        procedure SetIncubationTime(const Value: longint);
      public
        constructor Create;
        constructor DefaultGenes;
        destructor  Destroy;  override;
        function CopyGenes: TGenes;
        function CombineGenes(aGenes: TGenes): TGenes;
        property GenesCount: integer read GetGenesCount;
        property IntValue[const index: integer]: longint read GetIntValue write SetIntValue;
        property FloatValue[const index: integer]: single read GetFloatValue write SetFloatValue;
        property TypeValue[const index: integer]: TTypeValue read GetTypeValue;
        property GenName[const index: integer]: ShortString read GetGenName;
      private
        FMutateRate: longint;
        FDeltaOrdMutate: longint;
        FDeltaFltMutate: single;
        FFirstLibidoSlope: longint;
        FThirdRecoverAmount: longint;
        FEndStamping: longint;
        FPartitionRate: longint;
        FFirstHealthLibidoPoint: longint;
        FHealthFatten: longint;
        FRipeLibido: longint;
        FThirdLibidoSlope: longint;
        FFirstRecoverAmount: longint;
        FFirstHealthSlope: longint;
        FSecondRecoverAmount: longint;
        FFattenRate: longint;
        FPoisonousCapacity: longint;
        FFourthHungerSlope: longint;
        FSecondHealthSlope: longint;
        FSecondLibidoSlope: longint;
        FGrowthRate: longint;
        FBeginStamping: longint;
        FSecondHungerSlope: longint;
        FHealthGrowth: longint;
        FStartBodyWidth: longint;
        FFattenAmount: longint;
        FRestRatio: longint;
        FFirstRecoverPoint: longint;
        FReliefIntersectRatio: single;
        FLibidoAfterBudding: longint;
        FFirstHungerSlope: longint;
        FStartImmunologicalStrength: longint;
        FThirdHungerSlope: longint;
        FLibidoAfterBipartition: longint;
        FLongStep: longint;
        FHungerToBite: longint;
        FStartBiteSize: longint;
        FSecondRecoverPoint: longint;
        FWalkRatio: longint;
        FStomachCapacity: longint;
        FDrainCapacity: longint;
        FSecondHealthLibidoPoint: longint;
        FTurnRatio: longint;
        FThirdHealthSlope: longint;
        FAbortAngle: single;
        FDeflectAngle: single;
        FIntersectRatio: single;
        procedure SetMutateRate(const Value: longint);
        procedure SetDeltaOrdMutate(const Value: longint);
        procedure SetDeltaFltMutate(const Value: single);
        procedure SetAbortAngle(const Value: single);
        procedure SetBeginStamping(const Value: longint);
        procedure SetDeflectAngle(const Value: single);
        procedure SetDrainCapacity(const Value: longint);
        procedure SetEndStamping(const Value: longint);
        procedure SetFattenAmount(const Value: longint);
        procedure SetFattenRate(const Value: longint);
        procedure SetFirstHealthLibidoPoint(const Value: longint);
        procedure SetFirstHealthSlope(const Value: longint);
        procedure SetFirstHungerSlope(const Value: longint);
        procedure SetFirstLibidoSlope(const Value: longint);
        procedure SetFirstRecoverAmount(const Value: longint);
        procedure SetFirstRecoverPoint(const Value: longint);
        procedure SetFourthHungerSlope(const Value: longint);
        procedure SetGrowthRate(const Value: longint);
        procedure SetHealthFatten(const Value: longint);
        procedure SetHealthGrowth(const Value: longint);
        procedure SetHungerToBite(const Value: longint);
        procedure SetIntersectRatio(const Value: single);
        procedure SetLibidoAfterBipartition(const Value: longint);
        procedure SetLibidoAfterBudding(const Value: longint);
        procedure SetLongStep(const Value: longint);
        procedure SetPartitionRate(const Value: longint);
        procedure SetPoisonousCapacity(const Value: longint);
        procedure SetReliefIntersectRatio(const Value: single);
        procedure SetRestRatio(const Value: longint);
        procedure SetRipeLibido(const Value: longint);
        procedure SetSecondHealthLibidoPoint(const Value: longint);
        procedure SetSecondHealthSlope(const Value: longint);
        procedure SetSecondHungerSlope(const Value: longint);
        procedure SetSecondLibidoSlope(const Value: longint);
        procedure SetSecondRecoverAmount(const Value: longint);
        procedure SetSecondRecoverPoint(const Value: longint);
        procedure SetStartBiteSize(const Value: longint);
        procedure SetStartBodyWidth(const Value: longint);
        procedure SetStartImmunologicalStrength(const Value: longint);
        procedure SetStomachCapacity(const Value: longint);
        procedure SetThirdHealthSlope(const Value: longint);
        procedure SetThirdHungerSlope(const Value: longint);
        procedure SetThirdLibidoSlope(const Value: longint);
        procedure SetThirdRecoverAmount(const Value: longint);
        procedure SetTurnRatio(const Value: longint);
        procedure SetWalkRatio(const Value: longint);
      published
        // Genetic System
        property MutateRate                  : longint read FMutateRate write SetMutateRate;
        property DeltaOrdMutate              : longint read FDeltaOrdMutate write SetDeltaOrdMutate;
        property DeltaFltMutate              : single read FDeltaFltMutate write SetDeltaFltMutate;
        // Motor System
        property DeflectAngle                : single read FDeflectAngle write SetDeflectAngle;
        property AbortAngle                  : single read FAbortAngle write SetAbortAngle;
        property IntersectRatio              : single read FIntersectRatio write SetIntersectRatio;
        property ReliefIntersectRatio        : single read FReliefIntersectRatio write SetReliefIntersectRatio;
        property LongStep                    : longint read FLongStep write SetLongStep;
        property EndStamping                 : longint read FEndStamping write SetEndStamping;
        property BeginStamping               : longint read FBeginStamping write SetBeginStamping;
        property TurnRatio                   : longint read FTurnRatio write SetTurnRatio;
        property WalkRatio                   : longint read FWalkRatio write SetWalkRatio;
        property RestRatio                   : longint read FRestRatio write SetRestRatio;
        // Metabolism
        property FirstHealthSlope            : longint read FFirstHealthSlope write SetFirstHealthSlope;
        property SecondHealthSlope           : longint read FSecondHealthSlope write SetSecondHealthSlope;
        property ThirdHealthSlope            : longint read FThirdHealthSlope write SetThirdHealthSlope;
        property FirstHungerSlope            : longint read FFirstHungerSlope write SetFirstHungerSlope;
        property SecondHungerSlope           : longint read FSecondHungerSlope write SetSecondHungerSlope;
        property ThirdHungerSlope            : longint read FThirdHungerSlope write SetThirdHungerSlope;
        property FourthHungerSlope           : longint read FFourthHungerSlope write SetFourthHungerSlope;
        property FirstLibidoSlope            : longint read FFirstLibidoSlope write SetFirstLibidoSlope;
        property SecondLibidoSlope           : longint read FSecondLibidoSlope write SetSecondLibidoSlope;
        property ThirdLibidoSlope            : longint read FThirdLibidoSlope write SetThirdLibidoSlope;
        // Reproducer System
        property PartitionRate               : longint read FPartitionRate write SetPartitionRate;
        property LibidoAfterBipartition      : longint read FLibidoAfterBipartition write SetLibidoAfterBipartition;
        property LibidoAfterBudding          : longint read FLibidoAfterBudding write SetLibidoAfterBudding;
        property LibidoAfterSex              : longint read FLibidoAfterBudding write SetLibidoAfterBudding;
        property RipeLibido                  : longint read FRipeLibido write SetRipeLibido;
        property FirstHealthLibidoPoint      : longint read FFirstHealthLibidoPoint write SetFirstHealthLibidoPoint;
        property SecondHealthLibidoPoint     : longint read FSecondHealthLibidoPoint write SetSecondHealthLibidoPoint;
        property FertilityHealth             : longint read FFertilityHealth write SetFertilityHealth;
        property IncubationTime              : longint read FIncubationTime write SetIncubationTime;
        // Digestive System
        property StartBiteSize               : longint read FStartBiteSize write SetStartBiteSize;
        property HungerToBite                : longint read FHungerToBite write SetHungerToBite;
        property StomachCapacity             : longint read FStomachCapacity write SetStomachCapacity;
        property DrainCapacity               : longint read FDrainCapacity write SetDrainCapacity;
        property PoisonousCapacity           : longint read FPoisonousCapacity write SetPoisonousCapacity;
        // Immunological System
        property StartImmunologicalStrength  : longint read FStartImmunologicalStrength write SetStartImmunologicalStrength;
        property FirstRecoverPoint           : longint read FFirstRecoverPoint write SetFirstRecoverPoint;
        property FirstRecoverAmount          : longint read FFirstRecoverAmount write SetFirstRecoverAmount;
        property SecondRecoverPoint          : longint read FSecondRecoverPoint write SetSecondRecoverPoint;
        property SecondRecoverAmount         : longint read FSecondRecoverAmount write SetSecondRecoverAmount;
        property ThirdRecoverAmount          : longint read FThirdRecoverAmount write SetThirdRecoverAmount;
        // Growth System
        property StartBodyWidth              : longint read FStartBodyWidth write SetStartBodyWidth;
        property FattenRate                  : longint read FFattenRate write SetFattenRate;
        property HealthFatten                : longint read FHealthFatten write SetHealthFatten;
        property FattenAmount                : longint read FFattenAmount write SetFattenAmount;
        property GrowthRate                  : longint read FGrowthRate write SetGrowthRate;
        property HealthGrowth                : longint read FHealthGrowth write SetHealthGrowth;
    end;


{$TYPEINFO OFF}

  TReproducerSys =
    class
      private
        Owner: TACreature;
        FIncubationTime: integer;
        FFertilityHealth: integer;
        FPregnancy: boolean;
        FEmbryoGenoma: TGenes;
        FLibidoAfterSex: longint;
        PregnancyTime: integer;
        procedure Spawn;
        procedure SetIncubationTime(const Value: integer);
        procedure SetFertilityHealth(const Value: integer);
        procedure SetPregnancy(const Value: boolean);
        procedure SetEmbryoGenoma(const Value: TGenes);
        procedure SetLibidoAfterSex(const Value: longint);
      public
        constructor Create(aOwner: TACreature);
        procedure Performance;
        procedure MakeSex;
        procedure Bipartition;
        procedure Budding;
        function Fertilize: boolean;
        procedure Inseminate(aGenes: TGenes);
        property IncubationTime: integer read FIncubationTime write SetIncubationTime;
        property FertilityHealth: integer read FFertilityHealth write SetFertilityHealth;
        property Pregnancy: boolean read FPregnancy write SetPregnancy;
        property EmbryoGenoma: TGenes read FEmbryoGenoma write SetEmbryoGenoma;
        property LibidoAfterSex: longint read FLibidoAfterSex write SetLibidoAfterSex;
    end;

  TImmunologicalSys =
    class
      private
        Owner: TACreature;
        FImmunologicalStrength: integer;
        procedure Recover(const Rate: longint);
        procedure SetImmunologicalStrength(const Value: integer);
      public
        constructor Create(aOwner: TACreature);
        procedure Performance;
        property ImmunologicalStrength: integer read FImmunologicalStrength write SetImmunologicalStrength;
    end;

  TMotorSys =
    class
      private
        Owner: TACreature;
      public
        constructor Create(aOwner: TACreature);
        procedure Performance;
        function MoveAhead(const Speed: integer): boolean;
        procedure TurnHead(const Angle: TAngle);
    end;

  TGrowthSys =
    class
      private
        Owner: TACreature;
      public
        constructor Create(aOwner: TACreature);
        procedure Performance;
    end;

  TMetabolism =
    class
      private
        Owner: TACreature;
        FEnergy: longint;
        FHealth: longint;
        FMaxLiveTime: longint;
        FTimeLived: longint;
        FOldnessRate: longint;
        FLibido: longint;
        FHunger: longint;
        procedure SetEnergy(const Value: longint);
        procedure SetHealth(const Value: longint);
        procedure SetMaxLiveTime(const Value: longint);
        procedure SetTimeLived(const Value: longint);
        procedure SetOldnessRate(const Value: longint);
        procedure SetHunger(const Value: longint);
        procedure SetLibido(const Value: longint);
        function GetEnergyPercent: longint;
        function GetHealthPercent: longint;
        function GetHungerPercent: longint;
        function GetLibidoPercent: longint;
        function GetTimeLivedPercent: longint;
      public
        procedure Performance;
        property EnergyPercent: longint read GetEnergyPercent;
        property HealthPercent: longint read GetHealthPercent;
        property HungerPercent: longint read GetHungerPercent;
        property LibidoPercent: longint read GetLibidoPercent;
        property TimeLivedPercent: longint read GetTimeLivedPercent;
      public
        property Energy: longint read FEnergy write SetEnergy;
        property Health: longint read FHealth write SetHealth;
        property Hunger: longint read FHunger write SetHunger;
        property Libido: longint read FLibido write SetLibido;
        property MaxLiveTime: longint read FMaxLiveTime write SetMaxLiveTime;
        property TimeLived: longint read FTimeLived write SetTimeLived;
        property OldnessRate: longint read FOldnessRate write SetOldnessRate;
        constructor Create(aOwner: TACreature);
        destructor  Destroy;  override;
    end;

  TSimWorld =
    class
      private
        WorldObjects: TList;
        FCreatures: TList;
        FOnACreatureClick: TNotifyEvent;
        Timer: TTimer;
        FOnNewACreature: TNotifyEvent;
        FOnLostACreature: TNotifyEvent;
        procedure SetOnACreatureClick(const Value: TNotifyEvent);
        procedure OnTimer(Sender: TObject);
        procedure SetOnLostACreature(const Value: TNotifyEvent);
        procedure SetOnNewACreature(const Value: TNotifyEvent);
        function GetCreature(const i: integer): TACreature;
        function GetCreatureCount: integer;
        function GetTimeSpeed: integer;
        procedure SetTimeSpeed(const Value: integer);
      private
        FBGColor: TColor;
        procedure SetBGColor(const Value: TColor);
      public
        updating: boolean;
        constructor Create(Form: TForm; TheImages: TImageList);
        destructor  Destroy;  override;
        procedure AddBrick(const X, Y, Width, Height: Integer; aWall: TWall = nil);  overload;
        procedure AddBrick(aWall: TWall);  overload;
        procedure AddQuarry(Kind: CQuarry; const X, Y, Width, Height, StartCap: Integer; aSubstratum: TSubstratum = nil);  overload;
        procedure AddQuarry(aSubstratum: TSubstratum); overload;
        procedure AddACreature(const Name: string; const X, Y: Integer; aCreature: TCreature = nil);  overload;
        procedure AddACreature(aCreature: TCreature);  overload;
        procedure AddObject(aControl: TControl);
        function QuarryAt(const X, Y: longint): TQuarry;
        function ACreatureClose(C: TACreature): TACreature;
        function Bump(const X1, Y1, X2, Y2: longint; CO: TSimObject): boolean;
        procedure Stop;
        procedure Resume;
        procedure Trace;
        procedure InsertACreature(C: TACreature);
      public
        Ground:  TForm;
        Images:  TImageList;
        property BGColor: TColor read FBGColor write SetBGColor;
        property OnACreatureClick: TNotifyEvent read FOnACreatureClick write SetOnACreatureClick;
        property OnLostACreature: TNotifyEvent read FOnLostACreature write SetOnLostACreature;
        property OnNewACreature: TNotifyEvent read FOnNewACreature write SetOnNewACreature;
        property Creature[const i: integer]: TACreature read GetCreature;
        property CreatureCount: integer read GetCreatureCount;
        property TimeSpeed: integer read GetTimeSpeed write SetTimeSpeed;
    end;

  TACreature =
    class
      private
        FName: string;
        FOnClick: TNotifyEvent;
        Body: TList;
        FIntersectRatio: real;
        FParenthood: integer;
        procedure SetBodyWidth(const Value: integer);
        function GetTailBottom: integer;
        function GetTailLeft: integer;
        procedure SetName(const Value: string);
        procedure SetOnClick(const Value: TNotifyEvent);
        function GetAlive: boolean;
        function GetHead: TSegment;
        function GetTail: TSegment;
        function GetSegment(const i: integer): TSegment;
        function GetSegmentCount: integer;
        procedure Living;
        procedure SetIntersectRatio(const Value: real);
        procedure SetParenthood(const Value: integer);
        function GetBodyWidth: integer;
      public
        World:            TSimWorld;
        Genes:            TGenes;
        Metabolism:       TMetabolism;
        DigestiveSys:     TDigestiveSys;
        ImmunologicalSys: TImmunologicalSys;
        MotorSys:         TMotorSys;
        GrowthSys:        TGrowthSys;
        ReproducerSys:    TReproducerSys;
        NervousSys:       TNervousSys;
        Direction:        TSpaceDir;
      public
        procedure AddSegment(anImage: TMosaic = nil);
        procedure TurnHead(const X, Y: longint);
        procedure UpDateFace;
        function MoveHead(const Step: integer): boolean;
        function Intersect(const X1, Y1, X2, Y2: longint; Obj: TSimObject): boolean;
        constructor Create(const aName: string; G: TGenes; const X, Y: Integer; aWorld: TSimWorld; ImplicitSeg: boolean; anImage: TMosaic = nil);
        destructor  Destroy;  override;
        property BodyWidth: integer read GetBodyWidth write SetBodyWidth;
        property TailLeft: integer read GetTailLeft;
        property TailBottom: integer read GetTailBottom;
        property Name: string read FName write SetName;
        property OnClick: TNotifyEvent read FOnClick write SetOnClick;
        property Alive: boolean read GetAlive;
        property Head: TSegment read GetHead;
        property Tail: TSegment read GetTail;
        property Segment[const i: integer]: TSegment read GetSegment;
        property SegmentCount: integer read GetSegmentCount;
        property IntersectRatio: real read FIntersectRatio write SetIntersectRatio;
        property Parenthood: integer read FParenthood write SetParenthood;
    end;

  const
    HIGHTSPEED         = 100000;
    MIDSPEED           = 10000;
    LOWSPEED           = 1000;

    SPEED              = LOWSPEED;

    MAXLONGINT         = 2147483647;
    TOPVALUE           = MAXLONGINT div SPEED;
    FIRST_OLDNESS_RATE = 100;
    LOW_SPENDING       = 10;
    MID_SPENDING       = 100;
    HIGHT_SPENDING     = 1000;
    HUGE_SPENDING      = 10000;

    MAXENERGY          = TOPVALUE;
    MAXHEALTH          = TOPVALUE;
    MAXHUNGER          = TOPVALUE;
    MAXLIBIDO          = TOPVALUE;
    MAXTIMELIVED       = TOPVALUE;

    QUARRY_BASE_CAPACITY = 5000;
    CALORIC_RATE         = 1000;
    HEALING_RATE         = 1;

    TIME_SPEED_HIGHT     = 10;
    TIME_SPEED_MID       = 50;
    TIME_SPEED_LOW       = 100;

implementation

uses SysUtils, Constants;

{ TMatter }

  procedure TMatter.SetComposition(const Value: TComposition);
    begin
      FComposition := Value;
      ComputeSmell;
    end;

  procedure TMatter.ComputeSmell;
    begin
      with FComposition do
      FSmell := Longint(Nutritious) + (Longint(Innocuous) shl 8) + (Longint(Toxic) shl 16);
    end;

{ TSimWorld }

  procedure TSimWorld.AddBrick(const X, Y, Width, Height: Integer; aWall: TWall = nil);
    var
      Brick: TBrick;
    begin
      Brick := TBrick.Create(X, Y, Width, Height, Self, aWall);
      WorldObjects.Add(Brick);
      Brick.Image.Parent := Ground;
    end;

  procedure TSimWorld.AddBrick(aWall: TWall);
    begin
      with aWall do
        AddBrick(Left, Top, Width, Height, aWall);
    end;

  procedure TSimWorld.AddQuarry(Kind: CQuarry; const X, Y, Width, Height, StartCap: Integer; aSubstratum: TSubstratum = nil);
    var
      Quarry: TQuarry;
    begin
      Quarry := Kind.Create(X, Y, Width, Height, StartCap, Self, aSubstratum);
      WorldObjects.Add(Quarry);
      Quarry.Image.Parent := Ground;
    end;

  procedure TSimWorld.AddQuarry(aSubstratum: TSubstratum);
    var
      QuarryKind: CQuarry;
    begin
      case aSubstratum.Kind of
        skRed:    QuarryKind := TRedQuarry;
        skGreen:  QuarryKind := TGreenQuarry;
        skBlue:   QuarryKind := TBlueQuarry;
        else      QuarryKind := TYellowQuarry;
      end;
      with aSubstratum do
        AddQuarry(QuarryKind, Left, Top, Width, Height, Capacity, aSubstratum);
    end;

  procedure TSimWorld.AddACreature(const Name: string; const X, Y: Integer; aCreature: TCreature = nil);
    begin
      InsertACreature(TACreature.Create(Name, nil, X, Y, Self, true, aCreature));
    end;

  procedure TSimWorld.AddACreature(aCreature: TCreature);
    begin
      with aCreature do
        AddACreature(Name, Left, Top, aCreature);
    end;

  procedure TSimWorld.AddObject(aControl: TControl);
    begin
      if aControl is TWall then AddBrick(aControl as TWall);
      if aControl is TSubstratum then AddQuarry(aControl as TSubstratum);
      if aControl is TCreature then AddACreature(aControl as TCreature);
    end;

  function TSimWorld.Bump(const X1, Y1, X2, Y2: Integer; CO: TSimObject): boolean;
    var
      i: integer;
      R: TRect;
      Obj: TSimObject;
    begin
      i := 0;
      Result := false;
      while (i < WorldObjects.Count) and not Result do
        begin
          Obj := WorldObjects.Items[i];
          Result := not Obj.Surmountable and IntersectRect(R,
             Bounds(Obj.Position.X, Obj.Position.Y, Obj.Size.Width, Obj.Size.Height),
             Rect(X1, Y1, X2, Y2));
          inc(i);
        end;
      i := 0;
      if not Result
        then
          while (i < FCreatures.Count) and not Result do
            begin
              Result :=  TACreature(FCreatures.Items[i]).Intersect(X1, Y1, X2, Y2, CO);
              inc(i);
            end;
    end;

  constructor TSimWorld.Create(Form: TForm; TheImages: TImageList);
    begin
      inherited Create;
      Ground := Form;
      Images := TheImages;
      WorldObjects := TList.Create;
      FCreatures := TList.Create;
      Timer := TTimer.Create(Ground);
      Timer.OnTimer := OnTimer;
      Timer.Interval := TIME_SPEED_MID;
    end;

  destructor TSimWorld.Destroy;
    begin
      FCreatures.free;
      WorldObjects.free;
      Timer.free;
      inherited;
    end;

  procedure TSimWorld.InsertACreature(C: TACreature);
    begin
      WorldObjects.Add(C);
      FCreatures.Add(C);
      C.FOnClick := OnACreatureClick;
      if Assigned(FOnNewACreature)
        then OnNewACreature(C);
    end;

  procedure TSimWorld.OnTimer(Sender: TObject);
    var
      i: integer;
      ACreature: TACreature;
      Quarry: TQuarry;
    begin
      if updating then exit;
      updating := true;
      i := 0;
      while i < WorldObjects.Count do
        begin
          if TObject(WorldObjects.Items[i]) is TQuarry
            then
              begin
                Quarry := WorldObjects.Items[i];
                Quarry.CheckSate;
                if Quarry.Capacity = 0
                  then
                    begin
                      WorldObjects.Remove(Quarry);
                      Quarry.free;
                    end
                  else inc(i);
              end
            else inc(i);
        end;
      i := 0;
      while i < FCreatures.Count do
        begin
          ACreature := TACreature(FCreatures.Items[i]);
          with ACreature do
            if not Alive
              then
                begin
                  FCreatures.Remove(ACreature);
                  WorldObjects.Remove(ACreature);
                  OnLostACreature(ACreature);
                  free;
                end
              else inc(i);
        end;
      for i := 0 to pred(CreatureCount) do
        Creature[i].Living;
      updating := false;
    end;

  function TSimWorld.ACreatureClose(C: TACreature): TACreature;
    var
      i: integer;
      R: TRect;
    begin
      i := 0;
      Result := nil;
      while (i < CreatureCount) and (Result = nil) do
        begin
          with Creature[i].Head do
            if IntersectRect(R,
             Bounds(Left, Top, Width, Width),
             Bounds(C.Head.Left, C.Head.Top, C.Head.Width, C.Head.Width))
              then Result := Creature[i];
          inc(i);
        end;
    end;

  function TSimWorld.QuarryAt(const X, Y: longint): TQuarry;
    var
      i: integer;
    begin
      i := 0;
      Result := nil;
      while (i < WorldObjects.Count) and (Result = nil) do
        begin
          if TObject(WorldObjects.Items[i]) is TQuarry
            then
              with TQuarry(WorldObjects.Items[i]) do
                if PtInRect(Rect(Position.X, Position.Y,
                   Position.X + Size.Width, Position.Y + Size.Height),
                   Point(X, Y))
                  then Result := WorldObjects.Items[i];
          inc(i);
        end;
    end;

  procedure TSimWorld.Resume;
    begin
      Timer.Enabled := true;
    end;

  procedure TSimWorld.SetBGColor(const Value: TColor);
    begin
      FBGColor := Value;
      Ground.Color := Value;
    end;

  procedure TSimWorld.SetOnACreatureClick(const Value: TNotifyEvent);
    begin
      FOnACreatureClick := Value;
    end;

  procedure TSimWorld.Stop;
    begin
      Timer.Enabled := false;
    end;

  procedure TSimWorld.Trace;
    begin
      OnTimer(Self);
    end;

  procedure TSimWorld.SetOnLostACreature(const Value: TNotifyEvent);
    begin
      FOnLostACreature := Value;
    end;

  procedure TSimWorld.SetOnNewACreature(const Value: TNotifyEvent);
    begin
      FOnNewACreature := Value;
    end;

  function TSimWorld.GetCreature(const i: integer): TACreature;
    begin
      Result := FCreatures.Items[i];
    end;


  function TSimWorld.GetCreatureCount: integer;
    begin
      Result := FCreatures.Count;
    end;

  function TSimWorld.GetTimeSpeed: integer;
    begin
      Result := Timer.Interval;
    end;

  procedure TSimWorld.SetTimeSpeed(const Value: integer);
    begin
      Timer.Interval := Value;
    end;

{ TBrick }

  constructor TBrick.Create(const X, Y, W, H: longint; aWorld: TSimWorld; anImage: TMosaic = nil);
    begin
      inherited;
      Image.Picture.LoadFromFile('Brick.bmp');
      Image.Picture.Graphic.Transparent := true;
      Image.Tile := true;
    end;

{ TSimObject }

  constructor TSimObject.Create(const X, Y, W, H: longint; aWorld: TSimWorld; anImage: TMosaic = nil);
    begin
      inherited Create;
      Position.X  := X;
      Position.Y  := Y;
      Size.Width  := W;
      Size.Height := H;
      World       := aWorld;
      if anImage = nil
        then Image := TMosaic.Create(World.Ground)
        else Image := anImage;
      with Image do
        begin
          Left    := X;
          Top     := Y;
          Width   := W;
          Height  := H;
        end;
    end;

  destructor TSimObject.Destroy;
    begin
      Image.free;
    end;

  procedure TSimObject.SetBitmap(const index: integer; Bitmap: TBitmap);
    var
      bm: TBitmap;
    begin
      bm := TBitmap.Create;
      World.Images.GetBitmap(index, bm);
      Bitmap.Assign(bm);
      bm.free;
    end;

  procedure TSimObject.SetImage(const ImageID: integer);
    begin
      SetBitmap(ImageID, Image.Picture.Bitmap);
      Image.Picture.Graphic.Transparent := true;
    end;

  procedure TSimObject.SetSurmountable(const Value: boolean);
    begin
      FSurmountable := Value;
    end;

{ TQuarry }

  procedure TQuarry.CheckSate;
    begin
      if CapacityPercent < 100
        then SetImage(QuarryType + 1 + CapacityPercent div 20);
    end;

  constructor TQuarry.Create(const X, Y, W, H, aStartCap: Integer; aWorld: TSimWorld; anImage: TMosaic = nil);
    begin
      inherited Create(X, Y, W, H, aWorld);
      World := aWorld;
      SetImage(YELLOW_5);
      Image.Tile := true;
      StartCapacity := aStartCap;
      FCapacity  := StartCapacity;
      FSurmountable := true;
    end;

  function TQuarry.GetCapacityPercent: TPercent;
    begin
      Result := 100 * Capacity div StartCapacity;
    end;

  procedure TQuarry.SetCapacity(const Value: longint);
    begin
      if Value < 0
        then FCapacity := 0
        else FCapacity := Value;
    end;

{ TSegment }

  constructor TSegment.Create(aACreature: TACreature; Previous: TSegment; anImage: TMosaic = nil;
              const X: longint = 0; const Y: longint = 0; const W: longint = 0);
    begin
      inherited Create(X, Y, W, W, aACreature.World, anImage);
      ACreature := aACreature;
      if Previous = nil
        then Image.PictureName := 'HeadRight.bmp'
        else Image.PictureName := 'Segment.bmp';
      Image.OnClick := OnClick;
      Image.Tile := false;
      Left       := X;
      Top        := Y;
      Width      := W;
      FPrevious      := Previous;
      if ACreature.World.Bump(X, Y, X + Width, Y + Width, Self)
        then Top := Previous.Top;
    end;

  function TSegment.GetBottom: integer;
    begin
      Result := Top + Width;
    end;

  function TSegment.GetLeft: integer;
    begin
      Result := Position.X;
    end;

  function TSegment.GetRight: integer;
    begin
      Result := Left + Width;
    end;

  function TSegment.GetTop: integer;
    begin
      Result := Position.Y;
    end;

  function TSegment.GetWidth: integer;
    begin
      Result := Size.Width;
    end;

  procedure TSegment.MoveSegment(const Step: integer);
    var
      A, B: longint;
      DX, DY: longint;
      CX, CY: longint;
      X, Y: longint;
      Walking: boolean;
      Dir: integer;
      AlphaT: single;
      DAngle, Angle0: single;

    function Sign(const A: integer): integer;
      begin
        if A = 0
          then Result := 0
          else
            if A > 0
              then Result := 1
              else Result := -1;
      end;

    begin
      if Previous <> nil
        then
          begin
            A := Previous.CenterX - CenterX;
            B := Previous.CenterY - CenterY;
            if A = 0
              then AlphaT := Pi/2
              else AlphaT := Arctan( Abs(B/A));
            DAngle  := 0;
            Angle0  := AlphaT;
            Dir     := 1;
            repeat
              DX := Round(cos(AlphaT) * Width);
              DY := Round(sin(AlphaT) * Width);
              if ((AlphaT > 1.4181469983) and (AlphaT < 1.4659193882)) or
                 ((AlphaT > 0.10487693871) and (AlphaT < 0.1526493285))
                then
                  if DX < DY
                    then DX := 0
                    else DY := 0;
              CX := Previous.CenterX - DX * Sign(A);
              CY := Previous.CenterY - DY * Sign(B);
              X  := CX - Width div 2;
              Y  := CY - Width div 2;
              Walking := not ACreature.World.Bump(X, Y, X + Width, Y + Width, Self);
              if not Walking
                then
                  begin
                    if Dir = 1
                      then DAngle := DAngle + ACreature.Genes.DeflectAngle;
                    AlphaT := Angle0 + DAngle * Dir;
                    Dir := - Dir;
                  end;
            until Walking or (DAngle >= ACreature.Genes.AbortAngle);
            CenterX := CX;
            CenterY := CY;
          end;
      if Next <> nil
        then Next.MoveSegment(Step);
    end;

  procedure TSegment.OnClick(Sender: TObject);
    begin
      ACreature.Onclick(ACreature);
    end;

  procedure TSegment.SetACreature(const Value: TACreature);
    begin
      FACreature := Value;
      if Next <> nil
        then Next.ACreature := Value;
    end;

  procedure TSegment.SetLeft(const Value: integer);
    begin
      Position.X := Value;
      Image.Left := Value;
    end;

  procedure TSegment.SetNext(const Value: TSegment);
    begin
      FNext := Value;
    end;

  procedure TSegment.SetTop(const Value: integer);
    begin
      Position.Y := Value;
      Image.Top := Value;
    end;

  procedure TSegment.SetWidth(const Value: integer);
    begin
      Size.Width := Value;
      Size.Height := Value;
      Image.Width := Value;
      Image.Height := Value;
      if Next <> nil
        then Next.Width := Value;
    end;

  function TSegment.GetCenterX: integer;
    begin
      Result := Left + Width div 2;
    end;

  function TSegment.GetCenterY: integer;
    begin
      Result := Top + Width div 2;
    end;

  procedure TSegment.SetCenterX(const Value: integer);
    begin
      Left := Value - Width div 2;
    end;

  procedure TSegment.SetCenterY(const Value: integer);
    begin
      Top := Value - Width div 2;
    end;

  procedure TSegment.SetPrev(const Value: TSegment);
    begin
      FPrevious := Value;
    end;

{ TACreature }

  procedure TACreature.AddSegment(anImage: TMosaic = nil);
    var
      Segment: TSegment;
    begin
      if Body.Count = 0
        then Segment := TSegment.Create(Self, nil, anImage)
        else Segment := TSegment.Create(Self, Tail, anImage, TailLeft, TailBottom, BodyWidth);
      Segment.Image.Parent := World.Ground;
      if Body.Count > 0
        then Tail.Next := Segment;
      Body.Add(Segment);
      Metabolism.Energy := Metabolism.Energy - HIGHT_SPENDING;  //E&M
    end;

  constructor TACreature.Create(const aName: string; G: TGenes; const X, Y: Integer; aWorld: TSimWorld; ImplicitSeg: boolean; anImage: TMosaic = nil);
    begin
      inherited Create;
      World            := aWorld;
      if G = nil
        then Genes    := TGenes.DefaultGenes
        else Genes    := G;
      Body             := TList.Create;
      Metabolism       := TMetabolism.Create(Self);
      DigestiveSys     := TDigestiveSys.Create(Self);
      ImmunologicalSys := TImmunologicalSys.Create(Self);
      MotorSys         := TMotorSys.Create(Self);
      ReproducerSys    := TReproducerSys.Create(Self);
      NervousSys       := TNervousSys.Create(Self);
      GrowthSys        := TGrowthSys.Create(Self);
      Name             := aName;
      if ImplicitSeg
        then
          begin
            AddSegment(anImage);
            Head.Left        := X;
            Head.Top         := Y;
            BodyWidth        := Genes.StartBodyWidth;
          end;
      Direction.X      := 1;
      Direction.Y      := 0;
      IntersectRatio   := Genes.IntersectRatio;
    end;

  destructor TACreature.Destroy;
    var
      i: integer;
    begin
      for i := 0 to pred(Body.Count) do
        TSegment(Body.Items[i]).free;
      Body.free;
      Metabolism.free;
      DigestiveSys.free;
      ImmunologicalSys.free;
      MotorSys.free;
      GrowthSys.free;
      ReproducerSys.free;
      NervousSys.free;
      inherited;
    end;

  function TACreature.GetTailLeft: integer;
    begin
      if Body.Count = 0
        then Result := Head.Left
        else Result := TSegment(Body.Last).Left;
    end;

  function TACreature.GetTailBottom: integer;
    begin
      if Body.Count = 0
        then Result := Head.Top
        else Result := TSegment(Body.Last).Bottom;
    end;

  procedure TACreature.SetBodyWidth(const Value: integer);
    begin
      Head.Width := Value;
      Metabolism.Energy := Metabolism.Energy - MID_SPENDING;  //E&M
    end;

  procedure TACreature.SetName(const Value: string);
    begin
      FName := Value;
    end;

  procedure TACreature.SetOnClick(const Value: TNotifyEvent);
    begin
      FOnClick := Value;
    end;

  function TACreature.GetAlive: boolean;
    begin
      Result := Metabolism.Health > LOW_SPENDING;
    end;

  procedure TACreature.Living;
    begin
      Metabolism.Performance;
      ImmunologicalSys.Performance;
      DigestiveSys.Performance;
      MotorSys.Performance;
      GrowthSys.Performance;
      ReproducerSys.Performance;
      NervousSys.Performance;
    end;

  function TACreature.GetHead: TSegment;
    begin
      Result := Body.First;
    end;

  function TACreature.Intersect(const X1, Y1, X2, Y2: Integer; Obj: TSimObject): boolean;
    var
      i: integer;
      R: TRect;
      Seg: TSegment;
    begin
      Result := false;
      i := 0;
      while (i < Body.Count) and not Result do
        begin
          Seg := Body.Items[i];
          if Seg <> Obj
            then
              begin
                Result := IntersectRect(R,
                   Bounds(Seg.Position.X, Seg.Position.Y, Seg.Size.Width, Seg.Size.Height),
                   Rect(X1, Y1, X2, Y2));
                if Result
                  then
                    if Abs(R.Right - R.Left) * Abs(R.Bottom - R.Top) <
                       Abs(X2 - X1) * Abs(Y2 - Y1) * IntersectRatio
                      then Result := false;
              end;
          inc(i);
        end;
    end;

  procedure TACreature.TurnHead(const X, Y: Integer);
    begin
      Head.Left := X;
      Head.Top  := Y;
    end;

  function TACreature.GetTail: TSegment;
    begin
      Result := Body.Last;
    end;

  function TACreature.GetSegment(const i: integer): TSegment;
    begin
      Result := Body.Items[i];
    end;

  function TACreature.MoveHead(const Step: integer): boolean;
    var
      X, Y: longint;
    begin
      X := Head.Left + Direction.X * Step;
      Y := Head.Top  + Direction.Y * Step;
      if not World.Bump(X, Y, X + BodyWidth, Y + BodyWidth, Head)
        then
          begin
            Head.Left := X;
            Head.Top  := Y;
            Head.MoveSegment(Step);
            Result := true;
          end
        else
          begin
            if Random(2) = 1  //Conduct
              then MotorSys.TurnHead(anLeft)
              else MotorSys.TurnHead(anRight);
            Result := false;
          end;
    end;

  function TACreature.GetSegmentCount: integer;
    begin
      if Body <> nil
        then Result := Body.Count
        else Result := 0;
    end;

  procedure TACreature.SetIntersectRatio(const Value: real);
    begin
      FIntersectRatio := Value;
    end;

  procedure TACreature.SetParenthood(const Value: integer);
    begin
      FParenthood := Value;
    end;

  procedure TACreature.UpDateFace;
    begin
      if Direction.X = -1
        then Head.Image.PictureName := 'HeadLeft.bmp';
      if Direction.X = 1
        then Head.Image.PictureName := 'HeadRight.bmp';
      if Direction.Y = -1
        then Head.Image.PictureName := 'HeadUp.bmp';
      if Direction.Y = 1
        then Head.Image.PictureName := 'HeadDown.bmp';
    end;

  function TACreature.GetBodyWidth: integer;
    begin
      Result := Head.Width;
    end;

{ TMetabolism }

  constructor TMetabolism.Create(aOwner: TACreature);
    begin
      inherited Create;
      Owner := aOwner;
      FEnergy       := TOPVALUE;
      FHealth       := TOPVALUE;
      FMaxLiveTime  := TOPVALUE;
      FTimeLived    := 0;
      FOldnessRate  := FIRST_OLDNESS_RATE;
      FLibido       := 0;
      FHunger       := 0;
    end;

  destructor TMetabolism.Destroy;
    begin
      inherited;
    end;

  function TMetabolism.GetEnergyPercent: longint;
    begin
      Result := Round(100 * (Energy / MAXENERGY));
    end;

  function TMetabolism.GetHealthPercent: longint;
    begin
      Result := Round(100 * (Health / MAXHEALTH));
    end;

  function TMetabolism.GetHungerPercent: longint;
    begin
      Result := Round(100 * (Hunger / MAXHunger));
    end;

  function TMetabolism.GetLibidoPercent: longint;
    begin
      Result := Round(100 * (Libido / MAXLibido));
    end;

  function TMetabolism.GetTimeLivedPercent: longint;
    begin
      Result := Round(100 * (TimeLived / MAXTIMELIVED));
    end;

  procedure TMetabolism.SetEnergy(const Value: longint);
    begin
      if Value < 0
        then FEnergy := 0
        else FEnergy := Value;
    end;

  procedure TMetabolism.SetHealth(const Value: longint);
    begin
      if Value < 0
        then FHealth := 0
        else FHealth := Value;
    end;

  procedure TMetabolism.SetHunger(const Value: longint);
    begin
      if Value < 0
        then FHunger := 0
        else FHunger := Value;
    end;

  procedure TMetabolism.SetMaxLiveTime(const Value: longint);
    begin
      if Value < 0
        then FMaxLiveTime := 0
        else FMaxLiveTime := Value;
    end;

  procedure TMetabolism.SetOldnessRate(const Value: longint);
    begin
      if Value < 0
        then FOldnessRate := 0
        else FOldnessRate := Value;
    end;

  procedure TMetabolism.SetLibido(const Value: longint);
    begin
      if Value < 0
        then FLibido := 0
        else FLibido := Value;
    end;

  procedure TMetabolism.SetTimeLived(const Value: longint);
    begin
      if Value < 0
        then FTimeLived := 0
        else FTimeLived := Value;
    end;

  procedure TMetabolism.Performance;
    begin
      Energy       := Energy - LOW_SPENDING;  //E&M
      if EnergyPercent > Owner.Genes.FirstHealthSlope
       then Health := Health - MID_SPENDING
        else
          if EnergyPercent > Owner.Genes.SecondHealthSlope
            then Health := Health - HIGHT_SPENDING
            else
              if EnergyPercent > Owner.Genes.ThirdHealthSlope
                then Health := Health - HUGE_SPENDING
                else Health := Health - HUGE_SPENDING;
      if EnergyPercent > Owner.Genes.FirstHungerSlope
        then Hunger := Hunger - HUGE_SPENDING
        else
          if EnergyPercent > Owner.Genes.SecondHungerSlope
            then Hunger := Hunger - HIGHT_SPENDING
            else
              if EnergyPercent > Owner.Genes.ThirdHungerSlope
                then // do nothing
                else
                  if EnergyPercent > Owner.Genes.FourthHungerSlope
                    then Hunger := Hunger + HIGHT_SPENDING
                    else Hunger := Hunger + HUGE_SPENDING;
          if not Owner.ReproducerSys.Pregnancy
            then
              if HealthPercent > Owner.Genes.FirstLibidoSlope
                then FLibido := FLibido + MID_SPENDING
                else
                  if HealthPercent > Owner.Genes.SecondLibidoSlope
                    then FLibido := FLibido + HIGHT_SPENDING
                    else
                      if HealthPercent > Owner.Genes.ThirdLibidoSlope
                        then FLibido := FLibido + HIGHT_SPENDING
                        else FLibido := FLibido + HUGE_SPENDING;
      FTimeLived    := FTimeLived + FOldnessRate;
      //FMaxLiveTime  := TOPVALUE;
      //FOldnessRate  := FIRST_OLDNESS_RATE;
    end;

{ TMotorSys }

  constructor TMotorSys.Create(aOwner: TACreature);
    begin
      inherited Create;
      Owner := aOwner;
    end;

  function TMotorSys.MoveAhead(const Speed: integer): boolean;
    begin
      Result := Owner.MoveHead(Speed);
      Owner.Metabolism.Energy := Owner.Metabolism.Energy - Round(LOW_SPENDING * Owner.BodyWidth * 1);  //E&M
    end;

  procedure TMotorSys.Performance;
    var
      Stopped: integer;
    begin
      Owner.IntersectRatio := Owner.Genes.IntersectRatio;
      if Random(Owner.Genes.WalkRatio) = 0
        then
          begin
            Stopped := 0;
            while not MoveAhead(Owner.Genes.LongStep) and
                  (Stopped < Owner.Genes.EndStamping) do
              begin
                inc(Stopped);
                if Stopped >= Owner.Genes.BeginStamping
                  then Owner.IntersectRatio := Owner.Genes.ReliefIntersectRatio;
              end;
          end;
      if Random(Owner.Genes.TurnRatio) = 0
        then
          if Random(2) = 0
            then TurnHead(anLeft)
            else TurnHead(anRight);
    end;

  procedure TMotorSys.TurnHead(const Angle: TAngle);
    var
      LastDirX: TSingleDir;
      LastDirY: TSingleDir;
    begin
      with Owner do
        begin
          LastDirX := Direction.X;
          LastDirY := Direction.Y;
          if Direction.X = 0
            then
              if Angle = anRight
                then Direction.X := - LastDirY
                else Direction.X := LastDirY
            else Direction.X := 0;
          if Direction.Y = 0
            then
              if Angle = anRight
                then Direction.Y := LastDirX
                else Direction.Y := - LastDirX
            else Direction.Y := 0;
          Metabolism.Energy := Metabolism.Energy - Round(LOW_SPENDING * BodyWidth * 0.5);  //E&M
          UpDateFace;
        end;
    end;

{ TReproducerSys }

  procedure TReproducerSys.Bipartition;
    var
      C: TACreature;
      NewHead, Seg: TSegment;
      Index, i: integer;
    begin
      if (Owner.SegmentCount > 1) and (Owner.Metabolism.Energy > HUGE_SPENDING)  //E&M
        then
          begin
            Owner.Parenthood := Owner.Parenthood + 1;
            Index := Owner.SegmentCount div Owner.Genes.PartitionRate;
            NewHead := Owner.Segment[Index];
            C := TACreature.Create(Owner.Name + IntToStr(Owner.Parenthood),
                 Owner.Genes.CopyGenes,
                 NewHead.Left, NewHead.Top, Owner.World, false);
            NewHead.ACreature := C;
            Owner.World.InsertACreature(C);
            NewHead.Previous.Next := nil;
            NewHead.Previous := nil;
            for i := 1 to Owner.SegmentCount - Index do
              begin
                Seg := Owner.Segment[Index];
                C.Body.Add(Seg);
                Owner.Body.Remove(Seg);
              end;
            C.BodyWidth := Owner.Genes.StartBodyWidth;
            Owner.Metabolism.Energy := Owner.Metabolism.Energy div 2; //E&M
            Owner.Metabolism.Libido := Owner.Genes.LibidoAfterBipartition;
          end;
    end;

  procedure TReproducerSys.Budding;
    var
      C: TACreature;
    begin
      if (Owner.SegmentCount > 1) and (Owner.Metabolism.Energy > HUGE_SPENDING)  //E&M
        then
          begin
            Owner.Parenthood := Owner.Parenthood + 1;
            C := TACreature.Create(Owner.Name + IntToStr(Owner.Parenthood),
                 Owner.Genes.CopyGenes,
                 Owner.Tail.Left, Owner.Tail.Top, Owner.World, false);
            C.Body.Add(Owner.Tail);
            Owner.Tail.FACreature := C;
            Owner.Tail.Width := Owner.Genes.StartBodyWidth;
            Owner.World.InsertACreature(C);
            Owner.Tail.Previous.Next := nil;
            Owner.Body.Remove(Owner.Tail);
            Owner.Metabolism.Energy := Owner.Metabolism.Energy - HUGE_SPENDING;  //E&M
            Owner.Metabolism.Libido := Owner.Genes.LibidoAfterBudding;
          end;
    end;

  constructor TReproducerSys.Create(aOwner: TACreature);
    begin
      inherited Create;
      Owner := aOwner;
      FertilityHealth := Owner.Genes.FertilityHealth;
      IncubationTime := Owner.Genes.IncubationTime;
      LibidoAfterSex := Owner.Genes.LibidoAfterSex;
    end;

  function TReproducerSys.Fertilize: boolean;
    var
      C: TACreature;
    begin
      C := Owner.World.ACreatureClose(Self.Owner);
      if C <> nil
        then
          begin
            C.ReproducerSys.Inseminate(Owner.Genes);
            Result := true;
            Owner.Metabolism.Libido := LibidoAfterSex;
          end
        else Result := false;
    end;

  procedure TReproducerSys.Spawn;
    begin
      if Owner.Metabolism.Energy > HIGHT_SPENDING  //E&M
        then
          begin
            Owner.Parenthood := Owner.Parenthood + 1;
            Owner.World.InsertACreature(TACreature.Create(Owner.Name + IntToStr(Owner.Parenthood),
                 EmbryoGenoma, Owner.Tail.Left, Owner.Tail.Top, Owner.World, true));
            Owner.Metabolism.Energy := Owner.Metabolism.Energy - HIGHT_SPENDING;  //E&M
            Pregnancy := false;
          end;
    end;

  procedure TReproducerSys.Inseminate(aGenes: TGenes);
    begin
      if not Pregnancy and (Owner.Metabolism.HealthPercent > FertilityHealth)
        then EmbryoGenoma := Owner.Genes.CombineGenes(aGenes);
    end;

  procedure TReproducerSys.MakeSex;
    begin
      Fertilize;
    end;

  procedure TReproducerSys.Performance;
    begin
      if Pregnancy
        then
          if PregnancyTime = IncubationTime
            then SPawn
            else inc(PregnancyTime);
      if Owner.Metabolism.LibidoPercent > Owner.Genes.RipeLibido
        then
          if Owner.Metabolism.HealthPercent > Owner.Genes.FirstHealthLibidoPoint
            then MakeSex
            else
              if Owner.Metabolism.HealthPercent > Owner.Genes.SecondHealthLibidoPoint
                then Bipartition
                else Budding;
    end;

  procedure TReproducerSys.SetIncubationTime(const Value: integer);
    begin
      FIncubationTime := Value;
    end;

  procedure TReproducerSys.SetFertilityHealth(const Value: integer);
    begin
      FFertilityHealth := Value;
    end;

  procedure TReproducerSys.SetPregnancy(const Value: boolean);
    begin
      FPregnancy := Value;
    end;

  procedure TReproducerSys.SetEmbryoGenoma(const Value: TGenes);
    begin
      FEmbryoGenoma := Value;
      PregnancyTime := 0;
      Pregnancy := true;
    end;

  procedure TReproducerSys.SetLibidoAfterSex(const Value: longint);
    begin
      FLibidoAfterSex := Value;
    end;

{ TDigestiveSys }

  function TDigestiveSys.CanEat: boolean;
    begin
      Result := Owner.World.QuarryAt(Owner.Head.Left, Owner.Head.Top) <> nil;
    end;

  constructor TDigestiveSys.Create(aOwner: TACreature);
    begin
      inherited Create;
      Owner := aOwner;
      FBiteSize := Owner.Genes.StartBiteSize;
      FStomachCapacity := Owner.Genes.StomachCapacity;
      FDrainCapacity := Owner.Genes.DrainCapacity;
      FPoisonousCapacity := Owner.Genes.PoisonousCapacity;
    end;

  function TDigestiveSys.Bite: boolean;
    var
      Quarry: TQuarry;
    begin
      Quarry := Owner.World.QuarryAt(Owner.Head.Left, Owner.Head.Top);
      if Quarry <> nil
        then
          begin
            Quarry.Capacity := Quarry.Capacity - BiteSize;
            StomachCapacity := StomachCapacity + BiteSize * Quarry.Composition.Nutritious div 100;
            DrainCapacity   := DrainCapacity + BiteSize * Quarry.Composition.Innocuous div 100;
            PoisonousCapacity := PoisonousCapacity + BiteSize * Quarry.Composition.Toxic div 100;
            Result := true;
          end
        else Result := False;
    end;

  procedure TDigestiveSys.SetBiteSize(const Value: integer);
    begin
      FBiteSize := Value;
    end;

  procedure TDigestiveSys.SetStomachCapacity(const Value: integer);
    begin
      FStomachCapacity := Value;
    end;

  procedure TDigestiveSys.Performance;
    begin
      if Owner.Metabolism.HungerPercent > Owner.Genes.HungerToBite
        then Bite;
      if StomachCapacity > LOW_SPENDING
        then
          begin
            StomachCapacity := StomachCapacity - LOW_SPENDING;   //E&M
            Owner.Metabolism.Energy := Owner.Metabolism.Energy + LOW_SPENDING * CALORIC_RATE;
          end;
      if PoisonousCapacity > LOW_SPENDING
        then
          begin
            PoisonousCapacity := PoisonousCapacity - LOW_SPENDING;
            Owner.Metabolism.Health := Owner.Metabolism.Health - HIGHT_SPENDING;
          end;
    end;

  procedure TDigestiveSys.SetDrainCapacity(const Value: integer);
    begin
      FDrainCapacity := Value;
    end;

  procedure TDigestiveSys.SetPoisonousCapacity(const Value: integer);
    begin
      FPoisonousCapacity := Value;
    end;

{ TNervousSys }

  constructor TNervousSys.Create(aOwner: TACreature);
    begin
      inherited Create;
      Owner := aOwner;
    end;

  procedure TNervousSys.Performance;
    begin
      //  thinking process
    end;

{ TYellowQuarry }

  constructor TYellowQuarry.Create(const X, Y, W, H, aStartCap: longint;  aWorld: TSimWorld; anImage: TMosaic = nil);
    begin
      inherited;
      SetImage(YELLOW_5);
      FQuarryType := YELLOW;
      with Composition do
        begin
          Nutritious := 70;
          Toxic      := 30;
        end;
    end;

{ TRedQuarry }

  constructor TRedQuarry.Create(const X, Y, W, H, aStartCap: longint;  aWorld: TSimWorld; anImage: TMosaic = nil);
    begin
      inherited;
      SetImage(RED_5);
      FQuarryType := RED;
      with Composition do
        begin
          Nutritious := 90;
          Innocuous  := 10;
          Toxic      := 0;
        end;
    end;

{ TGreenQuarry }

  constructor TGreenQuarry.Create(const X, Y, W, H, aStartCap: longint;  aWorld: TSimWorld; anImage: TMosaic = nil);
    begin
      inherited;
      SetImage(GREEN_5);
      FQuarryType := GREEN;
      with Composition do
        begin
          Nutritious := 80;
          Innocuous  := 15;
          Toxic      := 5;
        end;
    end;

{ TBlueQuarry }

  constructor TBlueQuarry.Create(const X, Y, W, H, aStartCap: longint;  aWorld: TSimWorld; anImage: TMosaic = nil);
    begin
      inherited;
      SetImage(BLUE_5);
      FQuarryType := BLUE;
      with Composition do
        begin
          Nutritious := 50;
          Innocuous  := 45;
          Toxic      := 5;
        end;
    end;

{ TImmunologicalSys }

  constructor TImmunologicalSys.Create(aOwner: TACreature);
    begin
      inherited Create;
      Owner := aOwner;
      FImmunologicalStrength := Owner.Genes.StartImmunologicalStrength;
    end;

  procedure TImmunologicalSys.Performance;
    begin
      with Owner.Metabolism do
        begin
          if HealthPercent < 100
            then
              if HealthPercent > Owner.Genes.FirstRecoverPoint
                then Recover(Owner.Genes.FirstRecoverAmount)
                else
                  if EnergyPercent > Owner.Genes.SecondRecoverPoint
                    then Recover(Owner.Genes.SecondRecoverAmount)
                    else Recover(Owner.Genes.ThirdRecoverAmount);
        end;
    end;

  procedure TImmunologicalSys.Recover(const Rate: longint);
    begin
      if Owner.Metabolism.Energy > Rate
        then
          with Owner.Metabolism do
            begin
              Health := Health + Rate * ImmunologicalStrength;
              Energy := Energy - Rate;
            end;
    end;

  procedure TImmunologicalSys.SetImmunologicalStrength(const Value: integer);
    begin
      FImmunologicalStrength := Value;
    end;

{ TGrowthSys }

  constructor TGrowthSys.Create(aOwner: TACreature);
    begin
      inherited Create;
      Owner := aOwner;
    end;

  procedure TGrowthSys.Performance;
    begin
      if (Owner.Metabolism.TimeLived mod Owner.Genes.FattenRate = 0)
        and (Owner.Metabolism.HealthPercent > Owner.Genes.HealthFatten)
        then Owner.BodyWidth := Owner.BodyWidth + Owner.Genes.FattenAmount;
      if (Owner.Metabolism.TimeLived mod Owner.Genes.GrowthRate = 0)
        and (Owner.Metabolism.HealthPercent > Owner.Genes.HealthGrowth)
        then Owner.AddSegment;
    end;

{ TGenes }

  function TGenes.CombineGenes(aGenes: TGenes): TGenes;
    var
      i: integer;
      OrgOrdVal: longint;
      OrgFloatVal: single;
    begin
      Result := TGenes.Create;
      for i := 0 to pred(GenesCount) do
        if TypeValue[i] = tvInteger
          then
            begin
              if Random(2) = 0
                then OrgOrdVal := aGenes.IntValue[i]
                else OrgOrdVal := IntValue[i];
              Result.IntValue[i] := MutateOrd(OrgOrdVal);
            end
          else
            begin
              if Random(2) = 0
                then OrgFloatVal := aGenes.FloatValue[i]
                else OrgFloatVal := FloatValue[i];
              Result.FloatValue[i] := MutateFlt(OrgFloatVal);
            end;
    end;

  const
    SignMutate: array[0..1] of integer = (-1, 1);

  function TGenes.MutateFlt(const BaseGen: single): single;
    var
      FltValue: single;
    begin
      if Random(MutateRate) = 0
        then FltValue := BaseGen + (DeltaOrdMutate + Random) * SignMutate[Random(2)]
        else FltValue := BaseGen;
      Result := FltValue;
    end;

  function TGenes.MutateOrd(const BaseGen: longint): longint;
    var
      OrdValue: longint;
    begin
      if Random(MutateRate) = 0
        then OrdValue := BaseGen + Random(DeltaOrdMutate) * SignMutate[Random(2)]
        else OrdValue := BaseGen;
      Result := OrdValue;
    end;

  function TGenes.CopyGenes: TGenes;
    var
      i: integer;
    begin
      Result := TGenes.Create;
      for i := 0 to pred(GenesCount) do
        if TypeValue[i] = tvInteger
          then Result.IntValue[i] := MutateOrd(IntValue[i])
          else Result.FloatValue[i] := MutateFlt(FloatValue[i]);
    end;

  function TGenes.GetFloatValue(const index: integer): single;
    var
      PropInfo: PPropInfo;
    begin
      Result := 0;
      if GenesCount > 0
        then
          begin
            PropInfo := PropList^[index];
            if PropInfo^.PropType^.Kind = tkFloat
              then Result := GetFloatProp(Self, PropInfo);
          end;
    end;

  function TGenes.GetGenesCount: integer;
    begin
      Result := GetTypeData(ClassInfo)^.PropCount;
    end;

  function TGenes.GetIntValue(const index: integer): longint;
    var
      PropInfo: PPropInfo;
    begin
      Result := 0;
      if GenesCount > 0
        then
          begin
            PropInfo := PropList^[index];
            if PropInfo^.PropType^.Kind = tkInteger
              then Result := GetOrdProp(Self, PropInfo);
          end;
    end;

  function TGenes.GetTypeValue(const index: integer): TTypeValue;
    var
      PropInfo: PPropInfo;
    begin
      Result := tvUnknown;
      if GenesCount > 0
        then
          begin
            PropInfo := PropList^[index];
            if PropInfo^.PropType^.Kind = tkInteger
              then Result := tvInteger
              else
                if PropInfo^.PropType^.Kind = tkFloat
                  then Result := tvFloat;
          end;
    end;

  procedure TGenes.SetDeltaOrdMutate(const Value: Integer);
    begin
      if Value > 0
        then FDeltaOrdMutate := Value;
    end;

  procedure TGenes.SetFloatValue(const index: integer; const Value: single);
    var
      PropInfo: PPropInfo;
    begin
      if GenesCount > 0
        then
          begin
            PropInfo := PropList^[index];
            if PropInfo^.PropType^.Kind = tkFloat
              then SetFloatProp(Self, PropInfo, Value);
          end;
    end;

  procedure TGenes.SetIntValue(const index: integer; const Value: longint);
    var
      PropInfo: PPropInfo;
    begin
      if GenesCount > 0
        then
          begin
            PropInfo := PropList^[index];
            if PropInfo^.PropType^.Kind = tkInteger
              then SetOrdProp(Self, PropInfo, Value);
          end;
    end;

  procedure TGenes.SetMutateRate(const Value: Integer);
    begin
      if Value > 0
        then FMutateRate := Value;
    end;

  constructor TGenes.Create;
    begin
      inherited;
      GetMem(PropList, GenesCount * SizeOf(Pointer));
      GetPropInfos(ClassInfo, PropList);
    end;

  destructor TGenes.Destroy;
    begin
      FreeMem(PropList, GenesCount * SizeOf(Pointer));
      inherited;
    end;

  procedure TGenes.SetDeltaFltMutate(const Value: single);
    begin
      if Value > 0
        then FDeltaFltMutate := Value;
    end;

  procedure TGenes.SetAbortAngle(const Value: single);
    begin
      FAbortAngle := Value;
    end;

  procedure TGenes.SetBeginStamping(const Value: longint);
    begin
      FBeginStamping := Value;
    end;

  procedure TGenes.SetDeflectAngle(const Value: single);
    begin
      FDeflectAngle := Value;
    end;

  procedure TGenes.SetDrainCapacity(const Value: longint);
    begin
      FDrainCapacity := Value;
    end;

  procedure TGenes.SetEndStamping(const Value: longint);
    begin
      FEndStamping := Value;
    end;

  procedure TGenes.SetFattenAmount(const Value: longint);
    begin
      FFattenAmount := Value;
    end;

  procedure TGenes.SetFattenRate(const Value: longint);
    begin
      FFattenRate := Value;
    end;

  procedure TGenes.SetFirstHealthLibidoPoint(const Value: longint);
    begin
      FFirstHealthLibidoPoint := Value;
    end;

  procedure TGenes.SetFirstHealthSlope(const Value: longint);
    begin
      FFirstHealthSlope := Value;
    end;

  procedure TGenes.SetFirstHungerSlope(const Value: longint);
    begin
      FFirstHungerSlope := Value;
    end;

  procedure TGenes.SetFirstLibidoSlope(const Value: longint);
    begin
      FFirstLibidoSlope := Value;
    end;

  procedure TGenes.SetFirstRecoverAmount(const Value: longint);
    begin
      FFirstRecoverAmount := Value;
    end;

  procedure TGenes.SetFirstRecoverPoint(const Value: longint);
    begin
      FFirstRecoverPoint := Value;
    end;

  procedure TGenes.SetFourthHungerSlope(const Value: longint);
    begin
      FFourthHungerSlope := Value;
    end;

  procedure TGenes.SetGrowthRate(const Value: longint);
    begin
      FGrowthRate := Value;
    end;

  procedure TGenes.SetHealthFatten(const Value: longint);
    begin
      FHealthFatten := Value;
    end;

  procedure TGenes.SetHealthGrowth(const Value: longint);
    begin
      FHealthGrowth := Value;
    end;

  procedure TGenes.SetHungerToBite(const Value: longint);
    begin
      FHungerToBite := Value;
    end;

  procedure TGenes.SetIntersectRatio(const Value: single);
    begin
      FIntersectRatio := Value;
    end;

  procedure TGenes.SetLibidoAfterBipartition(const Value: longint);
    begin
      FLibidoAfterBipartition := Value;
    end;

  procedure TGenes.SetLibidoAfterBudding(const Value: longint);
    begin
      FLibidoAfterBudding := Value;
    end;

  procedure TGenes.SetLongStep(const Value: longint);
    begin
      FLongStep := Value;
    end;

  procedure TGenes.SetPartitionRate(const Value: longint);
    begin
      FPartitionRate := Value;
    end;

  procedure TGenes.SetPoisonousCapacity(const Value: longint);
    begin
      FPoisonousCapacity := Value;
    end;

  procedure TGenes.SetReliefIntersectRatio(const Value: single);
    begin
      FReliefIntersectRatio := Value;
    end;

  procedure TGenes.SetRestRatio(const Value: longint);
    begin
      FRestRatio := Value;
    end;

  procedure TGenes.SetRipeLibido(const Value: longint);
    begin
      FRipeLibido := Value;
    end;

  procedure TGenes.SetSecondHealthLibidoPoint(const Value: longint);
    begin
      FSecondHealthLibidoPoint := Value;
    end;

  procedure TGenes.SetSecondHealthSlope(const Value: longint);
    begin
      FSecondHealthSlope := Value;
    end;

  procedure TGenes.SetSecondHungerSlope(const Value: longint);
    begin
      FSecondHungerSlope := Value;
    end;

  procedure TGenes.SetSecondLibidoSlope(const Value: longint);
    begin
      FSecondLibidoSlope := Value;
    end;

  procedure TGenes.SetSecondRecoverAmount(const Value: longint);
    begin
      FSecondRecoverAmount := Value;
    end;

  procedure TGenes.SetSecondRecoverPoint(const Value: longint);
    begin
      FSecondRecoverPoint := Value;
    end;

  procedure TGenes.SetStartBiteSize(const Value: longint);
    begin
      FStartBiteSize := Value;
    end;

  procedure TGenes.SetStartBodyWidth(const Value: longint);
    begin
      FStartBodyWidth := Value;
    end;

  procedure TGenes.SetStartImmunologicalStrength(const Value: longint);
    begin
      FStartImmunologicalStrength := Value;
    end;

  procedure TGenes.SetStomachCapacity(const Value: longint);
    begin
      FStomachCapacity := Value;
    end;

  procedure TGenes.SetThirdHealthSlope(const Value: longint);
    begin
      FThirdHealthSlope := Value;
    end;

  procedure TGenes.SetThirdHungerSlope(const Value: longint);
    begin
      FThirdHungerSlope := Value;
    end;

  procedure TGenes.SetThirdLibidoSlope(const Value: longint);
    begin
      FThirdLibidoSlope := Value;
    end;

  procedure TGenes.SetThirdRecoverAmount(const Value: longint);
    begin
      FThirdRecoverAmount := Value;
    end;

  procedure TGenes.SetTurnRatio(const Value: longint);
    begin
      FTurnRatio := Value;
    end;

  procedure TGenes.SetWalkRatio(const Value: longint);
    begin
      FWalkRatio := Value;
    end;

  constructor TGenes.DefaultGenes;
    begin
      inherited Create;
      GetMem(PropList, GenesCount * SizeOf(Pointer));
      GetPropInfos(ClassInfo, PropList);
        // Genetic System
      MutateRate                  := 10;
      DeltaOrdMutate              := 5;
      DeltaFltMutate              := 0.1;
        // Motor System
      DeflectAngle                := 0.1;
      AbortAngle                  := 1.5;
      IntersectRatio              := 0.2;
      ReliefIntersectRatio        := 1;
      LongStep                    := 3;
      EndStamping                 := 10;
      BeginStamping               := 5;
      TurnRatio                   := 50;
      WalkRatio                   := 1;
      RestRatio                   := 20;
        // Metabolism
      FirstHealthSlope            := 70;
      SecondHealthSlope           := 50;
      ThirdHealthSlope            := 35;
      FirstHungerSlope            := 97;
      SecondHungerSlope           := 94;
      ThirdHungerSlope            := 89;
      FourthHungerSlope           := 60;
      FirstLibidoSlope            := 80;
      SecondLibidoSlope           := 70;
      ThirdLibidoSlope            := 60;
        // Reproducer System
      PartitionRate               := 2;
      LibidoAfterBipartition      := 0;
      LibidoAfterBudding          := 0;
      RipeLibido                  := 70;
      FirstHealthLibidoPoint      := 50;
      SecondHealthLibidoPoint     := 40;
      FertilityHealth             := 50;
      IncubationTime              := 10;
        // Digestive System
      StartBiteSize               := 5;
      HungerToBite                := 10;
      StomachCapacity             := 40;
      DrainCapacity               := 30;
      PoisonousCapacity           := 20;
        // Immunological System
      StartImmunologicalStrength  := 1;
      FirstRecoverPoint           := 80;
      FirstRecoverAmount          := 10;
      SecondRecoverPoint          := 60;
      SecondRecoverAmount         := 100;
      ThirdRecoverAmount          := 10;
        // Growth System
      StartBodyWidth              := 10;
      FattenRate                  := 200000;
      HealthFatten                := 50;
      FattenAmount                := 1;
      GrowthRate                  := 100000;
      HealthGrowth                := 70;
    end;

  function TGenes.GetGenName(const index: integer): ShortString;
    begin
      if GenesCount > 0
        then Result := PropList^[index].Name
        else Result := '';
    end;

  procedure TGenes.SetFertilityHealth(const Value: longint);
    begin
      FFertilityHealth := Value;
    end;

  procedure TGenes.SetIncubationTime(const Value: longint);
    begin
      FIncubationTime := Value;
    end;

end.