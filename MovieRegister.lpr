program MovieRegister;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, unitMain, unitCountries, unitGenders,
  unitClassification, unitTypes, unitEmissoras, unitQualities, unitPlaces, 
unitDataModule, zcomponent, unitAbout
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  {$PUSH}{$WARN 5044 OFF}
  Application.MainFormOnTaskbar:=True;
  {$POP}
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormCountries, FormCountries);
  Application.CreateForm(TFormGenders, FormGenders);
  Application.CreateForm(TFormClassifications, FormClassifications);
  Application.CreateForm(TFormTypes, FormTypes);
  Application.CreateForm(TFormEmissoras, FormEmissoras);
  Application.CreateForm(TFormQualities, FormQualities);
  Application.CreateForm(TFormPlaces, FormPlaces);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.Run;
end.

