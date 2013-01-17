unit Xmpp.stream.feature.compression.Compression;

interface
uses
  Element,XmppUri,Generics.Collections,xmpp.stream.feature.compression.Method,System.Classes;
type
  TCompression=class(TElement)
  const
  TagName='compression';
  private
    function FGetMethod:string;
    procedure FSetMethod(value:string);
  public
    constructor Create;override;
    property Method:string read FGetMethod write FSetMethod;
    procedure AddMethod(md:string);
    function SupportsMethod(md:string):Boolean;
    function GetMethods:TList;
    class function GetConstTagName():string;override;
  end;

implementation

{ TCompression }

procedure TCompression.AddMethod(md: string);
begin
  if not SupportsMethod(md) then
    AddTag(TMethod.Create);
end;

constructor TCompression.Create;
begin
  inherited Create;
  Name:='compression';
  Namespace:=XMLNS_FEATURE_COMPRESS;
end;

function TCompression.FGetMethod: string;
begin
  Result:=GetTag('method');
end;

procedure TCompression.FSetMethod(value: string);
begin
  if value<>'Unknown' then
    SetTag('method',value);
end;

class function TCompression.GetConstTagName: string;
begin
  Result:=TagName+'-'+XMLNS_FEATURE_COMPRESS;
end;

function TCompression.GetMethods: TList;
begin
  Result:=SelectElements(TMethod.TagName);
end;

function TCompression.SupportsMethod(md: string): Boolean;
var
  el:TList;
  i:Integer;
begin
  el:=SelectElements(TMethod.TagName);
  for i:=0 to el.count-1 do
  begin
    if TMethod(el[i]).CompressionMethod=md then
    begin
      Result:=true;
      exit;
    end;
  end;
  Result:=False;
end;

end.
