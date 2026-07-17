unit unitDataModule;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset, ZAbstractRODataset, DB, DBGrids;

type

  { TDM }

  TDM = class(TDataModule)
    ZConnectionMain: TZConnection;
    ZTableMovies: TZTable;
    ZTablePlaces: TZTable;
    ZTableQualities: TZTable;
    ZTableEmissoras: TZTable;
    ZTableTypes: TZTable;
    ZTableClassification: TZTable;
    ZTableGenders: TZTable;
    ZTableCountries: TZTable;
    procedure ZTableClassificationAfterPost(DataSet: TDataSet);
    procedure ZTableCountriesAfterPost(DataSet: TDataSet);
    procedure ZTableEmissorasAfterPost(DataSet: TDataSet);
    procedure ZTableGendersAfterPost(DataSet: TDataSet);
    procedure ZTableMoviesAfterPost(DataSet: TDataSet);
    procedure ZTablePlacesAfterPost(DataSet: TDataSet);
    procedure ZTableQualitiesAfterPost(DataSet: TDataSet);
    procedure ZTableTypesAfterPost(DataSet: TDataSet);
  private

  public

  end;

var
  DM: TDM;

implementation

uses unitCountries, unitGenders, unitClassification,
  unitTypes, unitEmissoras, unitQualities, unitPlaces, unitMain;

{$R *.lfm}

{ TDM }

procedure TDM.ZTableCountriesAfterPost(DataSet: TDataSet);
begin
  FormCountries.DBGrid1.Options:=FormCountries.DBGrid1.Options - [dgEditing];
end;

procedure TDM.ZTableEmissorasAfterPost(DataSet: TDataSet);
begin
  FormEmissoras.DBGrid1.Options:=FormEmissoras.DBGrid1.Options - [dgEditing];
end;

procedure TDM.ZTableClassificationAfterPost(DataSet: TDataSet);
begin
  FormClassifications.DBGrid1.Options:=FormClassifications.DBGrid1.Options - [dgEditing];
end;

procedure TDM.ZTableGendersAfterPost(DataSet: TDataSet);
begin
  FormGenders.DBGrid1.Options:=FormGenders.DBGrid1.Options - [dgEditing];
end;

procedure TDM.ZTableMoviesAfterPost(DataSet: TDataSet);
begin
  FormMain.DBGrid1.Options:=FormMain.DBGrid1.Options - [dgEditing];
end;

procedure TDM.ZTablePlacesAfterPost(DataSet: TDataSet);
begin
  FormPlaces.DBGrid1.Options:=FormPlaces.DBGrid1.Options - [dgEditing];
end;

procedure TDM.ZTableQualitiesAfterPost(DataSet: TDataSet);
begin
   FormQualities.DBGrid1.Options:=FormQualities.DBGrid1.Options - [dgEditing];
end;

procedure TDM.ZTableTypesAfterPost(DataSet: TDataSet);
begin
  FormTypes.DBGrid1.Options:=FormTypes.DBGrid1.Options - [dgEditing];
end;

end.

