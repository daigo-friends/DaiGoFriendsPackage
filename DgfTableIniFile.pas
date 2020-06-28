/// <summary>
///   This is an INIFILE component that uses a database table.
/// </summary>
/// <copyright>
///   Copyright (c) 2020 daigo-friends
///   Released under the MIT license
///   https://opensource.org/licenses/mit-license.php
/// </copyright>
///
/// <remarks>
/// </remarks>
///
/// <see>
/// </see>
///
/// <authors>
///   tomomori
/// </authors>
unit DgfTableIniFile;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FireDAC.Comp.Client,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Stan.Intf, IniFiles;

type
  TDgfCustomDBIniFile = class(TCustominiFile)
  private
    { Private éŒ¾ }
    FTable: TFDTable;
    procedure DoFilter(const ASection, AIdent: String); overload;
    procedure DoFilter(const ASection: String); overload;
    procedure SetTableName;
  protected
    { Protected éŒ¾ }
    procedure CreateTable(ARecreate: Boolean); virtual;
    property Table: TFDTable read FTable write FTable;
  public
    { Public éŒ¾ }
    constructor Create(ATable: TFDTable);
    destructor Destroy; override;

    function ReadString(const ASection, AIdent, ADefault: String): String; override;
    procedure WriteString(const ASection, AIdent, AValue: String); override;
    procedure ReadSection(const ASection: String; AStrings: TStrings); override;
    procedure ReadSections(AStrings: TStrings); override;
    procedure ReadSectionValues(const ASection: String; AStrings: TStrings); override;
    procedure EraseSection(const ASection: String); override;
    procedure DeleteKey(const ASection, AIdent: String); override;
    procedure UpdateFile; override;
  end;

  TDgfTableIniFile = class(TComponent)
  private
    { Private éŒ¾ }
    FTable: TFDTable;
    FIni: TDgfCustomDBIniFile;
    procedure SetTable(ATable: TFDTable);
  protected
    { Protected éŒ¾ }
  public
    { Public éŒ¾ }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateTable(ARecreate: Boolean);

    function ReadString(const ASection, AIdent, ADefault: String): String;
    procedure WriteString(const ASection, AIdent, AValue: String);
    procedure ReadSection(const ASection: String; AStrings: TStrings);
    procedure ReadSections(AStrings: TStrings);
    procedure ReadSectionValues(const ASection: String; AStrings: TStrings);
    procedure EraseSection(const ASection: String);
    procedure DeleteKey(const ASection, AIdent: String);
  published
    { Published éŒ¾ }
    property Table: TFDTable read FTable write SetTable;
  end;

const
  FIELD_NAME_SECTION = 'INI_SECTION';
  FIELD_NAME_KEY = 'INI_KEY';
  FIELD_NAME_VALUE = 'INI_VALUE';

procedure Register;

implementation

{$region 'TDgfCustomDBIniFile'}
constructor TDgfCustomDBIniFile.Create(ATable: TFDTable);
begin
  FTable := ATable;
end;

destructor TDgfCustomDBIniFile.Destroy;
begin
  inherited;
end;

procedure TDgfCustomDBIniFile.SetTableName;
begin
  if FTable.TableName = EmptyStr then
  begin
    FTable.TableName:='DB_INI_TABLE';
  end;
end;

