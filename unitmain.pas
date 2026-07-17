unit unitMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, DBGrids, DBCtrls, Menus, DBExtCtrls, DBDateTimePicker, unitDataModule;

type

  { TFormMain }

  TFormMain = class(TForm)
    BtnSelImage: TBitBtn;
    BtnNew: TBitBtn;
    BtnSave: TBitBtn;
    BtnEdit: TBitBtn;
    BtnDelete: TBitBtn;
    BtnCancel: TBitBtn;
    BtnClear: TBitBtn;
    CBField: TComboBox;
    DataSourcePlaces: TDataSource;
    DataSourceQualities: TDataSource;
    DataSourceCountries: TDataSource;
    DataSourceClassifications: TDataSource;
    DataSourceGenders: TDataSource;
    DataSourceEmissoras: TDataSource;
    DataSourceTypes: TDataSource;
    DataSourceMovies: TDataSource;
    DBCBVinheta: TDBCheckBox;
    DBCBComerciais: TDBCheckBox;
    DBDateRelease: TDBDateEdit;
    DBECover: TDBEdit;
    DBESession: TDBEdit;
    DBETitle: TDBEdit;
    DBEYear: TDBEdit;
    DBEdit3: TDBEdit;
    DBEFile: TDBEdit;
    DBESize: TDBEdit;
    DBEID: TDBEdit;
    DBGrid1: TDBGrid;
    DBLGender: TDBLookupComboBox;
    DBLEmissora: TDBLookupComboBox;
    DBLClassification: TDBLookupComboBox;
    DBLCountry: TDBLookupComboBox;
    DBLPlace: TDBLookupComboBox;
    DBLQuality: TDBLookupComboBox;
    DBLType: TDBLookupComboBox;
    DBMSinpsys: TDBMemo;
    DBMObs: TDBMemo;
    EditSearch: TEdit;
    GroupBox1: TGroupBox;
    GroupBoxMovieData: TGroupBox;
    GroupBoxCover: TGroupBox;
    GroupBoxMovieList: TGroupBox;
    GroupBoxActions: TGroupBox;
    ImageCover: TImage;
    ImageListMain: TImageList;
    Label1: TLabel;
    LabelSearch: TLabel;
    LabelField: TLabel;
    LabelQuality: TLabel;
    LabelSession: TLabel;
    LabelEmiss: TLabel;
    LabelType: TLabel;
    LabelClass: TLabel;
    LabelGender: TLabel;
    LabelRelease: TLabel;
    LabelDuration: TLabel;
    LabelCountry: TLabel;
    LabelYear: TLabel;
    LabelTitle: TLabel;
    LabelID: TLabel;
    LabelSize: TLabel;
    LabelFile: TLabel;
    LabelPlace: TLabel;
    LabelObs: TLabel;
    MainMenu1: TMainMenu;
    MenuItemArquivo: TMenuItem;
    MenuItemLocal: TMenuItem;
    MenuItemSair: TMenuItem;
    MenuItemSobre: TMenuItem;
    OpenDialogImage: TOpenDialog;
    Separator1: TMenuItem;
    MenuItemNovo: TMenuItem;
    MenuItemFilme: TMenuItem;
    MenuItemPais: TMenuItem;
    MenuItemGenero: TMenuItem;
    MenuItemClassificacao: TMenuItem;
    MenuItemTipo: TMenuItem;
    MenuItemEmissora: TMenuItem;
    MenuItemQualidade: TMenuItem;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    PanelRegistry: TPanel;
    Panel9: TPanel;
    SBSearch: TSpeedButton;
    SBClear: TSpeedButton;
    procedure BtnClearClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure BtnNewClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnSelImageClick(Sender: TObject);
    procedure DataSourceMoviesDataChange(Sender: TObject; Field: TField);
    procedure FormActivate(Sender: TObject);
    //procedure DataSourceMoviesStateChange(Sender: TObject);
    procedure MenuItemLocalClick(Sender: TObject);
    procedure MenuItemSairClick(Sender: TObject);
    procedure MenuItemPaisClick(Sender: TObject);
    procedure MenuItemGeneroClick(Sender: TObject);
    procedure MenuItemClassificacaoClick(Sender: TObject);
    procedure MenuItemSobreClick(Sender: TObject);
    procedure MenuItemTipoClick(Sender: TObject);
    procedure MenuItemEmissoraClick(Sender: TObject);
    procedure MenuItemQualidadeClick(Sender: TObject);
    procedure SBClearClick(Sender: TObject);
    procedure SBSearchClick(Sender: TObject);
  private

  public

  end;

var
  FormMain: TFormMain;
  OldCover: String;

implementation

uses unitCountries, unitGenders, unitClassification,
  unitTypes, unitEmissoras, unitQualities, unitPlaces,
  unitAbout;

{$R *.lfm}

