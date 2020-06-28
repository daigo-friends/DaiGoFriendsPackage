unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.TabControl,
  FMX.WebBrowser, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef, Data.DbxSqlite, FireDAC.Phys,
  FireDAC.Phys.SQLite, Data.DB, Data.SqlExpr, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.FMXUI.Wait, FMX.Edit, System.IOUtils,
  DgfStringsHolder, DgfTableIniFile, FMX.ListBox, FMX.ScrollBox, FMX.Memo;

type
  THeaderFooterForm = class(TForm)
    Header: TToolBar;
    Footer: TToolBar;
    HeaderLabel: TLabel;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    ScrollBox1: TScrollBox;
    TabItem2: TTabItem;
    Layout1: TLayout;
    Button1: TButton;
    Layout2: TLayout;
    Button2: TButton;
    DgfTableIniFile1: TDgfTableIniFile;
    FDTable1: TFDTable;
    FDConnection1: TFDConnection;
    Label2: TLabel;
    txtSection1: TEdit;
    Label3: TLabel;
    txtKey1: TEdit;
    Label4: TLabel;
    txtValue1: TEdit;
    btnWriteString: TButton;
    Label5: TLabel;
    txtSection2: TEdit;
    Label6: TLabel;
    txtKey2: TEdit;
    Label7: TLabel;
    txtValue2: TEdit;
    btnRReadString: TButton;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    Layout6: TLayout;
    Layout7: TLayout;
    Layout8: TLayout;
    Layout9: TLayout;
    Layout10: TLayout;
    ListBoxItem3: TListBoxItem;
    Layout11: TLayout;
    txtSection3: TEdit;
    Label8: TLabel;
    Layout12: TLayout;
    txtKey3: TEdit;
    Label9: TLabel;
    Layout14: TLayout;
    btnDeleteKey: TButton;
    ListBoxItem4: TListBoxItem;
    Layout15: TLayout;
    txtSection4: TEdit;
    Label10: TLabel;
    Layout18: TLayout;
    btnReadSection: TButton;
    ListBoxItem5: TListBoxItem;
    Layout16: TLayout;
    btnReadSections: TButton;
    ListBoxItem6: TListBoxItem;
    Layout13: TLayout;
    txtSection6: TEdit;
    Label11: TLabel;
    Layout17: TLayout;
    btnReadSectionValues: TButton;
    ListBoxItem7: TListBoxItem;
    Layout19: TLayout;
    txtSection7: TEdit;
    Label12: TLabel;
    Layout20: TLayout;
    btnEraseSection: TButton;
    DgfStringsHolder1: TDgfStringsHolder;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnWriteStringClick(Sender: TObject);
    procedure btnRReadStringClick(Sender: TObject);
    procedure btnDeleteKeyClick(Sender: TObject);
    procedure btnReadSectionClick(Sender: TObject);
    procedure btnReadSectionsClick(Sender: TObject);
    procedure btnReadSectionValuesClick(Sender: TObject);
    procedure btnEraseSectionClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HeaderFooterForm: THeaderFooterForm;

const
  DB_FILE_NAME = 'DaigoFriendsPackage.s3db';

implementation

{$R *.fmx}

procedure THeaderFooterForm.FormCreate(Sender: TObject);
var
  DbPath: String;
begin
  TabControl1.ActiveTab := TabItem1;
{$IF DEFINED(IOS) or DEFINED(ANDROID)}
  DbPath := TPath.GetDocumentsPath + PathDelim + DB_FILE_NAME;
{$ELSE}
  DbPath := ExtractFileDir(ParamStr(0)) + PathDelim + DB_FILE_NAME;
{$ENDIF}
  FDConnection1.Params.Values['Database'] := DbPath;
end;

// StringsHolder
procedure THeaderFooterForm.Button1Click(Sender: TObject);
begin
  ShowMessage(DgfStringsHolder1.Lines.Text);
end;

// TableIniFile
procedure THeaderFooterForm.Button2Click(Sender: TObject);
begin
  DgfTableIniFile1.Table := FDTable1;
  DgfTableIniFile1.CreateTable(True); // ReCreate = True
  TabControl1.ActiveTab := TabItem2;
end;

{$region 'TableIniFile'}

// Read string
procedure THeaderFooterForm.btnRReadStringClick(Sender: TObject);
var
  S: String;
begin
  S := DgfTableIniFile1.ReadString(txtSection2.Text, txtKey2.Text, txtValue2.Text);
  ShowMessage(S);
end;

// Write string
procedure THeaderFooterForm.btnWriteStringClick(Sender: TObject);
begin
  DgfTableIniFile1.WriteString(txtSection1.Text, txtKey1.Text, txtValue1.Text);
  ShowMessage('OK');
end;

// Delete key
procedure THeaderFooterForm.btnDeleteKeyClick(Sender: TObject);
begin
  DgfTableIniFile1.DeleteKey(txtSection3.Text, txtKey3.Text);
  ShowMessage('OK');
end;

// Read section
procedure THeaderFooterForm.btnReadSectionClick(Sender: TObject);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    DgfTableIniFile1.ReadSection(txtSection4.Text, SL);
    ShowMessage(SL.Text);
  finally
    SL.Free;
  end;
end;

// Read sections
procedure THeaderFooterForm.btnReadSectionsClick(Sender: TObject);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    DgfTableIniFile1.ReadSections(SL);
    ShowMessage(SL.Text);
  finally
    SL.Free;
  end;
end;

// Read section values
procedure THeaderFooterForm.btnReadSectionValuesClick(Sender: TObject);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    DgfTableIniFile1.ReadSectionValues(txtSection6.Text, SL);
    ShowMessage(SL.Text);
  finally
    SL.Free;
  end;
end;

// Erase section
procedure THeaderFooterForm.btnEraseSectionClick(Sender: TObject);
begin
  DgfTableIniFile1.EraseSection(txtSection7.Text);
  ShowMessage('OK');
end;

{$endregion}

end.
