unit DgfStringsHolder;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls;

type
  TDgfStringsHolder = class(TComponent)
  private
    { Private éŒ¾ }
    FLines: TStrings;
    procedure SetLines(const Value: TStrings);
  protected
    { Protected éŒ¾ }
  public
    { Public éŒ¾ }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published éŒ¾ }
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
