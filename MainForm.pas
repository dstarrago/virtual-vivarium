unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SimWorld, ComCtrls, Gauges, Buttons, Menus, SimTools, ExtCtrls,
  WorldInspector, ImgList;

type
  TObservatory =
    class(TForm)
        MainMenu1: TMainMenu;
        File1: TMenuItem;
        View1: TMenuItem;
        Speed1: TMenuItem;
        Tools1: TMenuItem;
        Insert1: TMenuItem;
        Open1: TMenuItem;
        Save1: TMenuItem;
        Saveas1: TMenuItem;
        N1: TMenuItem;
        Exit1: TMenuItem;
        Import1: TMenuItem;
        ExportTo1: TMenuItem;
        N2: TMenuItem;
        Metabolism1: TMenuItem;
        FoodMenu: TMenuItem;
        CreatureMenu: TMenuItem;
        Hight1: TMenuItem;
        Meed1: TMenuItem;
        Low1: TMenuItem;
        Custom1: TMenuItem;
        N3: TMenuItem;
        Pause1: TMenuItem;
        Step1: TMenuItem;
        Creature1: TCreature;
        Creature2: TCreature;
        Creature3: TCreature;
        Creature4: TCreature;
        Wall1: TWall;
        Wall2: TWall;
        Wall3: TWall;
        Wall4: TWall;
        Substratum1: TSubstratum;
        Substratum2: TSubstratum;
        Substratum3: TSubstratum;
        SaveDialog1: TSaveDialog;
    Images: TImageList;
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure Exit1Click(Sender: TObject);
        procedure Pause1Click(Sender: TObject);
        procedure Metabolism1Click(Sender: TObject);
        procedure Step1Click(Sender: TObject);
        procedure Hight1Click(Sender: TObject);
        procedure Meed1Click(Sender: TObject);
        procedure Low1Click(Sender: TObject);
        procedure Custom1Click(Sender: TObject);
      protected
        procedure WndProc(var Message: TMessage); override;
      private
        procedure ACreatureClick(Sender: TObject);
        procedure OnNewCreature(Sender: TObject);
        procedure OnLostCreature(Sender: TObject);
      public
        Sim: TSimWorld;
        procedure RegisterMap;
    end;

var
  Observatory: TObservatory;

implementation

 uses WorldSpeed;

{$R *.DFM}

  procedure TObservatory.FormCreate(Sender: TObject);
    begin
      Sim := TSimWorld.Create(Self, Images);
      with Sim do
        begin
          BGColor            := clGreen;
          OnACreatureClick  := ACreatureClick;
          OnNewACreature    := OnNewCreature;
          OnLostACreature   := OnLostCreature;
        end;
      RegisterMap;
      {
      Sim.AddBrick(0, 0, ClientWidth - 1, 20);
      Sim.AddBrick(0, ClientHeight - 21, ClientWidth - 1, 20);
      Sim.AddBrick(0, 21, 20, ClientHeight - 40);
      Sim.AddBrick(ClientWidth - 21, 21, 20, ClientHeight - 40);
      Sim.AddBrick(100, 80, 160, 20);
      Sim.AddBrick(200, 100, 20, 100);
      Sim.AddBrick(400, 200, 20, 60);
      Sim.AddBrick(350, 260, 140, 20);
      Sim.AddQuarry(TRedQuarry, 80, 140, 100, 180, QUARRY_BASE_CAPACITY);
      Sim.AddQuarry(TGreenQuarry, 140, 100, 60, 100, QUARRY_BASE_CAPACITY);
      Sim.AddQuarry(TBlueQuarry, 370, 20, 140, 80, QUARRY_BASE_CAPACITY);
      Sim.AddQuarry(TYellowQuarry, 420, 175, 80, 80, QUARRY_BASE_CAPACITY);
      Sim.AddQuarry(TYellowQuarry, 240, 120, 100, 180, QUARRY_BASE_CAPACITY);
      Sim.AddACreature('Cuca', 300, 200);
      Sim.AddACreature('Ana', 200, 200);
      Sim.AddACreature('Mary', 450, 150);
      Sim.AddACreature('Albert', 330, 180);
      Sim.AddACreature('Danel', 230, 120);
      Sim.AddACreature('Leandro', 280, 130);
      }
      //Sim.AddACreature('Adan', 220, 140);
    end;

  procedure TObservatory.FormDestroy(Sender: TObject);
    begin
      Sim.free;
    end;

  procedure TObservatory.WndProc(var Message: TMessage);
    begin
      if not Application.Terminated
        then
          begin
            if (Message.Msg = WM_Move) and (Inspector <> nil)
              then
                begin
                  Inspector.Left := Left;
                  Inspector.Top  := Top + Height;
                end;
            inherited WndProc(Message);
          end;
    end;

  procedure TObservatory.ACreatureClick(Sender: TObject);
    begin
      Inspector.SelectCreature(Sender as TACreature);
    end;

  procedure TObservatory.Exit1Click(Sender: TObject);
    begin
      Close;
    end;

  procedure TObservatory.Pause1Click(Sender: TObject);
    begin
      if Pause1.Tag = 0
        then
          begin
            Pause1.Caption := 'Resume';
            Pause1.Tag := 1;
            Sim.Stop;
          end
        else
          begin
            Pause1.Caption := 'Pause';
            Pause1.Tag := 0;
            Sim.Resume;
          end;
    end;

  procedure TObservatory.Metabolism1Click(Sender: TObject);
    begin
      with Inspector do
        begin
          Left := Self.Left;
          Top  := Self.Top + Self.Height;
          Show;
        end;
    end;

  procedure TObservatory.Step1Click(Sender: TObject);
    begin
      if Pause1.Tag = 0
        then
          begin
            Pause1.Caption := 'Resume';
            Pause1.Tag := 1;
            Sim.Stop;
          end;
      Sim.Trace;
    end;

  procedure TObservatory.OnNewCreature(Sender: TObject);
    begin
      if Inspector <> nil
        then Inspector.AddCreature(Sender as TACreature);
    end;

  procedure TObservatory.OnLostCreature(Sender: TObject);
    begin
      if Inspector <> nil
        then Inspector.RemoveCreature(Sender as TACreature);
    end;

  procedure TObservatory.RegisterMap;
    var
      i: integer;
    begin
      for i := 0 to pred(ControlCount) do
        Sim.AddObject(Controls[i]);
    end;


  procedure TObservatory.Hight1Click(Sender: TObject);
    begin
      Sim.TimeSpeed := TIME_SPEED_HIGHT;
      Hight1.Checked := true;
    end;

  procedure TObservatory.Meed1Click(Sender: TObject);
    begin
      Sim.TimeSpeed := TIME_SPEED_MID;
      Meed1.Checked := true;
    end;

  procedure TObservatory.Low1Click(Sender: TObject);
    begin
      Sim.TimeSpeed := TIME_SPEED_LOW;
      Low1.Checked := true;
    end;

  procedure TObservatory.Custom1Click(Sender: TObject);
    begin
      if TimeSpeed.ShowModal = mrOk
        then Sim.TimeSpeed := TimeSpeed.SpinEdit1.Value;
      Custom1.Checked := true;
    end;

  end.
