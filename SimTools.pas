unit SimTools;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TMosaic =
    class(TPaintBox)
      private
        FTile: boolean;
        FPicture: TPicture;
        FPictureName: string;
        procedure SetTile(const Value: boolean);
        procedure SetPicture(const Value: TPicture);
        procedure SetPictureName(const Value: string);
      protected
        procedure Paint; override;
      public
        constructor Create(AOwner: TComponent);  override;
        destructor Destroy;  override;
      published
        property Tile: boolean read FTile write SetTile;
        property Picture: TPicture read FPicture write SetPicture;
        property PictureName: string read FPictureName write SetPictureName;
    end;

  TWall =
    class(TMosaic)
      public
        constructor Create(AOwner: TComponent);  override;
    end;

  SubstratumKind = (skRed, skGreen, skBlue, skYellow);
  TSubstratum =
    class(TMosaic)
      private
        FKind: SubstratumKind;
        FCapacity: longint;
        procedure SetKind(const Value: SubstratumKind);
        procedure SetCapacity(const Value: longint);
      public
        constructor Create(AOwner: TComponent);  override;
      published
        property Kind: SubstratumKind read FKind write SetKind;
        property Capacity: longint read FCapacity write SetCapacity;
    end;

  TCreature =
    class(TMosaic)
      public
        constructor Create(AOwner: TComponent);  override;
    end;

  procedure Register;

implementation

  procedure Register;
    begin
      RegisterComponents('SimWorld', [TMosaic, TWall, TSubstratum, TCreature]);
    end;

{ TMosaic }

  constructor TMosaic.Create(AOwner: TComponent);
    begin
      inherited;
      Picture := TPicture.Create;
      Width := 20;
      Height := 20;
    end;

  destructor TMosaic.Destroy;
    begin
      Picture.free;
      inherited;
    end;

  procedure TMosaic.Paint;
    var
      i,j: integer;
    begin
      if Picture.Graphic <> nil
        then
          if Tile
            then
              begin
                j := 0;
                repeat
                  i := 0;
                  repeat
                    with inherited Canvas do
                      Draw(i,j, Picture.Graphic);
                    i := i + Picture.Width;
                  until i > Width;
                  j := j + Picture.Height;
                until j > Height;
              end
            else
              with inherited Canvas do
                StretchDraw(ClientRect, Picture.Graphic);
    end;

  procedure TMosaic.SetPicture(const Value: TPicture);
    begin
      FPicture := Value;
    end;

  procedure TMosaic.SetPictureName(const Value: string);
    begin
      if Value <> FPictureName
        then
          begin
            FPictureName := Value;
            Picture.LoadFromFile(FPictureName);
            Invalidate;
          end;
      if Picture.Graphic <> nil
        then Picture.Graphic.Transparent := true;
    end;

  procedure TMosaic.SetTile(const Value: boolean);
    begin
      if FTile <> Value
        then
          begin
            FTile := Value;
            Invalidate;
          end;
    end;

{ TWall }

  constructor TWall.Create(AOwner: TComponent);
    begin
      inherited;
      Tile := true;
      PictureName := 'Brick.bmp';
    end;

{ TSubstratum }

  constructor TSubstratum.Create(AOwner: TComponent);
    begin
      inherited;
      Kind := skYellow;
      FCapacity := 1000;
    end;

  procedure TSubstratum.SetCapacity(const Value: longint);
    begin
      FCapacity := Value;
    end;

  procedure TSubstratum.SetKind(const Value: SubstratumKind);
    begin
      FKind := Value;
      case Kind of
        skRed:    PictureName := 'Red5.bmp';
        skGreen:  PictureName := 'Green5.bmp';
        skBlue:   PictureName := 'Blue5.bmp';
        skYellow: PictureName := 'Yellow5.bmp';
      end;
    end;

{ TCreature }

  constructor TCreature.Create(AOwner: TComponent);
    begin
      inherited;
      PictureName := 'HeadRight.bmp';
      Width := 10;
      Height := 10;
    end;

end.
