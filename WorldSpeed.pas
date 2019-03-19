unit WorldSpeed;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Spin;

type
  TTimeSpeed = class(TForm)
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TimeSpeed: TTimeSpeed;

implementation

{$R *.DFM}

end.
