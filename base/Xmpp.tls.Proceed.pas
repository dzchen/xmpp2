unit Xmpp.tls.Proceed;

interface
uses
  Element,XmppUri;
type
  TProceed=class(TElement)
  const
    TagName='proceed';
    TagNameSpace=XMLNS_TLS;
  public
    constructor Create;override;
    class function GetConstTagName: string;override;
  end;

implementation

{ TProceed }

constructor TProceed.Create;
begin
  inherited Create;
  Name:=TagName;
  Namespace:=TagNameSpace;
end;

class function TProceed.GetConstTagName: string;
begin
  Result:=TagName+'-'+TagNameSpace;
end;

end.
