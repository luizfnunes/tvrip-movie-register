unit unitQualities;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  DBGrids, Buttons;
type

  { TFormQualities }

  TFormQualities = class(TForm)
    BtnNew: TBitBtn;
    BtnSave: TBitBtn;
    BtnEdit: TBitBtn;
    BtnDelete: TBitBtn;
    BtnCancel: TBitBtn;
    DataSourceQualities: TDataSource;
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
    procedure DataSourceQualitiesDataChange(Sender: TObject; Field: TField);
    procedure DataSourceQualitiesStateChange(Sender: TObject);
    procedure SBClearClick(Sender: TObject);
    procedure SBSearchClick(Sender: TObject);
  private

  public

  end;

var
  FormQualities: TFormQualities;

implementation

{$R *.lfm}

{ TFormQualities }

procedure TFormQualities.SBSearchClick(Sender: TObject);
begin
  if EditSearch.Text <> '' then
  begin
    DataSourceQualities.DataSet.Filter:='QUALIDADE LIKE '+ QuotedStr('*'+EditSearch.Text+'*');
    DataSourceQualities.DataSet.Filtered:=True;
  end;
end;

procedure TFormQualities.SBClearClick(Sender: TObject);
begin
  EditSearch.Text:='';
  DataSourceQualities.DataSet.Filter:='';
  DataSourceQualities.DataSet.Filtered:=False;
end;

procedure TFormQualities.BtnNewClick(Sender: TObject);
begin
  if DataSourceQualities.DataSet.State = dsBrowse then
  begin
    SBClear.Click;
    DBGrid1.Options := DBGrid1.Options + [dgEditing];
    DataSourceQualities.DataSet.Insert;
    DBGrid1.SetFocus;
    DBGrid1.EditorMode := True;
  end;
end;

procedure TFormQualities.BtnEditClick(Sender: TObject);
begin
  if DataSourceQualities.DataSet.State = dsBrowse then
  begin
    DBGrid1.Options := DBGrid1.Options + [dgEditing];
    DBGrid1.SetFocus;
    DBGrid1.EditorMode := True;
  end;
end;

procedure TFormQualities.BtnCancelClick(Sender: TObject);
begin
  if DataSourceQualities.DataSet.State in [dsInsert, dsEdit] then
  begin
    DataSourceQualities.DataSet.Cancel;
    DBGrid1.Options := DBGrid1.Options - [dgEditing];
  end;
end;

procedure TFormQualities.BtnDeleteClick(Sender: TObject);
begin
  if not DataSourceQualities.DataSet.IsEmpty then
  begin
    if QuestionDlg('Atenção',
                          'Deseja realmente excluir este registro?',
                          mtConfirmation,
                          [mrYes, mrNo],
                          'Sim;Não') = mrYes then
    begin
      DataSourceQualities.DataSet.Delete;
    end;
  end;
end;

procedure TFormQualities.BtnSaveClick(Sender: TObject);
begin
  if DataSourceQualities.DataSet.State in [dsInsert, dsEdit] then
  begin
    DataSourceQualities.DataSet.Post;
    DBGrid1.Options := DBGrid1.Options - [dgEditing];
  end;
end;

procedure TFormQualities.DataSourceQualitiesDataChange(Sender: TObject;
  Field: TField);
begin
  PanelRegistry.Caption:='Total de Registros: ' + IntToStr(DataSourceQualities.DataSet.RecordCount);
end;

procedure TFormQualities.DataSourceQualitiesStateChange(Sender: TObject);
begin
  if DataSourceQualities.DataSet.Active then
  begin
    case DataSourceQualities.DataSet.State of
    dsBrowse:
      begin;
        if DataSourceQualities.DataSet.IsEmpty then
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

