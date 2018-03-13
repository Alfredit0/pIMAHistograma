//Programa que muestra el histograma de una imagen
unit uImagen;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls,uVarios,uHistograma,Math;

type

  { TfrmImagen }

  TfrmImagen = class(TForm)
    Image1: TImage;
    imgHisto: TImage;
    MainMenu1: TMainMenu;
    mnuHerrHistograma: TMenuItem;
    mnuHerramientas: TMenuItem;
    mnuArchivoSalir: TMenuItem;
    mnuArchivoGuardar: TMenuItem;
    mnuArchivoAbrir: TMenuItem;
    mnuArchivo: TMenuItem;
    OpenDialog1: TOpenDialog;
    ScrollBox1: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure mnuArchivoAbrirClick(Sender: TObject);
    procedure mnuArchivoSalirClick(Sender: TObject);
    procedure MImagen (B : TBitMap);
    procedure mnuHerrHistogramaClick(Sender: TObject);
    procedure PintaHisto();
  private
    { private declarations }
  public
    { public declarations }
    BM : TBitMap;
    Iancho, Ialto : integer;
    MTR, MRES : Mat3D;
    Han, Hal, nc, nr : integer;
    BH : TBitMap;
    MH : Mat3D;
    HH : ArrInt;
  end;

var
  frmImagen: TfrmImagen;

implementation

{$R *.lfm}

{ TfrmImagen }

//Sale del sistema
procedure TfrmImagen.mnuArchivoSalirClick(Sender: TObject);
begin
  Application.Terminate;
end;

//Abre archivo de imagen BMP
procedure TfrmImagen.mnuArchivoAbrirClick(Sender: TObject);
var
  nom : string;
begin
  if OpenDialog1.Execute then
  begin
    nom := OpenDialog1.FileName;
    BM.LoadFromFile(nom);  //Carga la imagen en el BitMap
    MImagen(BM);           //Muestra la imagen

    BA.Assign(frmImagen.Image1.Picture.Bitmap);

    BH.Assign(BA);  //El contenido de BA se asigna a BH
    nc := BH.Width; //Número de columnas
    nr := BH.Height;//Número de renglones
    BM_MAT(BH,MH);  //Pasa la imagen a un matriz
    PintaHisto();   //Pinta el histograma
  end;

end;

procedure TfrmImagen.FormCreate(Sender: TObject);
begin
  BM := TBitmap.Create;
  BA := TBitmap.Create;
    Han := imgHisto.Width;  //Ancho y alto de la ventana donde se
  Hal := imgHisto.Height; //graficara el histograma
  imgHisto.Canvas.Brush.Color := clWhite;
  imgHisto.Canvas.Rectangle(0,0,Han,Hal);  //Dibuja un rectángulo negro
  BH := TBitMap.Create; //Se crea el área de trabajo
end;

//Muestra el contenido del BitMap en el Image
procedure TfrmImagen.MImagen (B : TBitMap);
begin
   Image1.Picture.Assign(B); //Muestra la imagen
end;

//Se muesra la ventana del Histograma
procedure TfrmImagen.mnuHerrHistogramaClick(Sender: TObject);
begin
  BA.Assign(frmImagen.Image1.Picture.Bitmap);
  frmHistograma.Show;
end;

//Pinta el histograma
procedure TfrmImagen.PintaHisto();
var
  i,j,ind : integer;
  maxi     : array [0..3] of integer;
  fac      : real;
begin
  for i := 0 to 255 do  //limpia la matriz
  begin
     HH[0,i] := 0;
     HH[1,i] := 0;
     HH[2,i] := 0;
     HH[3,i] := 0;
  end;
  //obtiene la cantidad de cada color 0..255
  for i:= 0 to nc-1 do
    for j := 0 to nr-1 do
    begin
      ind := MH[i][j][0]; //Rojo
      inc(HH[0,ind]);
      ind := MH[i][j][1]; //Verde
      inc(HH[1,ind]);
      ind := MH[i][j][2]; //Azul
      inc(HH[2,ind]);
      ind :=  (MH[i][j][0] + MH[i][j][1] + MH[i][j][2]) div 3;
      inc(HH[3,ind]);     //Gris
    end;
  // pinta
  maxi[0] := 0;
  maxi[1] := 0;
  maxi[2] := 0;
//  maxi[3] := 0;
  {*if chkRojo.Checked then
  begin*}
    imgHisto.Canvas.Pen.Color := clRed;      //Rojo
    for i := 0 to 255 do
      maxi[0] := Max(HH[0,i], maxi[0]);
    fac := Hal / (maxi[0]+1);
    imgHisto.Canvas.MoveTo(0,Hal-round(fac*HH[0,0]));
    for i := 1 to 255 do

      imgHisto.Canvas.LineTo(round(i * Han/255), Hal-round(fac*HH[0,i]));
  //end;
  {*if chkVerde.Checked then
  begin*}
    imgHisto.Canvas.Pen.Color := clGreen;   //Verde
    for i := 0 to 255 do
      maxi[1] := Max(HH[1,i], maxi[1]);
    fac := Hal / (maxi[1]+1);
    imgHisto.Canvas.MoveTo(0,Hal-round(fac*HH[1,0]));
    for i := 1 to 255 do

      imgHisto.Canvas.LineTo(round(i * Han/255), Hal-round(fac*HH[1,i]));
  {*end;
  if chkAzul.Checked then
  begin*}
    imgHisto.Canvas.Pen.Color := clBlue;    //Azul
    for i := 0 to 255 do
      maxi[2] := Max(HH[2,i], maxi[2]);
    fac := Hal / (maxi[2]+1);
    imgHisto.Canvas.MoveTo(0,Hal-round(fac*HH[2,0]));
    for i := 1 to 255 do

      imgHisto.Canvas.LineTo(round(i * Han/255), Hal-round(fac*HH[2,i]));
{*  end;
  if chkGris.Checked then
  begin*}
    imgHisto.Canvas.Pen.Color := clWhite;    //Gris
    for i := 0 to 255 do
      maxi[3] := Max(HH[3,i], maxi[3]);
    fac := Hal / (maxi[3]+1);
    imgHisto.Canvas.MoveTo(0,Hal-round(fac*HH[3,0]));
    for i := 1 to 255 do

      imgHisto.Canvas.LineTo(round(i * Han/255), Hal-round(fac*HH[3,i]));
  {*end;*}
end;
end.

