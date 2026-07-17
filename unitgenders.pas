unit unitGenders;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  DBGrids, Buttons;
type

  { TFormGenders }

  TFormGenders = class(TForm)
    BtnNew: TBitBtn;
    BtnSave: TBitBtn;
    BtnEdit: TBitBtn;
    BtnDelete: TBitBtn;
    BtnCancel: TBitBtn;
    DataSourceGenders: TDataSource;
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
    procedure DataSourceGendersDataChange(Sender: TObject; Field: TField);
    procedure DataSourceGendersStateChange(Sender: TObject);
    procedure SBClearClick(Sender: TObject);
    procedure SBSearchClick(Sender: TObject);
  private

  public

  end;

var
  FormGenders: TFormGenders;

implementation

{$R *.lfm}

{ TFormGenders }

procedure TFormGenders.BtnNewClick(Sender: TObject);
begin
  if DataSourceGenders.DataSet.State = dsBrowse then
  begin
    SBClear.Click;
    DBGrid1.Options := DBGrid1.Options + [dgEditing];
    DataSourceGenders.DataSet.Insert;
    DBGrid1.SetFocus;
    DBGrid1.EditorMode := True;
  end;
end;

procedure TFormGenders.BtnEditClick(Sender: TObject);
begin
  if DataSourceGenders.DataSet.State = dsBrowse then
  begin
    DBGrid1.Options := DBGrid1.Options + [dgEditing];
    DBGrid1.SetFocus;
    DBGrid1.EditorMode := True;
  end;
end;

procedure TFormGenders.BtnCancelClick(Sender: TObject);
begin
  if DataSourceGenders.DataSet.State in [dsInsert, dsEdit] then
  begin
    DataSourceGenders.DataSet.Cancel;
    DBGrid1.Options := DBGrid1.Options - [dgEditing];
  end;
end;

procedure TFormGenders.BtnDeleteClick(Sender: TObject);
begin
  if not DataSourceGenders.DataSet.IsEmpty then
  begin
    if QuestionDlg('Atenção','Deseja realmente excluir este registro?',
    mtConfirmation,[mrYes, mrNo],'Sim;Não') = mrYes then
    begin
      DataSourceGenders.DataSet.Delete;
    end;
  end;
end;

procedure TFormGenders.BtnSaveClick(Sender: TObject);
begin
  if DataSourceGenders.DataSet.State in [dsInsert, dsEdit] then
  begin
    DataSourceGenders.DataSet.Post;
    DBGrid1.Options := DBGrid1.Options - [dgEditing];
  end;
end;

procedure TFormGenders.DataSourceGendersDataChange(Sender: TObject;
  Field: TField);
begin
  PanelRegistry.Caption:='Total de Registros: ' + IntToStr(DataSourceGenders.DataSet.RecordCount);
end;

procedure TFormGenders.DataSourceGendersStateChange(Sender: TObject);
begin
  if DataSourceGenders.DataSet.Active then
  begin
    case DataSourceGenders.DataSet.State of
    dsBrowse:
      begin;
        if DataSourceGenders.DataSet.IsEmpty then
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

procedure TFormGenders.SBClearClick(Sender: TObject);
begin
  EditSearch.Text:='';
  DataSourceGenders.DataSet.Filter:='';
  DataSourceGenders.DataSet.Filtered:=False;
end;

procedure TFormGenders.SBSearchClick(Sender: TObject);
begin
  if EditSearch.Text <> '' then
  begin
    DataSourceGenders.DataSet.Filter:='GENERO LIKE '+ QuotedStr('*'+EditSearch.Text+'*');
    DataSourceGenders.DataSet.Filtered:=True;
  end;
end;

end.

