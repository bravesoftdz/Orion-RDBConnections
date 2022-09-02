unit DB.Conexao.Factory;

interface

uses
  System.Generics.Collections,
  DB.Conexao.Interfaces,
  Infra.Conf;

type
  TConexaoFactory = class(TInterfacedObject, iConexaoFactory)
  private
    FConexoes : TList<iConexao>;
    FConfiguracoes : TConfiguracoes;
  public
    constructor Create;
    destructor Destroy; override;
    class function New : iConexaoFactory;

    function Conexao : iConexao;
    procedure Commit;
    procedure Rollback;
  end;
implementation

uses
  DB.Conexao.FireDAC.Connection.Firebird;

{ TConexaoFactory }

procedure TConexaoFactory.Commit;
var
  lConexao: iConexao;
begin
  for lConexao in FConexoes do begin
    lConexao.Commit;
  end;
end;

function TConexaoFactory.Conexao: iConexao;
var
  lConexao : iConexao;
begin
  lConexao := TDBConexaoFirebird.New;
  lConexao.Configurations(FConfiguracoes.CaminhoBanco, FConfiguracoes.UserName, FConfiguracoes.Password, '', FConfiguracoes.Porta);
  FConexoes.Add(lConexao);
  Result := lConexao;
end;

constructor TConexaoFactory.Create;
begin
  FConexoes := TList<iConexao>.Create;
  FConfiguracoes := TConfiguracoes.Create;
end;

destructor TConexaoFactory.Destroy;
begin
  FConexoes.DisposeOf;
  FConfiguracoes.DisposeOf;
  inherited;
end;

class function TConexaoFactory.New: iConexaoFactory;
begin
  Result := Self.Create;
end;

procedure TConexaoFactory.Rollback;
var
  lConexao : iConexao;
begin
  for lConexao in FConexoes do begin
    lConexao.RollBack;
  end;
end;

end.
