unit Xmpp.extensions.Compress;

interface
uses
  Element,XmppUri;
type
  TCompress=class(TElement)
  const
  TagName='compress';
  private
    function FGetMethod:string;
    procedure FSetMethod(value:string);
  public
    constructor Create;override;
    constructor Create(md:string);overload;
    property Method:string read FGetMethod write FSetMethod;
    class function GetConstTagName():string;override;
  end;
  TCompressed=class(TElement)
  const
  TagName='compressed';
  public
    constructor Create;overload;
    class function GetConstTagName():string;override;
  end;

implementation

{ TCompress }

constructor TCompress.Create;
begin
  inherited Create;
  Name:='compress';
  Namespace:=XMLNS_COMPRESS;
end;

constructor TCompress.Create(md: string);
begin
  self.Create;
  Self.Method:=md;
end;

function TCompress.FGetMethod: string;
begin
  Result:=GetTag('method');
end;

procedure TCompress.FSetMethod(value: string);
begin
  if value<>'Unknown' then
    SetTag('method',value);
end;

class function TCompress.GetConstTagName: string;
begin
   Result:=TagName+'-'+XMLNS_COMPRESS;
end;

{ TCompressed }

constructor TCompressed.Create;
begin
  inherited Create;
  Name:='compressed';
  Namespace:=XMLNS_COMPRESS;
end;

class function TCompressed.GetConstTagName: string;
begin
  Result:=TagName+'-'+XMLNS_COMPRESS;
end;

end.
