unit DB.Conexao.Utils;

interface

uses
  Data.DB;

function BlobToBase64(aValue : TField) : string;

implementation

uses
  System.Classes, System.NetEncoding;

function BlobToBase64(aValue : TField) : string;
var
  lInput, lOutput : TStringStream;
begin
  lInput := TStringStream.Create;
  lOutput := TStringStream.Create;
  try
    TBlobField(aValue).SaveToStream(lInput);
    lInput.Position := 0;
    TNetEncoding.Base64.Encode(LInput, LOutput);
    lOutput.Position := 0;
    Result := lOutput.DataString;
  finally
    lInput.DisposeOf;
    lOutput.DisposeOf;
  end;
end;

end.
