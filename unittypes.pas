unit unitTypes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  DBGrids, Buttons;
type

  { TFormTypes }

  TFormTypes = class(TForm)
    BtnNew: TBitBtn;
    BtnSave: TBitBtn;
    BtnEdit: TBitBtn;
    BtnDelete: TBitBtn;
    BtnCancel: TBitBtn;
    DataSourceTypes: TDataSource;
    DBGrid1: TDBGrid;
    EditSearch: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    LabelSearch: TLabel;
    Panel1: TPanel;
    PanelRegistry: TPanel;
    SBClear: TSpeedButton;
    SBSearch: TSpeedButton;
    procedure BtnNewClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure DataSourceTypesDataChange(Sender: TObject; Field: TField);
    procedure DataSourceTypesStateChange(Sender: TObject);
    procedure SBClearClick(Sender: TObject);
    procedure SBSearchClick(Sender: TObject);
  private

  public

  end;

var
  FormTypes: TFormTypes;

implementation

{$R *.lfm}

{ TFormTypes }

procedure TFormTypes.BtnNewClick(Sender: TObject);
begin
  if DataSourceTypes.DataSet.State = dsBrowse then
  begin
    SBClear.Click;
    DBGrid1.Options := DBGrid1.Options + [dgEditing];
    DataSourceTypes.DataSet.Insert;
    DBGrid1.SetFocus;
    DBGrid1.EditorMode := True;
  end;
end;

procedure TFormTypes.BtnSaveClick(Sender: TObject);
begin
  if DataSourceTypes.DataSet.State in [dsInsert, dsEdit] then
  begin
    DataSourceTypes.DataSet.Post;
    DBGrid1.Options := DBGrid1.Options - [dgEditing];
  end;
end;

procedure TFormTypes.BtnEditClick(Sender: TObject);
begin
  if DataSourceTypes.DataSet.State = dsBrowse then
  begin
    DBGrid1.Options := DBGrid1.Options + [dgEditing];
    DBGrid1.SetFocus;
    DBGrid1.EditorMode := True;
  end;
end;

procedure TFormTypes.BtnDeleteClick(Sender: TObject);
begin
  if not DataSourceTypes.DataSet.IsEmpty then
  begin
    if QuestionDlg('Atenção',
                          'Deseja realmente excluir este registro?',
                          mtConfirmation,
                          [mrYes, mrNo],
                          'Sim;Não') = mrYes then
    begin
      DataSourceTypes.DataSet.Delete;
    end;
  end;
end;

procedure TFormTypes.BtnCancelClick(Sender: TObject);
begin
  if DataSourceTypes.DataSet.State in [dsInsert, dsEdit] then
  begin
    DataSourceTypes.DataSet.Cancel;
    DBGrid1.Options := DBGrid1.Options - [dgEditing];
  end;
end;

procedure TFormTypes.DataSourceTypesDataChange(Sender: TObject; Field: TField);
begin
  PanelRegistry.Caption:='Total de Registros: ' + IntToStr(DataSourceTypes.DataSet.RecordCount);
end;

procedure TFormTypes.DataSourceTypesStateChange(Sender: TObject);
begin
  if DataSourceTypes.DataSet.Active then
  begin
    case DataSourceTypes.DataSet.State of
    dsBrowse:
      begin;
        if DataSourceTypes.DataSet.IsEmpty then
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

procedure TFormTypes.SBClearClick(Sender: TObject);
begin
  EditSearch.Text:='';
  DataSourceTypes.DataSet.Filter:='';
  DataSourceTypes.DataSet.Filtered:=False;
end;

procedure TFormTypes.SBSearchClick(Sender: TObject);
begin
  if EditSearch.Text <> '' then
  begin
    DataSourceTypes.DataSet.Filter:='TIPO LIKE '+ QuotedStr('*'+EditSearch.Text+'*');
    DataSourceTypes.DataSet.Filtered:=True;
  end;
end;

end.

