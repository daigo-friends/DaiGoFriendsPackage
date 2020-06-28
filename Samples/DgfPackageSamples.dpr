program DgfPackageSamples;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {HeaderFooterForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'DaiGoFriends Package Samples';
  Application.CreateForm(THeaderFooterForm, HeaderFooterForm);
  Application.Run;
end.
