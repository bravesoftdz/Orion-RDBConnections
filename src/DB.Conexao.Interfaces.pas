unit DB.Conexao.Interfaces;

interface

uses
  Data.DB, System.Classes;


const
  FORMAT_DATE_TIME = 'yyyy-mm-dd hh:mm:ss';

type
  TDataProcessorStatementType = (None, Read, Write, WriteWithReturn);
  TTipoCampoNControle = (tcString, tcInteger);

  iDataset = interface;

  iConexao = interface
    procedure Configurations(aPath, aUsername, aPassword, aServer : string; aPort : integer);
    procedure StartTransaction;
    procedure Commit;
    procedure RollBack;
    function NControle(aDescricao : string; aTipoCampoNControle : TTipoCampoNControle) : string;
    function Component : TComponent;
    function NewDataset : iDataset;
  end;

  iConexaoFactory = interface
    function Conexao : iConexao;
    procedure Commit;
    procedure Rollback;
  end;

  iDataset = interface
    procedure Conexao(aValue : iConexao);
    function RecordCount : integer;
    function FieldByName(aValue : string) : TField;
    procedure ParamValue(aName, aValue : string); overload;
    procedure ParamValue(aName : string; aValue : integer); overload;
    procedure ParamValue(aName : string; aValue : Extended); overload;
    procedure ParamValue(aName : string; aValue : TDateTime; aFormat : string); overload;
    function FieldExist(aFieldName : string) : boolean;
    procedure Statement(aValue : string);
    procedure Open;
    procedure ExecSQL;
    procedure Next;
    function Dataset : TDataset;
    function Eof : boolean;
  end;
implementation

end.
