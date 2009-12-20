unit glview;

{$mode objfpc}{$H+}

interface

uses
  Classes, Controls, OpenGLContext, SysUtils,
  gllist,gl,glu;
  
type
  TGlView = class
    constructor Create(AParent,AOwner: TWinControl);
    destructor Destroy;
    procedure Paint(Sender: TObject);
    procedure Resize(Sender: TObject);
    procedure MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure MakeLimits;
    procedure MakeCoords;

    procedure MakeCone;
  private
    ogl: TOpenGlControl;
    AreaInitialized: Boolean;
    L, ML, CL: TExtents;  // L= limits  ML= machine limits  CL= gcode limits
    Aspect: double;
    Dist: double;
    ConeL: integer;
    LimitsL: integer;
    CoordsL: integer;
    ListL: integer;
  public
    RotationX: double;
    RotationY: double;
    RotationZ: double;
    PanX: double;
    PanY: double;
    PanZ: double;
    CenterX: double;
    CenterY: double;
    CenterZ: double;
    LimW: double;
    LimH: double;
    LimD: double;
    ConeX,ConeY,ConeZ: Double;
    procedure GetLimits(var E: TExtents);
    procedure SetMachineLimits(E: TExtents);
    procedure UpdateView;
    procedure Invalidate;
    procedure MakeList;
    procedure MoveCone;
    procedure SetBounds(X,Y,W,H: Integer);
    procedure Update;
  end;
  
var
  MyGlView: TGlView;

implementation

uses
 GlCanon;

constructor TGlView.Create(AParent,AOwner: TWinControl);
begin
  AreaInitialized:= False;
  Aspect:= 1;
  ogl:= TOpenGlControl.Create(AOwner);
  ogl.Parent:= AParent;
  ogl.SetBounds(0,0,500,500);
  ogl.OnPaint:= @self.Paint;
  ogl.OnResize:= @self.Resize;
  ogl.OnMouseWheel:= @self.MouseWheel;
end;

destructor TGlView.Destroy;
begin
  if Assigned(ogl) then ogl.Free;
  ogl:= nil;
end;

procedure TGlView.Update;
begin
  MoveCone;
  Paint(nil);
end;

procedure TGlView.MoveCone;
var
  x,y,z: Double;
begin
  x:= ToInternalUnits(ConeX);
  y:= ToInternalUnits(ConeY);
  z:= ToInternalUnits(ConeZ);
  glPushMatrix;
  glTranslatef(x,y,z);
  glCallList(ConeL);
  glPopMatrix;
end;

procedure TGlView.SetBounds(X,Y,W,H: Integer);
begin
  if Assigned(ogl) and (H > 0) then
    begin
      ogl.SetBounds(X,Y,W,H);
      Aspect:= W/H;
      AreaInitialized:= False;
    end;
end;

procedure TGlView.GetLimits(var E: TExtents);
begin
  E:= L;
end;

procedure TglView.Invalidate;
begin
  ogl.Invalidate;
end;

procedure TGlView.UpdateView;
begin
  with L do
    begin
      MinX:= 0; MaxX:= 0;
      MinY:= 0; MaxY:= 0;
      MinZ:= 0; MaxZ:= 0;
    end;
  if Assigned(MyGlList) then
    MyGlList.GetExtents(CL);

  if CL.MaxX > ML.MaxX then L.MaxX:= CL.MaxX else L.MaxX:= ML.MaxX;
  if CL.MinX < ML.MinX then L.MinX:= CL.MinX else L.MinX:= ML.MinX;
  if CL.MaxY > ML.MaxY then L.MaxY:= CL.MaxY else L.MaxY:= ML.MaxY;
  if CL.MinY < ML.MinY then L.MinY:= CL.MinY else L.MinY:= ML.MinY;
  if CL.MaxZ > ML.MaxZ then L.MaxZ:= CL.MaxZ else L.MaxZ:= ML.MaxZ;
  if CL.MinZ < ML.MinZ then L.MinZ:= CL.MinZ else L.MinZ:= ML.MinZ;

  limW:= (L.maxX - L.minX);
  limH:= (L.maxY - L.minY);
  limD:= (L.maxZ - L.minZ);

  centerx:= L.maxX - (limW / 2);
  centery:= L.maxY - (limH / 2);
  centerz:= L.maxZ - (limD / 2);

  PanX:= 0;
  PanY:= 0;
  PanZ:= 0;
  
  if limW < limH then
    Dist:= limH * 4
  else
    Dist:= limW * 4;

  AreaInitialized:= False;
  ogl.MakeCurrent;
  if Assigned(MyGlList) then
    MakeList;
  Invalidate;
end;

procedure TGlView.SetMachineLimits(E: TExtents);
begin
  ML:= E;
  UpdateView;
end;

procedure TGlView.MakeList;
var
  P: PListItem;
begin
  ListL:= glGenLists(4);
  glNewList(ListL, GL_COMPILE);
  if Assigned(MyGlList) then
    begin
      MyGlList.First;
      P:= MyGlList.Get;
      while (P <> nil) do
        begin
          glBegin(GL_LINES);
          if P^.ltype = ltFeed then
            glColor3f(1,1,1)
          else
          if P^.ltype = ltArcFeed then
            glColor3f(1,0,1)
          else
            glColor3f(0.2,0.2,0.3);
          glVertex3f(P^.l1.x,P^.l1.y,P^.l1.z);
          glVertex3f(P^.l2.x,P^.l2.y,P^.l2.z);
          glEnd;
          P:= MyGlList.Get;
        end;
    end;
  glEndList;
