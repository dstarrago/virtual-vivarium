unit WorldInspector;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, ComCtrls, SimWorld, StdCtrls, ExtCtrls, Gauges, Grids;

type
  TInspector =
    class(TForm)
      ListBox1: TListBox;
      Timer1: TTimer;
      PageControl1: TPageControl;
      General: TTabSheet;
      Metabolism: TTabSheet;
      Label1: TLabel;
      Label2: TLabel;
      Label3: TLabel;
      Label4: TLabel;
      Label5: TLabel;
      Panel4: TPanel;
      EnergyPB: TGauge;
      Panel5: TPanel;
      TimeLivedPB: TGauge;
      Panel6: TPanel;
      LibidoPB: TGauge;
      Panel7: TPanel;
      HungerPB: TGauge;
      Panel8: TPanel;
      HealthPB: TGauge;
      Others: TGroupBox;
      Panel2: TPanel;
      MaxLiveTime: TLabel;
      Panel3: TPanel;
      OldnessRate: TLabel;
      Panel9: TPanel;
      SegmentWidth: TLabel;
      Genetic: TTabSheet;
      Panel1: TPanel;
      Name: TLabel;
      Perception: TTabSheet;
      StringGrid1: TStringGrid;
      Panel10: TPanel;
      Panel11: TPanel;
      Panel12: TPanel;
      Splitter1: TSplitter;
      procedure FormShow(Sender: TObject);
      procedure Timer1Timer(Sender: TObject);
      procedure ListBox1Click(Sender: TObject);
      procedure Splitter1Moved(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    private
      selectedCreature: TACreature;
      procedure Clear;
      function GetACreature: TACreature;
      procedure UpDateCreature;
      procedure UpDateGeneInspector;
      procedure FormatStringGrid;
    public
      procedure AddCreature(aCreature: TACreature);
      procedure RemoveCreature(aCreature: TACreature);
      procedure SelectCreature(C: TACreature);
      procedure ResetList;
      procedure UpDateInspector;
      property  ACreature: TACreature read GetACreature;
    end;

var
  Inspector: TInspector;

implementation

{$R *.DFM}

  uses MainForm;

{ TInspector }

  procedure TInspector.ListBox1Click(Sender: TObject);
    begin
      selectedCreature := TACreature(ListBox1.Items.Objects[ListBox1.ItemIndex]);
      UpDateInspector;
    end;

  procedure TInspector.SelectCreature(C: TACreature);
    begin
      with ListBox1 do
        begin
          selectedCreature := C;
          ItemIndex := Items.IndexOfObject(C);
          if ItemIndex > 0
            then UpDateInspector;
        end;
    end;

  procedure TInspector.AddCreature(aCreature: TACreature);
    begin
      ListBox1.Items.AddObject(aCreature.Name, TACreature(aCreature));
      UpDateInspector;
    end;

  procedure TInspector.RemoveCreature(aCreature: TACreature);
    var
      delindex: Integer;
    begin
      delindex := ListBox1.Items.IndexOfObject(aCreature);
      if ListBox1.ItemIndex = delindex
        then ListBox1.ItemIndex := 0;
      ListBox1.Items.Delete(delindex);
      if ListBox1.Count > 0
        then selectedCreature := TACreature(ListBox1.Items.Objects[ListBox1.ItemIndex])
        else selectedCreature := nil;
      UpDateInspector;
    end;

  procedure TInspector.UpDateInspector;
    begin
      if (selectedCreature <> nil)
        then
          begin
            UpDateCreature;
            UpDateGeneInspector;
            FormatStringGrid;
          end
    end;

  procedure TInspector.UpDateCreature;
    begin
      Name.Caption := selectedCreature.Name;
      EnergyPB.Progress := selectedCreature.Metabolism.EnergyPercent;
      HealthPB.Progress := selectedCreature.Metabolism.HealthPercent;
      HungerPB.Progress := selectedCreature.Metabolism.HungerPercent;
      LibidoPB.Progress := selectedCreature.Metabolism.LibidoPercent;
      TimeLivedPB.Progress := selectedCreature.Metabolism.TimeLivedPercent;
      MaxLiveTime.Caption := IntToStr(selectedCreature.Metabolism.MaxLiveTime);
      OldnessRate.Caption := IntToStr(selectedCreature.Metabolism.OldnessRate);
      SegmentWidth.Caption := IntToStr(selectedCreature.BodyWidth);
    end;

  procedure TInspector.FormShow(Sender: TObject);
    begin
      UpDateInspector;
      FormatStringGrid;
    end;

  procedure TInspector.Timer1Timer(Sender: TObject);
    begin
      if not Observatory.Sim.updating
        then
          begin
            Observatory.Sim.updating := true;
            UpDateInspector;
            Observatory.Sim.updating := false;
          end;
    end;

  procedure TInspector.Clear;
    begin
      ListBox1.Items.Clear;
      EnergyPB.Progress := 0;
      HealthPB.Progress := 0;
      HungerPB.Progress := 0;
      LibidoPB.Progress := 0;
      TimeLivedPB.Progress := 0;
      MaxLiveTime.Caption := '';
      OldnessRate.Caption := '';
      Name.Caption := '';
      SegmentWidth.Caption := '';
    end;

  function TInspector.GetACreature: TACreature;
    begin
      with ListBox1 do
        if Items.Count = 0
          then Result := nil
          else
            begin
              if ItemIndex = -1
                then ItemIndex := 0;
              Result := TACreature(Items.Objects[ItemIndex]);
            end;
    end;

  procedure TInspector.ResetList;
    var
      i: integer;
    begin
      ListBox1.Items.Clear;
      for i := 0 to pred(Observatory.Sim.CreatureCount) do
        AddCreature(Observatory.Sim.Creature[i])
    end;

  procedure TInspector.UpDateGeneInspector;
    var
      i: integer;
    begin
      for i := 0 to pred(selectedCreature.Genes.GenesCount) do
        if selectedCreature.Genes.TypeValue[i] = tvInteger
          then StringGrid1.Cells[1, i] := IntToStr(selectedCreature.Genes.IntValue[i])
          else StringGrid1.Cells[1, i] := FloatToStrF(selectedCreature.Genes.FloatValue[i], ffGeneral, 4, 8);
    end;

  procedure TInspector.FormatStringGrid;
    var
      i: integer;
    begin
      if (selectedCreature <> nil)
        then
          begin
            StringGrid1.RowCount := selectedCreature.Genes.GenesCount;
            for i := 0 to pred(selectedCreature.Genes.GenesCount) do
              StringGrid1.Cells[0, i] := selectedCreature.Genes.GenName[i];
          end;
    end;

  procedure TInspector.Splitter1Moved(Sender: TObject);
    begin
      StringGrid1.ColWidths[0] := Panel11.Width;
    end;

  procedure TInspector.FormCreate(Sender: TObject);
    var
      aCreature: TACreature;
      i: integer;
    begin
      ListBox1.Items.Clear;
      for i := 0 to pred(Observatory.Sim.CreatureCount) do
        begin
          aCreature := Observatory.Sim.Creature[i];
          ListBox1.Items.AddObject(aCreature.Name, aCreature);
        end;
      UpDateInspector;
    end;

end.
