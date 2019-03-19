program CyberLife;

uses
  Forms,
  SimWorld in 'SimWorld.pas',
  WorldInspector in 'WorldInspector.pas' {Inspector},
  WorldSpeed in 'WorldSpeed.pas' {TimeSpeed},
  Constants in 'Constants.pas',
  MainForm in 'MainForm.pas' {Observatory},
  SimTools in 'SimTools.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'CyberLife';
  Application.CreateForm(TObservatory, Observatory);
  Application.CreateForm(TInspector, Inspector);
  Application.CreateForm(TTimeSpeed, TimeSpeed);
  Application.Run;
end.
