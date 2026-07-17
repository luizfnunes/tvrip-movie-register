unit unitCountries;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  DBGrids, Buttons;

type

  { TFormCountries }

  TFormCountries = class(TForm)
    BtnNew: TBitBtn;
    BtnSave: TBitBtn;
    BtnEdit: TBitBtn;
    BtnDelete: TBitBtn;
    BtnCancel: TBitBtn;
    DataSourceCountries: TDataSource;
    DBGrid1: TDBGrid;
    EditSearch: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    LabelSearch: TLabel;
    Panel1: TPanel;
    PanelRegistry: TPanel;
    SBClear: TSpeedButton;
    SBSearch: TSpeedButton;
    procedure BtnDeleteClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnNewClick(Sender: TObject);
    procedure DataSourceCountriesDataChange(Sender: TObject; Field: TField);
    procedure DataSourceCountriesStateChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure SBClearClick(Sender: TObject);
    procedure SBSearchClick(Sender: TObject);
  private

  public

  end;

var
  FormCountries: TFormCountries;

implementation

uses unitDataModule;

{$R *.lfm}

{ TFormCountries }

procedure TFormCountries.BtnNewClick(Sender: TObject);
begin
  if DataSourceCountries.DataSet.State = dsBrowse then
  begin
    SBClear.Click;
    DBGrid1.Options := DBGrid1.Options + [dgEditing];
    DataSourceCountries.DataSet.Insert;
    DBGrid1.SetFocus;
    DBGrid1.EditorMode := True;
  end;
end;

procedure TFormCountries.DataSourceCountriesDataChange(Sender: TObject;
  Field: TField);
begin
  PanelRegistry.Caption:='Total de Registros: ' + IntToStr(DataSourceCountries.DataSet.RecordCount);
end;

procedure TFormCountries.DataSourceCountriesStateChange(Sender: TObject);
begin
  if DataSourceCountries.DataSet.Active then
  begin
    case DataSourceCountries.DataSet.State of
    dsBrowse:
      begin;
        if DataSourceCountries.DataSet.IsEmpty then
        begin
          BtnEdit.Enabled:=False;
          BtnDelete.Enabled:=False;
        end
        else
        begin
          BtnEdit.Enabled:=True;
          BtnDelete.Enabled:=True;
        end;
        BtnNew.Enabled:=True;
        BtnSave.Enabled:=False;
        BtnCancel.Enabled:=False;
      end;
    dsInsert, dsEdit:
      begin
        BtnNew.Enabled:=False;
        BtnSave.Enabled:=True;
        BtnEdit.Enabled:=False;
        BtnCancel.Enabled:=True;
        BtnDelete.Enabled:=False;
      end;
    end;
  end
  else
  begin
    BtnNew.Enabled:=False;
    BtnSave.Enabled:=False;
    BtnEdit.Enabled:=False;
    BtnCancel.Enabled:=False;
    BtnDelete.Enabled:=False;
  end;
end;

procedure TFormCountries.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  SBClear.Click;
  BtnCancel.Click;
  DataSourceCountries.DataSet.First;
end;

procedure TFormCountries.SBClearClick(Sender: TObject);
begin
  EditSearch.Text:='';
  DataSourceCountries.DataSet.Filter:='';
  DataSourceCountries.DataSet.Filtered:=False;
end;

procedure TFormCountries.SBSearchClick(Sender: TObject);
begin
  if EditSearch.Text <> '' then
  begin
    DataSourceCountries.DataSet.Filter:='PAIS LIKE '+ QuotedStr('*'+EditSearch.Text+'*');
    DataSourceCountries.DataSet.Filtered:=True;
  end;
end;

procedure TFormCountries.BtnCancelClick(Sender: TObject);
begin
  if DataSourceCountries.DataSet.State in [dsInsert, dsEdit] then
  begin
    DataSourceCountries.DataSet.Cancel;
    DBGrid1.Options := DBGrid1.Options - [dgEditing];
  end;
end;

procedure TFormCountries.BtnSaveClick(Sender: TObject);
begin
  if DataSourceCountries.DataSet.State in [dsInsert, dsEdit] then
  begin
    DataSourceCountries.DataSet.Post;
    DBGrid1.Options := DBGrid1.Options - [dgEditing];
  end;
end;

procedure TFormCountries.BtnEditClick(Sender: TObject);
begin
  if DataSourceCountries.DataSet.State = dsBrowse then
  begin
    DBGrid1.Options := DBGrid1.Options + [dgEditing];
    DBGrid1.SetFocus;
    DBGrid1.EditorMode := True;
  end;
end;

procedure TFormCountries.BtnDeleteClick(Sender: TObject);
begin
  if not DataSourceCountries.DataSet.IsEmpty then
  begin
    //if QuestionDlg('Confirmar Exclusão', 'Deseja realmente excluir o registro selecionado?', mtConfirmation, [mbYes, mbNo], 'Sim;Não') = mrYes then
    if QuestionDlg('Atenção',
                          'Deseja realmente excluir este registro?',
                          mtConfirmation,
                          [mrYes, mrNo],
                          'Sim;Não') = mrYes then
    begin
      DataSourceCountries.DataSet.Delete;
    end;
  end;
end;

end.

