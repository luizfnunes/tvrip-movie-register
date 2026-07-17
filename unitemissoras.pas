unit unitEmissoras;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  DBGrids, Buttons;
type

  { TFormEmissoras }

  TFormEmissoras = class(TForm)
    BtnNew: TBitBtn;
    BtnSave: TBitBtn;
    BtnEdit: TBitBtn;
    BtnDelete: TBitBtn;
    BtnCancel: TBitBtn;
    DataSourceEmissoras: TDataSource;
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
    procedure DataSourceEmissorasDataChange(Sender: TObject; Field: TField);
    procedure DataSourceEmissorasStateChange(Sender: TObject);
    procedure SBClearClick(Sender: TObject);
    procedure SBSearchClick(Sender: TObject);
  private

  public

  end;

var
  FormEmissoras: TFormEmissoras;

implementation

{$R *.lfm}

{ TFormEmissoras }

procedure TFormEmissoras.SBSearchClick(Sender: TObject);
begin
  if EditSearch.Text <> '' then
  begin
    DataSourceEmissoras.DataSet.Filter:='EMISSORA LIKE '+ QuotedStr('*'+EditSearch.Text+'*');
    DataSourceEmissoras.DataSet.Filtered:=True;
  end;
end;

procedure TFormEmissoras.SBClearClick(Sender: TObject);
begin
  EditSearch.Text:='';
  DataSourceEmissoras.DataSet.Filter:='';
  DataSourceEmissoras.DataSet.Filtered:=False;
end;

procedure TFormEmissoras.BtnNewClick(Sender: TObject);
begin
  if DataSourceEmissoras.DataSet.State = dsBrowse then
  begin
    SBClear.Click;
    DBGrid1.Options := DBGrid1.Options + [dgEditing];
    DataSourceEmissoras.DataSet.Insert;
    DBGrid1.SetFocus;
    DBGrid1.EditorMode := True;
  end;
end;

procedure TFormEmissoras.BtnEditClick(Sender: TObject);
begin
  if DataSourceEmissoras.DataSet.State = dsBrowse then
  begin
    DBGrid1.Options := DBGrid1.Options + [dgEditing];
    DBGrid1.SetFocus;
    DBGrid1.EditorMode := True;
  end;
end;

procedure TFormEmissoras.BtnCancelClick(Sender: TObject);
begin
  if DataSourceEmissoras.DataSet.State in [dsInsert, dsEdit] then
  begin
    DataSourceEmissoras.DataSet.Cancel;
    DBGrid1.Options := DBGrid1.Options - [dgEditing];
  end;
end;

procedure TFormEmissoras.BtnDeleteClick(Sender: TObject);
begin
  if not DataSourceEmissoras.DataSet.IsEmpty then
  begin
    if QuestionDlg('Atenção',
                          'Deseja realmente excluir este registro?',
                          mtConfirmation,
                          [mrYes, mrNo],
                          'Sim;Não') = mrYes then
    begin
      DataSourceEmissoras.DataSet.Delete;
    end;
  end;
end;

procedure TFormEmissoras.BtnSaveClick(Sender: TObject);
begin
  if DataSourceEmissoras.DataSet.State in [dsInsert, dsEdit] then
  begin
    DataSourceEmissoras.DataSet.Post;
    DBGrid1.Options := DBGrid1.Options - [dgEditing];
  end;
end;

procedure TFormEmissoras.DataSourceEmissorasDataChange(Sender: TObject;
  Field: TField);
begin
  PanelRegistry.Caption:='Total de Registros: ' + IntToStr(DataSourceEmissoras.DataSet.RecordCount);
end;

procedure TFormEmissoras.DataSourceEmissorasStateChange(Sender: TObject);
begin
  if DataSourceEmissoras.DataSet.Active then
  begin
    case DataSourceEmissoras.DataSet.State of
    dsBrowse:
      begin;
        if DataSourceEmissoras.DataSet.IsEmpty then
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

