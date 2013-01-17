unit Xmpp.x.data.Reported;

interface
uses
  Xmpp.x.FieldContainer,XmppUri;
type
  TReported=class(TFieldcontainer)
  const
  TagName='reported';
  public
    constructor Create;override;
    class function GetConstTagName():string;override;
  end;
implementation

{ TReported }

constructor TReported.Create;
begin
  Name:='reported';
  Namespace:=XMLNS_X_DATA;
end;

class function TReported.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_X_DATA;
end;

end.