procedure TDgfCustomDBIniFile.DoFilter(const ASection: String);
begin
  if Assigned(FTable) then
  begin
    FTable.Filter := FIELD_NAME_SECTION + ' = ''' + ASection + '''';
    FTable.Filtered := True;
    if not FTable.Active then
    begin
      SetTableName;
      FTable.Open;
    end;
    FTable.First;
  end;
end;

procedure TDgfCustomDBIniFile.DoFilter(const ASection, AIdent: String);
begin
  if Assigned(FTable) then
  begin
    FTable.Filter := FIELD_NAME_SECTION + ' = ''' + ASection + ''' AND '
                   + FIELD_NAME_KEY + ' = ''' + AIdent + '''';
    FTable.Filtered := True;
    if not FTable.Active then
    begin
      SetTableName;
      FTable.Open;
    end;
    FTable.First;
  end;
end;

procedure TDgfCustomDBIniFile.CreateTable(ARecreate: Boolean);
begin
  if not Assigned(FTable) then Exit;

  SetTableName;

  if (FTable.Exists) and (not ARecreate) then
  begin
    Exit;
  end;

  FTable.DeleteIndexes;
  if FTable.Active then
  begin
    FTable.Active := False;
  end;
  if ARecreate then
  begin
    FTable.FieldDefs.Clear;
  end;
  FTable.FieldDefs.Add(FIELD_NAME_SECTION, ftString, 50, True);
  FTable.FieldDefs.Add(FIELD_NAME_KEY, ftString, 50, True);
  FTable.FieldDefs.Add(FIELD_NAME_VALUE, ftString, 255, False);
  FTable.AddIndex('INI_PK',FIELD_NAME_SECTION + ';' + FIELD_NAME_KEY,'',[soPrimary]);
  FTable.CreateTable(ARecreate);
  FTable.Active := True;
end;

{$region 'override'}
function TDgfCustomDBIniFile.ReadString(const ASection, AIdent, ADefault: String): String;
begin
  Result := ADefault;
  if Assigned(FTable) then
  begin
    DoFilter(ASection, AIdent);
    if not FTable.Eof then
    begin
      Result := FTable.FieldByName(FIELD_NAME_VALUE).AsString;
    end;
  end;
end;

procedure TDgfCustomDBIniFile.WriteString(const ASection, AIdent, AValue: String);
begin
  if Assigned(FTable) then
  begin
    DoFilter(ASection, AIdent);
    if not FTable.Eof then
    begin
      FTable.Edit;
    end else begin
      FTable.Append;
      FTable.FieldByName(FIELD_NAME_SECTION).AsString := ASection;
      FTable.FieldByName(FIELD_NAME_KEY).AsString := AIdent;
    end;
    FTable.FieldByName(FIELD_NAME_VALUE).AsString := AValue;
    FTable.Post;
  end;
end;

procedure TDgfCustomDBIniFile.DeleteKey(const ASection, AIdent: String);
begin
  if Assigned(FTable) then
  begin
    DoFilter(ASection, AIdent);
    if not FTable.Eof then
    begin
      FTable.Delete;
    end;
  end;
end;

procedure TDgfCustomDBIniFile.EraseSection(const ASection: String);
var
  I: Integer;
begin
  if Assigned(FTable) then
  begin
    DoFilter(ASection);
    FTable.BeginBatch;
    try
      for I := FTable.RecordCount - 1 downto 0 do
      begin
        FTable.Delete;
        if I > 0 then
        begin
          FTable.Next;
        end;
      end;
    finally
      FTable.EndBatch;
      FTable.Refresh;
    end;
  end;
end;

// Get key names
procedure TDgfCustomDBIniFile.ReadSection(const ASection: String; AStrings: TStrings);
begin
  AStrings.BeginUpdate;
  try
    AStrings.Clear;
    if Assigned(FTable) then
    begin
      DoFilter(ASection);
      while not FTable.Eof do
      begin
        AStrings.Add(FTable.FieldByName(FIELD_NAME_KEY).AsString);
        FTable.Next;
      end;
    end;
  finally
    AStrings.EndUpdate;
  end;
end;

// Get section names
procedure TDgfCustomDBIniFile.ReadSections(AStrings: TStrings);
var
  S: String;
begin
  AStrings.BeginUpdate;
  try
    AStrings.Clear;
    FTable.Filter := '';
    FTable.Filtered := False;
    FTable.First;
    if Assigned(FTable) then
    begin
      while not FTable.Eof do
      begin
        S := FTable.FieldByName(FIELD_NAME_SECTION).AsString;
        if AStrings.IndexOf(S) = -1 then
        begin
          AStrings.Add(S);
        end;
        FTable.Next;
      end;
    end;
  finally
    AStrings.EndUpdate;
  end;
end;

// Get values
procedure TDgfCustomDBIniFile.ReadSectionValues(const ASection: string; AStrings: TStrings);
begin
  AStrings.BeginUpdate;
  try
    AStrings.Clear;
    if Assigned(FTable) then
    begin
      DoFilter(ASection);
      while not FTable.Eof do
      begin
        AStrings.Add(FTable.FieldByName(FIELD_NAME_VALUE).AsString);
        FTable.Next;
      end;
    end;
  finally
    AStrings.EndUpdate;
  end;
end;

procedure TDgfCustomDBIniFile.UpdateFile;
begin

end;
{$endregion}

{$endregion}

{$region 'TDgfTableIniFile'}
procedure Register;
begin
  RegisterComponents('DaigoFriends', [TDgfTableIniFile]);
end;

constructor TDgfTableIniFile.Create(AOwner: TComponent);
begin
  inherited;
  FIni := TDgfCustomDBIniFile.Create(FTable);
end;

procedure TDgfTableIniFile.CreateTable(ARecreate: Boolean);
begin
  FIni.CreateTable(ARecreate);
end;

destructor TDgfTableIniFile.Destroy;
begin
  FreeAndNil(FIni);
  inherited;
end;

procedure TDgfTableIniFile.SetTable(ATable: TFDTable);
begin
  FTable := ATable;
  FIni.Table := ATable;
end;

function TDgfTableIniFile.ReadString(const ASection, AIdent, ADefault: String): String;
begin
  Result := Fini.ReadString(ASection, AIdent, ADefault);
end;

procedure TDgfTableIniFile.WriteString(const ASection, AIdent, AValue: String);
begin
  Fini.WriteString(ASection, AIdent, AValue);
end;

procedure TDgfTableIniFile.ReadSection(const ASection: String; AStrings: TStrings);
begin
  Fini.ReadSection(ASection, AStrings);
end;

procedure TDgfTableIniFile.ReadSections(AStrings: TStrings);
begin
  Fini.ReadSections(AStrings);
end;

procedure TDgfTableIniFile.ReadSectionValues(const ASection: String; AStrings: TStrings);
begin
  Fini.ReadSectionValues(ASection, AStrings);
end;

procedure TDgfTableIniFile.EraseSection(const ASection: String);
begin
  Fini.EraseSection(ASection);
end;

procedure TDgfTableIniFile.DeleteKey(const ASection, AIdent: String);
begin
 Fini.DeleteKey(ASection, AIdent);
end;

{$endregion}

end.