{ TFormMain }

procedure TFormMain.MenuItemSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFormMain.MenuItemLocalClick(Sender: TObject);
begin
  FormPlaces.ShowModal;
end;

procedure TFormMain.BtnNewClick(Sender: TObject);
begin
  if DataSourceMovies.DataSet.Active then
  begin
    DataSourceMovies.DataSet.Insert;
    ImageCover.Picture.Clear;
    DBETitle.SetFocus;
  end;
end;

procedure TFormMain.BtnDeleteClick(Sender: TObject);
var
  Cover: String;
  Folder: String;
begin
  Folder:=ExtractFilePath(Application.ExeName) + 'database\images\';
  if not DataSourceMovies.DataSet.IsEmpty then
  begin
    if QuestionDlg('Atenção',
                          'Deseja realmente excluir este registro?',
                          mtConfirmation,
                          [mrYes, mrNo],
                          'Sim;Não') = mrYes then
    begin
      Cover := DataSourceMovies.DataSet.FieldByName('CAPA').AsString;
      if FileExists(Folder+Cover) then
        DeleteFile(Folder+Cover);
      DataSourceMovies.DataSet.Delete;
    end;
  end;
end;

procedure TFormMain.BtnClearClick(Sender: TObject);
begin

end;

procedure TFormMain.BtnSaveClick(Sender: TObject);
var
  Cover: String;
  Folder: String;
begin
  if DataSourceMovies.DataSet.State in [dsInsert, dsEdit] then
  begin
    Folder:=ExtractFilePath(Application.ExeName) + 'database\images\';
    if DataSourceMovies.DataSet.State = dsInsert then
    begin
      Cover := DataSourceMovies.DataSet.FieldByName('CAPA').AsString;
      if Cover <> '' then
      begin
        ImageCover.Picture.SaveToFile(Folder+Cover);
      end;
    end
    else if DataSourceMovies.DataSet.State = dsEdit then
    begin
      Cover := DataSourceMovies.DataSet.FieldByName('CAPA').AsString;
      if Cover <> '' then
      begin
        if Cover <> OldCover then
        begin
          if FileExists(Folder+OldCover) then
          begin
            DeleteFile(Folder+OldCover);
          end;
          ImageCover.Picture.SaveToFile(Folder+Cover);
        end;
      end;
    end;
    DataSourceMovies.DataSet.Post;
  end;
end;

procedure TFormMain.BtnEditClick(Sender: TObject);
begin
  if DataSourceMovies.DataSet.State = dsBrowse then
  begin
    OldCover:=DataSourceMovies.DataSet.FieldByName('CAPA').AsString;
    DataSourceMovies.DataSet.Edit;
    DBETitle.SetFocus;
  end;
end;

procedure TFormMain.BtnCancelClick(Sender: TObject);
begin
  if DataSourceMovies.DataSet.State in [dsInsert, dsEdit] then
  begin
    DataSourceMovies.DataSet.Cancel;
  end;
end;

procedure TFormMain.BtnSelImageClick(Sender: TObject);
begin
  if DataSourceMovies.DataSet.State in [dsInsert, dsEdit] then
  begin
    if OpenDialogImage.Execute then
    begin
      ImageCover.Picture.LoadFromFile(OpenDialogImage.FileName);
      try
        // 2. Desativa as notificações visuais do banco para evitar o "flicker" ou limpeza
        DataSourceMovies.DataSet.DisableControls;

        // 3. Grava o nome gerado no campo do banco
        DataSourceMovies.DataSet.FieldByName('CAPA').AsString :=
          FormatDateTime('yyyymmddhhnnsszzz', Now) + ExtractFileExt(OpenDialogImage.FileName);
      finally
        // 4. Reativa as notificações para que o DBEdit do nome se atualize
        DataSourceMovies.DataSet.EnableControls;
      end;
    end;
  end;
end;

procedure TFormMain.DataSourceMoviesDataChange(Sender: TObject; Field: TField);
var
  Cover: String;
  Folder: String;
  FileCover: String;
