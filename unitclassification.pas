unit unitClassification;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls,ExtCtrls,
  DBGrids, Buttons;
type

  { TFormClassifications }

  TFormClassifications = class(TForm)
    BtnNew: TBitBtn;
    BtnSave: TBitBtn;
    BtnEdit: TBitBtn;
    BtnDelete: TBitBtn;
    BtnCancel: TBitBtn;
    DataSourceClassification: TDataSource;
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
    procedure DataSourceClassificationDataChange(Sender: TObject; Field: TField
      );
    procedure DataSourceClassificationStateChange(Sender: TObject);
    procedure SBClearClick(Sender: TObject);
    procedure SBSearchClick(Sender: TObject);
  private

  public

  end;

var
  FormClassifications: TFormClassifications;

implementation

{$R *.lfm}

{ TFormClassifications }

procedure TFormClassifications.BtnNewClick(Sender: TObject);
begin
  if DataSourceClassification.DataSet.State = dsBrowse then
  begin
    SBClear.Click;
    DBGrid1.Options := DBGrid1.Options + [dgEditing];
    DataSourceClassification.DataSet.Insert;
    DBGrid1.SetFocus;
    DBGrid1.EditorMode := True;
  end;
end;

procedure TFormClassifications.BtnEditClick(Sender: TObject);
begin
  if DataSourceClassification.DataSet.State = dsBrowse then
  begin
    DBGrid1.Options := DBGrid1.Options + [dgEditing];
    DBGrid1.SetFocus;
    DBGrid1.EditorMode := True;
  end;
end;

procedure TFormClassifications.BtnCancelClick(Sender: TObject);
begin
  if DataSourceClassification.DataSet.State in [dsInsert, dsEdit] then
  begin
    DataSourceClassification.DataSet.Cancel;
    DBGrid1.Options := DBGrid1.Options - [dgEditing];
  end;
end;

procedure TFormClassifications.BtnDeleteClick(Sender: TObject);
begin
  if not DataSourceClassification.DataSet.IsEmpty then
  begin
    if QuestionDlg('Atenção',
                          'Deseja realmente excluir este registro?',
                          mtConfirmation,
                          [mrYes, mrNo],
                          'Sim;Não') = mrYes then
    begin
      DataSourceClassification.DataSet.Delete;
    end;
  end;
end;

procedure TFormClassifications.BtnSaveClick(Sender: TObject);
begin
  if DataSourceClassification.DataSet.State in [dsInsert, dsEdit] then
  begin
    DataSourceClassification.DataSet.Post;
    DBGrid1.Options := DBGrid1.Options - [dgEditing];
  end;
end;

procedure TFormClassifications.DataSourceClassificationDataChange(
  Sender: TObject; Field: TField);
begin
  PanelRegistry.Caption:='Total de Registros: ' + IntToStr(DataSourceClassification.DataSet.RecordCount);
end;

procedure TFormClassifications.DataSourceClassificationStateChange(
  Sender: TObject);
begin
  if DataSourceClassification.DataSet.Active then
  begin
    case DataSourceClassification.DataSet.State of
    dsBrowse:
      begin;
        if DataSourceClassification.DataSet.IsEmpty then
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

procedure TFormClassifications.SBClearClick(Sender: TObject);
begin
  EditSearch.Text:='';
  DataSourceClassification.DataSet.Filter:='';
  DataSourceClassification.DataSet.Filtered:=False;
end;

procedure TFormClassifications.SBSearchClick(Sender: TObject);
begin
  if EditSearch.Text <> '' then
  begin
    DataSourceClassification.DataSet.Filter:='CLASSIFICACAO LIKE '+ QuotedStr('*'+EditSearch.Text+'*');
    DataSourceClassification.DataSet.Filtered:=True;
  end;
end;

end.

