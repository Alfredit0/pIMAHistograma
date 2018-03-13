//Programa que muestra el histograma de una imagen
unit uImagen;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls,uVarios,uHistograma;

type

  { TfrmImagen }

  TfrmImagen = class(TForm)
    Image1: TImage;
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
  private
    { private declarations }
  public
    { public declarations }
    BM : TBitMap;
    Iancho, Ialto : integer;
    MTR, MRES : Mat3D;
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
  end;

end;

procedure TfrmImagen.FormCreate(Sender: TObject);
begin
  BM := TBitmap.Create;
  BA := TBitmap.Create;
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

end.

