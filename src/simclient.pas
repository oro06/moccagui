unit simclient;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type

  { TSimClientForm }

  TSimClientForm = class(TForm)
    Panel: TPanel;
    sbH: TScrollBar;
    sbV: TScrollBar;
    procedure BevelResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbHChange(Sender: TObject);
    procedure sbVChange(Sender: TObject);
  public
    procedure LoadPreview(FileName: string);
    procedure Update;
  end;
  
var
  clSim: TSimClientForm;

implementation

uses
  mocjoints,emc2pas,
  mocglb, glView,glList,glCanon;

const
  LINE_LEN = 256;
  
var
  E: TExtents;

procedure TSimClientForm.LoadPreview(FileName: string);
var
  Error: integer;
begin
  if (not Assigned(MyGlList)) or (not Assigned(MyGlView)) then
    Exit;
  Error:= ParseGCode(FileName,True);
  //if (Error >= INTP_OK) and (Error < INTP_FILE_NOT_OPEN) then
  //  begin
      //Label1.Caption:= MyGlList.GetInfo;
       MyGlView.UpdateView;
       MyGlView.Invalidate;
       MyGlView.GetLimits(E)
 //   end;
end;

procedure TSimClientForm.Update;
var
  ix,iy,iz: integer;
  X,Y,Z: double;
begin
  if Assigned(Joints) then
    if Assigned(MyGlView) then
      begin
        ix:= Joints.AxisByChar('X');
        iy:= Joints.AxisByChar('Y');
        iz:= Joints.AxisByChar('Z');
        if ix >= 0 then X:= GetRelPos(ix) else Exit;
        if iy >= 0 then Y:= GetRelPos(iy) else Exit;
        if iz >= 0 then Z:= GetRelPos(iz) else Exit;
        MyGlView.MoveCone(x,y,z);
      end;
end;

procedure TSimClientForm.sbHChange(Sender: TObject);
begin
  MyGlView.RotateZ(sbH.Position);
end;

procedure TSimClientForm.sbVChange(Sender: TObject);
begin
  MyGlView.RotateX(sbV.Position);
end;

procedure TSimClientForm.FormCreate(Sender: TObject);
begin
  E.MinX:= 0; E.MaxX:= 10;
  E.MinY:= 0; E.MaxY:= 10;
  E.MinZ:= 0; E.MaxZ:= 10;
  if not Assigned(MyGlList) then
    MyGlList:= TGlList.Create;
  if not Assigned(MyGlView) then
    MyGlView:= TGlView.Create(Self,Self);
  MyGlView.SetMachineLimits(E);
end;

procedure TSimClientForm.BevelResize(Sender: TObject);
begin
  if Assigned(MyGlView) then
    MyGlView.SetBounds(1,1,Panel.Width - 2,Panel.Height - 2);
end;

procedure TSimClientForm.FormDestroy(Sender: TObject);
begin
  if Assigned(MyGlView) then
    MyGlView.Free;
  if Assigned(MyGlList) then
    MyGlList.Free;
end;

initialization
  {$I simclient.lrs}

end.

