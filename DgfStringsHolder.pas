unit DgfStringsHolder;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls;

type
  TDgfStringsHolder = class(TComponent)
  private
    { Private �錾 }
    FLines: TStrings;
    procedure SetLines(const Value: TStrings);
  protected
    { Protected �錾 }
  public
    { Public �錾 }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published �錾 }
    property Lines: TStrings read FLines write SetLines;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('DaigoFriends', [TDgfStringsHolder]);
end;

constructor TDgfStringsHolder.Create(AOwner: TComponent);
begin
  inherited;
  FLines := TStringList.Create;
end;

destructor TDgfStringsHolder.Destroy;
begin
  inherited;
  FreeAndNil(FLines);
end;

procedure TDgfStringsHolder.SetLines(const Value: TStrings);
begin
  FLines.Assign(Value);
end;

end.
