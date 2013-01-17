unit Xmpp.stream.feature.compression.Method;

interface
uses
  Element,XmppUri;
type
  TMethod=class(TElement)
  const
  TagName='method';
  private
    function FGetCompressionMethod:string;
    procedure FSetCompressionMethod(value:string);
  public
    constructor Create();override;
    constructor Create(md:string);overload;
    property CompressionMethod:string read FGetCompressionMethod write FSetCompressionMethod;
    class function GetConstTagName():string;override;
  end;

implementation

{ TMethod }

constructor TMethod.Create;
begin
  inherited Create;
  Name:='method';
  Namespace:=XMLNS_FEATURE_COMPRESS;
end;

constructor TMethod.Create(md: string);
begin
  self.Create;
  value:=md;
end;

function TMethod.FGetCompressionMethod: string;
begin
  Result:=data;
end;

procedure TMethod.FSetCompressionMethod(value: string);
begin
  self.value:=value;
end;

class function TMethod.GetConstTagName: string;
begin
  Result:=TagName+'-'+XMLNS_FEATURE_COMPRESS;
end;

end.
