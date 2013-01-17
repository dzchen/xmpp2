unit Xmpp.extentions.Primary;

interface
uses
  Element,XmppUri;
type
  TPrimary=class(TElement)
  const
  TagName='p';
  public
    constructor Create();override;
    class function GetConstTagName():string;override;
  end;

implementation

{ TPrimary }

constructor TPrimary.Create();
begin
  inherited Create();
  Name:='p';
  Namespace:=XMLNS_PRIMARY;
end;

class function TPrimary.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_PRIMARY;
end;

end.