begin
  PanelRegistry.Caption:='Total de Registros: ' + IntToStr(DataSourceMovies.DataSet.RecordCount);
  Folder:=ExtractFilePath(Application.ExeName) + 'database\images\';
  if DataSourceMovies.DataSet.Active then
  begin
    case DataSourceMovies.DataSet.State of
    dsBrowse:
      begin;
        if DataSourceMovies.DataSet.IsEmpty then
        begin
          ImageCover.Picture.Clear;
          BtnEdit.Enabled:=False;
          BtnDelete.Enabled:=False;
        end
        else
        begin
          Cover := DataSourceMovies.DataSet.FieldByName('CAPA').AsString;
          if (Cover = '') or not FileExists(Folder+Cover) then
          begin
            ImageCover.Picture.LoadFromFile(Folder+'no_movie.jpg');
          end
          else
          begin
            FileCover:=ExtractFilePath(Application.ExeName)+'database\images\';
            if FileExists(FileCover+Cover) then
              ImageCover.Picture.LoadFromFile(FileCover+Cover)
            else
              ImageCover.Picture.LoadFromFile(Folder+'no_movie.jpg');
          end;
          BtnEdit.Enabled:=True;
          BtnDelete.Enabled:=True;
        end;
        BtnSelImage.Enabled:=False;
        BtnNew.Enabled:=True;
        BtnSave.Enabled:=False;
        BtnClear.Enabled:=False;
        BtnCancel.Enabled:=False;
      end;
    dsInsert, dsEdit:
      begin
        BtnSelImage.Enabled:=True;
        //ImageCover.Picture.Clear;
        BtnNew.Enabled:=False;
        BtnSave.Enabled:=True;
        BtnClear.Enabled:=True;
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
    BtnClear.Enabled:=False;
    BtnEdit.Enabled:=False;
    BtnCancel.Enabled:=False;
    BtnDelete.Enabled:=False;
  end;
end;

procedure TFormMain.FormActivate(Sender: TObject);
var
  PathDB: string;
begin
  OldCover:='';
  PathDB:=ExtractFilePath(Application.ExeName);
  try
  DM.ZTableTypes.Close;
  DM.ZTableCountries.Close;
  DM.ZTableEmissoras.Close;
  DM.ZTableGenders.Close;
  DM.ZTableQualities.Close;
  DM.ZTableClassification.Close;
  DM.ZTablePlaces.Close;
  DM.ZTableMovies.Close;
  DM.ZConnectionMain.Connected:=False;
  DM.ZConnectionMain.Database:=PathDB+'database\MOVIES.FDB';
  DM.ZConnectionMain.HostName:='127.0.0.1';
  DM.ZConnectionMain.LibraryLocation:=PathDB+'database\FBCLIENT.DLL';
  DM.ZConnectionMain.Password:='masterkey';
  DM.ZConnectionMain.Protocol:='firebird';
  DM.ZConnectionMain.User:='SYSDBA';
  DM.ZTableTypes.Connection:=DM.ZConnectionMain;
  DM.ZTableCountries.Connection:=DM.ZConnectionMain;
  DM.ZTableEmissoras.Connection:=DM.ZConnectionMain;
  DM.ZTableGenders.Connection:=DM.ZConnectionMain;
  DM.ZTableQualities.Connection:=DM.ZConnectionMain;
  DM.ZTableClassification.Connection:=DM.ZConnectionMain;
  DM.ZTablePlaces.Connection:=DM.ZConnectionMain;
  DM.ZTableMovies.Connection:=DM.ZConnectionMain;
  DM.ZTableTypes.Open;
  DM.ZTableCountries.Open;
  DM.ZTableEmissoras.Open;
  DM.ZTableGenders.Open;
  DM.ZTableQualities.Open;
  DM.ZTableClassification.Open;
  DM.ZTablePlaces.Open;
  DM.ZTableMovies.Open;
  except
    On E: Exception do
    begin
      MessageDlg('Erro', 'Erro ao manipular o banco de dados! Finalizando aplicação!', mtError, [mbOK], 0);
      Application.Terminate;
    end;
  end;
end;

procedure TFormMain.MenuItemPaisClick(Sender: TObject);
begin
  FormCountries.ShowModal;
end;

procedure TFormMain.MenuItemGeneroClick(Sender: TObject);
begin
  FormGenders.ShowModal;
end;

procedure TFormMain.MenuItemClassificacaoClick(Sender: TObject);
begin
  FormClassifications.ShowModal;
end;

procedure TFormMain.MenuItemSobreClick(Sender: TObject);
begin
  FormAbout.ShowModal;
end;

procedure TFormMain.MenuItemTipoClick(Sender: TObject);
begin
  FormTypes.ShowModal;
end;

procedure TFormMain.MenuItemEmissoraClick(Sender: TObject);
begin
  FormEmissoras.ShowModal;
end;

procedure TFormMain.MenuItemQualidadeClick(Sender: TObject);
begin
  FormQualities.ShowModal;
end;

procedure TFormMain.SBClearClick(Sender: TObject);
begin
  DataSourceMovies.DataSet.Filter:='';
  DataSourceMovies.DataSet.Filtered:=False;
  EditSearch.Text:='';
end;

procedure TFormMain.SBSearchClick(Sender: TObject);
var
  Field: String;
  Filter: String;
begin
  Field:=CBField.Text;
  if EditSearch.Text <> '' then
  begin
    Filter:=Field+' LIKE '+QuotedStr('*'+EditSearch.Text+'*');
    DataSourceMovies.DataSet.Filter:=Filter;
    DataSourceMovies.DataSet.Filtered:=True;
  end;
end;

end.

