unit Xmpp.Iq.DiscoFeature;

interface
uses
  Element,XmppUri;
type
  TDiscoFeature=class(TElement)
  const
  TagName='feature';
  private
    function FGetVar:string;
    procedure FSetVar(value:string);
  public
    constructor Create;overload;override;
    constructor Create(v:string);overload;
    property DiscoVar:string read FGetVar write FSetVar;
    class function GetConstTagName():string;override;
  end;

implementation

{ TDiscoFeature }

constructor TDiscoFeature.Create;
begin
  inherited Create;
  Name:='feature';
  Namespace:=XMLNS_DISCO_INFO;
end;

constructor TDiscoFeature.Create(v: string);
begin
  Self.Create;
  Self.DiscoVar:=v;
end;

function TDiscoFeature.FGetVar: string;
begin
  Result:=GetAttribute('var');
end;

procedure TDiscoFeature.FSetVar(value: string);
begin
  SetAttribute('var',value);
end;

class function TDiscoFeature.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_DISCO_INFO;
end;

end.
