unit unitPlaces;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  DBGrids, Buttons;
type

  { TFormPlaces }

  TFormPlaces = class(TForm)
    BtnNew: TBitBtn;
    BtnSave: TBitBtn;
    BtnEdit: TBitBtn;
    BtnDelete: TBitBtn;
    BtnCancel: TBitBtn;
    DataSourcePlaces: TDataSource;
    DBGrid1: TDBGrid;
    EditSearch: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    LabelSearch: TLabel;
    Panel1: TPanel;
    PanelRegistry: TPanel;
    SBClear: TSpeedButton;
    SBSearch: TSpeedButton;
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnNewClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure DataSourcePlacesDataChange(Sender: TObject; Field: TField);
    procedure DataSourcePlacesStateChange(Sender: TObject);
    procedure SBClearClick(Sender: TObject);
    procedure SBSearchClick(Sender: TObject);
  private

  public

  end;

var
  FormPlaces: TFormPlaces;

implementation

{$R *.lfm}

{ TFormPlaces }

procedure TFormPlaces.SBSearchClick(Sender: TObject);
begin
  if EditSearch.Text <> '' then
  begin
    DataSourcePlaces.DataSet.Filter:='LOCAIS LIKE '+ QuotedStr('*'+EditSearch.Text+'*');
    DataSourcePlaces.DataSet.Filtered:=True;
  end;
end;

procedure TFormPlaces.SBClearClick(Sender: TObject);
begin
  EditSearch.Text:='';
  DataSourcePlaces.DataSet.Filter:='';
  DataSourcePlaces.DataSet.Filtered:=False;
end;

procedure TFormPlaces.BtnNewClick(Sender: TObject);
begin
  if DataSourcePlaces.DataSet.State = dsBrowse then
  begin
    SBClear.Click;
    DBGrid1.Options := DBGrid1.Options + [dgEditing];
    DataSourcePlaces.DataSet.Insert;
    DBGrid1.SetFocus;
    DBGrid1.EditorMode := True;
  end;
end;

procedure TFormPlaces.BtnEditClick(Sender: TObject);
begin
  if DataSourcePlaces.DataSet.State = dsBrowse then
  begin
    DBGrid1.Options := DBGrid1.Options + [dgEditing];
    DBGrid1.SetFocus;
    DBGrid1.EditorMode := True;
  end;
end;

procedure TFormPlaces.BtnCancelClick(Sender: TObject);
begin
  if DataSourcePlaces.DataSet.State in [dsInsert, dsEdit] then
  begin
    DataSourcePlaces.DataSet.Cancel;
    DBGrid1.Options := DBGrid1.Options - [dgEditing];
  end;
end;

procedure TFormPlaces.BtnDeleteClick(Sender: TObject);
begin
  if not DataSourcePlaces.DataSet.IsEmpty then
  begin
    if QuestionDlg('Atenção',
                          'Deseja realmente excluir este registro?',
                          mtConfirmation,
                          [mrYes, mrNo],
                          'Sim;Não') = mrYes then
    begin
      DataSourcePlaces.DataSet.Delete;
    end;
  end;
end;

procedure TFormPlaces.BtnSaveClick(Sender: TObject);
begin
  if DataSourcePlaces.DataSet.State in [dsInsert, dsEdit] then
  begin
    DataSourcePlaces.DataSet.Post;
    DBGrid1.Options := DBGrid1.Options - [dgEditing];
  end;
end;

procedure TFormPlaces.DataSourcePlacesDataChange(Sender: TObject; Field: TField
  );
begin
  PanelRegistry.Caption:='Total de Registros: ' + IntToStr(DataSourcePlaces.DataSet.RecordCount);
end;

procedure TFormPlaces.DataSourcePlacesStateChange(Sender: TObject);
begin
  if DataSourcePlaces.DataSet.Active then
  begin
    case DataSourcePlaces.DataSet.State of
    dsBrowse:
      begin;
        if DataSourcePlaces.DataSet.IsEmpty then
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

end.