end;

procedure TGlView.Paint(sender: TObject);

const GLInitialized: boolean = false;

procedure InitGL;
begin
  if GLInitialized then Exit;
  GLInitialized:= True;
  glClearColor(0,0,0,1);
  glClearDepth(1.0);
  MakeCone;
  MakeCoords;
  MakeLimits;
  MakeList;
end;

begin
  if not ogl.MakeCurrent then Exit;
  if not AreaInitialized then
    begin
      InitGL;
      glMatrixMode (GL_PROJECTION);    { prepare for and then }
      glLoadIdentity;                  { define the projection }
      gluPerspective(45,Aspect,0.5,LimD * 100);
      glMatrixMode (GL_MODELVIEW);  { back to modelview matrix }
      glViewport (0,0,ogl.Width,ogl.Height); { define the viewport }
      AreaInitialized:=true;
    end;
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glLoadIdentity;             { clear the matrix }
  gluLookAt (0,0,Dist,0,0,0,0,1,0);
  glRotatef(RotationX,1.0,0.0,0.0);
  glRotatef(RotationY,0.0,1.0,0.0);
  glRotatef(RotationZ,0.0,0.0,1.0);
  glTranslatef(-centerx + PanX,-centery + PanY ,-centerz + PanZ);
  glCallList(CoordsL);
  glCallList(LimitsL);
  glCallList(ListL);
  MoveCone;
  ogl.SwapBuffers;
end;

procedure TGlView.MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if Assigned(ogl) then
    if Assigned(MyGlList) then
      begin
        if WheelDelta < 0 then
          Dist:= Dist / 1.2
        else
          Dist:= Dist * 1.2;
        Handled:= True;
        ogl.Invalidate;
      end;
end;

procedure TGlView.Resize(Sender: TObject);
begin
  if (AreaInitialized) and ogl.MakeCurrent then
    glViewport(0,0,ogl.Width,ogl.Height);
end;

procedure TGlView.MakeCone;
var
  q: PGLUquadric;
begin
  q := gluNewQuadric();
  ConeL:= glGenLists(1);
  glNewList(ConeL, GL_COMPILE);
  glColor3f(0,1,1);
  // gluPartialDisk(q, 1, 2, 12, 4, 0, 310);
  gluCylinder(q, 0,0.2,0.5,12,1);
  glEndList;
  gluDeleteQuadric(q);
end;

procedure TGlView.MakeCoords;
begin
  CoordsL:= glGenLists(2);
  glNewList(CoordsL, GL_COMPILE);
  glBegin(GL_LINES);
    glColor3f(1,0,0);
    glVertex3f(0,0,0);
    glVertex3f(10,0,0);
  glEnd;
  glBegin(GL_LINES);
    glColor3f(0,10,0);
    glVertex3f(0,0,0);
    glVertex3f(0,10,0);
  glEnd;
  glBegin(GL_LINES);
    glColor3f(0,0,10);
    glVertex3f(0,0,0);
    glVertex3f(0,0,10);
  glEnd;
  glEndList;
end;

procedure TGlView.MakeLimits;
const
  pattern = $5555;
begin
  //Stippling aktivieren
  LimitsL:= glGenLists(3);
  glNewList(LimitsL, GL_COMPILE);
  glEnable(GL_LINE_STIPPLE);
  glLineStipple(10, pattern);
  glBegin(GL_LINE_STRIP);
    glColor3f(0.7,0.1,0.1);
    glVertex3f(ML.minX,ML.minY,ML.minZ);
    glVertex3f(ML.maxX,ML.minY,ML.minZ);
    glVertex3f(ML.maxX,ML.maxY,ML.minZ);
    glVertex3f(ML.minX,ML.maxY,ML.minZ);
    glVertex3f(ML.minX,ML.minY,ML.minZ);
    glVertex3f(ML.minX,ML.minY,ML.maxZ);
    glVertex3f(ML.maxX,ML.minY,ML.maxZ);
    glVertex3f(ML.maxX,ML.maxY,ML.maxZ);
    glVertex3f(ML.minX,ML.maxY,ML.maxZ);
    glVertex3f(ML.minX,ML.minY,ML.maxZ);
    glVertex3f(ML.minX,ML.minY,ML.minZ);
  glEnd;
  glBegin(GL_LINES);
    glVertex3f(ML.minX,ML.maxY,ML.maxZ);
    glVertex3f(ML.minX,ML.maxY,ML.minZ);
    glVertex3f(ML.maxX,ML.maxY,ML.maxZ);
    glVertex3f(ML.maxX,ML.maxY,ML.minZ);
    glVertex3f(ML.maxX,ML.minY,ML.maxZ);
    glVertex3f(ML.maxX,ML.minY,ML.minZ);
  glEnd;
  glDisable(GL_LINE_STIPPLE);
  glEndList;
end;

end.

