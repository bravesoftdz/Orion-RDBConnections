unit DB.Conexao.FireDAC.Query;

interface

uses
  System.SysUtils,
  System.DateUtils,
  DB.Conexao.Interfaces,
  Data.DB,
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
  FireDAC.Phys.FBDef,
  {$IFDEF FMX}
    FireDAC.FMXUI.Wait,
  {$ELSEIFDEF VCL}
    FireDAC.VCLUI.Wait,
  {$ELSE}
    FireDAC.ConsoleUI.Wait,
  {$ENDIF}
  FireDAC.Comp.UI,
  FireDAC.Phys.IBBase,
  FireDAC.Phys.FB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  System.Classes;

type
  TFiredacQuery = class(TInterfacedObject, iDataset)
  private
    [weak]
    FConexao : iConexao;
    FDBQuery : TFDQuery;
  public
    constructor Create(aValue : iConexao);
    destructor Destroy; override;
    class function New(aValue : iConexao) : iDataset;

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

{ TFiredacQuery }

procedure TFiredacQuery.Conexao(aValue: iConexao);
begin
  FDBQuery.Connection := aValue.Component as TFDCustomConnection;
end;

constructor TFiredacQuery.Create(aValue : iConexao);
begin
  FDBQuery := TFDQuery.Create(nil);
  FConexao := aValue;
  FDBQuery.Connection := FConexao.Component as TFDCustomConnection;
end;

function TFiredacQuery.Dataset: TDataset;
begin
  Result := FDBQuery;
end;

destructor TFiredacQuery.Destroy;
begin
  FDBQuery.DisposeOf;
  inherited;
end;

function TFiredacQuery.Eof: boolean;
begin
  Result := FDBQuery.Eof;
end;

procedure TFiredacQuery.ExecSQL;
begin
  FDBQuery.ExecSQL;
end;

function TFiredacQuery.FieldByName(aValue: string): TField;
begin
  Result := FDBQuery.FieldByName(aValue);
end;

function TFiredacQuery.FieldExist(aFieldName: string): boolean;
var
  lField : TField;
begin
  lField := FDBQuery.FindField(aFieldName);
  Result := Assigned(lField);
end;

class function TFiredacQuery.New(aValue : iConexao) : iDataset;
begin
  Result := Self.Create(aValue);
end;

procedure TFiredacQuery.Next;
begin
  FDBQuery.Next;
end;

procedure TFiredacQuery.Open;
begin
  FDBQuery.Open();
end;

procedure TFiredacQuery.ParamValue(aName: string; aValue: TDateTime; aFormat : string);
var
  lParam : TFDParam;
begin
  lParam := FDBQuery.Params.Add;
  lParam.Name := aName;
  lParam.Value := aValue;

//  FDBQuery.Params.Add(aName, aValue.Format(aFormat).QuotedString);
end;

procedure TFiredacQuery.ParamValue(aName, aValue: string);
var
  lParam : TFDParam;
begin
  lParam := FDBQuery.Params.Add;
  lParam.Name := aName;
  lParam.Value := aValue;
end;

procedure TFiredacQuery.ParamValue(aName: string; aValue: integer);
var
  lParam : TFDParam;
begin
  lParam := FDBQuery.Params.Add;
  lParam.Name := aName;
  lParam.Value := aValue;
end;

procedure TFiredacQuery.ParamValue(aName: string; aValue: Extended);
var
  lParam : TFDParam;
begin
  lParam := FDBQuery.Params.Add;
  lParam.Name := aName;
  lParam.Value := aValue;

//  FDBQuery.ParamByName(aName).Value := aValue.ToString.Replace(',', '', [rfReplaceAll]).QuotedString;
end;

function TFiredacQuery.RecordCount: integer;
begin
  Result := FDBQuery.RecordCount;
end;

procedure TFiredacQuery.Statement(aValue: string);
begin
  FDBQuery.SQL.Text := aValue;
end;

end.
