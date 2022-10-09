unit DB.Conexao.FireDAC.Connection.SQLite;

interface
uses
  DB.Conexao.Interfaces,

  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Phys,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Phys.SQLiteDef,
  {$IFDEF FMX}
    FireDAC.FMXUI.Wait,
  {$ELSEIFDEF VCL}
    FireDAC.VCLUI.Wait,
  {$ELSE}
    FireDAC.ConsoleUI.Wait,
  {$ENDIF}
  FireDAC.Comp.UI,
  FireDAC.Phys.IBBase,
  FireDAC.Phys.SQLite,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  System.Classes;
type
  TDBConexaoSQLite = class(TInterfacedObject, iConexao)
  private
    FDBConnection : TFDConnection;
    FDriverLink : TFDPhysSQLiteDriverLink;
    FDBQueryControlaID : TFDQuery;
    function ComplementaZeros(aValue : string) : string;
  public
    constructor Create;
    destructor Destroy; override;
    class function New : iConexao;
    procedure Configurations(aPath, aUsername, aPassword, aServer : string; aPort : integer);
    procedure StartTransaction;
    procedure Commit;
    procedure RollBack;
    function NControle(aDescricao : string; aTipoCampoNControle : TTipoCampoNControle) : string;
    function Component : TComponent;
    function NewDataset : iDataset;
  end;
implementation
uses
  System.SysUtils, DB.Conexao.FireDAC.Query;
{ TDBConexaoSQLite }
procedure TDBConexaoSQLite.Commit;
begin
  FDBConnection.Commit;
end;
function TDBConexaoSQLite.ComplementaZeros(aValue: string): string;
var
  nDoc: Integer;
  cDoc: string;
begin
  try
    while Pos(' ', aValue) > 0 do
      Delete(aValue, Pos(' ', aValue), 1);
    nDoc := StrToInt(aValue);
    cDoc := Format('%6d', [nDoc]);
    while Pos(' ', cDoc) > 0 do
      cDoc[Pos(' ', cDoc)] := '0';
  except
    raise EDatabaseError.Create('Numero Inválido');
  end;
  Result := cDoc;
end;
function TDBConexaoSQLite.Component: TComponent;
begin
  Result := FDBConnection;
end;
procedure TDBConexaoSQLite.Configurations(aPath, aUsername, aPassword, aServer: string; aPort: integer);
begin
  FDBConnection.Params.DriverID := 'SQLite';
  FDBConnection.Params.Database := aPath;
  FDBConnection.Params.UserName := aUserName;
  FDBConnection.Params.Password := aPassword;
  FDBConnection.Params.AddPair('Port', aPort.ToString);
end;
constructor TDBConexaoSQLite.Create;
begin
  FDBConnection := TFDConnection.Create(nil);
  FDBConnection.UpdateOptions.AutoCommitUpdates := False;
  FDriverLink := TFDPhysSQLiteDriverLink.Create(nil);
  FDBQueryControlaID := TFDQuery.Create(nil);
end;
destructor TDBConexaoSQLite.Destroy;
begin
  if FDBConnection.InTransaction then
    FDBConnection.Rollback;
  FDBConnection.Connected := False;
  FDBConnection.DisposeOf;
  FDriverLink.DisposeOf;
  FDBQueryControlaID.DisposeOf;
  inherited;
end;
function TDBConexaoSQLite.NControle(aDescricao : string; aTipoCampoNControle : TTipoCampoNControle) : string;
begin
  try
    FDBQueryControlaID.Connection := FDBConnection;
    FDBQueryControlaID.CachedUpdates := true;
    repeat
      FDBQueryControlaID.Open('SELECT * FROM CONTROLE WHERE CAMPO = '+aDescricao.QuotedString);
      if FDBQueryControlaID.RecordCount > 0 then
        FDBQueryControlaID.Edit
      else
        FDBQueryControlaID.Append;
      FDBQueryControlaID.FieldByName('campo').AsVariant := aDescricao;
      FDBQueryControlaID.FieldByName('valor').AsFloat  := FDBQueryControlaID.FieldByName('valor').AsFloat + 1;
      FDBQueryControlaID.Post;
    until FDBQueryControlaID.ApplyUpdates(0) = 0;
    if aTipoCampoNControle = tcString then begin
      Result := ComplementaZeros(FDBQueryControlaID.FieldByName('valor').AsString)
    end
    else
      Result := FDBQueryControlaID.FieldByName('valor').AsString;
  finally
    FDBQueryControlaID.Close;
  end;
end;
class function TDBConexaoSQLite.New: iConexao;
begin
  Result := Self.Create;
end;
function TDBConexaoSQLite.NewDataset: iDataset;
begin
  Result := TFiredacQuery.New(Self);
end;
procedure TDBConexaoSQLite.RollBack;
begin
  FDBConnection.Rollback;
end;
procedure TDBConexaoSQLite.StartTransaction;
begin
  FDBConnection.StartTransaction;
end;
end.
