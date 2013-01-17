unit Xmpp.stream.feature.Register;

interface
uses
  Element,XmppUri;
type
  TRegister=class(TElement)
  const
  TagName='register';
  public
    constructor Create;override;
    class function GetConstTagName():string;override;
  end;

implementation

{ TRegister }

constructor TRegister.Create;
begin
  inherited Create;
  Name:='register';
  Namespace:=XMLNS_FEATURE_IQ_REGISTER;
end;

class function TRegister.GetConstTagName: string;
begin
  Result:=TagName+'-'+XMLNS_FEATURE_IQ_REGISTER;
end;

end.
