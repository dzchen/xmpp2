unit Xmpp.x.data.item;

interface
uses
  Xmpp.x.FieldContainer,XmppUri;
type
  TItem=class(TFieldcontainer)
  const
  TagName='item';
  public
    constructor Create;override;
    class function GetConstTagName():string;override;
  end;
implementation

{ TItem }

constructor TItem.Create;
begin
  Name:='item';
  namespace:=XMLNS_X_DATA;
end;

class function TItem.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_X_DATA;
end;

end.
